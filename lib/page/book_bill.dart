// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:bloom/detail/bill_detail.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BookingListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      // If the user is not authenticated, return a login screen or handle accordingly
      return Scaffold(
        body: Center(
          child: Text('User not logged in'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking List'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('bookings')
            .where('userId', isEqualTo: currentUser.uid)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text('Something went wrong'),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          final bookings = snapshot.data!.docs;

          if (bookings.isEmpty) {
            return Center(
              child: Text('No bookings available'),
            );
          }

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (BuildContext context, int index) {
              final booking = bookings[index];
              final roomName = booking['roomName'];
              final totalPrice = booking['totalPrice'];
              final checkInDate = booking['checkInDate'];
              final checkOutDate = booking['checkOutDate'];
              final roomAmount = booking['roomAmount'].toString();
              final adults = booking['adults'];
              final children = booking['children'];

              return GestureDetector(
                onTap: () {
                  // Navigate to a detailed view passing the booking data
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BookingDetailsPage(
                        roomName: roomName,
                        totalPrice: totalPrice,
                        checkInDate: checkInDate,
                        checkOutDate: checkOutDate,
                        roomAmount: roomAmount,
                        adults: adults,
                        bookingId: '',
                        name: null,
                        userId: null,
                        username: null,
                        children: children,
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    title: Text(
                      roomName,
                      style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 6.0),
                        Text(
                          'Check-in Date: $checkInDate',
                          style: TextStyle(fontSize: 14.0),
                        ),
                        Text(
                          'Check-out Date: $checkOutDate',
                          style: TextStyle(fontSize: 14.0),
                        ),
                      ],
                    ),
                    trailing: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Total Price:',
                          style: TextStyle(fontSize: 14.0, color: Colors.grey),
                        ),
                        Text(
                          '$totalPrice',
                          style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
