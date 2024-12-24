from django.db import models


class Organization(models.Model):
    organization = models.CharField(max_length=100)

    def __str__(self):
        return self.organization


class Supply(models.Model):
    organization = models.ForeignKey(Organization, on_delete=models.CASCADE)
    supply = models.CharField(max_length=50)

    def __str__(self):
        return f"{self.organization} - {self.supply}"


class SupplyData(models.Model):
    supply = models.ForeignKey(Supply, on_delete=models.CASCADE)
    timestamp = models.DateTimeField()
    value = models.IntegerField()

    def __str__(self):
        return f"{self.supply} - {self.timestamp} - {self.value}"
