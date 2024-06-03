import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/hooks.dart';
import 'package:gopetadmin/controller/uploadimage.dart';
import 'package:gopetadmin/controller/vetmap.dart';
import 'package:gopetadmin/misc/snackbar.dart';
import 'package:gopetadmin/model/vetirinary.dart';
import 'package:gopetadmin/widgets/button.dart';
import 'package:gopetadmin/widgets/formtext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import 'package:image/image.dart' as img;

class VetGovController extends StatefulWidget {
  final String documentID;
  final bool ishome;
  const VetGovController({
    super.key,
    required this.documentID,
    required this.ishome,
  });

  @override
  State<VetGovController> createState() => _VetGovControllerState();
}

class _VetGovControllerState extends State<VetGovController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController tinID = TextEditingController();
  final ImagePicker _imageDTI = ImagePicker();
  final ImagePicker _imageBIR = ImagePicker();
  final VeterinaryModel veterinaryModel = VeterinaryModel();
  Uint8List xfiledti = Uint8List(8);
  Uint8List xfilebir = Uint8List(8);
  bool isobscure = true;
  bool isconfirm = true;
  bool isuploading = false;

  Future<void> pickimageDTI() async {
    XFile? filepath = await _imageDTI.pickImage(source: ImageSource.gallery);

    if (filepath != null) {
      var selectedDti = await filepath.readAsBytes();
      setState(() {
        xfiledti = selectedDti;
      });
    } else {
      xfiledti.isEmpty;
    }
  }

  Future<void> pickimageBIR() async {
    XFile? filepath = await _imageBIR.pickImage(source: ImageSource.gallery);

    if (filepath != null) {
      var selectedbir = await filepath.readAsBytes();
      setState(() {
        xfilebir = selectedbir;
      });
    } else {
      xfilebir.isEmpty;
    }
  }

  @override
  void dispose() {
    super.dispose();
    tinID.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  Future<String> uploadImageToFirebaseBIR(Uint8List imageBytes) async {
    img.Image image = img.decodeImage(imageBytes)!;
    List<int> jpegBytes = img.encodeJpg(image, quality: 90);
    Uint8List jpegUint8List = Uint8List.fromList(jpegBytes);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('govid')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(contentType: 'image/jpeg');
    firebase_storage.UploadTask uploadTask =
        storageRef.putData(jpegUint8List, metadata);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<String> uploadImageToFirebaseDTI(Uint8List imageBytes) async {
    img.Image image = img.decodeImage(imageBytes)!;
    List<int> jpegBytes = img.encodeJpg(image, quality: 90);
    Uint8List jpegUint8List = Uint8List.fromList(jpegBytes);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('govid')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(contentType: 'image/jpeg');
    firebase_storage.UploadTask uploadTask =
        storageRef.putData(jpegUint8List, metadata);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> handlegovid() async {
    setState(() {
      isuploading = true;
    });
    try {
      if (xfiledti.isEmpty) {
        snackbar(context, "Please upload DTI permit");
        setState(() {
          isuploading = false;
        });
      } else if (xfilebir.isEmpty) {
        snackbar(context, "Please upload BIR permit");
        setState(() {
          isuploading = false;
        });
      } else {
        if (_formkey.currentState!.validate()) {
          String birfile = await uploadImageToFirebaseBIR(xfilebir);
          String dtifile = await uploadImageToFirebaseDTI(xfiledti);
          String tinid = tinID.text;
          await usercred
              .doc(widget.documentID)
              .collection('vertirenary')
              .doc(widget.documentID)
              .update({
            "tin": tinid,
            "dti": dtifile,
            "bir": birfile,
          }).then((value) {
            ishome();
            setState(() {
              isuploading = false;
            });
            debugPrint(widget.documentID);
          });
        }
      }
    } catch (error) {
      if (mounted) {
        snackbar(context, "$error");
      }
      setState(() {
        isuploading = false;
      });
    }
  }

  void ishome() {
    if (widget.ishome) {
      Navigator.pushNamedAndRemoveUntil(context, '/vetuser', (route) => false);
    } else {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => VetMapping(
                    documentID: widget.documentID,
                    ishome: false,
                    isclient: false,
                  )));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(18.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width * 0.40,
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Goverment ID",
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
                    const SizedBox(
                      height: 15,
                    ),
                    Textformtype(
                        textEditingController: tinID,
                        uppertitle: "Provide TIN Number",
                        fieldname: "000-000-000-00000",
                        textvalidator: "TIN 000-000-000-00000"),
                    const SizedBox(
                      height: 15,
                    ),
                    UploadImageField(
                      title: "Upload DTI Permit",
                      xfiledti: xfiledti,
                      pickimage: () {
                        pickimageDTI();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    UploadImageField(
                      title: "Upload BIR Permit",
                      xfiledti: xfilebir,
                      pickimage: () {
                        pickimageBIR();
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isuploading == false
                        ? GlobalButton(
                            callback: () {
                              handlegovid();
                              debugPrint("${widget.ishome}");
                            },
                            title: "Proceed")
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

  // Future<void> deleteuser() async {
  //   try {
  //     await usercred.doc(widget.documentID).delete();
  //   } catch (e) {
  //     debugPrint("error deleting user");
  //   }
  // }
}
