from __future__ import unicode_literals
from django.shortcuts import render
from django.http import HttpResponse
from django.views.generic import View

class TemplateView(View):
    template_name = 'swagger-ui.html'

    def get(self, request):
          return render(request, self.template_name)