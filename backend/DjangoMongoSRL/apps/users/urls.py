from django.urls import include, path
from rest_framework import routers
from ..users import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('users', views.UserView.as_view()),
    path('users/<str:id>', views.UserView.as_view()),
    path('users/<str:id>/device-token', views.UserDeviceToken.as_view()),
]
