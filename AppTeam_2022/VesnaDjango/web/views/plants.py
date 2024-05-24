from django.shortcuts import render
from django.views import View

class Plants(View):
    def get(self, request):

        return render(request, 'devices/list_plants.html')
