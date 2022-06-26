from array import array
from turtle import pu
from django.forms import model_to_dict
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny

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

