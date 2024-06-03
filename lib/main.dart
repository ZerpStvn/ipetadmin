import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gopetadmin/controller/vet.dart';
import 'package:gopetadmin/firebase_options.dart';
import 'package:gopetadmin/misc/theme.dart';
import 'package:gopetadmin/model/authprovider.dart';
import 'package:gopetadmin/pages/home.dart';
import 'package:gopetadmin/pages/login.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthProviderClass>(
            create: (context) => AuthProviderClass())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pet Go',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: maincolor),
          useMaterial3: true,
        ),
        routes: {
          '/vetuser': (context) => const HomeScreenVeterinary(),
          '/pet': (context) => const VetController(),
        },
        initialRoute: '/',
        home: const GloballoginController(),
      ),
    );
  }
}
