from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import status

from apps.utils.jwt import JsonWebTokenHelper
from apps.users.models import User
from apps.users.serializers import UserSerializer, LoginSerializer, RegisterSerializer, UserViewSerializer
from apps.users.response import ResponseMessage, HttpResponse
from apps.utils.hashing import HashingHelper
from bson.objectid import ObjectId
from datetime import datetime

class UserView(APIView):
    permission_classes = (AllowAny, )

    def post(self, request):
        path = request.path_info
        
        if 'login' in path:
            serialize = LoginSerializer(data = request.data)
            if serialize.is_valid():
                # Authentication
                plain_password = serialize.data['password']
                user = User.objects.get(username = serialize.data['username'])

                data = (UserSerializer(user).data)

                if not HashingHelper.compare(data['password'], plain_password):
                    return HttpResponse.response(
                        data = { },
                        message = ResponseMessage.LOGIN_FAILED,
                        status = status.HTTP_401_UNAUTHORIZED,
                    )

                # Return token
                now = datetime.now()
                payload = {
                    '_id': data['_id'],
                    'issued_at': now.strftime("%m/%d/%Y %H:%M:%S"),
                    'username': data['username'],
                    'first_name': data['first_name'],
                    'last_name': data['last_name'],
                    'email': data['email'],
                }

                token = JsonWebTokenHelper.generate(payload)

                return HttpResponse.response(
                    data = {'jwt': token },
                    message = ResponseMessage.LOGIN_SUCCESS,
                    status = status.HTTP_200_OK,
                )

        if 'register' in path:
            serialize = RegisterSerializer(data = request.data)
            if serialize.is_valid():
                # Validate
                

                # Hash password
                hashed_password = HashingHelper.encrypt(serialize.data['password'])

                # Save user
                new_user = User.objects.create(
                    _id = ObjectId(),
                    username = serialize.data['username'],
                    password = hashed_password,
                    last_name = serialize.data['last_name'],
                    first_name = serialize.data['first_name'],
                    email = serialize.data['email'],
                )

                new_user.save()

                user_serializer = UserViewSerializer(new_user)

                return HttpResponse.response(
                    data = user_serializer.data,
                    message = ResponseMessage.LOGIN_SUCCESS,
                    status = status.HTTP_200_OK,
                )
        
        return HttpResponse.response(
            data = {},
            message = 'error',
            status = status.HTTP_400_BAD_REQUEST,
        )
        