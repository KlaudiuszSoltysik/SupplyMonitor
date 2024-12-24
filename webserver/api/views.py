import requests
from django.conf import settings
from django.db import transaction
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Organization, Supply, SupplyData
import pickle


class WeatherView(APIView):
    def get(self, request, *args, **kwargs):
        lat = request.query_params.get('lat')
        lon = request.query_params.get('lon')

        if not lat or not lon:
            return Response(
                {'error': 'Latitude and longitude are required parameters.'},
                status=status.HTTP_400_BAD_REQUEST
            )

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
                status=status.HTTP_400_BAD_REQUEST
            )


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