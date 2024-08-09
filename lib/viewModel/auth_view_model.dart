import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eats_seller_app/global/global_instances.dart';
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
      await createUserInFirebaseAuth(email, password, ctx);
    }
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
      commonViewModel.showSnackBar(error, context);
    });

    if (currentFirebaseUser == null) return;
  }
}
