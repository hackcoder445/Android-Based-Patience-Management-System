from django.urls import path
from . views import (PatientView, PatientUpdateView, 
                     MedicineView, MedicineUpdateView,
                     DrugPrescribeView, GetDrugPrescriptionView,
                     PrescriptionView, PrescriptionModifyView, GenerateVisitationReport)

urlpatterns = [
    path('patient/', PatientView.as_view(), name='patient'),
    path('patient/<str:pk>/', PatientUpdateView.as_view(), name='patient_modify'),
    path('medicine/', MedicineView.as_view(), name='medicine'),
    path('medicine/<str:pk>/', MedicineUpdateView.as_view(), name='medicine'),
    path('prescribe-drug/', DrugPrescribeView.as_view(), name='prescribe_drug'),
    path('prescription/', PrescriptionView.as_view(), name='prescription'),
    path('prescription/<str:pk>/', PrescriptionModifyView.as_view(), name='prescription_modify'),
    path('drug-prescription/<str:pk>/', GetDrugPrescriptionView.as_view(), name='drug_prescription'),
    path('visitation-report/', GenerateVisitationReport.as_view(), name='visitation_report')
]

