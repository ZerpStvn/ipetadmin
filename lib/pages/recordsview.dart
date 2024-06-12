import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/model/authprovider.dart';
import 'package:provider/provider.dart';

class RecordsView extends StatefulWidget {
  final String? recordID;
  final String? userID;
  final bool isview;
  const RecordsView(
      {super.key, this.recordID, this.userID, required this.isview});

  @override
  State<RecordsView> createState() => _RecordsViewState();
}

class _RecordsViewState extends State<RecordsView> {
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
  List<dynamic> records = [];

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

  String? docid;

  Future<void> handleGetUserDataRecord() async {
    try {
      final DocumentSnapshot record = await FirebaseFirestore.instance
          .collection('medicalrecord')
          .doc(widget.userID)
          .collection('records')
          .doc(widget.recordID)
          .get();

      if (record.exists) {
        final itemData = record.data() as Map<String, dynamic>;
        if (itemData.isNotEmpty) {
          setState(() {
            ownerNameController.text = itemData['owner_name']! ?? '';
            ownerAddressController.text = itemData['owner_address'] ?? '';
            ownerPhoneController.text = itemData['owner_phone'] ?? '';
            ownerEmailController.text = itemData['owner_email'] ?? '';
            petNameController.text = itemData['pet_name'] ?? '';
            petSpeciesController.text = itemData['pet_species'] ?? '';
            petBreedController.text = itemData['pet_breed'] ?? '';
            petGenderController.text = itemData['pet_gender'] ?? '';
            petDobController.text = itemData['pet_dob'] ?? '';
            petColorController.text = itemData['pet_color'] ?? '';
            microchipNumberController.text = itemData['microchip_number'] ?? '';
            spayedNeuteredController.text = itemData['spayed_neutered'] ?? '';
            previousClinicsController.text = itemData['previous_clinics'] ?? '';
            previousConditionsController.text =
                itemData['previous_conditions'] ?? '';
            currentConditionsController.text =
                itemData['current_conditions'] ?? '';
            allergiesController.text = itemData['allergies'] ?? '';
            currentMedicationsController.text =
                itemData['current_medications'] ?? '';
            vaccinationHistoryController.text =
                itemData['vaccination_history'] ?? '';
            surgicalHistoryController.text = itemData['surgical_history'] ?? '';
            chronicDiseasesController.text = itemData['chronic_diseases'] ?? '';
            visitDateController.text = itemData['visit_date'] ?? '';
            reasonForVisitController.text = itemData['reason_for_visit'] ?? '';
            symptomsController.text = itemData['symptoms'] ?? '';
            durationOfSymptomsController.text =
                itemData['duration_of_symptoms'] ?? '';
            behaviorChangesController.text = itemData['behavior_changes'] ?? '';
            dietNutritionController.text = itemData['diet_nutrition'] ?? '';
            exerciseRoutineController.text = itemData['exercise_routine'] ?? '';
            livingEnvironmentController.text =
                itemData['living_environment'] ?? '';
            contactWithOtherAnimalsController.text =
                itemData['contact_with_other_animals'] ?? '';
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching record: $e");
    }
  }

  @override
  void initState() {
    handleGetUserDataRecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AuthProviderClass>(context);
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Center(
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.60,
            child: Form(
              key: _formKey,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 11, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Owner Information
                    const Text('Owner Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: ownerNameController,
                      decoration: const InputDecoration(
                          labelText: 'Owner\'s Full Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the owner\'s full name';
                        }
                        return null;
                      },
                    ),

                    TextFormField(
                      readOnly: widget.isview,
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
                      readOnly: widget.isview,
                      controller: ownerPhoneController,
                      decoration:
                          const InputDecoration(labelText: 'Phone Number'),
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
                      readOnly: widget.isview,
                      controller: ownerEmailController,
                      decoration:
                          const InputDecoration(labelText: 'Email Address'),
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
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: petNameController,
                      decoration:
                          const InputDecoration(labelText: 'Pet\'s Name'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the pet\'s name';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: widget.isview,
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
                      readOnly: widget.isview,
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
                      readOnly: widget.isview,
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
                      readOnly: widget.isview,
                      controller: petDobController,
                      decoration:
                          const InputDecoration(labelText: 'Date of Birth'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the date of birth';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: petColorController,
                      decoration:
                          const InputDecoration(labelText: 'Color/Markings'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the color/markings';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: microchipNumberController,
                      decoration:
                          const InputDecoration(labelText: 'Microchip Number'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: spayedNeuteredController,
                      decoration: const InputDecoration(
                          labelText: 'Spayed/Neutered Status'),
                    ),

                    const SizedBox(height: 20),

                    // Medical History
                    const Text('Medical History',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: previousClinicsController,
                      decoration: const InputDecoration(
                          labelText: 'Previous Veterinary Clinics'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: previousConditionsController,
                      decoration: const InputDecoration(
                          labelText: 'Previous Medical Conditions'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
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
                      readOnly: widget.isview,
                      controller: allergiesController,
                      decoration: const InputDecoration(labelText: 'Allergies'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: currentMedicationsController,
                      decoration: const InputDecoration(
                          labelText: 'Current Medications'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: vaccinationHistoryController,
                      decoration: const InputDecoration(
                          labelText: 'Vaccination History'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: surgicalHistoryController,
                      decoration:
                          const InputDecoration(labelText: 'Surgical History'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: chronicDiseasesController,
                      decoration:
                          const InputDecoration(labelText: 'Chronic Diseases'),
                    ),

                    const SizedBox(height: 20),

                    // Current Visit Information
                    const Text('Current Visit Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: visitDateController,
                      decoration:
                          const InputDecoration(labelText: 'Date of Visit'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the date of visit';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: reasonForVisitController,
                      decoration:
                          const InputDecoration(labelText: 'Reason for Visit'),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter the reason for visit';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: symptomsController,
                      decoration:
                          const InputDecoration(labelText: 'Symptoms Observed'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: durationOfSymptomsController,
                      decoration: const InputDecoration(
                          labelText: 'Duration of Symptoms'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: behaviorChangesController,
                      decoration:
                          const InputDecoration(labelText: 'Behavior Changes'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: dietNutritionController,
                      decoration: const InputDecoration(
                          labelText: 'Diet and Nutrition'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: exerciseRoutineController,
                      decoration:
                          const InputDecoration(labelText: 'Exercise Routine'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: livingEnvironmentController,
                      decoration: const InputDecoration(
                          labelText: 'Living Environment'),
                    ),
                    TextFormField(
                      readOnly: widget.isview,
                      controller: contactWithOtherAnimalsController,
                      decoration: const InputDecoration(
                          labelText: 'Contact with Other Animals'),
                    ),

                    const SizedBox(height: 20),
                    //Text("${provider.userModel!.vetid}"),
                    // Submit Button
                    widget.isview == false
                        ? SizedBox(
                            width: 230,
                            height: 50,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: maincolor,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8))),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _updateRecordToFirestore();
                                }
                              },
                              child: const Text(
                                'Submit',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _updateRecordToFirestore() async {
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
          .doc(widget.userID)
          .collection('records')
          .doc(widget.recordID)
          .update(formValues)
          .then((value) {
        showAlertinfo("Record Updated");
      });
    } catch (e) {
      showAlertinfo(
          "There was a problem updating the data!\nPlease Try again later");
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
