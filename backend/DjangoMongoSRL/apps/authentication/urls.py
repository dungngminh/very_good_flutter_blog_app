from django.urls import include, path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
urlpatterns = [
    path('login', views.UserView.as_view()),
    path('register', views.UserView.as_view()),
]
