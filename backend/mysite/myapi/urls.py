from django.urls import include, path
from rest_framework import routers
from . import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('book', views.BookManage.as_view()),
    path('book/<int:id>', views.BookManage.as_view()),
    path('staff/login', views.StaffLoginView.as_view(), name='login'),
    # path('user/', views.UserManage.as_view()),
    # path('rating', views.RatingManage.as_view()),
]
