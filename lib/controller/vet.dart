import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:flutter/services.dart';
import 'package:gopetadmin/controller/hooks.dart';
import 'package:gopetadmin/controller/vetcred.dart';
import 'package:gopetadmin/misc/randomstring.dart';
import 'package:gopetadmin/misc/snackbar.dart';
import 'package:gopetadmin/model/users.dart';
import 'package:gopetadmin/widgets/button.dart';
import 'package:gopetadmin/widgets/formtext.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image/image.dart' as img;

class VetController extends StatefulWidget {
  const VetController({super.key});

  @override
  State<VetController> createState() => _VetControllerState();
}

class _VetControllerState extends State<VetController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController nameofclinic = TextEditingController();
  final TextEditingController ownersfirstname = TextEditingController();
  final TextEditingController ownerslastname = TextEditingController();
  final TextEditingController phonenumber = TextEditingController();
  final TextEditingController emailaddress = TextEditingController();
  final TextEditingController password = TextEditingController();
  final TextEditingController cpassword = TextEditingController();
  final ImagePicker _imagePicker = ImagePicker();
  final UsersModel usersModel = UsersModel();
  Uint8List _pickedFile = Uint8List(8);
  bool isobscure = true;
  bool isconfirm = true;
  bool isuploading = false;
  String? imageprofile;
  final userAuth = FirebaseAuth.instance;

  Future<void> pickimage() async {
    XFile? filepath = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (filepath != null) {
      var selectedFile = await filepath.readAsBytes();
      setState(() {
        _pickedFile = selectedFile;
      });
    } else {
      setState(() {
        _pickedFile.isEmpty;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    generateRandomString();
  }

  @override
  void dispose() {
    super.dispose();
    nameofclinic.dispose();
    ownersfirstname.dispose();
    ownerslastname.dispose();
    phonenumber.dispose();
    emailaddress.dispose();
    password.dispose();
    cpassword.dispose();
  }

  Future<String> uploadImageToFirebase(Uint8List imageBytes) async {
    img.Image image = img.decodeImage(imageBytes)!;
    List<int> jpegBytes = img.encodeJpg(image, quality: 90);
    Uint8List jpegUint8List = Uint8List.fromList(jpegBytes);
    firebase_storage.Reference storageRef = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('userprofile')
        .child('${DateTime.now().millisecondsSinceEpoch}.jpg');
    firebase_storage.SettableMetadata metadata =
        firebase_storage.SettableMetadata(contentType: 'image/jpeg');
    firebase_storage.UploadTask uploadTask =
        storageRef.putData(jpegUint8List, metadata);
    firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;
    String downloadURL = await taskSnapshot.ref.getDownloadURL();
    return downloadURL;
  }

  Future<void> handlecreateuser(String validID) async {
    try {
      String userprofleurl = await uploadImageToFirebase(_pickedFile);
      usersModel.imageprofile = userprofleurl;
      usersModel.nameclinic = nameofclinic.text;
      usersModel.fname = ownersfirstname.text;
      usersModel.lname = ownerslastname.text;
      usersModel.pnum = phonenumber.text;
      usersModel.email = emailaddress.text;
      usersModel.pass = password.text;
      usersModel.role = 1;
      usersModel.vetid = userAuth.currentUser!.uid;

      await usercred
          .doc(validID)
          .set(usersModel.usersModelmap())
          .then((value) => {
                setState(() {
                  isuploading = false;
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => VetCreds(
                                documentID: validID,
                                clinicname: nameofclinic.text,
                                imageprofile: userprofleurl,
                              )));
                })
              });
    } catch (e) {
      debugPrint("$e");
    }
  }

  Future<void> uploadfirstcred() async {
    setState(() {
      isuploading = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        if (_pickedFile.isNotEmpty) {
          await userAuth
              .createUserWithEmailAndPassword(
                  email: emailaddress.text, password: password.text)
              .then((value) => handlecreateuser(value.user!.uid));
        } else {
          setState(() {
            imageprofile = "Add your profile picture";
            isuploading = false;
          });
        }
      } else {
        setState(() {
          isuploading = false;
        });
      }
    } on FirebaseException catch (e) {
      setState(() {
        switch (e.code) {
          case "invalid-email":
            snackbar(context, "Your email address is invalid.");
            break;
          case "wrong-password":
            snackbar(context, "Your password is wrong.");
            break;
          case "user-not-found":
            snackbar(context, "User with this email doesn't exist.");
            break;
          case "user-disabled":
            snackbar(context, "User with this email has been disabled.");
            break;
          case "too-many-requests":
            snackbar(context, "Too many requests");
            break;
          case "operation-not-allowed":
            snackbar(
                context, "Signing in with Email and Password is not enabled.");
            break;
          default:
            snackbar(context, "Check your email, password and try again");
        }
        isuploading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(18.0),
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formkey,
              child: SizedBox(
                width: MediaQuery.of(context).size.width * 0.40,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Register Your Clinic with Us",
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
                    const Text(
                      "Are you a veterinary clinic owner or manager looking to expand your reach and connect with a broader audience of pet owners?",
                      style: TextStyle(
                          fontSize: 15, fontWeight: FontWeight.normal),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    GestureDetector(
                      onTap: () {
                        pickimage();
                      },
                      child: Container(
                        height: 100,
                        width: 100,
                        decoration: _pickedFile.isNotEmpty
                            ? BoxDecoration(
                                color: maincolor,
                                shape: BoxShape.circle,
                                image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(_pickedFile)))
                            : BoxDecoration(
                                color: const Color.fromARGB(68, 158, 158, 158),
                                shape: BoxShape.circle,
                                border:
                                    Border.all(width: 3, color: Colors.green)),
                        child: const Icon(
                          Icons.add_a_photo,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Text(
                      "Please upload your profile",
                      style: TextStyle(
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Textformtype(
                        textEditingController: nameofclinic,
                        uppertitle: "What's The Name of Your Clinic?",
                        textvalidator: "Provide clinic name"),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Textformtype(
                                textEditingController: ownersfirstname,
                                uppertitle: "First Name",
                                textvalidator: "Enter first name")),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Textformtype(
                                textEditingController: ownerslastname,
                                uppertitle: "Last Name",
                                textvalidator: "Enter last name")),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Textformtype(
                        textEditingController: phonenumber,
                        uppertitle: "Phone Number",
                        textvalidator: "Provide phone number"),
                    const SizedBox(
                      height: 15,
                    ),
                    Textformtype(
                        textEditingController: emailaddress,
                        uppertitle: "Email Address",
                        textvalidator: "Provide valid email address"),
                    const SizedBox(
                      height: 15,
                    ),
                    Row(
                      children: [
                        Expanded(
                            child: Textformtype(
                                isbscure: isobscure,
                                icons: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isobscure = !isobscure;
                                    });
                                  },
                                  child: Icon(isobscure
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                                textEditingController: password,
                                uppertitle: "Password",
                                textvalidator: "Password")),
                        const SizedBox(
                          width: 5,
                        ),
                        Expanded(
                            child: Textformtype(
                                isbscure: isconfirm,
                                icons: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      isconfirm = !isconfirm;
                                    });
                                  },
                                  child: Icon(isconfirm
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined),
                                ),
                                textEditingController: cpassword,
                                uppertitle: "Confirm Password",
                                textvalidator: "Confirm password")),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    isuploading == false
                        ? GlobalButton(
                            callback: () {
                              if (_pickedFile.isNotEmpty) {
                                isuploading == false ? uploadfirstcred() : null;
                              } else {
                                setState(() {
                                  imageprofile = "Please upload your profile";
                                  debugPrint(imageprofile);
                                  isuploading = false;
                                });
                              }

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => VetCreds(
                              //               documentID:
                              //                   "43TlT6R73aOBnArrWmN3ubkbu2y2",
                              //               clinicname: "anotehr",
                              //               imageprofile:
                              //                   "https://firebasestorage.googleapis.com/v0/b/ipet-ededd.appspot.com/o/userprofile%2F1717398291658.jpg?alt=media&token=0141ecf7-8f8e-44d4-bf32-0a5ef3bd3d5b",
                              //             )));

                              // Navigator.push(
                              //     context,
                              //     MaterialPageRoute(
                              //         builder: (context) => const VetMapping(
                              //               documentID:
                              //                   '43TlT6R73aOBnArrWmN3ubkbu2y2',
                              //               ishome: false,
                              //               isclient: false,
                              //             )));
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
}
