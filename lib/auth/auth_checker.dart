// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:bloom/splashscreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bloom/page/bottom_bar.dart';
import 'package:bloom/main.dart';
// Import your home screen or any other screen here


class CheckAuth extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Show the loading splash screen
          return SplashScreen();
        } else if (snapshot.hasData && snapshot.data != null) {
          User? user = snapshot.data;

          // Assuming Firestore collection 'users' contains user-specific data
          CollectionReference users = FirebaseFirestore.instance.collection('users');

          return FutureBuilder<DocumentSnapshot>(
            future: users.doc(user!.uid).get(),
            builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.hasError) {
                return Text('Error occurred: ${snapshot.error}');
              }

              if (snapshot.connectionState == ConnectionState.waiting) {
                return SplashScreen(); // Show the loading splash screen
              }

              if (snapshot.hasData && snapshot.data != null) {
                // Access the user's specific data from Firestore

                // You can use userData to access specific fields like name, email, etc.
                // For example: String userName = userData['name'];

                // Check if the signed-in user is using Google authentication
                bool isGoogleSignIn = user.providerData.any((userInfo) => userInfo.providerId == 'google.com');

                if (isGoogleSignIn) {
                  // If signed in with Google, navigate to bottom bar
                  return bottombar();
                } else {
                  // If signed in with Email, navigate to bottom bar
                  return bottombar();
                }
              }

              return Text('No user data found');
            },
          );
        } else {
          // If no user is signed in, navigate to Home
          return Home();
        }
      },
    );
  }
}
