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
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _distanceToField = MediaQuery.of(context).size.width;
    _distanceSpecialties = MediaQuery.of(context).size.width;
  }

  @override
  void initState() {
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
                    const SizedBox(
                      height: 5,
                    ),
                    Textformtype(
                        fieldname: "Clinic Description",
                        textEditingController: description,
                        uppertitle: "Tell Us About your Clinic",
                        textvalidator: "Provide Short Description"),
                    const SizedBox(
                      height: 25,
                    ),
                    const Text("Service Offer"),
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
