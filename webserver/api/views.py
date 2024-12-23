import requests
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status

class WeatherView(APIView):
    def get(self, request, *args, **kwargs):
        lat = request.query_params.get('lat')
        lon = request.query_params.get('lon')

        if not lat or not lon:
            return Response(
                {"error": "Latitude and longitude are required parameters."},
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

class DataBaseInfoView(APIView):
    def get(self, request, *args, **kwargs):
        return Response(
            {'error': 'ass'},
            status=status.HTTP_400_BAD_REQUEST
        )