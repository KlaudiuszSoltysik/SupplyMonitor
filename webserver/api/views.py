# TODO: Make async function that redo database tables
# TODO: Auth

import requests
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from datetime import datetime, timedelta
from .models import Organization, Supply, SupplyData


class WeatherView(APIView):
    def get(self, request, *args, **kwargs):
        lat = request.query_params.get('lat')
        lon = request.query_params.get('lon')

        if not lat or not lon:
            return Response(
                {'error': 'lat and lon are required parameters.'},
                status=status.HTTP_400_BAD_REQUEST)

        api_key = settings.OPENWEATHER_API_KEY

        weather_response = requests.get(f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}&units=metric')
        forecast_response = requests.get(f'https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={api_key}&units=metric')

        if weather_response.status_code == 200 and forecast_response.status_code == 200:
            weather_data = weather_response.json()
            forecast_data = forecast_response.json()

            return_data = {
                'weather_icon': weather_data['weather'][0]['icon'],
                'weather_temp': f'{weather_data['main']['temp']:.1f}',
                'weather_cloudiness': weather_data['clouds']['all'],
                'weather_wind_dir': weather_data['wind']['deg'],
                'weather_wind_speed': f'{weather_data['wind']['speed']:.1f}',
                'forecast': [{
                    'time': item['dt_txt'],
                    'icon': item['weather'][0]['icon'],
                    'temp': f'{item['main']['temp']:.1f}',
                    'cloudiness': item['clouds']['all'],
                    'wind_speed': f'{item['wind']['speed']:.1f}',
                } for item in forecast_data['list']]
            }

            return Response(return_data, status=status.HTTP_200_OK)
        else:
            return Response(
                {'error': 'Unable to fetch weather data'},
                status=status.HTTP_400_BAD_REQUEST)


class SupplyDataView(APIView):
    def get(self, request, *args, **kwargs):
        org_name = request.query_params.get('org')
        supply_name = request.query_params.get('supply')
        last = request.query_params.get('last')

        if not org_name or not supply_name or not last:
            return Response(
                {'error': 'org and supply are required parameters.'},
                status=status.HTTP_400_BAD_REQUEST)

        timestamp = datetime(2024, 12, 24, 8, 0, 0)
        stop_timestamp = timestamp.replace(minute=timestamp.minute - (timestamp.minute % 15),
                                          second=0,
                                          microsecond=0)

        if last == 'day':
            start_timestamp = stop_timestamp - timedelta(days=1)
        elif last == 'week':
            start_timestamp = stop_timestamp - timedelta(weeks=1)
        elif last == 'month':
            start_timestamp = stop_timestamp - timedelta(days=30)
        elif last == 'year':
            start_timestamp = stop_timestamp - timedelta(days=365)
        else:
            return Response(
                {'error': r"parameter last only accepts 'day', 'week', 'month' or 'year' values"},
                status=status.HTTP_400_BAD_REQUEST)

        start_timestamp += timedelta(minutes=15)

        organization = Organization.objects.filter(organization=org_name)

        supply = Supply.objects.filter(
            organization__in=organization,
            supply=supply_name)

        records = SupplyData.objects.filter(
            supply__in=supply,
            timestamp__gte=start_timestamp,
            timestamp__lte=stop_timestamp)

        records_list = list(records.values())
        segment_size = len(records_list) // 96
        means = []

        for i in range(0, len(records_list), segment_size):
            segment = records_list[i:i + segment_size]
            sub_sum = 0
            for s in segment:
                sub_sum += s['value']

            means.append(int(sub_sum/len(segment)))

        return_data = {'means': means, 'start_timestamp': start_timestamp, 'stop_timestamp': stop_timestamp, 'resolution': segment_size}

        return Response(return_data, status=status.HTTP_200_OK)


# class UploadGeneratedSupplyData(APIView):
#     def get(self, request, *args, **kwargs):
#         with open('data5.txt', 'rb') as file:
#             loaded_data = pickle.load(file)
#
#         organization_name = ''
#         supply_name = ''
#
#         try:
#             selected_organization = Organization.objects.get(organization=organization_name)
#             selected_supply = Supply.objects.get(organization=selected_organization, supply=supply_name)
#         except Organization.DoesNotExist:
#             return Response({'error': 'Organization not found'}, status=status.HTTP_400_BAD_REQUEST)
#         except Supply.DoesNotExist:
#             return Response({'error': 'Supply not found'}, status=status.HTTP_400_BAD_REQUEST)
#
#         supply_data_objects = []
#
#         for data in loaded_data:
#             try:
#                 timestamp = data['timestamp']
#                 value = data['value']
#
#                 supply_data_objects.append(SupplyData(
#                     supply=selected_supply,
#                     timestamp=timestamp,
#                     value=value
#                 ))
#
#             except Exception as e:
#                 return Response({'error': str(e)}, status=status.HTTP_400_BAD_REQUEST)
#
#         with transaction.atomic():
#             SupplyData.objects.bulk_create(supply_data_objects)
#
#         return Response({'response': 'Data uploaded successfully'}, status=status.HTTP_200_OK)