# from rest_framework import serializers
# from .models import Supply, SupplyData, Organization
#
#
# class SupplyDataSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = SupplyData
#         fields = ['timestamp', 'value']
#
#
# class SupplySerializer(serializers.ModelSerializer):
#     data = SupplyDataSerializer(many=True)
#
#     class Meta:
#         model = Supply
#         fields = ['supply', 'data']
#
#
# class OrganizationSerializer(serializers.ModelSerializer):
#     data = SupplySerializer(many=True)
#
#     class Meta:
#         model = Organization
#         fields = ['organization', 'data']
