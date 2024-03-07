// ignore_for_file: unused_import, use_key_in_widget_constructors, prefer_const_constructors

import 'package:bloom/detail/payment.dart';
import 'package:bloom/detail/select.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DetailedRoomPage extends StatelessWidget {
  final Map<String, dynamic> roomData;

  const DetailedRoomPage({required this.roomData, required String picUrl, List<String>? imgUrls});

  @override
  Widget build(BuildContext context) {
    List<String> imgUrls = List<String>.from(roomData['img'] ?? []);

    return Scaffold(
      appBar: AppBar(
        title: Text('Detailed Room'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            CarouselSlider(
              items: imgUrls.map((url) {
                return Image.network(
                  url,
                  fit: BoxFit.cover,
                  height: 500,
                );
              }).toList(),
              options: CarouselOptions(
                height: 500,
                enlargeCenterPage: true,
                enableInfiniteScroll: false,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 16.0),
                  Row(
                    children: [
                      Icon(
                        Icons.hotel,
                        size: 24.0,
                      ),
                      SizedBox(width: 8.0),
                      Text(
                        '${roomData['name'] ?? 'Type not specified'}',
                        style: TextStyle(fontSize: 18.0),
                      ),
                    ],
                  ),
                  SizedBox(height: 16.0),
                  Text(
                    'Price: \$${roomData['price'].toString()}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.0),
                  Text(
                    '${roomData['desc'] ?? 'Description not available'}',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  SizedBox(height: 12.0),
                  Row(
                    children: List.generate(
                      roomData['Adult'] ?? 0,
                      (index) => Icon(Icons.person, size: 30),
                    ),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {
              Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => SelectionWidget(
      roomName: roomData['name'] ?? 'Type not specified',
      roomPrice: roomData['price'].toString(),
      imageUrl: roomData['img'][0] ?? 'https://via.placeholder.com/150',
      adults: roomData['Adult'] ?? 1, // Pass the count of adults from roomData
      children: roomData['children'] ?? 0, // Pass the count of children from roomData
    ),
  ),
);

              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: Text(
                'Booking Now',
                style: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 16.0), // Add additional space at the bottom
          ],
        ),
      ),
    );
  }
}
