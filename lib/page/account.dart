import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class AccountPage extends StatefulWidget {
  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final ImagePicker _imagePicker = ImagePicker();

  User? _user;
  String _userName = 'No name';
  String _userPhone = 'No phone number';
  XFile? _imageFile;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    if (_user != null) {
      _fetchUserDetails(_user!.uid);
      setState(() {
        _userName = _user!.displayName ?? 'No name';
      });
    }
  }

  Future<void> _fetchUserDetails(String userId) async {
    try {
      DocumentSnapshot userDoc =
          await _firestore.collection('Users').doc(userId).get();

      if (userDoc.exists) {
        setState(() {
          _userName = userDoc.get('name') ?? 'No name';
          _userPhone = userDoc.get('phoneNumber') ?? 'No phone number';
        });
      }
    } catch (e) {
      print('Error fetching user details: $e');
    }
  }

  Future<void> _selectAndSaveImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = pickedFile;
      });

      if (_user != null) {
        await _saveImageToFirebase(_user!.uid);
      }
    }
  }

  Future<void> _saveImageToFirebase([String? uid]) async {
    try {
      if (_imageFile != null && _user != null) {
        final String userId = _user!.uid;
        final String imageFileName = 'profile_picture.jpg';
        final FirebaseStorage storage = FirebaseStorage.instance;
        final Reference ref = storage
            .ref()
            .child('user_images')
            .child(userId)
            .child(imageFileName);

        // Read image file as bytes (Uint8List)
        Uint8List imageBytes = await _imageFile!.readAsBytes();

        await ref.putData(imageBytes);
        final imageUrl = await ref.getDownloadURL();

        final userRef = _firestore.collection('Users').doc(userId);
        await userRef.update({'profilePicture': imageUrl});
      }
    } catch (e) {
      if (e is FirebaseException) {
        print('Firebase Exception: $e');
      } else {
        print('Error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Account'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: _selectAndSaveImage,
                child: Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: _imageFile != null
                        ? FileImage(File(_imageFile!.path))
                        : (_user?.photoURL != null
                            ? NetworkImage(_user!.photoURL!) as ImageProvider
                            : null),
                    child: _imageFile == null && _user?.photoURL == null
                        ? Icon(Icons.add_a_photo)
                        : null,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'Account Information',
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 20.0),
              buildListTile('Name:', _userName),
              buildListTile('Email:', _user?.email ?? 'No email'),
              buildListTile('Phone:', _userPhone),
              SizedBox(height: 40.0),
              ElevatedButton(
                onPressed: () async {
                  await _auth.signOut();
                  // Perform navigation to the sign-in page or any other page after sign-out.
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildListTile(String title, String subtitle) {
    return Column(
      children: [
        ListTile(
          title: Text(
            title,
            style: TextStyle(fontSize: 18.0),
          ),
          subtitle: Text(
            subtitle,
            style: TextStyle(fontSize: 16.0),
          ),
        ),
        Divider(),
      ],
    );
  }
}
