import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import '../firebase_options.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
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
          title: const Text('Register'),
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
                      final userCredential =  await FirebaseAuth.instance.createUserWithEmailAndPassword(
                      email: email, password: password);
                      print(userCredential);
                    } on FirebaseAuthException catch (e) {
                      if(e.code == 'weak-password'){
                        print("U h'v used a weak password");
                      } else if (e.code == 'email-already-in-use'){
                        print("The account already exists for that email");
                      } else if (e.code == 'invalid-email') {
                        print('Thats not a valid email');
                      }
                      
                    }
                    
                  },
                  child: const Text('Resgister'),
                ),

                TextButton(
                  onPressed: () {

                      Navigator.of(context).pushNamedAndRemoveUntil('/Login/', (route) => false);
                  }, 
                  child: const Text('Already Registered? Login here!'))
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