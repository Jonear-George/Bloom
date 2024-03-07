// ignore_for_file: use_super_parameters, library_private_types_in_public_api, use_build_context_synchronously, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:bloom/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'forget_password.dart';
import 'signup_screen.dart';


class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
   final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String email = '';
  String password = '';
  String error = '';
  bool showImage = true;
  bool isLoading = false;

  Future<void> _signInWithEmailAndPassword(
    String email,
    String password,
  ) async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      if (email.isEmpty || !email.contains('@')) {
        throw 'Please enter a valid email address';
      }

      if (password.length < 6) {
        throw 'Password must be at least 6 characters';
      }

      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (userCredential.user != null) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('userEmail', email);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => SplashScreen()),
        );
      }
    } on FirebaseAuthException catch (e) {
      setState(() {
        error = e.message ?? 'An error occurred';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    setState(() {
      isLoading = true;
      error = '';
    });

    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential = await _auth.signInWithCredential(credential);

        if (userCredential.user != null) {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('userEmail', userCredential.user!.email!);
          await prefs.setString('userId', userCredential.user!.uid); // Save user ID to SharedPreferences

          // Save user's information to Firestore 'Users' collection
          final userRef = _firestore.collection('Users').doc(userCredential.user!.uid);
          await userRef.set({
            'email': userCredential.user!.email!,
            'name': userCredential.user!.displayName ?? 'No name', // Save the user's name, if available
            // Add other fields you want to save to the 'Users' collection here
          });

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => SplashScreen()),
          );
        }
      }
    } catch (e) {
      setState(() {
        error = 'Error signing in with Google: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  void _navigateToResetPassword() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ResetPasswordScreen()),
    );
  }

  void _navigateToSignUp() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => SignUp()),
    );
  }

  Widget _buildLoadingBox() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.5),
        child: Center(
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(), // Replace with your app bar
      body: Stack(
        fit: StackFit.expand,
        children: [
          Visibility(
            visible: showImage,
            child: Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Container(
                width: 190,
                height: 190,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  image: DecorationImage(
                    image: AssetImage('assets/images/logo.png'),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextFormField(
                  onTap: () {
                    setState(() {
                      showImage = false;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      showImage = true;
                    });
                  },
                  onChanged: (value) => email = value.trim(),
                  decoration: InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 20.0),
                TextFormField(
                  onTap: () {
                    setState(() {
                      showImage = false;
                    });
                  },
                  onEditingComplete: () {
                    setState(() {
                      showImage = true;
                    });
                  },
                  onChanged: (value) => password = value.trim(),
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50.0),
                    ),
                  ),
                ),
                SizedBox(height: 5.0),
                if (error.isNotEmpty)
                  Text(
                    error,
                    style: TextStyle(color: Colors.red),
                  ),
                SizedBox(height: 5.0),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading
                        ? null
                        : () {
                            _signInWithEmailAndPassword(email, password);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.amber,
                    ),
                    child: Text(
                      'SignIn',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: isLoading ? null : _navigateToResetPassword,
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: Colors.black), // Change text color
                      ),
                    ),
                    TextButton(
                      onPressed: isLoading ? null : _navigateToSignUp,
                      child: Text("Don't have an account?"),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'OR',
                        style: TextStyle(
                          color: Colors.grey,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Divider(
                        color: Colors.black,
                        height: 1,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10.0),
                OutlinedButton(
                  onPressed: isLoading ? null : _signInWithGoogle,
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: Colors.black),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google.png',
                        height: 20,
                        width: 20,
                      ),
                      SizedBox(width: 10),
                      Text(
                        'Sign in with Google',
                        style: TextStyle(color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (isLoading) _buildLoadingBox(),
        ],
      ),
    );
  }
}
