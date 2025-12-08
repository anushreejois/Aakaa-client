import 'package:flutter/material.dart';

class ClientMenu extends StatefulWidget {
  const ClientMenu({super.key});

  @override
  State<ClientMenu> createState() => _ClientMenuState();
}

class _ClientMenuState extends State<ClientMenu>{

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
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          child: Column(
            children: [
              Container(
                alignment: Alignment.center,
                  height: MediaQuery.of(context).size.height * 0.2,
                  width: MediaQuery.of(context).size.width * 0.86,
                  decoration: BoxDecoration(
                    color: Color(0xFFB3261E),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
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
                      ),
                    ],
                  )
                ),
              ),
              Container(
                    width: MediaQuery.of(context).size.width * 0.85,
                    height: MediaQuery.of(context).size.height * 0.3,
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
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20),
                      ),
                      child: Image.asset(
                        'assets/images/MenuCard.jpeg',
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.vertical,
                      child: Column(
                        children: [
                          Text("Scroll up to view more options"),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.1,
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
                      borderRadius: BorderRadius.circular(20),
                             ),
                            child: ElevatedButton(
                              onPressed: (){
                                // TODO
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF7F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("About us",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Find it here",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.45
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF222B45),
                                    size: 25,
                                  ),
                                ],
                                )
                                ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.1,
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
                      borderRadius: BorderRadius.circular(20),
                             ),
                            child: ElevatedButton(
                              onPressed: (){
                                // TODO
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF7F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("About Psychological Disorders ",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Find it here",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      ),
                                    ],
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF222B45),
                                    size: 25,
                                  ),
                                ],
                                )
                                ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.1,
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
                      borderRadius: BorderRadius.circular(20),
                             ),
                            child: ElevatedButton(
                              onPressed: (){
                                // TODO
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF7F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("Find a therapist here",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Find it here",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.2
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF222B45),
                                    size: 25,
                                  ),
                                ],
                                )
                                ),
                          ),
                          SizedBox(height: 20),
                          Container(
                            width: MediaQuery.of(context).size.width * 0.85,
                            height: MediaQuery.of(context).size.height * 0.1,
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
                      borderRadius: BorderRadius.circular(20),
                             ),
                            child: ElevatedButton(
                              onPressed: (){
                                // TODO
                              }, 
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF7F7),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                )
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("View Chat",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),),
                                      Text("Find it here",
                                      style: TextStyle(
                                        color: Color(0xFF000000),
                                        fontSize: 16,
                                        fontWeight: FontWeight.normal,
                                      ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width * 0.42
                                  ),
                                  Icon(
                                    Icons.arrow_forward,
                                    color: Color(0xFF222B45),
                                    size: 25,
                                  ),
                                ],
                                )
                                ),
                          ),
                          SizedBox(height: 10, width: MediaQuery.of(context).size.width * 0.86)
                        ],
                        ),
                    ),
                  )
            ],
          ),
        ),
      ),
    );
  }
}