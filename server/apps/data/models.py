from __future__ import unicode_literals
from django.db import models


class ScoreManager(models.Manager):
    def getAllScores(self):
        allObjects = Score.objects.all().order_by("-score")
        allScores = []
        for score in allObjects:
            allScores.append({"userName" : score.name, "score" : score.score})
        return allScores


class Score(models.Model):
    name = models.CharField(max_length = 255)
    score = models.IntegerField()
    date = models.DateTimeField(auto_now_add = True)
    objects = ScoreManager()