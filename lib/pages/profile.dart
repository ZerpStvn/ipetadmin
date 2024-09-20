import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/misc/theme.dart';
// import 'package:gopetadmin/controller/hooks.dart';
// import 'package:gopetadmin/misc/randomstring.dart';
// import 'package:gopetadmin/misc/theme.dart';
// import 'package:gopetadmin/model/authprovider.dart';
// import 'package:provider/provider.dart';

class VeterinaryProfile extends StatefulWidget {
  const VeterinaryProfile({super.key});

  @override
  State<VeterinaryProfile> createState() => _VeterinaryProfileState();
}

class _VeterinaryProfileState extends State<VeterinaryProfile> {
  final FirebaseAuth userauth = FirebaseAuth.instance;
  final FirebaseFirestore usercred = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        FutureBuilder(
            future: usercred
                .collection('users')
                .doc(userauth.currentUser!.uid)
                .get(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                Map<String, dynamic>? snaphotdata = snapshot.data!.data();
                return Container(
                  height: 230,
                  width: MediaQuery.of(context).size.width,
                  color: maincolor,
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Row(
                      children: [
                        Container(
                          height: 170,
                          width: 170,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: maincolor,
                              image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: NetworkImage(
                                      snaphotdata!['imageprofile']))),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        FutureBuilder(
                            future: usercred
                                .collection('users')
                                .doc(userauth.currentUser!.uid)
                                .collection('vertirenary')
                                .doc(userauth.currentUser!.uid)
                                .get(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Container();
                              } else {
                                Map<String, dynamic>? snaphotdata =
                                    snapshot.data!.data();

                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${snaphotdata!['clinicname']}",
                                      style: const TextStyle(
                                          fontSize: 32, color: Colors.white),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(
                                          Icons.health_and_safety_outlined,
                                          color: Colors.white,
                                        ),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        Text(
                                          "${snaphotdata['description']}",
                                          style: const TextStyle(
                                              fontSize: 23,
                                              color: Colors.white),
                                        ),
                                      ],
                                    )
                                  ],
                                );
                              }
                            })
                      ],
                    ),
                  ),
                );
              }
            }),
        const SizedBox(
          height: 30,
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: FutureBuilder(
              future: usercred
                  .collection('users')
                  .doc(userauth.currentUser!.uid)
                  .collection('vertirenary')
                  .doc(userauth.currentUser!.uid)
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  Map<String, dynamic>? snaphotdata = snapshot.data!.data();

                  return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Taxpayer Identification Number",
                          style: TextStyle(fontSize: 21, color: Colors.black),
                        ),
                        Text(
                          "${snaphotdata!['tin']}",
                          style: TextStyle(fontSize: 28, color: maincolor),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Row(
                          children: [
                            Column(
                              children: [
                                const Text(
                                  "BIR Certificate",
                                  style: TextStyle(
                                      fontSize: 21, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 270,
                                  width: 270,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              snaphotdata['bir']))),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            ),
                            const SizedBox(
                              width: 15,
                            ),
                            Column(
                              children: [
                                const Text(
                                  "DTI Certificate",
                                  style: TextStyle(
                                      fontSize: 21, color: Colors.black),
                                ),
                                const SizedBox(
                                  height: 10,
                                ),
                                Container(
                                  height: 270,
                                  width: 270,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          width: 1, color: Colors.black),
                                      image: DecorationImage(
                                          fit: BoxFit.cover,
                                          image: NetworkImage(
                                              snaphotdata['dti']))),
                                ),
                                const SizedBox(
                                  width: 20,
                                ),
                              ],
                            )
                          ],
                        )
                      ]);
                }
              }),
        )
      ],
    );
  }
}
