from django.urls import include, path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('bookmarks', views.BookmarksView.as_view()),
    path('bookmarks/<str:id>', views.BookmarksView.as_view()),
]