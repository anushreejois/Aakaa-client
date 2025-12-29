import 'package:flutter/material.dart';

class ClientProfile extends StatefulWidget {
  const ClientProfile({super.key});

  @override
  State<ClientProfile> createState() => _ClientProfileState();
}

class _ClientProfileState extends State<ClientProfile>{

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
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: GestureDetector(
              child: Stack(
                children:[ 
                  CircleAvatar(
                    radius: 70,
                    child: Image.asset("assets/images/ProfileAvatar.png", fit: BoxFit.fill,)
                    ),
                ]
                ),
            ),
          ),
        )
      ),
    );
  }
}