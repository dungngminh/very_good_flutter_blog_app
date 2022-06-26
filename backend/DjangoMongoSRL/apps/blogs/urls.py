from django.urls import include, path
from rest_framework import routers

from ..blogs import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('blog/', views.BlogManage.as_view(),name='blog'),
    path('blog/<int:pk>/', views.BlogManage.as_view()),
    path('search/',views.postFilter.as_view(),name='blogsearch')
]
