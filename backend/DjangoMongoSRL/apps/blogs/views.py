from array import array
from django.forms import model_to_dict
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from apps.utils.response import ResponseMessage
from apps.utils.response import HttpResponse
from .serializers import BlogSerializer, BlogPostSerializer, BlogViewSerializer, BlogGetSerializer
from rest_framework.response import Response
from rest_framework import status
from bson.objectid import ObjectId
from bson import json_util
from django.core import serializers
import json
from apps.utils.database import mongo_extension
from . import models
from . import middleware
from datetime import datetime, timedelta

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)


def convert_timestamp(data: datetime):
    local_time = (data + timedelta(hours=7))
    return int(datetime.timestamp(local_time))

def map_timestamp(x):
    x['_id'] = str(x['_id'])
    x['author_detail']['_id'] = str(x['author_detail']['_id'])
    del x['author_id']
    x['created_at'] = convert_timestamp(x['created_at'])
    x['updated_at'] = convert_timestamp(x['updated_at'])
    x['category'] = x['category'][0]
    return x

class BlogManage(APIView):
    permission_classes = (AllowAny,)
    serializer_class = BlogSerializer
    db = mongo_extension.get_database()

    def get(self, request, *args, **kwargs):
        try:
            id = kwargs['id']
        except:
            id = ''

        try:
            if id:
                blog_dict = self.db.blogs_blog.find_one({ '_id': ObjectId(id) })
                user = self.db.users_user.find_one({ '_id': ObjectId(blog_dict['author_id']) })
                del user['password']
                del user['created_at']
                del user['updated_at']
                del blog_dict['author_id']
                user['_id'] = str(user['_id'])
                blog_dict['_id'] = str(blog_dict['_id'])
                blog_dict['author_detail'] = user
                blog_dict['category'] = blog_dict['category'][0]
                blog_dict['created_at'] = convert_timestamp(blog_dict['created_at'])
                blog_dict['updated_at'] = convert_timestamp(blog_dict['updated_at'])
                
                return HttpResponse.response(
                    data=blog_dict,
                    message=ResponseMessage.GET_BLOG_SUCCESSFULLY,
                    status=status.HTTP_200_OK,
                )

            categories = (request.query_params['category'].split(',')) if "category" in request.query_params else []
            search = (request.query_params['search']) if "search" in request.query_params else ""
            page = (int(request.query_params['page'])) if "page" in request.query_params else 1
            limit = (int(request.query_params['limit'])) if "limit" in request.query_params else 10
            author_id = (request.query_params['author_id']) if "author_id" in request.query_params else ""
            offset = (page - 1) * limit

            pipelines = [
                { 
                    "$match": {
                        "title": { "$exists": True } if len(search) == 0 else { '$regex': search, '$options': 'i' },
                        "category": { "$exists": True } if len(categories) == 0 else { "$in": categories },
                        "author_id": { "$exists": True } if len(author_id) == 0 else author_id, 
                    },
                },
                {
                    "$addFields": {
                        "owner": {
                            "$toObjectId": "$author_id",
                        },
                    },
                },
                { 
                    "$lookup": {
                        "from": "users_user",
                        "localField": "owner",
                        "foreignField": "_id",
                        "as": "author_detail",
                    }
                },
                {
                    "$unwind": "$author_detail",
                },
                {
                    "$project": {
                        "author_detail": 1,
                        "title": 1,
                        "category": 1,
                        "image_url": 1,
                        "_id": 1,
                        "author_id": 1,
                        "likes": 1,
                        "created_at": 1,
                        "updated_at": 1,
                        "content": 1,
                    }
                },
                {
                    "$unset": [
                        "author_detail.password",
                    ]
                },
                {
                    "$skip": int(offset),
                },
                {
                    "$limit": int(limit),
                }
            ];

            records = self.db['blogs_blog'].aggregate(pipeline=pipelines);
            arr = list((map(map_timestamp, list(records))))

            return HttpResponse.response(
                data=arr,
                message=ResponseMessage.GET_BLOGS_SUCCESSFULLY,
                status=status.HTTP_200_OK,
            )

        except Exception as e:
            print(e)
            return Response(status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        try:
            jwt = request.META['HTTP_AUTHORIZATION']
            # Authorization
            payload = middleware.BlogMiddleware.authorization(jwt)
            if not payload:
                return HttpResponse.response(
                    data={},
                    message=ResponseMessage.UNAUTHORIZED,
                    status=status.HTTP_401_UNAUTHORIZED,
                )

            current_user = self.db.users_user.find_one({ '_id': ObjectId(payload['_id']) })
            if not current_user:
                return HttpResponse.response(
                    data={},
                    message=ResponseMessage.UNAUTHORIZED,
                    status=status.HTTP_401_UNAUTHORIZED,
                )

            serialize = BlogPostSerializer(data=request.data)
            if serialize.is_valid(raise_exception=True):
                # Check if user exists

                id = ObjectId()

                new_blog = models.Blog.objects.create(
                    _id=id,
                    author_id=payload['_id'],
                    content=serialize.data['content'],
                    title=serialize.data['title'].lower(),
                    category=serialize.data['category'],
                    image_url=serialize.data['image_url']
                )

                blog_dict = self.db.blogs_blog.find_one({ '_id': ObjectId(str(id)) })
                blog_dict['_id'] = str(blog_dict['_id'])
                blog_dict['created_at'] = convert_timestamp(blog_dict['created_at'])
                blog_dict['updated_at'] = convert_timestamp(blog_dict['updated_at'])

                self.db.users_user.update_one({
                    "_id": ObjectId(payload['_id'])
                }, {
                    "$inc": {
                        "num_blog": 1,
                    }
                });

                return HttpResponse.response(
                    data=blog_dict,
                    message='',
                    status=status.HTTP_201_CREATED,
                )
            else:
                return HttpResponse.response(
                    data={},
                    message='format is not true',
                    status=status.HTTP_400_BAD_REQUEST,
                )
        except Exception as e:
            print(e)
            return HttpResponse.response(
                data={},
                message=ResponseMessage.INTERNAL_SERVER_ERROR,
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def delete(self, request, *args, **kwargs):
        try:
            id = kwargs['id']
        except:
            id = ''

        try:
            if id:

                jwt = request.META['HTTP_AUTHORIZATION']
                payload = middleware.BlogMiddleware.authorization(jwt)
                if not payload:
                    return HttpResponse.response(
                        data={},
                        message=ResponseMessage.UNAUTHORIZED,
                        status=status.HTTP_401_UNAUTHORIZED,
                    )

                blog = models.Blog.objects.get(_id=ObjectId(id))
                if blog:
                    blog.delete()
                    self.db.users_user.update_one({
                        "_id": ObjectId(payload['_id'])
                    }, {
                        "$inc": {
                            "num_blog": -1,
                        }
                    });
                return HttpResponse.response(
                    data={},
                    message='delete_succeed',
                    status=status.HTTP_200_OK,
                )
            else:
                return HttpResponse.response(
                    data={},
                    message='id_is_not_provided',
                    status=status.HTTP_400_BAD_REQUEST,
                )
        except Exception as e:
            return HttpResponse.response(
                data={},
                message=ResponseMessage.INTERNAL_SERVER_ERROR,
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )

    def put(self, request, *args, **kwargs):
        try:
            id = kwargs['id']
        except:
            id = ''

        try:
            if id:
                jwt = request.META['HTTP_AUTHORIZATION']
                payload = middleware.BlogMiddleware.authorization(jwt)
                if not payload:
                    return HttpResponse.response(
                        data={},
                        message=ResponseMessage.UNAUTHORIZED,
                        status=status.HTTP_401_UNAUTHORIZED)

                blog = models.Blog.objects.get(_id=ObjectId(id))
                data = BlogPostSerializer(request.data).data

                blog_data = (model_to_dict(blog))

                if payload['_id'] != str(blog_data['author_id']):
                    return HttpResponse.response(
                        data={},
                        message=ResponseMessage.UNAUTHORIZED,
                        status=status.HTTP_401_UNAUTHORIZED)

                blog.content = data['content']
                blog.title = data['title']
                blog.image_url = data['image_url']
                blog.category = data['category']

                blog.save()
                data = BlogViewSerializer(blog).data

                data['category'] = data['category'][0]
            
                return HttpResponse.response(
                    data=data,
                    message=ResponseMessage.SUCCESS,
                    status=status.HTTP_200_OK,
                )

        except Exception as e:
            print(e)
            return HttpResponse.response(
                data={},
                message=ResponseMessage.INTERNAL_SERVER_ERROR,
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )
