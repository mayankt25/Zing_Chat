import 'package:flutter/material.dart';
import 'package:zing_chat/constants.dart';
import '../components/rounded_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  static const String id = 'registration_screen';
  const RegistrationScreen({super.key});

  @override
  RegistrationScreenState createState() => RegistrationScreenState();
}

class RegistrationScreenState extends State<RegistrationScreen> {

  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  late String name;
  bool showSpinner = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: Container(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              TextField(
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  name = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your name',
                ),
              ),
              TextField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.emailAddress,
                style: const TextStyle(color: Colors.black),
                onChanged: (value) {
                  email = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your email',
                ),
              ),
              const SizedBox(
                height: 8.0,
              ),
              TextField(
                style: const TextStyle(color: Colors.black),
                textAlign: TextAlign.center,
                obscureText: true,
                onChanged: (value) {
                  password = value;
                },
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter your password',
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              RoundedButton(
                  color: kAppRegiColor,
                  text: 'Register',
                  onClick: () async {
                    setState(() {
                      showSpinner = true;
                    });
                    try{
                      final newUser = await _auth.createUserWithEmailAndPassword(email: email, password: password);
                      await newUser.user!.updateDisplayName(name);
                      Navigator.pushNamed(context, ChatScreen.id);
                      setState(() {
                        showSpinner = false;
                      });
                    } catch(e){
                      print(e);
                    }
                  },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
