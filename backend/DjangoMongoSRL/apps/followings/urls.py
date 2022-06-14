from django.urls import include, path
from rest_framework import routers
from .views import FollowingManage

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('/followings', FollowingManage.as_view()),
]
