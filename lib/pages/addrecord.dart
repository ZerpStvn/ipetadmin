import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/model/authprovider.dart';
import 'package:provider/provider.dart';

class AddMedicalRecord extends StatefulWidget {
  final bool isedit;
  final bool isview;
  final String? recordID;
  const AddMedicalRecord(
      {super.key, required this.isedit, required this.isview, this.recordID});

  @override
  State<AddMedicalRecord> createState() => _AddMedicalRecordState();
}

class _AddMedicalRecordState extends State<AddMedicalRecord> {
  // Define a global key for the form
  final _formKey = GlobalKey<FormState>();

  // Controllers for owner information
  final ownerNameController = TextEditingController();
  final ownerAddressController = TextEditingController();
  final ownerPhoneController = TextEditingController();
  final ownerEmailController = TextEditingController();

  // Controllers for pet information
  final petNameController = TextEditingController();
  final petSpeciesController = TextEditingController();
  final petBreedController = TextEditingController();
  final petGenderController = TextEditingController();
  final petDobController = TextEditingController();
  final petColorController = TextEditingController();
  final microchipNumberController = TextEditingController();
  final spayedNeuteredController = TextEditingController();

  // Controllers for medical history
  final previousClinicsController = TextEditingController();
  final previousConditionsController = TextEditingController();
  final currentConditionsController = TextEditingController();
  final allergiesController = TextEditingController();
  final currentMedicationsController = TextEditingController();
  final vaccinationHistoryController = TextEditingController();
  final surgicalHistoryController = TextEditingController();
  final chronicDiseasesController = TextEditingController();

  // Controllers for current visit information
  final visitDateController = TextEditingController();
  final reasonForVisitController = TextEditingController();
  final symptomsController = TextEditingController();
  final durationOfSymptomsController = TextEditingController();
  final behaviorChangesController = TextEditingController();
  final dietNutritionController = TextEditingController();
  final exerciseRoutineController = TextEditingController();
  final livingEnvironmentController = TextEditingController();
  final contactWithOtherAnimalsController = TextEditingController();

  @override
  void dispose() {
    // Dispose controllers to free up resources
    ownerNameController.dispose();
    ownerAddressController.dispose();
    ownerPhoneController.dispose();
    ownerEmailController.dispose();
    petNameController.dispose();
    petSpeciesController.dispose();
    petBreedController.dispose();
    petGenderController.dispose();
    petDobController.dispose();
    petColorController.dispose();
    microchipNumberController.dispose();
    spayedNeuteredController.dispose();
    previousClinicsController.dispose();
    previousConditionsController.dispose();
    currentConditionsController.dispose();
    allergiesController.dispose();
    currentMedicationsController.dispose();
    vaccinationHistoryController.dispose();
    surgicalHistoryController.dispose();
    chronicDiseasesController.dispose();
    visitDateController.dispose();
    reasonForVisitController.dispose();
    symptomsController.dispose();
    durationOfSymptomsController.dispose();
    behaviorChangesController.dispose();
    dietNutritionController.dispose();
    exerciseRoutineController.dispose();
    livingEnvironmentController.dispose();
    contactWithOtherAnimalsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 30),
        child: Column(
          children: [
            // Owner Information
            const Text('Owner Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: ownerNameController,
              decoration:
                  const InputDecoration(labelText: 'Owner\'s Full Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the owner\'s full name';
                }
                return null;
              },
            ),

            TextFormField(
              controller: ownerAddressController,
              decoration: const InputDecoration(labelText: 'Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ownerPhoneController,
              decoration: const InputDecoration(labelText: 'Phone Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the phone number';
                }
                if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
                  return 'Please enter a valid phone number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: ownerEmailController,
              decoration: const InputDecoration(labelText: 'Email Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the email address';
                }
                if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),

            const SizedBox(height: 20),

            // Pet Information
            const Text('Pet Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: petNameController,
              decoration: const InputDecoration(labelText: 'Pet\'s Name'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the pet\'s name';
                }
                return null;
              },
            ),
            TextFormField(
              controller: petSpeciesController,
              decoration: const InputDecoration(labelText: 'Species'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the species';
                }
                return null;
              },
            ),
            TextFormField(
              controller: petBreedController,
              decoration: const InputDecoration(labelText: 'Breed'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the breed';
                }
                return null;
              },
            ),
            TextFormField(
              controller: petGenderController,
              decoration: const InputDecoration(labelText: 'Gender'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the gender';
                }
                return null;
              },
            ),
            TextFormField(
              controller: petDobController,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the date of birth';
                }
                return null;
              },
            ),
            TextFormField(
              controller: petColorController,
              decoration: const InputDecoration(labelText: 'Color/Markings'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the color/markings';
                }
                return null;
              },
            ),
            TextFormField(
              controller: microchipNumberController,
              decoration: const InputDecoration(labelText: 'Microchip Number'),
            ),
            TextFormField(
              controller: spayedNeuteredController,
              decoration:
                  const InputDecoration(labelText: 'Spayed/Neutered Status'),
            ),

            const SizedBox(height: 20),

            // Medical History
            const Text('Medical History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: previousClinicsController,
              decoration: const InputDecoration(
                  labelText: 'Previous Veterinary Clinics'),
            ),
            TextFormField(
              controller: previousConditionsController,
              decoration: const InputDecoration(
                  labelText: 'Previous Medical Conditions'),
            ),
            TextFormField(
              controller: currentConditionsController,
              decoration: const InputDecoration(
                  labelText: 'Current Medical Conditions'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter current medical conditions';
                }
                return null;
              },
            ),
            TextFormField(
              controller: allergiesController,
              decoration: const InputDecoration(labelText: 'Allergies'),
            ),
            TextFormField(
              controller: currentMedicationsController,
              decoration:
                  const InputDecoration(labelText: 'Current Medications'),
            ),
            TextFormField(
              controller: vaccinationHistoryController,
              decoration:
                  const InputDecoration(labelText: 'Vaccination History'),
            ),
            TextFormField(
              controller: surgicalHistoryController,
              decoration: const InputDecoration(labelText: 'Surgical History'),
            ),
            TextFormField(
              controller: chronicDiseasesController,
              decoration: const InputDecoration(labelText: 'Chronic Diseases'),
            ),

            const SizedBox(height: 20),

            // Current Visit Information
            const Text('Current Visit Information',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextFormField(
              controller: visitDateController,
              decoration: const InputDecoration(labelText: 'Date of Visit'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the date of visit';
                }
                return null;
              },
            ),
            TextFormField(
              controller: reasonForVisitController,
              decoration: const InputDecoration(labelText: 'Reason for Visit'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the reason for visit';
                }
                return null;
              },
            ),
            TextFormField(
              controller: symptomsController,
              decoration: const InputDecoration(labelText: 'Symptoms Observed'),
            ),
            TextFormField(
              controller: durationOfSymptomsController,
              decoration:
                  const InputDecoration(labelText: 'Duration of Symptoms'),
            ),
            TextFormField(
              controller: behaviorChangesController,
              decoration: const InputDecoration(labelText: 'Behavior Changes'),
            ),
            TextFormField(
              controller: dietNutritionController,
              decoration:
                  const InputDecoration(labelText: 'Diet and Nutrition'),
            ),
            TextFormField(
              controller: exerciseRoutineController,
              decoration: const InputDecoration(labelText: 'Exercise Routine'),
            ),
            TextFormField(
              controller: livingEnvironmentController,
              decoration:
                  const InputDecoration(labelText: 'Living Environment'),
            ),
            TextFormField(
              controller: contactWithOtherAnimalsController,
              decoration: const InputDecoration(
                  labelText: 'Contact with Other Animals'),
            ),

            const SizedBox(height: 20),
            //Text("${provider.userModel!.vetid}"),
            // Submit Button
            SizedBox(
              width: 230,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: maincolor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8))),
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _addRecordToFirestore("${provider.userModel!.vetid}");
                  }
                },
                child: const Text(
                  'Submit',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addRecordToFirestore(String vetID) async {
    final formValues = {
      'owner_name': ownerNameController.text,
      'owner_address': ownerAddressController.text,
      'owner_phone': ownerPhoneController.text,
      'owner_email': ownerEmailController.text,
      'pet_name': petNameController.text,
      'pet_species': petSpeciesController.text,
      'pet_breed': petBreedController.text,
      'pet_gender': petGenderController.text,
      'pet_dob': petDobController.text,
      'pet_color': petColorController.text,
      'microchip_number': microchipNumberController.text,
      'spayed_neutered': spayedNeuteredController.text,
      'previous_clinics': previousClinicsController.text,
      'previous_conditions': previousConditionsController.text,
      'current_conditions': currentConditionsController.text,
      'allergies': allergiesController.text,
      'current_medications': currentMedicationsController.text,
      'vaccination_history': vaccinationHistoryController.text,
      'surgical_history': surgicalHistoryController.text,
      'chronic_diseases': chronicDiseasesController.text,
      'visit_date': visitDateController.text,
      'reason_for_visit': reasonForVisitController.text,
      'symptoms': symptomsController.text,
      'duration_of_symptoms': durationOfSymptomsController.text,
      'behavior_changes': behaviorChangesController.text,
      'diet_nutrition': dietNutritionController.text,
      'exercise_routine': exerciseRoutineController.text,
      'living_environment': livingEnvironmentController.text,
      'contact_with_other_animals': contactWithOtherAnimalsController.text,
      'date_added': DateTime.now(),
    };

    try {
      await FirebaseFirestore.instance
          .collection('medicalrecord')
          .doc(vetID)
          .collection('records')
          .add(formValues)
          .then((value) {
        showAlertinfo("New Record Added");
      });
    } catch (e) {
      showAlertinfo(
          "There was a problem uploading the data!\nPlease Try again later");
    }
  }

  void showAlertinfo(String content) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text("Information"),
            content: Text(content),
            actions: [
              TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Continue"))
            ],
          );
        });
  }
}
