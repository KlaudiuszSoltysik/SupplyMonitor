from django.urls import path
from .views import WeatherView

urlpatterns = [
    path('weather/', WeatherView.as_view(), name='weather_view'),
    # path('upload/', UploadGeneratedSupplyData.as_view(), name='upload-text-file'),
]
