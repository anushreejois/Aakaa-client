import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/clientfullprofilepic.dart';
import 'package:psychologyapp_login/views/clientlogin.dart';

class ClientProfile extends StatefulWidget {
  final String email;
  const ClientProfile({super.key, required this.email});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile>{
  String get alternatescreenname => widget.email.split('@').first;
  String screenname = "";
  String get result => screenname.isNotEmpty ? screenname : alternatescreenname;
  File? _profileImage;
  String phoneNumber = "Add Phone Number";
  String dob = "Add Date of Birth";
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> openProfileImage() async {
    final File? updatedImage = await Navigator.push<File?>(
      context, MaterialPageRoute(builder: (_) => FullProfileImageScreen(imageFile: _profileImage))
    );
    if(updatedImage != null){
      setState(() {
        _profileImage = updatedImage;
      });
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Text(
        "My Profile",
        style: TextStyle(
          color: Color(0xFF000000),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
                      ),
        backgroundColor:  Color(0xFFFFFFFF),
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
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                children:[ GestureDetector(
                  onTap: openProfileImage,
                  child: Stack(
                    children:[ 
                      CircleAvatar(
                        radius: 70,
                        backgroundImage: _profileImage != null
                        ? FileImage(_profileImage!)
                        : const AssetImage("assets/images/ProfileAvatar.png") as ImageProvider,
                        ),
                    ]
                    ),
                ),
                const SizedBox(height: 10),
                Text(result,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 30,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Color(0xFF3E64FF).withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed:(){
                            //
                          },
                          child: FittedBox(
                            child: Text("Edit Profile",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          )
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.25,
                        height: 30,
                        decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Color(0xFF3E64FF).withOpacity(0.5),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: Offset(0, 4), // changes position of shadow
                            ),
                          ],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ElevatedButton(
                          onPressed:(){
                            //
                          },
                          child: FittedBox(
                            child: Text("My Plan",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),),
                          ),
                          )
                      ),
                    ],
                    ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
                  child: Column(
                    children: [
                      Align(
                        alignment: Alignment.topLeft, 
                        child: Text("My Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB3261E),
                        ),),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Icon(
                            Icons.phone,
                            size: 24,
                            color: Color(0xFFB3261E),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("+91 $phoneNumber",
                          style: TextStyle(
                            fontSize: 16,
                      
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Icon(
                            Icons.calendar_today_outlined,
                            size: 24,
                            color: Color(0xFFB3261E),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text(dob,
                          style: TextStyle(
                            fontSize: 16,
                      
                          ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Icon(
                            Icons.sticky_note_2_rounded,
                            size: 24,
                            color: Color(0xFFB3261E),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("Freemium Plan",
                          style: TextStyle(
                            fontSize: 16,
                      
                          ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Divider(
                  color: Color(0xFF9E9C9C),
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                  child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft, 
                          child: Text("My Information",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB3261E),
                          ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children:[
                          Icon(
                            Icons.incomplete_circle,
                            size: 24,
                            color: Color(0xFFB3261E),
                            ),
                            SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("0 Upcoming.",
                          style: TextStyle(
                            fontSize: 16,
                      
                          ),
                          ),
                        ],
                      ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children:[
                          Text("View All",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                          SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          IconButton(
                            onPressed: (){
        
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xFF9E9C9C),
                              ),
                          ),
                          
                        ],
                      ),
                      ]
                  ),
                ),
                Divider(
                  color: Color(0xFF9E9C9C),
                  thickness: 1,
                  indent: 10,
                  endIndent: 10,
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(30, 0, 20, 0),
                  child: Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft, 
                          child: Text("Preferences",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFB3261E),
                          ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Row(
                            children: [
                              Icon(
                                Icons.notifications_none_rounded,
                                size: 24,
                                color: Color(0xFFB3261E),
                                ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("Notifications",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                            ],
                          ),
                          IconButton(
                            onPressed: (){
                              //
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xFF9E9C9C),
                              ),
                              ),
                        ],
                      ),
                        Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Row(
                            children: [
                              Icon(
                                Icons.language_sharp,
                                size: 24,
                                color: Color(0xFFB3261E),
                                ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("Language",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                            ],
                          ),
                          Row(
                            children: [
                              Text("English",
                              style: TextStyle(
                              fontSize: 16,
        
                            ),
                              ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                              IconButton(
                                onPressed: (){
                                  //
                                },
                                icon: Icon(
                                  Icons.arrow_forward_ios,
                                  size: 20,
                                  color: Color(0xFF9E9C9C),
                                  ),
                                  ),
                            ],
                          ),
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children:[
                          Row(
                            children: [
                              Icon(
                                Icons.help_outline,
                                size: 24,
                                color: Color(0xFFB3261E),
                                ),
                              SizedBox(width: MediaQuery.of(context).size.width * 0.05),
                          Text("Help & Support",
                          style: TextStyle(
                            fontSize: 16,
                          ),
                          ),
                            ],
                          ),
                          IconButton(
                            onPressed: (){
                              //
                            },
                            icon: Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: Color(0xFF9E9C9C),
                              ),
                              ),
                        ],
                      ),
                      ]
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                                    height: MediaQuery.of(context).size.height * 0.07,
                                    width: MediaQuery.of(context).size.width * 0.8,
                                    child: ElevatedButton(
                                      onPressed: (){
                                        Navigator.pushAndRemoveUntil(
                                          context, 
                                          MaterialPageRoute(builder: (_) => ClientLogin()), (route) => false);
                                      },
                                      style: ElevatedButton.styleFrom(
                                                          backgroundColor: Color(
                                                            0xFFB3261E,
                                                          ),
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  20,
                                                                ),
                                                          ),
                                                          elevation: 6,
                                                        ), 
                                      child: Text("Log Out",
                                      style: TextStyle(
                                        fontSize: 28,
                                        fontWeight: FontWeight.bold,
                                        color: Color(0xFFFFFFFF),
                                      ))),
                                  ),
                                  SizedBox(height: 30),
                ],
              ),
            ),
          )
        ),
      ),
    );
  }
}