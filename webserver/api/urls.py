from django.urls import path
from .views import WeatherView, SupplyDataView

urlpatterns = [
    path('weather/', WeatherView.as_view()),
    path('supply_data/', SupplyDataView.as_view()),
    # path('upload/', UploadGeneratedSupplyData.as_view()),
]
