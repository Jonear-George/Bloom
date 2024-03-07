import 'package:bloom/detail/roomdetail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class Room extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Room'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('Room').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          final roomDocs = snapshot.data!.docs;

          return ListView(
            children: roomDocs.map((doc) {
              final roomData = doc.data() as Map<String, dynamic>;
              final price = roomData['price'];
              final roomType = roomData['name']; // Extracting name
              final List<String>? imgUrls = roomData['img']?.cast<String>();
              final status = roomData['status']; // Extracting status

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => DetailedRoomPage(
                        roomData: roomData,
                        imgUrls: imgUrls,
                        picUrl: '',
                      ),
                    ),
                  );
                },
                child: Card(
                  margin: EdgeInsets.all(8.0),
                  elevation: 4.0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      if (imgUrls != null && imgUrls.isNotEmpty)
                        Image.network(
                          imgUrls[0], // Display the first image
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      else
                        Container(
                          height: 200,
                          color: Colors.grey, // Placeholder for image
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    '$roomType', // Display name
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 4.0),
                                  Text(
                                    'Price: \$${price.toString()}/Night',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              'Status: $status', // Display status
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}
