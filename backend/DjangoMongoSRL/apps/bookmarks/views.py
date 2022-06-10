from django.http import HttpResponse
from rest_framework.views import APIView
from rest_framework.permissions import AllowAny
from rest_framework.response import Response
from rest_framework import status

class BookmarksView(APIView):
    permission_classes = (AllowAny, )

    def get(self, request):
        print('DMM')
        return Response({}, status.HTTP_200_OK)

    def post(self, request):
        return True
    
    def delete(self, request):
        return True