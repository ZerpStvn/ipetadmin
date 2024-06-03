import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/alert.dart';
import 'package:gopetadmin/controller/hooks.dart';
import 'package:gopetadmin/controller/mapcon.dart';
import 'package:gopetadmin/pages/login.dart';

class VetMapping extends StatelessWidget {
  final String documentID;
  final bool ishome;
  final bool isclient;
  const VetMapping(
      {super.key,
      required this.documentID,
      required this.ishome,
      required this.isclient});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didpop) async {
        if (didpop) return;
        handlenotcontinue(context, () {
          deleteusermap(context);
        });
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            "Mark your Location",
          ),
        ),
        body: MappController(
          isclient: isclient,
          documentID: documentID,
          ishome: ishome,
        ),
      ),
    );
  }

  Future<void> deleteusermap(BuildContext context) async {
    try {
      await userAuth.currentUser!.delete();
      await usercred.doc(documentID).delete().then((value) {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
                builder: (context) => const GloballoginController()),
            (route) => false);
      });
    } catch (e) {
      debugPrint("error deleting user");
    }
  }
}
