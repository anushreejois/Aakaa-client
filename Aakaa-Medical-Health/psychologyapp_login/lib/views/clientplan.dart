import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/clientsubscription.dart';

class ClientPlan extends StatefulWidget {
  const ClientPlan({super.key});

  @override
  State<ClientPlan> createState() => _ClientPlanState();
}

class _ClientPlanState extends State<ClientPlan>{

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFFB3261E),
        automaticallyImplyLeading: false,
      ),
      backgroundColor: Color(0xFFB3261E),
      body: SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: Column(
                children: [
                  Text("My Plan",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFFFFF),
                  )
                  ),
                  SizedBox(height: 40),
                  Container(
                alignment: Alignment.bottomCenter,
                height: MediaQuery.of(context).size.height * 0.75,
                width: MediaQuery.of(context).size.width * 1.0,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_use
                      color: Color(0xFF3E64FF).withOpacity(0.5),
                      spreadRadius: 15,
                      blurRadius: 22.3,
                      offset: Offset(0, 1), // changes position of shadow
                    ),
                  ],
                  color: Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(50),
                    topRight: Radius.circular(50),
                  ),
                ),
                child: Card(
                  elevation: 20,
                  color: Color(0xFFFFFFFF),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50),
                    ),
                  ),
                  child: SizedBox(
                    child: Stack(
                      children: [
                        Positioned(
                          top: 30,
                          left: 0,
                          right: 0,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.16,
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
                                              color: Color(0xFFFCF8F7),
                                              borderRadius: BorderRadius.circular(20),
                                            ),
                                            child: Card(
                                              elevation: 0,
                                              color: Color(0xFFFCF8F7),
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(20),
                                              ),
                                              child: Stack(
                                                children: [
                                                  Positioned(
                                                    top: 20,
                                                    left: 0,
                                                    right: 0,
                                                    child: Padding(
                                                      padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                                                      child: Column(
                                                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Freemium🧪",
                                                          style: TextStyle(
                                                            fontSize: 32,
                                                            color: Color(0xFF000000),
                                                          )
                                                          ),
                                                          Text("Onboard users with limited access.",
                                                          style: TextStyle(
                                                            fontSize: 20,
                                                            color: Color(0xFF000000),
                                                          ),
                                                          ),
                                                        ],
                                                      )
                                                      )
                                                    ),                                                 
                                                ],
                                              )
                                            )
                            ),
                          ),
                        ),
                        Positioned(
                          top: 200,
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children:[
                                Text("What's included",
                                style: TextStyle(
                                  fontSize: 30,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                SizedBox(height: 10),
                                Text("• Basic profile setup.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                Text("• Limited mood tracking (3 days).",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                Text("• Explore therapists (no booking).",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                Text("• 1 self-help article/week.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                Text("• No appointment access.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                                Text("• No therapist chat.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                                ),
                              ]
                            )
                            ),
                            ),
                            Positioned(
                              top: 500,
                              left: 0,
                              right: 0,
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                                child: SizedBox(
                                  height: MediaQuery.of(context).size.height * 0.07,
                                  child: ElevatedButton(
                                    onPressed: (){
                                      Navigator.push(
                                        context, 
                                        MaterialPageRoute(
                                          builder: (context) => ClientSubscription()
                                          ),
                                          );
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
                                    child: Text("Upgrade Plan",
                                    style: TextStyle(
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFFFFFF),
                                    ))),
                                )
                                ),
                            ),
                      ],
                    )
                  )
                  )
                  ),
                ]
              ),
            ),
          ),
        ),
      ),
    );
  }
}