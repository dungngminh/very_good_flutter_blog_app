from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import status
from bson.objectid import ObjectId
from apps.utils.response import ResponseMessage
from apps.utils.jwt import JsonWebTokenHelper
from apps.utils.database import mongo_extension
from .models import User
from .serializers import UserViewSerializer, UserViewPutSerializer
from apps.utils.response import HttpResponse
from .middleware import UserMiddleware


class UserView(APIView):
    permission_classes = (AllowAny, )

    def get(self, request, *args, **kwargs):
        id = ''
        try:
            id = kwargs['id']
        except:
            id = ''

        try:
            if id:
                user = User.objects.get(_id = ObjectId(id))
                data = (UserViewSerializer(user).data)

                return HttpResponse.response(
                    data=data,
                    message='get_info_successfully',
                    status=status.HTTP_200_OK,
                )
            else:
                user = list(User.objects.all())
                data = list(map(lambda x: (UserViewSerializer(x)).data, user))
                return HttpResponse.response(
                    data=data,
                    message='error',
                    status=status.HTTP_200_OK,
                )
        except Exception as e:
            print(e)
            return HttpResponse.response(
                    data={},
                    message='error',
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

    def put(self, request, *args, **kwargs):
        id = ''
        try:
            id = kwargs['id']
        except:
            id = ''

        if not id:
            return HttpResponse.response(
                data={},
                message='missing_id',
                status=status.HTTP_400_BAD_REQUEST,
            )

        else:
            try:
                if not UserMiddleware.authorization(request.META['HTTP_AUTHORIZATION'], id):
                    return HttpResponse.response(
                        data = {},
                        message = ResponseMessage.UNAUTHORIZED,
                        status = status.HTTP_401_UNAUTHORIZED
                    )

                print(request.data)
                serialize = UserViewPutSerializer(data = request.data)

                if serialize.is_valid(raise_exception=False):
                    user = User.objects.get(_id = ObjectId(serialize.data['_id']))

                    user.first_name = serialize.data['first_name']
                    user.last_name = serialize.data['last_name']
                    user.avatar = serialize.data['avatar']

                    user.save()

                    return HttpResponse.response(
                        data=UserViewSerializer(user).data,
                        message='success',
                        status=status.HTTP_200_OK,
                    )

                else:
                    return HttpResponse.response(
                        data={},
                        message='serializer_not_valid',
                        status=status.HTTP_400_BAD_REQUEST,
                    )
            except Exception as e:
                print(e)
                return HttpResponse.response(
                    data={},
                    message='error',
                    status=status.HTTP_500_INTERNAL_SERVER_ERROR,
                )

    def delete(self, request, *args, **kwargs):
        try:
            id = ''
            try:
                id = kwargs['id']
            except:
                id = ''
            if not id:
                return HttpResponse.response(
                    data={},
                    message='error',
                    status=status.HTTP_400_BAD_REQUEST,
                )

            if not UserMiddleware.authorization(request.META['HTTP_AUTHORIZATION'], id):
                    return HttpResponse.response(
                        data = {},
                        message = ResponseMessage.UNAUTHORIZED,
                        status = status.HTTP_401_UNAUTHORIZED
                    )

            else:
                user = User.objects.get(_id = ObjectId(id))
                user.delete()
                return HttpResponse.response(
                    data={},
                    message='success',
                    status=status.HTTP_200_OK,
                )   
        except Exception as e:
            return HttpResponse.response(
                data={},
                message='error',
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

class UserDeviceToken(APIView):
    permission_classes = (AllowAny, )
    database = mongo_extension.get_database()

    def put(self, request, *a, **b):
        id = ''
        try:
            id = b['id']
            if not id:
                return HttpResponse.response({}, 'unauthorized', status.HTTP_401_UNAUTHORIZED)
            else:
                user = User.objects.get(_id = ObjectId(id))
                if not user:
                    return HttpResponse.response({}, '', status.HTTP_400_BAD_REQUEST)
                payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
                if not payload or payload['_id'] != id:
                    return HttpResponse.response({}, 'unauthorized', status.HTTP_401_UNAUTHORIZED)
                device_token = request.data['device_token']
                self.database.users_user.update_one({ '_id': ObjectId(id) }, 
                    { 
                        '$set': {
                            'device_token': device_token,
                        },
                });
                return HttpResponse.response({}, 'success', status.HTTP_200_OK)
        except:
            return HttpResponse.response({}, '', status.HTTP_500_INTERNAL_SERVER_ERROR)