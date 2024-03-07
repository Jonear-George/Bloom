// ignore_for_file: prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _emailController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isResettingPassword = false;
  String _resetMessage = '';

  Future<void> _resetPassword(String email) async {
    setState(() {
      _isResettingPassword = true;
      _resetMessage = ''; // Clear any previous reset message
    });

    try {
      await _auth.sendPasswordResetEmail(email: email);
      setState(() {
        _resetMessage =
            'Password reset link sent to $email. Check your email inbox.';
      });
    } catch (e) {
      setState(() {
        _resetMessage = 'Failed to send reset link: ${e.toString()}';
      });
    } finally {
      setState(() {
        _isResettingPassword = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reset Password'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _isResettingPassword
                  ? null
                  : () {
                      final email = _emailController.text.trim();
                      if (email.isNotEmpty) {
                        _resetPassword(email);
                      } else {
                        setState(() {
                          _resetMessage = 'Please enter an email';
                        });
                      }
                    },
              child: Text('Reset Password'),
            ),
            SizedBox(height: 20.0),
            if (_resetMessage.isNotEmpty)
              Text(
                _resetMessage,
                style: TextStyle(
                  color: _resetMessage.contains('sent') ? Colors.green : Colors.red,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
