import 'package:flutter/material.dart';
import 'package:bloom/detail/payment.dart';

class SelectionWidget extends StatefulWidget {
  final String roomName;
  final String roomPrice;
  final String imageUrl;

  SelectionWidget({
    required this.roomName,
    required this.roomPrice,
    required this.imageUrl,
    required adults,
    required children,
  });

  @override
  _SelectionWidgetState createState() => _SelectionWidgetState();
}

class _SelectionWidgetState extends State<SelectionWidget> {
  late DateTime _checkInDate;
  late DateTime _checkOutDate;
  int _adults = 1;
  int _children = 0;
  int _roomAmount = 1;
  final int maxGuests = 4;

  late int roomPrice;
  late int totalPrice;

  @override
  void initState() {
    super.initState();
    _checkInDate = DateTime.now();
    _checkOutDate = DateTime.now().add(Duration(days: 1));

    roomPrice = int.parse(widget.roomPrice.replaceAll('\$', ''));
    totalPrice = roomPrice;
  }

  Future<void> _selectDate(BuildContext context, bool isCheckIn) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isCheckIn ? _checkInDate : _checkOutDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null &&
        picked != (isCheckIn ? _checkInDate : _checkOutDate)) {
      setState(() {
        if (isCheckIn) {
          _checkInDate = picked;
        } else {
          _checkOutDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('Select'),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(screenWidth * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: screenHeight * 0.25,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                image: DecorationImage(
                  image: NetworkImage(widget.imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.roomName,
                      style: TextStyle(
                        fontSize: 24.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Text(
                      'Price: \$${widget.roomPrice}',
                      style: TextStyle(
                        fontSize: 18.0,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Dates:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => _selectDate(context, true),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Check-In',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              '${_checkInDate.day}/${_checkInDate.month}/${_checkInDate.year}',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTap: () => _selectDate(context, false),
                        child: Column(
                          children: [
                            Icon(Icons.calendar_today),
                            SizedBox(height: screenHeight * 0.005),
                            Text(
                              'Check-Out',
                              style: TextStyle(fontSize: 16.0),
                            ),
                            Text(
                              '${_checkOutDate.day}/${_checkOutDate.month}/${_checkOutDate.year}',
                              style: TextStyle(fontSize: 14.0),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            Container(
              padding: EdgeInsets.all(screenWidth * 0.04),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Guests:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_adults > 1) {
                            setState(() {
                              _adults--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('Adults: $_adults',
                          style: TextStyle(fontSize: 16.0)),
                      IconButton(
                        onPressed: () {
                          if (_adults < maxGuests) {
                            setState(() {
                              _adults++;
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                      IconButton(
                        onPressed: () {
                          if (_children > 0) {
                            setState(() {
                              _children--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('Children: $_children',
                          style: TextStyle(fontSize: 16.0)),
                      IconButton(
                        onPressed: () {
                          if (_children < maxGuests) {
                            setState(() {
                              _children++;
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Text(
                    'Room Amount:',
                    style: TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (_roomAmount > 1) {
                            setState(() {
                              _roomAmount--;
                            });
                          }
                        },
                        icon: Icon(Icons.remove),
                      ),
                      Text('Amount: $_roomAmount',
                          style: TextStyle(fontSize: 16.0)),
                      IconButton(
                        onPressed: () {
                          if (_roomAmount < maxGuests) {
                            setState(() {
                              _roomAmount++;
                            });
                          }
                        },
                        icon: Icon(Icons.add),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight * 0.02),
            ElevatedButton(
              onPressed: () {
                int roomPrice =
                    int.parse(widget.roomPrice.replaceAll('\$', ''));
                int totalPrice = roomPrice * _roomAmount;

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PaymentPage(
                      roomName: widget.roomName,
                      roomPrice: widget.roomPrice,
                      roomAmount: _roomAmount.toString(),
                      totalPrice: totalPrice.toString(),
                      total: '',
                      adults: _adults,
                    
                      username: '',
                      children: _children,
                    ),
                  ),
                );
              },
              child: Text('Make Payment'),
            ),
            SizedBox(height: screenHeight * 0.02),
            Text(
              'Total Price: \$${roomPrice * _roomAmount}',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
