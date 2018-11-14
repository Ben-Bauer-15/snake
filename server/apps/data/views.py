from django.shortcuts import render, HttpResponse, redirect
from .models import *
import json
from datetime import datetime
from django.views.decorators.csrf import csrf_exempt

def index(request):
    
    allScores = Score.objects.getAllScores()
    if len(allScores) < 5:
        return HttpResponse(json.dumps(allScores), content_type = 'application/json')

    myList = allScores[:5]
    print(myList)
    return HttpResponse(json.dumps(myList), content_type = 'application/json')

@csrf_exempt
def addScore(request):
    score = request.POST['newScore']
    scoreList = score.split(",")
    Score.objects.create(name = scoreList[0], score = scoreList[1])
    return HttpResponse("Bllah")