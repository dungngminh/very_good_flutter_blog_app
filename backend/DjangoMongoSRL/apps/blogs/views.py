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

class JSONEncoder(json.JSONEncoder):
    def default(self, o):
        if isinstance(o, ObjectId):
            return str(o)
        return json.JSONEncoder.default(self, o)

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
                blog = models.Blog.objects.get(_id=ObjectId(id))
                return HttpResponse.response(
                    data=BlogViewSerializer(blog).data,
                    message=ResponseMessage.GET_BLOG_SUCCESSFULLY,
                    status=status.HTTP_200_OK,
                )

            categories = (request.query_params['category'].split(',')) if "category" in request.query_params else []
            search = (request.query_params['search']) if "search" in request.query_params else ""
            page = (int(request.query_params['page'])) if "page" in request.query_params else 0
            limit = (int(request.query_params['limit'])) if "limit" in request.query_params else 10
            author_id = (request.query_params['author_id']) if "author_id" in request.query_params else ""
            offset = (page - 1) * limit

            pipelines = [
                { 
                    "$match": {
                        "title": { "$exists": True } if len(search) == 0 else search,
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
                        "content": 1,
                        "category": 1,
                        "image_url": 1,
                        "_id": 1,
                        "author_id": 1,
                        "likes": 1,
                        "created_at": 1,
                        "updated_at": 1,
                    }
                },
                {
                    "$unset": [
                        "author_detail._id",
                        "author_detail.password",
                    ]
                }
            ];

            records = self.db['blogs_blog'].aggregate(pipeline=pipelines);
            arr = list(records)
            serializer = BlogGetSerializer(arr, many=True)

            return HttpResponse.response(
                data=serializer.data,
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
            print(payload)
            if not payload:
                return HttpResponse.response(
                    data={},
                    message=ResponseMessage.UNAUTHORIZED,
                    status=status.HTTP_401_UNAUTHORIZED,
                )
            print(request.data)
            serialize = BlogPostSerializer(data=request.data)
            if serialize.is_valid(raise_exception=True):
                # Check if user exists
                new_blog = models.Blog.objects.create(
                    _id=ObjectId(),
                    author_id=payload['_id'],
                    content=serialize.data['content'],
                    title=serialize.data['title'].lower(),
                    category=serialize.data['category'],
                )

                new_blog.save()
                dict_obj = json.loads(json_util.dumps(
                    serializers.serialize('python', [new_blog, ])[0]['fields']))

                return HttpResponse.response(
                    data=dict_obj,
                    message='ok',
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
                blog = models.Blog.objects.get(_id=ObjectId(id))
                if blog:
                    blog.delete()
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
            blog = models.Blog.objects.get(_id=ObjectId(id))
            data = BlogPostSerializer(request.data).data

            blog.content = data['content']
            blog.title = data['title']
            blog.image_url = data['image_url']
            blog.category = data['category']

            blog.save()
            data = BlogViewSerializer(blog).data

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
