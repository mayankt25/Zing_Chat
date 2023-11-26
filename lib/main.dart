import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zing_chat/screens/welcome_screen.dart';
import 'package:zing_chat/screens/login_screen.dart';
import 'package:zing_chat/screens/registration_screen.dart';
import 'package:zing_chat/screens/chat_screen.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ZingChat());
}

class ZingChat extends StatelessWidget {
  const ZingChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: const AppBarTheme(
          iconTheme: IconThemeData(
            color: Colors.white,
          ),
        ),
      ),
      initialRoute: WelcomeScreen.id,
      routes: {
        WelcomeScreen.id : (context) => const WelcomeScreen(),
        LoginScreen.id : (context) => const LoginScreen(),
        RegistrationScreen.id : (context) => const RegistrationScreen(),
        ChatScreen.id : (context) => const ChatScreen(),
      },
    );
  }
}
