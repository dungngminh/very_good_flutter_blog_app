from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import status
from bson.objectid import ObjectId
from .models import User
from .serializers import UserViewSerializer
from apps.utils.response import HttpResponse


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
                serialize = UserViewSerializer(data = request.data)

                if serialize.is_valid(raise_exception=False):
                    print(serialize.data)
                    user = User.objects.get(_id = serialize.data['_id'])

                    user.first_name = serialize.data['first_name']
                    user.last_name = serialize.data['last_name']
                    user.username = serialize.data['username']

                    print(user, 'ad')

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
                print(str(e))

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
            else:
                user = User.objects.get(_id = id)
                user.delete()
                return HttpResponse.response(
                    data={},
                    message='success',
                    status=status.HTTP_200_OK,
                )   
        except:
            return HttpResponse.response(
                data={},
                message='error',
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
