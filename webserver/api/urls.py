from django.urls import path
from .views import WeatherView

urlpatterns = [
    path('weather/<int:factory>', WeatherView.as_view(), name='weather_view'),
]
