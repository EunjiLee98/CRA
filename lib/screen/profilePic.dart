import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:link_ver1/helper/helper_functions.dart';
import 'package:link_ver1/services/auth_service.dart';
import 'package:link_ver1/screen/profileMain.dart';

//profile pic
class ProfilePic extends StatefulWidget {
  FirebaseAuth auth = FirebaseAuth.instance; //get current user

  @override
  _ProfilePicState createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  final _storage = FirebaseStorage.instance;
  final _picker = ImagePicker();
  User _user;

  PickedFile image;
  String imageUrl;
  String downloadUrl;

  Future getImage() async {
    image = await _picker.getImage(source: ImageSource.gallery);

    if (image != null) {
      uploadFile(image.path);
    }
  }

  Future uploadFile(String path) async {
    var file = File(path);
    var snapshot =
        await _storage.ref().child('folderName/imageName').putFile(file);

    downloadUrl = await snapshot.ref.getDownloadURL();
    _user.updateProfile(
      photoURL: downloadUrl,
    );
    print(downloadUrl);
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  getCurrentUser() async {
    _user = await FirebaseAuth.instance.currentUser;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 115,
      width: 115,
      child: Stack(
        fit: StackFit.expand,
        overflow: Overflow.visible,
        children: [
          CircleAvatar(
            backgroundImage: image == null
                ? AssetImage("assets/user.png")
                : FileImage(File(image.path)),
            backgroundColor: Colors.white,
          ),
          Positioned(
            right: -16,
            bottom: 0,
            child: SizedBox(
              height: 46,
              width: 46,
              child: FlatButton(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(50),
                  side: BorderSide(color: Colors.white),
                ),
                color: Color(0xFFF5F6F9),
                onPressed: () {
                  getImage();
                },
                child: Image.asset("assets/camera.png"),
              ),
            ),
          )
        ],
      ),
    );
  }
}
//profile pic

//profile screen
class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthService _auth = AuthService();
  var _user;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _getUserAuthAndJoinedGroups();
  }

  _getUserAuthAndJoinedGroups() async {
    _user = await FirebaseAuth.instance.currentUser;
    await HelperFunctions.getUserNameSharedPreference().then((value) {
      setState(() {
        _userName = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ProfileMain(
        userName: _userName, //pass user name
      ),
    );
  }
}
//profile screen
