import 'package:flutter/material.dart';
import 'package:psychologyapp_login/views/info.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Card(
                      elevation: 8,
                      color: const Color(0xFFB3261E),
                      shadowColor: const Color(0xFF000000),
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.9, // 90% of the screen width
                        height: MediaQuery.of(context).size.height * 0.9, // 90% of the screen height
                        alignment: Alignment.center,
                        child: Padding(padding: const EdgeInsets.all(16.0), 
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end, // Align to bottom
                          children: [
                            SizedBox(
                            
                              // Button height and width
                              width: 279,
                              height: 78,
                              
                              //Get Started Button
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Info()),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFFFFFFFF),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 6,
                    
                                ),
                                child: const Text(
                                  "Let’s Get Started !",
                                  style: TextStyle(
                                    color: Color(0xFF000000),
                                    fontSize: 25,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(height: 16), // spacing from bottom
                          ],
                        ),
                        )
                        )
                        ),
                  ),
                ),
              ],
            ),
              ),
        ),
          );
  }
}