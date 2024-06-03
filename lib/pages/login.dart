import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/snackbar.dart';
import 'package:gopetadmin/model/authprovider.dart';
import 'package:gopetadmin/model/vetirinary.dart';
import 'package:provider/provider.dart';

import '../widgets/button.dart';

class GloballoginController extends StatefulWidget {
  const GloballoginController({super.key});

  @override
  State<GloballoginController> createState() => _GloballoginControllerState();
}

class _GloballoginControllerState extends State<GloballoginController> {
  final _formkey = GlobalKey<FormState>();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  final VeterinaryModel veterinaryModel = VeterinaryModel();
  bool isobscure = true;
  String error = "";
  Color maincolor = const Color(0xff78AEA8);
  bool isloggingin = false;
  bool isautlogin = false;
  final usercred = FirebaseFirestore.instance.collection('users');
  @override
  void dispose() {
    super.dispose();
    email.dispose();
    password.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  void getuserdata(role) {
    if (role == 1) {
      Navigator.pushNamedAndRemoveUntil(context, '/vetuser', (route) => false);
    }
  }

  Future<void> getveterinary(uid) async {
    DocumentSnapshot datafetch =
        await usercred.doc(uid).collection('collectionPath').doc(uid).get();

    if (datafetch.exists) {}
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: isautlogin == false
            ? Center(
                child: Padding(
                  padding: const EdgeInsets.all(18.0),
                  child: SingleChildScrollView(
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width * 0.40,
                      child: Form(
                        key: _formkey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(
                              height: 95,
                            ),
                            Text(
                              "Let's Sign you in.",
                              style: TextStyle(
                                  fontSize: 25,
                                  color: maincolor,
                                  fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            Container(
                              height: 5,
                              width: 70,
                              decoration: BoxDecoration(
                                  color: maincolor,
                                  borderRadius: BorderRadius.circular(9)),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text(
                              "Welcome to our platform! We're thrilled to have you here. To unlock all the features and resources available, please log in to your account.",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                            const SizedBox(
                              height: 75,
                            ),
                            const Text("Email address"),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 65,
                              child: TextFormField(
                                controller: email,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter valid email";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                decoration: InputDecoration(
                                    hintText: "Enter Email Address",
                                    suffix: const Icon(Icons.email_outlined),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            const SizedBox(
                              height: 15,
                            ),
                            const Text("Passowd"),
                            const SizedBox(
                              height: 5,
                            ),
                            SizedBox(
                              height: 65,
                              child: TextFormField(
                                obscureText: isobscure,
                                controller: password,
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Enter your password";
                                  } else {
                                    return null;
                                  }
                                },
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                decoration: InputDecoration(
                                    hintText: "Enter your password",
                                    suffixIcon: GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          isobscure = !isobscure;
                                        });
                                      },
                                      child: Icon(isobscure
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                    ),
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    child: const Text("Forgot password?")),
                                const SizedBox(
                                  height: 5,
                                ),
                                isloggingin == false
                                    ? GlobalButton(
                                        callback: () {
                                          loginuser(context, email.text,
                                              password.text);
                                        },
                                        title: "Login")
                                    : Center(
                                        child: CircularProgressIndicator(
                                          color: maincolor,
                                        ),
                                      ),
                                Center(
                                  child: TextButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, "/pet");
                                      },
                                      child: const Text(
                                          "Don't have an account ? Sign up")),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Center(
                    child: CircularProgressIndicator(
                      color: maincolor,
                    ),
                  )
                ],
              ));
  }

  Future<void> loginuser(BuildContext context, String email, password) async {
    final authProvider = Provider.of<AuthProviderClass>(context, listen: false);
    setState(() {
      isloggingin = true;
    });
    try {
      if (_formkey.currentState!.validate()) {
        await authProvider
            .loginWithEmailAndPassword(email, password)
            .then((value) {
          getuserdata(authProvider.userModel!.role);
          setState(() {
            isloggingin = false;
            debugPrint("${authProvider.userModel!.vetid}");
          });
        });
      } else {
        setState(() {
          isloggingin = false;
        });
      }
    } on FirebaseException catch (error) {
      setState(() {
        switch (error.code) {
          case "invalid-email":
            debugPrint("Your email address is invalid.");
            break;
          case "wrong-password":
            debugPrint("Your password is wrong.");
            break;
          case "user-not-found":
            debugPrint("User with this email doesn't exist.");
            break;
          case "user-disabled":
            debugPrint("User with this email has been disabled.");
            break;
          case "too-many-requests":
            debugPrint("Too many requests");
            break;
          case "operation-not-allowed":
            debugPrint("Signing in with Email and Password is not enabled.");
            break;
          default:
            snackbar(context, "Check your email, password and try again");
        }

        isloggingin = false;
      });
    }
  }
}
