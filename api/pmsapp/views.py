from django.shortcuts import render, get_object_or_404
from rest_framework import permissions
from rest_framework import status
from rest_framework.response import Response
from rest_framework.generics import (
    CreateAPIView, ListAPIView,
    ListCreateAPIView, RetrieveUpdateDestroyAPIView)

from . models import Patient, Medicine, DrugPrescribed, Prescription
from . serializers import (PatientSerializer, DrugPrescribedSerializer,
                           MedicineSerializer, PrescriptionSerializer,
                           FullPrescriptionSerializer, FullDrugPrescribedSerializer)
# Create your views here.

class PatientView(ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer

class PatientUpdateView(RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Patient.objects.all()
    serializer_class = PatientSerializer

class MedicineView(ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Medicine.objects.all()
    serializer_class = MedicineSerializer

class MedicineUpdateView(RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Medicine.objects.all()
    serializer_class = MedicineSerializer

class DrugPrescribeView(ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = DrugPrescribed.objects.all()
    serializer_class = FullDrugPrescribedSerializer


class GetDrugPrescriptionView(ListAPIView):
    # permission_classes = [permissions.IsAuthenticated]
    # queryset = DrugPrescribed.objects.all()
    serializer_class = FullDrugPrescribedSerializer

    def get_queryset(self):
        return DrugPrescribed.objects.filter(prescription__pres_id=self.kwargs['pk'])
    
    
class PrescriptionView(ListCreateAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer

    def post(self, request):
        data = request.data
        print(f"data: {data}")
        # drug_prescribed_data = data.pop('drug_prescribed')
        drug_prescribed_data = data.pop('drug_prescribed', [])

        # prescription
        prescription_serializer = PrescriptionSerializer(data=data)
        if prescription_serializer.is_valid():
            prescription_instance = prescription_serializer.save(total=0)

            total = 0

            for dp_data in drug_prescribed_data:
                dp_data['prescription'] = prescription_instance.pk
                dp_serializer = DrugPrescribedSerializer(data=dp_data)
                if dp_serializer.is_valid():
                    dp_instance = dp_serializer.save()
                    print(f"totale: {dp_instance.total}")
                    total += dp_instance.total
                else:
                    return Response(dp_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
                
                prescription_instance.total = total
                prescription_instance.payment_made = True
                prescription_instance.save()


            return Response(prescription_serializer.data, status=status.HTTP_201_CREATED)
        else:
            return Response(prescription_serializer.errors, status=status.HTTP_400_BAD_REQUEST)
       

class PrescriptionModifyView(RetrieveUpdateDestroyAPIView):
    permission_classes = [permissions.IsAuthenticated]
    queryset = Prescription.objects.all()
    serializer_class = PrescriptionSerializer


class GenerateVisitationReport(ListAPIView):
    queryset = Prescription.objects.all()
    # queryset = DrugPrescribed.objects.all()
    serializer_class = FullPrescriptionSerializer
    # serializer_class = FullDrugPrescribedSerializer

    def get_queryset(self):
        qs = super().get_queryset()
        from_date = self.request.query_params.get('from')
        to_date = self.request.query_params.get('to')

        if self.request.user.is_authenticated:
            return Prescription.objects.filter(date__range = (from_date, to_date))
            return DrugPrescribed.objects.filter(prescription__date__range = (from_date, to_date))
        else:
            return Prescription.objects.none()
            # return DrugPrescribed.objects.none()
