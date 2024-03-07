import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_credit_card/flutter_credit_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'confirmation_page.dart';

class PaymentPage extends StatefulWidget {
  final String roomName;
  final String roomPrice;
  final String roomAmount;
  final String totalPrice;
  final int adults;
  final int children;

  const PaymentPage({
    Key? key,
    required this.roomName,
    required this.roomPrice,
    required this.roomAmount,
    required this.totalPrice,
    required this.adults,
    required this.children, required String total, required String username,
  }) : super(key: key);

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController cardNumberController = TextEditingController();
  TextEditingController expiryDateController = TextEditingController();
  TextEditingController cardHolderNameController = TextEditingController();
  TextEditingController cvvCodeController = TextEditingController();

  late User? _user; // Firebase User object
  late String username = ''; // Variable to store username

  @override
  void initState() {
    super.initState();
    _getUser();
  }

  final _googleSignIn = GoogleSignIn(); // Google Sign-In instance

  void _getUser() {
    _user = FirebaseAuth.instance.currentUser;
    if (_user != null) {
      getUserCreditCardDetails(); // Retrieve credit card details if the user is authenticated
      if (_user!.providerData.first.providerId == 'google.com') {
        _getGoogleSignInName();
      }
    }
  }

  Future<void> _getGoogleSignInName() async {
    try {
      GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser != null) {
        setState(() {
          username = googleUser.displayName ?? '';
        });
      }
    } catch (error) {
      print('Error retrieving Google Sign-In user name: $error');
    }
  }

  Future<void> getUserCreditCardDetails() async {
    try {
      DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('Users').doc(_user!.uid).get();

      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      cardNumberController.text = userData['cardNumber'] ?? '';
      expiryDateController.text = userData['expiryDate'] ?? '';
      cardHolderNameController.text = userData['cardHolderName'] ?? '';
      cvvCodeController.text = userData['cvv'] ?? '';

      username = userData['name'] ?? '';
    } catch (error) {
      print('Error retrieving user credit card details: $error');
    }
  }

  Future<void> navigateToConfirmation(BuildContext context) async {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ConfirmationPage(
          roomName: widget.roomName,
          totalPrice: widget.totalPrice,
          roomAmount: widget.roomAmount,
          adults: widget.adults,
          children: widget.children,
          cardNumber: cardNumberController.text,
          expiryDate: expiryDateController.text,
          cardHolderName: cardHolderNameController.text,
          cvv: cvvCodeController.text,
          username: username,
          userId: _user!.uid,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CreditCardWidget(
              cardNumber: cardNumberController.text,
              expiryDate: expiryDateController.text,
              cardHolderName: cardHolderNameController.text,
              cvvCode: cvvCodeController.text,
              showBackView: false,
              obscureCardNumber: true,
              obscureCardCvv: true,
              onCreditCardWidgetChange: (CreditCardBrand) {},
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TextFormField(
                    controller: cardNumberController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Card Number',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.credit_card),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the card number';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: expiryDateController,
                    keyboardType: TextInputType.datetime,
                    decoration: InputDecoration(
                      labelText: 'Expiry Date',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.calendar_today),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the expiry date';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cvvCodeController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'CVV',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.lock),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the CVV';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: cardHolderNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      labelText: 'Cardholder Name',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      prefixIcon: const Icon(Icons.person),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter the cardholder name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        navigateToConfirmation(context);
                      }
                    },
                    child: const Text('Make Payment'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
