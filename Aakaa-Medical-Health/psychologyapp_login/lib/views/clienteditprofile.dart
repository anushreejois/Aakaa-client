// ignore_for_file: deprecated_member_use

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/clientfullprofilepic.dart';

class EditProfile extends StatefulWidget {
  final File? imageFile;
  const EditProfile({super.key, required this.imageFile});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

enum Gender { male, female, other }

class _EditProfileState extends State<EditProfile> {
  File? _profileImage;
  Gender? _selectedGender;
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController _dobController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _profileImage = widget.imageFile;
  }

  Future<void> openProfileImage() async {
    final File? updatedImage = await Navigator.push<File?>(
      context,
      MaterialPageRoute(
        builder: (_) => FullProfileImageScreen(imageFile: _profileImage),
      ),
    );
    if (updatedImage != null) {
      setState(() {
        _profileImage = updatedImage;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope<File?>(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Navigator.pop(context, _profileImage);
        }
      },
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context, _profileImage);
            },
            icon: Icon(Icons.arrow_back),
          ),
          backgroundColor: Color(0xFFFFFFFF),
          automaticallyImplyLeading: false,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: SizedBox(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: SingleChildScrollView(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                child: Form(
                  key: _editProfileFormKey,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: openProfileImage,
                        child: Stack(
                          children: [
                            CircleAvatar(
                              radius: 70,
                              backgroundImage: _profileImage != null
                                  ? FileImage(_profileImage!)
                                  : const AssetImage(
                                          "assets/images/ProfileAvatar.png",
                                        )
                                        as ImageProvider,
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "Edit Photo",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.topCenter,
                        height: MediaQuery.of(context).size.height * 0.3,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF3E64FF).withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(
                                0,
                                4,
                              ), // changes position of shadow
                            ),
                          ],
                          color: Color(0xFFFCF8F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 0,
                          color: Color(0xFFFCF8F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "First Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFFB3261E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 40,
                                left: 10,
                                right: 10,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "First Name",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFE9E8),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 100,
                                left: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Last Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFFB3261E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 130,
                                left: 10,
                                right: 10,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Last Name",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFE9E8),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Positioned(
                                top: 190,
                                left: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Screen Name",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFFB3261E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 220,
                                left: 10,
                                right: 10,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Screen Name",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFE9E8),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        alignment: Alignment.topCenter,
                        height: MediaQuery.of(context).size.height * 0.11,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFF3E64FF).withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(
                                0,
                                4,
                              ), // changes position of shadow
                            ),
                          ],
                          color: Color(0xFFFCF8F7),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Card(
                          elevation: 0,
                          color: Color(0xFFFCF8F7),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 10,
                                left: 10,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "Date of Birth",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      "*",
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0XFFB3261E),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 40,
                                left: 10,
                                right: 10,
                                child: TextFormField(
                                  controller: _dobController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    border: InputBorder.none,
                                    hintText: "Select your DOB",
                                    hintStyle: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                    filled: true,
                                    fillColor: Color(0xFFFFE9E8),
                                    prefixIcon: IconButton(
                                      onPressed: () async {
                                        DateTime? pickedDate =
                                            await showDatePicker(
                                              context: context,
                                              initialDate: DateTime(
                                                2000,
                                              ), // reasonable default
                                              firstDate: DateTime(1900),
                                              lastDate: DateTime.now(),
                                            );

                                        if (pickedDate != null) {
                                          _dobController.text =
                                              "${pickedDate.day}/${pickedDate.month}/${pickedDate.year}";
                                        }
                                      },
                                      icon: Icon(
                                        Icons.calendar_today_outlined,
                                        size: 24,
                                        color: Color(0xFFB3261E),
                                      ),
                                    ),
                                  ),
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Gender",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              "*",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0XFFB3261E),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<Gender>(
                                value: Gender.male,
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                },
                                activeColor: Color(0XFFB3261E),
                              ),
                              Text(
                                "Male",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<Gender>(
                                value: Gender.female,
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                },
                                activeColor: Color(0XFFB3261E),
                              ),
                              Text(
                                "Female",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Radio<Gender>(
                                value: Gender.other,
                                groupValue: _selectedGender,
                                onChanged: (value) {
                                  setState(() => _selectedGender = value);
                                },
                                activeColor: Color(0XFFB3261E),
                              ),
                              Text(
                                "Other",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            "Phone Number",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.only(
                            left: 15.0,
                            right: 15.0,
                          ),
                          child: TextFormField(
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              hintText: "Phone Number",
                              hintStyle: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.normal,
                              ),
                              filled: true,
                              fillColor: Color(0xFFFFE9E8),
                            ),
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                            keyboardType: TextInputType.number,
                            maxLength: 10,
                          ),
                        ),
                      ),
                      SizedBox(height: 30),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.8,
                        child: ElevatedButton(
                          onPressed: () {
                            //TODO
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB3261E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            "Update",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
