import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eats_seller_app/global/global_instances.dart';
import 'package:flutter_eats_seller_app/global/global_vars.dart';
import 'package:flutter_eats_seller_app/views/screens/mainScreens/home_screen.dart';
import 'package:image_picker/image_picker.dart';

class AuthViewModel {
  validateSignUpForm(
    XFile? imageXFile,
    String password,
    String confirmPassword,
    String name,
    String email,
    String phone,
    String address,
    BuildContext ctx,
  ) async {
    if (imageXFile == null) {
      commonViewModel.showSnackBar("Please select an image", ctx);
    } else if (password.isEmpty || confirmPassword.isEmpty) {
      commonViewModel.showSnackBar("Please enter passwords", ctx);
    } else if (password != confirmPassword) {
      commonViewModel.showSnackBar("Passwords do not match", ctx);
    } else if (password.length < 6) {
      commonViewModel.showSnackBar(
          "Password must be at least 6 characters", ctx);
    } else if (name.isEmpty) {
      commonViewModel.showSnackBar("Please enter your name", ctx);
    } else if (!RegExp(r"^[a-zA-Z ]+$").hasMatch(name)) {
      commonViewModel.showSnackBar("Name should only contain alphabets", ctx);
    } else if (email.isEmpty) {
      commonViewModel.showSnackBar("Please enter your email", ctx);
    } else if (!RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$").hasMatch(email)) {
      commonViewModel.showSnackBar("Please enter a valid email", ctx);
    } else if (phone.isEmpty) {
      commonViewModel.showSnackBar("Please enter your phone number", ctx);
    } else if (!RegExp(r"^\d{11}$").hasMatch(phone)) {
      commonViewModel.showSnackBar(
          "Please enter a valid 11-digit phone number", ctx);
    } else if (address.isEmpty) {
      commonViewModel.showSnackBar("Please enter your address", ctx);
    } else {
      // Sign up
      commonViewModel.showSnackBar('Please wait...', ctx);

      User? currentFirebaseUser =
          await createUserInFirebaseAuth(email, password, ctx);

      if (currentFirebaseUser == null) return;

      String downloadUrl =
          await commonViewModel.uploadImageToFirebaseStorage(imageXFile);
      await saveUserDataIntoFirestore(currentFirebaseUser, downloadUrl, name,
          email, password, address, phone);
    }

    Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomeScreen()));

    commonViewModel.showSnackBar('Account created successfully', ctx);
  }

  // create user in firebase
  createUserInFirebaseAuth(
      String email, String password, BuildContext context) async {
    User? currentFirebaseUser;

    await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((authValue) {
      currentFirebaseUser = authValue.user;
    }).catchError((error) {
      commonViewModel.showSnackBar(error.toString(), context);
    });

    if (currentFirebaseUser == null) return signOut();

    return currentFirebaseUser;
  }

  // save data info firestore
  saveUserDataIntoFirestore(currentFirebaseUser, downloadUrl, name, email,
      password, address, phone) async {
    FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentFirebaseUser.uid)
        .set({
      'uid': currentFirebaseUser.uid,
      'email': email,
      'name': name,
      'image': downloadUrl,
      'phone': phone,
      'address': address,
      'status': 'approved',
      'earnings': 0.0,
      'latitude': position!.latitude,
      'longitude': position!.longitude,
    });

    commonViewModel.saveDataIntoLocalStorage('uid', currentFirebaseUser.uid);
    commonViewModel.saveDataIntoLocalStorage('email', email);
    commonViewModel.saveDataIntoLocalStorage('name', name);
    commonViewModel.saveDataIntoLocalStorage('imageUrl', downloadUrl);
  }

  validateSignInForm(String email, String password, BuildContext ctx) async {
    if (email.isNotEmpty && password.isNotEmpty) {
      // login
      commonViewModel.showSnackBar('Checking credentials...', ctx);
      User? currentFirebaseUser = await loginUser(email, password, ctx);
      if (currentFirebaseUser == null) {
        return signOut();
      }
      await readDataFromFirestoreAndSetDataLocally(currentFirebaseUser, ctx);
    } else {
      commonViewModel.showSnackBar('Email and Password are required', ctx);
    }
  }

  loginUser(email, password, ctx) async {
    User? currentFirebaseUser;

    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password)
        .then((authValue) {
      currentFirebaseUser = authValue.user;
    }).catchError((message) {
      commonViewModel.showSnackBar(message.toString(), ctx);
    });

    return currentFirebaseUser;
  }

  signOut() {
    FirebaseAuth.instance.signOut();
  }

  readDataFromFirestoreAndSetDataLocally(
      User? currentFirebaseUser, BuildContext ctx) async {
    await FirebaseFirestore.instance
        .collection('sellers')
        .doc(currentFirebaseUser?.uid)
        .get()
        .then((dataSnapshot) async {
      if (dataSnapshot.exists) {
        if (dataSnapshot.data()?['status'] == 'approved') {
          commonViewModel.saveDataIntoLocalStorage(
              'uid', currentFirebaseUser?.uid);
          commonViewModel.saveDataIntoLocalStorage(
              'email', dataSnapshot.data()?['email']);
          commonViewModel.saveDataIntoLocalStorage(
              'name', dataSnapshot.data()?['name']);
          commonViewModel.saveDataIntoLocalStorage(
              'imageUrl', dataSnapshot.data()?['image']);
          Navigator.push(ctx, MaterialPageRoute(builder: (ctx) => HomeScreen()));
        } else {
          commonViewModel.showSnackBar('You are blocked by admin', ctx);
          return signOut();
        }
      } else {
        commonViewModel.showSnackBar('User not found', ctx);
        signOut();
      }
    });
  }
}
