import 'package:flutter/material.dart';

class ClientSubscription extends StatefulWidget {
  const ClientSubscription({super.key});

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
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
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
                          childrenPadding: EdgeInsets.only(left: 15),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Freemium 🧪",
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
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Feature:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Basic profile setup",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Limited mood tracking (3 days)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Explore therapists (no booking)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("1 self-help article/week",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("No appointment access",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("No therapist chat",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
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
                          childrenPadding: EdgeInsets.only(left: 15),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Basic Plan 🎯",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                "Affordable starter with limited access.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Feature:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Mood tracking + journal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("5+ self-help tools/articles",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Therapist chat (limited hours/week)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Appointment access",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("No AI insights or PDF exports",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
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
                          childrenPadding: EdgeInsets.only(left: 15),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Premium 💎",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                "Full access for active therapy users.",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Feature:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Therapist chat (unlimited)",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Full self-help library",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("AI-powered mood insights",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Download session notes",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Mood tracking + journal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Appointment access",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: Container(
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
                          childrenPadding: EdgeInsets.only(left: 15),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Platinum 👑",
                                style: TextStyle(
                                  fontSize: 32,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              Text(
                                "VIP-level care (mental wellness coaching + speed)",
                                style: TextStyle(
                                  fontSize: 20,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Align(
                                  alignment: Alignment.topLeft,
                                  child: Text("Feature:",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text("Emergency support line",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Dedicated therapist match",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("AI coach insights & habit tracking",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Weekly PDF progress reports",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Mood tracking + journal",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text("Appointment access",
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    ),
                                  ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SizedBox(
                        height: MediaQuery.of(context).size.height * 0.07,
                        width: MediaQuery.of(context).size.width * 0.9,
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
                            "Continue",
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
