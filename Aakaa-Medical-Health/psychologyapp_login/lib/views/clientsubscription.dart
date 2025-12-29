import 'package:flutter/material.dart';

class ClientSubscription extends StatefulWidget {
  const ClientSubscription({Key? key}) : super(key: key);

  @override
  State<ClientSubscription> createState() => _ClientSubscriptionState();
}

class _ClientSubscriptionState extends State<ClientSubscription> {
  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Subscription Plans',
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: Color(0xFF000000),
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              child: GestureDetector(
                    onTap: (){
                    setState(() {
                      isExpanded = !isExpanded;
                    });
                    },
                child: Card(
                  elevation: 20,
                  color: Color(0xFFFCF8F7),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: AnimatedContainer(
                    width: MediaQuery.of(context).size.width * 0.9,
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
                    duration: const Duration(seconds: 5),
                    padding: const EdgeInsets.all(15),
                    curve: Curves.bounceInOut,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Freemium🧪",
                          style: TextStyle(
                            fontSize: 32,
                            color: Color(0xFF000000),
                          ),
                        ),
                        Text(
                          "Onboard users with limited access.",
                          style: TextStyle(
                            fontSize: 20,
                            color: Color(0xFF000000),
                          ),
                        ),
                        if(isExpanded)...[
                          const SizedBox(height: 10),
                          Text("Feature :"),
                          Text("Feature :"),
                          Text("Feature :"),
                          Text("Feature :"),
                          Text("Feature :"),
                          Text("Feature :"),
                          Text("Feature :"),
                        ]
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          
        ],
      ),
    );
  }
}
