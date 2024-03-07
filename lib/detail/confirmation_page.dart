// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ConfirmationPage extends StatefulWidget {
  final String roomName;
  final String totalPrice;
  final String roomAmount;
  final int adults;
  final int children;
  final String cardNumber;
  final String expiryDate;
  final String cardHolderName;
  final String cvv;
  final String username;
  final String userId;

  const ConfirmationPage({
    Key? key,
    required this.roomName,
    required this.totalPrice,
    required this.roomAmount,
    required this.adults,
    required this.children,
    required this.cardNumber,
    required this.expiryDate,
    required this.cardHolderName,
    required this.cvv,
    required this.username,
    required this.userId,
  }) : super(key: key);

  @override
  _ConfirmationPageState createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  bool isConfirmed = false;

  Future<void> confirmBooking(BuildContext context) async {
    try {
      final bookingData = {
        'roomName': widget.roomName,
        'totalPrice': widget.totalPrice,
        'roomAmount': widget.roomAmount,
        'checkInDate': DateTime.now().toString(),
        'checkOutDate': DateTime.now().add(const Duration(days: 1)).toString(),
        'cardNumber': widget.cardNumber,
        'expiryDate': widget.expiryDate,
        'cardHolderName': widget.cardHolderName,
        'cvv': widget.cvv,
        'adults': widget.adults,
        'children': widget.children,
        'username': widget.username,
        'userId': widget.userId,
        'confirmed': false,
      };

      final bookingRef = await FirebaseFirestore.instance.collection('bookings').add(bookingData);
      final bookingId = bookingRef.id;

      setState(() {
        isConfirmed = true;
      });
    } catch (error) {
      print('Error confirming booking: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Room Name: ${widget.roomName}'),
            Text('Check-In: ${DateTime.now().toString()}'),
            Text('Check-Out: ${DateTime.now().add(const Duration(days: 1)).toString()}'),
            Text('Adults: ${widget.adults}'),
            Text('Children: ${widget.children}'),
            Text('Room Amount: ${widget.roomAmount}'),
            Text('Total Price: ${widget.totalPrice}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (!isConfirmed) {
                  confirmBooking(context);
                }
              },
              child: Text(isConfirmed ? 'Confirmed' : 'Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
