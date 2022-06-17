from django.urls import include, path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('blogs', views.BlogManage.as_view()),
    path('blogs/<str:id>', views.BlogManage.as_view()),
]
