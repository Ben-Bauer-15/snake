from django.conf.urls import url
from . import views

urlpatterns = [
    url(r'^allGames$', views.index),
    url(r'^addScore$', views.addScore)
]