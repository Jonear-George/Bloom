// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';

class BookingDetailsPage extends StatelessWidget {
  final String roomName;
  final dynamic totalPrice;
  final String checkInDate;
  final String checkOutDate;
  final String roomAmount;
  final int adults;
  final int children;

  const BookingDetailsPage({
    required this.roomName,
    required this.totalPrice,
    required this.checkInDate,
    required this.checkOutDate,
    required this.roomAmount,
    required this.adults,
    required this.children,
    required String bookingId, required name, required userId, required username,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Details'),
      ),
      body: Padding(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Card(
          elevation: 4.0,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.all(screenWidth * 0.04),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'BLOOM Hotel',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenWidth * 0.02),
                  buildInfoRow('Room Name:', roomName, screenWidth),
                  buildInfoRow('Check-in Date:', checkInDate, screenWidth),
                  buildInfoRow('Check-out Date:', checkOutDate, screenWidth),
                  buildInfoRow('Adults:', '$adults', screenWidth),
                  buildInfoRow('Children:', '$children', screenWidth),
                  buildInfoRow('Room Amount:', roomAmount, screenWidth),
                  const Divider(),
                  buildInfoRow('Total Price:', '$totalPrice', screenWidth),
                  const SizedBox(height: 20), // Adjust spacing as needed
                  Center(
                    child: Text(
                      'Thank you for choosing BLOOM Hotel!',
                      style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: screenWidth * 0.04,
                      ),
                    ),
                  ),
                  SizedBox(
                      height:
                          screenWidth * 0.04), // Extra padding at the bottom
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildInfoRow(String title, String value, double screenWidth) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: screenWidth * 0.02),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: screenWidth * 0.4,
            child: Text(
              title,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(
            width: screenWidth * 0.4,
            child: Text(
              value,
              style: TextStyle(
                fontSize: screenWidth * 0.04,
              ),
              overflow: TextOverflow.ellipsis, // Handles long text
            ),
          ),
        ],
      ),
    );
  }
}
