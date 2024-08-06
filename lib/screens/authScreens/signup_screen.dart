import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../../widgets/custom_text_field.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  XFile? imageFile;
  ImagePicker imagePicker = ImagePicker();

  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController emailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();
  TextEditingController confirmPasswordTextEditingController =
      TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController locationTextEditingController = TextEditingController();

  // method to get image from gallery
  pickImageFromGallery() async {
    // send the user to the gallery
    imageFile = await imagePicker.pickImage(source: ImageSource.gallery);

    // update the changes on the ui
    setState(() {
      imageFile;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(
            height: 11,
          ),
          InkWell(
            onTap: () {
              pickImageFromGallery();
            },
            child: CircleAvatar(
              radius: MediaQuery.of(context).size.width * 0.20,
              backgroundColor: Colors.white,
              backgroundImage:
                  imageFile == null ? null : FileImage(File(imageFile!.path)),
              child: imageFile == null
                  ? Icon(
                      Icons.add_photo_alternate,
                      size: MediaQuery.of(context).size.width * 0.20,
                      color: Colors.grey,
                    )
                  : null,
            ),
          ),
          const SizedBox(
            height: 11,
          ),
          Form(
              key: formKey,
              child: Column(
                children: [
                  CustomTextField(
                    textEditingController: nameTextEditingController,
                    iconData: Icons.person,
                    hintString: 'Name',
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: emailTextEditingController,
                    iconData: Icons.email,
                    hintString: 'Email',
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: phoneTextEditingController,
                    iconData: Icons.phone,
                    hintString: 'Phone no',
                    isObscure: false,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: passwordTextEditingController,
                    iconData: Icons.password,
                    hintString: 'Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: confirmPasswordTextEditingController,
                    iconData: Icons.password,
                    hintString: 'Confirm Password',
                    isObscure: true,
                    enabled: true,
                  ),
                  CustomTextField(
                    textEditingController: locationTextEditingController,
                    iconData: Icons.my_location,
                    hintString: 'Cafe/Restaurant address',
                    isObscure: false,
                    enabled: true,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    width: 398,
                    height: 39,
                    alignment: Alignment.center,
                    child: ElevatedButton.icon(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32),
                          )),
                      icon: const Icon(
                        Icons.location_on,
                        color: Colors.white,
                      ),
                      label: const Text(
                        'Get my current location',
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                    ),
                    child: const Text(
                      'Sign up',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ))
        ],
      ),
    );
  }
}
