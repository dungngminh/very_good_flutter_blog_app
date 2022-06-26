from rest_framework import serializers

class FollowViewSerializer(serializers.Serializer):
    _id = serializers.CharField()
    sender = serializers.CharField()
    receiver = serializers.CharField()