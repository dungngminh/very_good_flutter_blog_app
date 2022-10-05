import json
from bson import json_util
from django.core import serializers
from bson import ObjectId
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from apps.utils.response import ResponseMessage
from rest_framework import status
from apps.utils.response import HttpResponse
from apps.utils.jwt import JsonWebTokenHelper
from apps.utils.database import mongo_extension
from .models import Following
from apps.users.models import User
from apps.users.serializers import UserViewSerializer
from apps.notifications.service import pubsub
from apps.utils.topic import get_follow_topic, get_post_topic
# Create your views here.

def convert_objectId(x):
    x['_id'] = str(x['_id'])
    return x

class FollowView(APIView):
    permission_classes = (AllowAny,)
    database = mongo_extension.get_database()

    def get(self, request, *args, **kwargs):
        try:
            user_id = request.query_params['user_id'] if "user_id" in request.query_params else ""
            direction = request.query_params['direction'] if "direction" in request.query_params else ['in', 'out']

            if direction == 'both':
                direction = ['in', 'out']
            else:
                direction = [direction]

            if not user_id:
                return HttpResponse.response(data = {}, message = ResponseMessage.INVALID_DATA, status = status.HTTP_400_BAD_REQUEST)
            
            followers = []
            followings = []
            
            if 'in' in direction:
                followers = list(self.database.followings_following.find({ 'receiver': user_id }))
                ids = list(map(lambda x: ObjectId(x['sender']), followers))
                followers = list(
                    map(
                        convert_objectId,
                        list(self.database.users_user.find({ '_id': { '$in': ids } }, { 'password': 0 }))
                    )
                )

            if 'out' in direction:
                followings = list(self.database.followings_following.find({ 'sender': user_id }))
                ids = list(map(lambda x: ObjectId(x['receiver']), followings))
                print(ids)
                followings = list(
                    map(
                        convert_objectId,
                        list(self.database.users_user.find({ '_id': { '$in': ids } }, { 'password': 0 }))
                    )
                )

            response_data = {}
            if len(followers) >= 0:
                response_data['followers'] = followers
            if len(followings) >= 0:
                response_data['followings'] = followings

            print(response_data)
            
            return HttpResponse.response(data=response_data, message=ResponseMessage.SUCCESS, status=status.HTTP_200_OK) 

        except Exception as e:
            print(e)
            return HttpResponse.response(
                data = {},
                message = ResponseMessage.INTERNAL_SERVER_ERROR,
                status = status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def delete(self, request, *args, **kwargs):
        try:
            follow_id = kwargs['id']
            if not follow_id:
                return HttpResponse.response(data={}, message='failed', status=status.HTTP_400_BAD_REQUEST)

            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])

            if not payload:
                return HttpResponse.response(data={}, message='failed', status=status.HTTP_401_UNAUTHORIZED)

            sender_id = payload['_id']

            follow_record = dict(self.database.followings_following.find_one({ '_id': ObjectId(follow_id) }))

            if not follow_record:
                return HttpResponse.response(data={}, message='failed', status=status.HTTP_400_BAD_REQUEST)

            receiver_id = follow_record['receiver']
            sender = self.database.users_user.find_one({ '_id': ObjectId(sender_id) })

            if not sender:
                return HttpResponse.response(
                    data = {},
                    message = ResponseMessage.INVALID_DATA,
                    status = status.HTTP_400_BAD_REQUEST
                )
            
            if sender_id != str(follow_record['sender']):
                return HttpResponse.response(data={}, message='failed', status=status.HTTP_401_UNAUTHORIZED)
            
            self.database.followings_following.delete_one({ 'sender': sender_id, '_id': ObjectId(follow_id) })
            pubsub.unsubscribe(sender['device_token'], receiver_id)

            self.database.users_user.update_one({ '_id': ObjectId(sender_id) }, { '$inc': { 'following_count': -1 } });
            self.database.users_user.update_one({ '_id': ObjectId(receiver_id) }, { '$inc': { 'follower_count': -1 } });

            return HttpResponse.response(
                data = {},
                message = ResponseMessage.SUCCESS,
                status = status.HTTP_200_OK
            )

        except Exception as e:
            return HttpResponse.response(
                data = {},
                message = str(e),
                status = status.HTTP_500_INTERNAL_SERVER_ERROR
            )

    def post(self, request, *args, **kwargs):
        try:
            jwt = request.META['HTTP_AUTHORIZATION']
            # Author
            payload = JsonWebTokenHelper.decode(jwt)
            if not payload:
                return HttpResponse.response(
                    data = {},
                    message = ResponseMessage.UNAUTHORIZED,
                    status = status.HTTP_401_UNAUTHORIZED,
                )
            receiver_id = request.data['receiver_id']
            sender_id = payload['_id']
            # Check receiver, sender
            receiver = dict(self.database.users_user.find_one({ '_id': ObjectId(receiver_id) }))
            sender = dict(self.database.users_user.find_one({ '_id': ObjectId(sender_id) }))

            if not sender or not receiver:
                return HttpResponse.response(
                    data = {},
                    message = ResponseMessage.INVALID_DATA,
                    status = status.HTTP_400_BAD_REQUEST
                )

            is_existed = self.database.followings_following.find_one({
                "sender": sender_id,
                "receiver": receiver_id,
            })

            if is_existed:
                return HttpResponse.response(data={}, message='existed', status=status.HTTP_200_OK)

            following_obj = Following.objects.create(
                _id = ObjectId(),
                sender = sender_id,
                receiver = receiver_id,
            )

            self.database.users_user.update_one({ '_id': ObjectId(sender_id) }, { '$inc': { 'following_count': 1 } });
            self.database.users_user.update_one({ '_id': ObjectId(receiver_id) }, { '$inc': { 'follower_count': 1 } });

            following_obj.save()

            pubsub.subscribe(sender['device_token'], get_post_topic(str(receiver['_id'])))
            pubsub.personal_publish(receiver['device_token'], sender['username'] + ' has just follwed you', {})

            return HttpResponse.response(
                data = {},
                message = ResponseMessage.SUCCESS,
                status = status.HTTP_201_CREATED,
            )
            
        except:
            return HttpResponse.response(
                data = {},
                message = "missing_receiver",
                status = status.HTTP_400_BAD_REQUEST,
            )
