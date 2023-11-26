import 'package:flutter/material.dart';
import 'package:zing_chat/screens/login_screen.dart';
import 'registration_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import '../components/rounded_button.dart';
import 'package:zing_chat/constants.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';
  const WelcomeScreen({super.key});

  @override
  WelcomeScreenState createState() => WelcomeScreenState();
}

class WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    // animation = CurvedAnimation(parent: controller, curve: Curves.decelerate);
    animation = ColorTween(begin: Colors.blueGrey, end: Colors.white).animate(controller);

    controller.forward();
    // controller.reverse(from: 1.0);

    // controller.addStatusListener((status) {
    //   if(status == AnimationStatus.completed){
    //     controller.reverse(from: 1.0);
    //   } else if(status == AnimationStatus.dismissed){
    //     controller.forward();
    //   }
    // });

    controller.addListener(() {
      setState(() { });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(right: 40.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Hero(
                    tag: 'logo',
                    child: Container(
                      height: 60.0,
                      child: Image.asset('images/logo.png'),
                    ),
                  ),
                  AnimatedTextKit(
                    animatedTexts: [
                      TypewriterAnimatedText(
                        'Zing Chat',
                        textStyle: const TextStyle(
                          color: Colors.black,
                          fontSize: 45.0,
                          fontWeight: FontWeight.w900,
                        ),
                        speed: const Duration(milliseconds: 200),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              text: 'Log In',
              color: kAppColor,
              onClick: () {
                Navigator.pushNamed(context, LoginScreen.id);
              },
            ),
            RoundedButton(
              text: 'Register',
              color: kAppRegiColor,
              onClick: () {
                Navigator.pushNamed(context, RegistrationScreen.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}
