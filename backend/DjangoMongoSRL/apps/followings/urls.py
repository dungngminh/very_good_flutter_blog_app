from django.urls import include, path
from rest_framework import routers
from .views import FollowView

# Follow
# Unfollow

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('following', FollowView.as_view()),
    path('following/<str:id>', FollowView.as_view()),]

