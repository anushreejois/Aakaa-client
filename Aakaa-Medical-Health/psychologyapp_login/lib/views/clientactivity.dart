import 'package:flutter/material.dart';

class ClientActivity extends StatefulWidget {
  const ClientActivity({super.key});

  @override
  State<ClientActivity> createState() => _ClientActivityState();
}

class _ClientActivityState extends State<ClientActivity>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        title: Row(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                "Welcome,",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 2),
              Text(
                "Username,",
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 18,
                  fontWeight: FontWeight.normal,
                ),
              ),
              ],
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.5),
            IconButton(
              onPressed: (){
                // TODO: Implement notification functionality
              }, icon: Icon(
                Icons.notifications_none,
                color: Color(0xFF000000),
                size: 35
              ),
            ),
          ],
        ),
        backgroundColor:  Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
            child: Container(
              alignment: Alignment.center,
                height: MediaQuery.of(context).size.height * 0.5,
                width: MediaQuery.of(context).size.width * 0.85,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Color(0xFF3E64FF).withOpacity(0.5),
                      spreadRadius: 3,
                      blurRadius: 4,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                  color: Color(0xFFB3261E),
                  borderRadius: BorderRadius.circular(20),
                  ),
              child: Card(
                elevation: 20,
                color: Color(0xFFB3261E),
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Text(
                        "Mental\nHealthcare",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        )
                      )
                    ),
                    Positioned(
                      top: 110,
                      left: 10,
                      child: Text(
                        "Book your next\nonline appointments",
                        style: TextStyle(
                          color: Color(0xFFFFFFFF),
                          fontSize: 20,
                          fontWeight: FontWeight.normal,
                        )
                      )
                    )
                  ],
                )
              ),
            
            ),
          ),
        )
      ),
    );
  }
}