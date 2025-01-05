import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/fieldtags.dart';
import 'package:gopetadmin/controller/hooks.dart';
import 'package:gopetadmin/controller/vetgov.dart';
import 'package:gopetadmin/model/vetirinary.dart';
import 'package:gopetadmin/widgets/button.dart';
import 'package:gopetadmin/widgets/formtext.dart';
import 'package:intl/intl.dart';
import 'package:textfield_tags/textfield_tags.dart';

class VetCreds extends StatefulWidget {
  final String documentID;
  final String clinicname;
  final String imageprofile;
  const VetCreds(
      {super.key,
      required this.documentID,
      required this.clinicname,
      required this.imageprofile});

  @override
  State<VetCreds> createState() => _VetCredsState();
}

class _VetCredsState extends State<VetCreds> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController dateEstablished = TextEditingController();
  final TextEditingController operationtime = TextEditingController();
  final TextEditingController description = TextEditingController();
  List<Map<String, String>> clinicSchedule = [];
  late StringTagController stringController;
  late StringTagController specialties;
  late double _distanceSpecialties;
  late double _distanceToField;
  bool isupload = false;
  final VeterinaryModel veterinaryModel = VeterinaryModel();
  List<String> servicetags = [];
  List<String> specialtiesList = [];
  List<Map<String, dynamic>> roomDetails = [];
  List<String> dogTypes = [];

  final List<String> hotelServices = [
    "Grooming",
    "Boarding",
    "Daycare",
    "Bathing",
    "Training",
    "Walking",
    "Feeding",
    "Playtime",
  ];

  final List<String> clinicServices = [
    "Vaccination",
    "Check-up",
    "Surgery",
    "Dental Cleaning",
    "Diagnostics",
    "X-ray",
    "Blood Test",
    "Medication",
  ];

  // Toggle switch state
  bool isHotel = true; // True for Hotel, False for Clinic

  // Selected services
  List<bool> isSelected = [];
  Map<String, List<double>> servicePrices =
      {}; // Stores prices for each service

  // Initialize toggle buttons selection
  void _initializeSelection() {
    isSelected = List.generate(
        isHotel ? hotelServices.length : clinicServices.length, (_) => false);
  }

  // Function to add prices for a service
  void addPrice(String service, double price) {
    setState(() {
      if (!servicePrices.containsKey(service)) {
        servicePrices[service] = [];
      }
      servicePrices[service]!.add(price);
    });
  }

  // Function to save data to Firestore
  Future<void> saveToFirestore() async {
    try {
      final data = {
        'type': isHotel ? 'Hotel' : 'Clinic',
        'dogTypes': isHotel ? dogTypes : [],
        'roomDetails': isHotel ? roomDetails : [],
        'timestamp': Timestamp.now(),
      };

      await FirebaseFirestore.instance
          .collection('pet_services')
          .doc(widget.documentID)
          .set(data, SetOptions(merge: true));

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Data saved successfully!")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error saving data: $e")),
      );
    }
  }

  Future<void> addDogType(String type) async {
    setState(() {
      dogTypes.add(type);
    });
  }

  Future<void> addRoomDetails(String size, int capacity) async {
    setState(() {
      roomDetails.add({'size': size, 'capacity': capacity});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
    _distanceSpecialties = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
    _initializeSelection();
    super.initState();
    stringController = StringTagController();
    specialties = StringTagController();
  }

  @override
  void dispose() {
    super.dispose();
    stringController.dispose();
    dateEstablished.dispose();
    operationtime.dispose();
    specialties.dispose();
  }

  Future<void> handlecredclinic() async {
    setState(() {
      isupload = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        veterinaryModel.clinicname = widget.clinicname;
        veterinaryModel.imageprofile = widget.imageprofile;
        veterinaryModel.operation = clinicSchedule;
        veterinaryModel.services = servicetags;
        veterinaryModel.specialties = specialtiesList;
        veterinaryModel.description = description.text;
        veterinaryModel.dateestablished = dateEstablished.text;
        await saveToFirestore();
        await usercred
            .doc(widget.documentID)
            .collection('vertirenary')
            .doc(widget.documentID)
            .set(veterinaryModel.veterinarymap())
            .then((value) {
          setState(() {
            isupload = false;
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => VetGovController(
                          documentID: widget.documentID,
                          ishome: false,
                        )));
          });
        });
      }
    } catch (error) {
      debugPrint("error - $error");
      setState(() {
        isupload = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentServices = isHotel ? hotelServices : clinicServices;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: Form(
              key: _formkey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "About Your Clinic",
                      style: TextStyle(
                          fontSize: 25,
                          color: Color(0xff78AEA8),
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      height: 5,
                      width: 70,
                      decoration: BoxDecoration(
                          color: const Color(0xff78AEA8),
                          borderRadius: BorderRadius.circular(9)),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Date The Clinic Established"),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      validator: (val) {
                        if (val!.isEmpty) {
                          return "Provide Date The Clinic Established";
                        } else {
                          return null;
                        }
                      },
                      onTap: () {
                        _selectdate();
                      },
                      readOnly: true,
                      controller: dateEstablished,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.next,
                      decoration: const InputDecoration(
                          prefixIcon: Icon(Icons.calendar_month_outlined),
                          hintText: "Clinic Establish (mm-dd-yyyy)",
                          border: OutlineInputBorder()),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    const Text("Clinic Operation Hour (M-T-W-TH-F-S-SU)"),
                    const SizedBox(
                      height: 5,
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff78AEA8),
                              shape: const RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)))),
                          onPressed: _selectDateTime,
                          child: const Text(
                            'Add Clinic Operation Hour',
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          )),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: clinicSchedule.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          title: Text(
                            '${clinicSchedule[index]['day']}: ${clinicSchedule[index]['startTime']} - ${clinicSchedule[index]['endTime']}',
                          ),
                        );
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    const SizedBox(height: 20),
                    if (isHotel)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Dog Types Accepted",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Wrap(
                            spacing: 8.0,
                            children: dogTypes
                                .map((type) => Chip(
                                      label: Text(type),
                                      onDeleted: () {
                                        setState(() {
                                          dogTypes.remove(type);
                                        });
                                      },
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 20),
                          TextField(
                            decoration: const InputDecoration(
                              labelText: "Add Dog Type",
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (value) {
                              if (value.isNotEmpty) addDogType(value);
                            },
                          ),
                          const SizedBox(height: 20),
                          const Text(
                            "Room Details",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 20),
                          ListView.builder(
                            shrinkWrap: true,
                            itemCount: roomDetails.length,
                            itemBuilder: (context, index) {
                              final room = roomDetails[index];
                              return ListTile(
                                title: Text("Room Size: ${room['size']}"),
                                subtitle:
                                    Text("Capacity: ${room['capacity']} dogs"),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete),
                                  onPressed: () {
                                    setState(() {
                                      roomDetails.removeAt(index);
                                    });
                                  },
                                ),
                              );
                            },
                          ),
                          ElevatedButton(
                            onPressed: () async {
                              final sizeController = TextEditingController();
                              final capacityController =
                                  TextEditingController();

                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text("Add Room Details"),
                                    content: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: sizeController,
                                          decoration: const InputDecoration(
                                            labelText: "Room Size",
                                          ),
                                        ),
                                        TextField(
                                          controller: capacityController,
                                          decoration: const InputDecoration(
                                            labelText: "Capacity",
                                          ),
                                          keyboardType: TextInputType.number,
                                        ),
                                      ],
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: const Text("Cancel"),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          final size = sizeController.text;
                                          final capacity = int.tryParse(
                                              capacityController.text);
                                          if (size.isNotEmpty &&
                                              capacity != null) {
                                            addRoomDetails(size, capacity);
                                            Navigator.pop(context);
                                          }
                                        },
                                        child: const Text("Add"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            child: const Text("Add Room"),
                          ),
                        ],
                      ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Clinic"),
                        Switch(
                          value: isHotel,
                          onChanged: (value) {
                            setState(() {
                              isHotel = value;
                              _initializeSelection(); // Reinitialize selection for new services
                            });
                          },
                        ),
                        const Text("Hotel"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text("Add Price Rate"),
                    Wrap(
                      spacing: 8.0, // Horizontal spacing between children
                      runSpacing: 4.0, // Vertical spacing between rows
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.90,
                          child: ToggleButtons(
                            isSelected: isSelected,
                            onPressed: (index) {
                              setState(() {
                                isSelected[index] = !isSelected[index];
                              });
                            },
                            children: currentServices
                                .map((service) => Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0),
                                      child: Text(service),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      itemCount: currentServices.length,
                      itemBuilder: (context, index) {
                        final service = currentServices[index];
                        return isSelected[index]
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "$service Prices:",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  if (servicePrices.containsKey(service))
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: servicePrices[service]!
                                          .map((price) => Text(
                                              "\$${price.toStringAsFixed(2)}"))
                                          .toList(),
                                    ),
                                  TextField(
                                    decoration: InputDecoration(
                                      labelText: "Add Price for $service",
                                    ),
                                    keyboardType: TextInputType.number,
                                    onSubmitted: (value) {
                                      final price = double.tryParse(value);
                                      if (price != null) {
                                        addPrice(service, price);
                                      }
                                    },
                                  ),
                                ],
                              )
                            : SizedBox.shrink();
                      },
                    ),
                    const SizedBox(
                      height: 18,
                    ),
                    Textformtype(
                        fieldname: "Clinic Description",
                        textEditingController: description,
                        uppertitle: "Tell Us About your Clinic",
                        textvalidator: "Provide Short Description"),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Service Offer (tags)"),
                    ClinicFieldTags(
                        stringController: stringController,
                        distanceToField: _distanceToField,
                        hintext: 'Service Offered',
                        servicetags: servicetags),
                    const Text(
                        "E.g: wellness-exams, vaccinations, surgeries, etc."),
                    const SizedBox(
                      height: 19,
                    ),
                    const Text("specialties"),
                    const SizedBox(
                      height: 5,
                    ),
                    ClinicFieldTags(
                        stringController: specialties,
                        distanceToField: _distanceSpecialties,
                        hintext: 'specialties',
                        servicetags: specialtiesList),
                    const Text(
                        "E.g: orthopedic, dermatology, exotic-pets, etc."),
                    const SizedBox(
                      height: 25,
                    ),
                    isupload == false
                        ? GlobalButton(
                            callback: () {
                              handlecredclinic();
                            },
                            title: "Continue")
                        : const Center(
                            child: CircularProgressIndicator(
                              color: Color(0xff78AEA8),
                            ),
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectdate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));

    if (picked != null) {
      setState(() {
        dateEstablished.text =
            dateEstablished.text = DateFormat('MM-dd-yyyy').format(picked);
      });
    }
  }

  Future<void> _selectDateTime() async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      TimeOfDay? pickedStartTime = await showTimePicker(
        // ignore: use_build_context_synchronously
        context: context,
        initialTime: const TimeOfDay(hour: 8, minute: 0), // Default start time
      );

      if (pickedStartTime != null) {
        TimeOfDay? pickedEndTime = await showTimePicker(
          // ignore: use_build_context_synchronously
          context: context,
          initialTime: const TimeOfDay(hour: 17, minute: 0), // Default end time
        );

        if (pickedEndTime != null) {
          setState(() {
            clinicSchedule.add({
              'day': DateFormat('EEEE').format(pickedDate),
              'startTime': pickedStartTime.format(context),
              'endTime': pickedEndTime.format(context),
            });
          });
        }
      }
    }
  }

  Future<void> deleteuser() async {
    try {
      await FirebaseAuth.instance.currentUser!.delete();
      await usercred.doc(widget.documentID).delete();
    } catch (e) {
      debugPrint("error deleting user");
    }
  }
}
