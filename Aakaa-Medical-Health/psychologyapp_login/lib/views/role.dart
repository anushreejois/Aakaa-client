import "package:flutter/material.dart";
import "package:psychologyapp_login/views/clientlogin.dart";

class RoleView extends StatelessWidget {
  const RoleView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFB3261E),
      appBar: AppBar(
        backgroundColor: Color(0xFFB3261E),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Color(0xFFFFFFFF), size: 30),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            child: const Center(
              child: Text(
                "I am a",
                style: TextStyle(
                  color: Color(0xFFFFFFFF),
                  fontSize: 38,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ),
          SizedBox(height: 40),
          Expanded(
            child: Container(
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
                        bottom: MediaQuery.of(context).size.height * 0.4,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: SizedBox(
                            height: 80,
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context, MaterialPageRoute(
                                    builder: (context) => const ClientLogin(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF9F9),
                                shadowColor: Color(0xFF3E64FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Client",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                      Positioned(
                        top: MediaQuery.of(context).size.height * 0.4,
                        left: 0, 
                        right: 0,
                        child:Center(
                          child: SizedBox(
                            height: 80,
                            width: 250,
                            child: ElevatedButton(
                              onPressed: () {
                                // Action for "A Patient"
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFFFFF9F9),
                                shadowColor: Color(0xFF3E64FF),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                elevation: 6,
                              ),
                              child: const Text(
                                "Therapist",
                                style: TextStyle(
                                  color: Color(0xFF000000),
                                  fontSize: 36,
                                ),
                              ),
                            ),
                          ),
                        )
                      ),
                    ],
                  )
                )
                )
                ),
          ),
        ],
      ),
    );
  }
}
