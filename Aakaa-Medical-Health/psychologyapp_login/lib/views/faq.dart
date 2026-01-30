import 'package:flutter/material.dart';

class FaQ extends StatefulWidget {
  const FaQ({super.key});

  @override
  State<FaQ> createState() => _FaQState();
}

class _FaQState
 extends State<FaQ>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor:  Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text("FAQ's",
                  style: TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  ),
                  ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              children: [
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("What is Aakaa?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),),
                              children: [
                                Text("Aakaa is a comprehensive mental wellness app designed to help you manage stress, anxiety and improve your overall mental health through guided meditation, mood tracking, breathing exercises and journaling tools.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("Is Aakaa free to use?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),),
                              children: [
                                Text("Aakaa will offer a free tier with essential features, as well as a premium subscription that unlocks advanced tools, personalized plans and exclusive content from mental health professionals.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("Is my data private and secure?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),
                              ),
                              children: [
                                Text("Absolutely. Your privacy is our top priority. All your data is encrypted and stored securely. We never share your personal information with third parties and you have full control over your data.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("Can Aakaa replace therapy?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),),
                              children: [
                                Text("While Aakaa provides valuable tools and resources for mental wellness, it is not a replacement for professional therapy or medical treatment. We recommend consulting with a mental health professional for serious concerns.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("What devices will Aakaa be available on?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),),
                              children: [
                                Text("Aakaa will be available on both iOS and Android devices at launch. We're also exploring a web version for the future.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
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
                      borderRadius: BorderRadius.circular(10),
                      ),
                      child: Card(
                        elevation: 0,
                        color: Color(0xFFFCF8F7),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Theme(
                            data: Theme.of(context).copyWith(
                              splashColor: Colors.transparent,
                              dividerColor: Colors.transparent,
                            ),
                            child: ExpansionTile(
                              enableFeedback: false,
                              title: Text("Can I use Aakaa offline?",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB3261E),
                              ),),
                              children: [
                                Text("Many features including guided meditations and journaling will be available offline once content is downloaded. Some features like community support will require an internet connection.",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.left,
                                )
                              ],
                              ),
                          ),
                        )
                      )
                ),
                const SizedBox(height: 70),
                SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: ElevatedButton(
                          onPressed: () {
                            int count = 0;
                            Navigator.popUntil(context, (route){
                              return count++ == 2;
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFFB3261E),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 6,
                          ),
                          child: Text(
                            "Go To Dashboard",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
              ]
            ),
          ),
        )
      ),
    );
  }
}