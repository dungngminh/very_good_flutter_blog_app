from asyncio.log import logger
from bson import ObjectId
from apps.utils.response import ResponseMessage
from apps.utils.response import HttpResponse
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework import status
from apps.utils.jwt import JsonWebTokenHelper
from apps.utils.database import mongo_extension
from .models import Likes
from datetime import datetime, timedelta

# add code view like

def convert_timestamp(data: datetime):
    local_time = (data + timedelta(hours=7))
    return int(datetime.timestamp(local_time))

def convert_data(data):
    data['created_at'] = convert_timestamp(data['created_at'])
    
    data['updated_at'] = convert_timestamp(data['updated_at'])
    
    data['_id'] = str(data['_id'])
    
    return data

class LikesView(APIView):
    permission_classes = (AllowAny, )
    
    database = mongo_extension.get_database()

    def post(self, request, *a, **b):
        try:
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            if not payload:
                return HttpResponse.response({}, ResponseMessage.UNAUTHORIZED, status.HTTP_401_UNAUTHORIZED)
            
            blog_id = request.data['blog_id']
            user_id = payload['_id']

            likes = Likes.objects.create(
                _id = ObjectId(),
                
                blog_id = blog_id,
                
                user_id = user_id,
                
            )

            likes.save()
            return HttpResponse.response({}, ResponseMessage.SUCCESS, status.HTTP_200_OK)

        except Exception as e:
            print(e)
            return HttpResponse.response({}, ResponseMessage.INTERNAL_SERVER_ERROR, status.HTTP_500_INTERNAL_SERVER_ERROR)

    
    def get(self, request, *a, **b):
        try:
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            if not payload:
                return HttpResponse.response({}, ResponseMessage.UNAUTHORIZED, status.HTTP_401_UNAUTHORIZED)
            
            user_id = payload['_id']

            blogs = self.database.likes_likes.find({
                'user_id': user_id,
            })

            blogs = list(blogs)
            blogs = list(map(convert_data, blogs))

            return HttpResponse.response(blogs, ResponseMessage.SUCCESS, status.HTTP_200_OK)

        except Exception as e:
            print(e)
            return HttpResponse.response({}, ResponseMessage.INTERNAL_SERVER_ERROR, status.HTTP_500_INTERNAL_SERVER_ERROR)


    def delete(self, request, *a, **b):
        try:
            payload = JsonWebTokenHelper.decode(request.META['HTTP_AUTHORIZATION'])
            
            if not payload:
                
                return HttpResponse.response({}, ResponseMessage.UNAUTHORIZED, status.HTTP_401_UNAUTHORIZED)
            
            user_id = payload['_id']
            blog_id = request.data['blog_id']

            self.database.likes_likes.delete_one({
                'user_id': user_id,
                'blog_id': blog_id,
            })

            return HttpResponse.response({}, ResponseMessage.SUCCESS, status.HTTP_200_OK)

        except Exception as e:
            
            print(e)
            
            return HttpResponse.response({}, ResponseMessage.INTERNAL_SERVER_ERROR, status.HTTP_500_INTERNAL_SERVER_ERROR)
        
    # def patch(self, request, pk, format=None):
    #     rating_obj = models.Likes.objects.get(pk=pk)
    #     serializer = RatingSerializer(
    #         data=request.data, instance=rating_obj, partial=True)
    #     if serializer.is_valid():
    #         serializer.save()
    #         return Response({"Message": "Data updated successfully !!"})
    #     else:
    #         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


