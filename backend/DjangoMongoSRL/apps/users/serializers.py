from pkg_resources import require
from rest_framework import serializers
from .models import User

class LoginSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    password = serializers.CharField(required=True)

class RegisterSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            'username',
            'password',
            'last_name',
            'first_name',
            'email',
        ]

class UserSerializer(serializers.ModelSerializer):
    class Meta:
        model = User
        fields = [
            '_id',
            'username',
            'password',
            'last_name',
            'first_name',
            'email',
        ]

class UserViewSerializer(serializers.Serializer):
    username = serializers.CharField(required=True)
    last_name = serializers.CharField(required=False)
    first_name = serializers.CharField(required=False)
    _id = serializers.CharField(required=True)
    email = serializers.CharField(required=False)