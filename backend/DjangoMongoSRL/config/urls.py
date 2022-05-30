"""DjangoMongoSRL URL Configuration

The `urlpatterns` list routes URLs to views. For more information please see:
    https://docs.djangoproject.com/en/3.0/topics/http/urls/
Examples:
Function views
    1. Add an import:  from my_app import views
    2. Add a URL to urlpatterns:  path('', views.home, name='home')
Class-based views
    1. Add an import:  from other_app.views import Home
    2. Add a URL to urlpatterns:  path('', Home.as_view(), name='home')
Including another URLconf
    1. Import the include() function: from django.urls import include, path
    2. Add a URL to urlpatterns:  path('blog/', include('blog.urls'))
"""
from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include, re_path
from rest_framework_swagger.renderers import SwaggerUIRenderer, OpenAPIRenderer
from rest_framework import permissions
from drf_yasg.views import get_schema_view
from drf_yasg import openapi
from rest_framework_swagger.views import get_swagger_view
from apps.swagger.views import TemplateView
from django.views import static as another_static

swagger_view = get_schema_view(
   openapi.Info(
      title="Snippets API",
      default_version='v1',
      description="Test description",
      terms_of_service="https://www.google.com/policies/terms/",
      contact=openapi.Contact(email="contact@snippets.local"),
      license=openapi.License(name="BSD License"),
   ),
   public=True,
   permission_classes=[permissions.AllowAny],
)

schema_view = get_swagger_view(title='My great API', url='./swagger.yaml')

urlpatterns = [\
    re_path(r'.well-known/pki-validation/(?P<path>.*)$', another_static.serve, {'document_root': settings.STATIC_ROOT + "/ssl-cert"}),
    re_path(r'^swagger(?P<format>\.json|\.yaml)$', swagger_view.without_ui(cache_timeout=0), name='schema-json'),
    re_path(r'^swagger/$', swagger_view.with_ui('swagger', cache_timeout=0), name='schema-swagger-ui'),
    path('swagger-ui/', TemplateView.as_view()),
    path('documentation/', schema_view),
    path('admin/', admin.site.urls),
    path('api/v1/auth/', include('apps.authentication.urls')),
    path('api/v1/', include('apps.users.urls')),
    path('', include('rest_framework.urls', namespace='rest_framework')),
] + static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)

if settings.DEBUG:
    urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
