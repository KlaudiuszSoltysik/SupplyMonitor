import requests
from django.conf import settings
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .serializers import WeatherSerializer

class WeatherView(APIView):
    def get(self, request, factory, *args, **kwargs):
        api_key = settings.OPENWEATHER_API_KEY

        if factory == 0:
            lat = 52.4119921802926
            lon = 17.029640488794385
        elif factory == 1:
            lat = 52.29809870368471
            lon = 17.51718564090986
        elif factory == 2:
            lat = 52.378225963404475
            lon = 16.90778212557254
        else:
            lat = 52.39628030620998
            lon = 17.104588967902355

        weather_url = f'https://api.openweathermap.org/data/2.5/weather?lat={lat}&lon={lon}&appid={api_key}&units=metric'
        forecast_url = f'https://api.openweathermap.org/data/2.5/forecast?lat={lat}&lon={lon}&appid={api_key}&units=metric'
        print(forecast_url)

        weather_response = requests.get(weather_url)
        forecast_response = requests.get(forecast_url)

        if weather_response.status_code == 200 and forecast_response.status_code == 200:
            weather_data = weather_response.json()
            forecast_data = forecast_response.json()

            data = {'weather': weather_data, 'forecast': forecast_data}

            # return_data = {
            #     'main': data['weather'][0]['main'],
            #     'description': data['weather'][0]['description'],
            #     'temperature': data['main']['temp'],
            #     'humidity': data['main']['humidity'],
            #     'pressure': data['main']['pressure'],
            # }
            #
            # serializer = WeatherSerializer(return_data)

            return Response(data, status=status.HTTP_200_OK)
        else:
            return Response(
                {'error': 'Unable to fetch weather data'},
                status=status.HTTP_400_BAD_REQUEST
            )