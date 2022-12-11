import 'package:flutter/material.dart';
import 'package:swapn/screens/landing_screen.dart';
import './create_account.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  @override
  Widget build(BuildContext context) {
    
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;


    return Scaffold(
        body: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.only(top:80),
            width: 200,
            height: 200,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.black,
              // borderRadius: BorderRadius.all(Radius.circular(50)),
              image: DecorationImage(
                image: AssetImage(
                  'assets/images/beyolix-app.png',
                ),
              ),
            ),

            // child: Image.asset(
            //   'assets/images/beyolix-app.png',
            //   fit: BoxFit.cover,
            // ),
          ),
          Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.all(10),
            child: const Text(
              'Let\'s get started',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Please enter email';
                }
                return null;
              }),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            child: TextFormField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(5),
                  ),
                ),
              ),
              validator: ((value) {
                if (value!.isEmpty) {
                  return 'Please enter password';
                }
                return null;
              }),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(10),
            height: 40,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () async {
                 if (emailController.text.isEmpty ||
                        passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email and password'),
                        ),
                      );
                    } else if (emailController.text == null ||
                        passwordController.text == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter your email and password'),
                        ),
                      );
                    } else if (emailController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                        try {
                          UserCredential userCredential = await auth.signInWithEmailAndPassword(
                              email: emailController.text, 
                              password: passwordController.text
                          );
                          user = userCredential.user;

                          // if (user != null) {
                          //   Navigator.of(context)
                          //       .pushReplacementNamed(LandingScreen.routeName);
                          // }
                        } on FirebaseException catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(e.message!),
                            ),
                          );
                        }
                    }
              },
              child: const Text(
                'Login',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
          Container(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(CreateAccount.routeName);
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ))
        ],
      ),
    ));
  }
}
