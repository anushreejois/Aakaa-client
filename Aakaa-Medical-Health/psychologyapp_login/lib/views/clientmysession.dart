import 'package:flutter/material.dart';

class ClientMySession extends StatefulWidget {
  const ClientMySession({super.key});

  @override
  State<ClientMySession> createState() => _ClientMySessionState();
}

class _ClientMySessionState extends State<ClientMySession>{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor:  Color(0xFFFFFFFF),
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 30,
              color: Color(0xFFB3261E)
            ),
            SizedBox(width: 10),
            Text(
            "My Sessions",
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
                          ),
          ],
        ),
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
      ),
    );
  }
}