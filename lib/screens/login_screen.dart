// ignore_for_file: prefer_const_constructors, sort_child_properties_last

import 'package:chat_app/screens/Register_screen.dart';
import 'package:chat_app/screens/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String? email;

  String? password;
  bool isLoading = false;

  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Form(
          key: formKey,
          child: ListView(children: [
            Column(
              children: [
                Image.asset(
                  'images/chat.png',
                  height: 200,
                ),
                // ignore: prefer_const_constructors
                Text(
                  'Chat App',
                  // ignore: prefer_const_constructors
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 100,
                ),

                Container(
                  padding: EdgeInsets.only(left: 20),
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Sign in',
                    // ignore: prefer_const_constructors
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  onChanged: (data) {
                    email = data;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ' Please enter your email';
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter Your Email',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  obscureText: true,
                  onChanged: (data) {
                    password = data;
                  },
                  validator: (value) {
                    if (value!.isEmpty) {
                      return ' Please enter your password';
                    }
                  },
                  autocorrect: true,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Password',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(15),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),

                ElevatedButton(
                  onPressed: () async {
                    if (formKey.currentState!.validate()) {
                      isLoading = true;
                      setState(() {});
                      try {
                        await UserLogin();
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => ChatPage(email!)));
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              backgroundColor: Colors.red,
                              content: Text('This email has not registered ')));
                        } else if (e.code == 'wrong-password') {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.red,
                            content: Text('Wrong password, pleas try again'),
                          ));
                        }
                      } catch (e) {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            backgroundColor: Colors.green,
                            content: Text('There was an error')));
                      }
                      isLoading = false;
                      setState(() {});
                    } else {}
                  },
                  child: Text(
                    'Sign In',
                    style: TextStyle(fontSize: 20),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                          Color.fromARGB(255, 13, 111, 190)),
                      padding: MaterialStateProperty.all(
                        const EdgeInsets.only(
                            left: 150, right: 150, top: 15, bottom: 15),
                      ),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15)),
                              side: BorderSide(color: Colors.black)))),
                ),
                SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account",
                      style: TextStyle(color: Colors.white, fontSize: 15),
                    ),
                    TextButton(
                        onPressed: (() {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => RegisterScreen(),
                              ));
                        }),
                        child: Text('Register Now',
                            style: TextStyle(
                              color: Colors.blue,
                              fontSize: 15,
                            ))),
                  ],
                )
              ],
            ),
          ]),
        ),
      ),
    );
  }

  Future<void> UserLogin() async {
    var auth = FirebaseAuth.instance;
    UserCredential user = await auth.signInWithEmailAndPassword(
        email: email!, password: password!);
  }
}
