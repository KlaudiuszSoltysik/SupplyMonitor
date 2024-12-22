from rest_framework import serializers

class WeatherSerializer(serializers.Serializer):
    main = serializers.CharField()
    description = serializers.CharField()
    temperature = serializers.FloatField()
    humidity = serializers.IntegerField()
    pressure = serializers.IntegerField()