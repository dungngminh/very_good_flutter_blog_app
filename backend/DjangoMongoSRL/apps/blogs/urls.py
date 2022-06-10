from django.urls import include, path
from rest_framework import routers

from ..blogs import views

router = routers.DefaultRouter()
urlpatterns = [
    path('', include(router.urls)),
    path('blog', views.BlogManage.as_view()),
    # path('blog/<int:id>', views.BlogManage.as_view()),
    # path('blog/<int:id_user>', views.BlogManage.as_view())
]
