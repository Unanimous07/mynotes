import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
   
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

@override
  void dispose() {
    _email.dispose();
    _password.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('LogIn'),
        ),
        body: FutureBuilder(
          future:  Firebase.initializeApp(
                    options: DefaultFirebaseOptions.currentPlatform,
                  )
                  ,
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(child: CircularProgressIndicator());
              case ConnectionState.done:
                if (snapshot.hasError) {
                  return const Center(child: Text('Error'));
                }
              return Column(
              children: [
                TextField(
                  controller: _email,
                  enableSuggestions: false,
                  autocorrect: false,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    hintText: 'Enter your email'),
                ),
                TextField(
                  controller: _password,
                    obscureText: true,
                    enableSuggestions: false,
                    autocorrect: false,
                    decoration: const InputDecoration(
                    hintText: 'Enter your password'),
                    ),
            
                TextButton(
                  onPressed: () async {
            
                    
                    final email = _email.text;
                    final password = _password.text;
                    try {
                      final userCredential =  await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: email, password: password);
                      print(userCredential);

                    }
                    on FirebaseAuthException catch (e) {
                      if (e.code == 'user-not-found') {
                        print('No user found for that email.');
                      } else if (e.code == 'wrong-password') {
                        print('Wrong password provided for that user.');
                      }
                    } 
                    
                    
                  },
                  child: const Text('LogIn'),
                ),

                TextButton(
                  onPressed: (){
                      Navigator.of(context).pushNamedAndRemoveUntil('/register/', (route) => false);
                  }, 
                  child: const Text('Not Registered yet? Register here!'))
              ],
            );

               
              default:
                return const Center(child: CircularProgressIndicator());
              
            }
                
            
          },
          
        ),
    );
  }
}