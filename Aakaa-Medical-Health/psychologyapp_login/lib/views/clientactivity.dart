import 'package:flutter/material.dart';

class ClientActivity extends StatefulWidget {
  const ClientActivity({super.key});

  @override
  State<ClientActivity> createState() => _ClientActivityState();
}

class _ClientActivityState extends State<ClientActivity>{

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Color(0xFFFFFFFF),
        appBar: AppBar(
          backgroundColor:  Color(0xFFFFFFFF),
            automaticallyImplyLeading: false,
            elevation: 0,
            scrolledUnderElevation: 0,
            surfaceTintColor: Colors.transparent,
            forceMaterialTransparency: false,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
              "Activity",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 2),
            Text(
              "Activity Summary",
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 18,
                fontWeight: FontWeight.normal,
              ),
            ),
            ],
          ),
        ),
        // Need to add SingleChildScrollView in the body.
        body: Center(
          child: Text("Coming Soon!")
          // child: Padding(
          //   padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
          //   child: Column(
          //     children: [
          //       Container(
          //         alignment: Alignment.center,
          //           height: MediaQuery.of(context).size.height * 0.1,
          //           width: MediaQuery.of(context).size.width * 0.85,
          //           decoration: BoxDecoration(
          //             boxShadow: [
          //               BoxShadow(
          //                 // ignore: deprecated_member_use
          //                 color: Color(0xFF3E64FF).withOpacity(0.5),
          //                 spreadRadius: 0,
          //                 blurRadius: 4,
          //                 offset: Offset(0, 4), // changes position of shadow
          //               ),
          //             ],
          //             color: Color(0xFFFCF8F7),
          //             borderRadius: BorderRadius.circular(20),
          //             ),
          //         child: Card(
          //           elevation: 0,
          //           child: Stack(
          //             children: [
          //               Padding(
          //                 padding: const EdgeInsets.fromLTRB(10, 20, 10, 10),
          //                 child: Row(
          //                   mainAxisAlignment: MainAxisAlignment.spaceAround,
          //                   crossAxisAlignment: CrossAxisAlignment.center,
          //                   children: [
          //                     Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Icon(Icons.check_circle_outline, size: 26, color: Color(0xFFB3261E),),
          //                         Text("Sessions",  //TODO: Replace with dynamic date
          //                         style: TextStyle(
          //                           fontSize: 16,
          //                           color: Color(0xFF000000),
          //                         ),
          //                         ),
          //                       ],
          //                     ),
          //                     VerticalDivider(
          //                       color: Color(0xFF9E9C9C),
          //                       thickness: 1,
          //                     ),
          //                     Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Icon(Icons.document_scanner_rounded, size: 26, color: Color(0xFFB3261E),),
          //                         Text("Mood Logs", //TODO: Replace with dynamic date
          //                         style: TextStyle(
          //                           fontSize: 16,
          //                           color: Color(0xFF000000),
          //                         ),
          //                         ),
          //                       ],
          //                     ),
          //                     VerticalDivider(
          //                       color: Color(0xFF9E9C9C),
          //                       thickness: 1,
          //                     ),
          //                     Column(
          //                       mainAxisAlignment: MainAxisAlignment.start,
          //                       crossAxisAlignment: CrossAxisAlignment.center,
          //                       children: [
          //                         Icon(Icons.bar_chart_rounded, size: 26, color: Color(0xFFB3261E),),
          //                         Text("This Week", //TODO: Replace with dynamic date
          //                         style: TextStyle(
          //                           fontSize: 16,
          //                           color: Color(0xFF000000),
          //                         ),
          //                         ),
          //                       ],
          //                     ),
          //                   ],
          //                 ),
          //               )
          //             ],
          //           )
          //         ),
                
          //       ),
          //       SizedBox(height: 20),
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //         child: Align(
          //           alignment: Alignment.topLeft,
          //           child: Text("Appointment History",
          //           style: TextStyle(
          //             fontSize: 18,
          //             fontWeight: FontWeight.bold,
          //             color: Color(0xFF000000),
          //           ),
          //           ),
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       Text(
          //         "No appointment history available.",
          //         style: TextStyle(
          //           fontSize: 16,
          //         )
          //       ),
          //       SizedBox(height: 20),
          //       Padding(
          //         padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //         child: Row(
          //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //           children: [
          //             Text("Mood Tracker",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF000000),
          //             ),
          //             ),
          //             IconButton(
          //               onPressed: (){
          //                 // TODO: Navigate to detailed mood tracker page
          //               }, 
          //               icon: Icon(
          //                 Icons.arrow_forward_ios,
          //                 size: 25,
          //                 color: Color(0xFF000000),) )
          //           ],
          //         ),
          //       ),
          //       SizedBox(height: 20),
          //       Row(
          //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //         children: [
          //           Column(
          //             children: [
          //               Text("S",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("M",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("T",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("W",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("T",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("F",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //           Column(
          //             children: [
          //               Text("S",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 fontWeight: FontWeight.bold,
          //                 color: Color(0xFF000000),
          //               ),
          //               ),
          //               SizedBox(height: 10),
          //               Text("😀",
          //               style: TextStyle(
          //                 fontSize: 40,
          //               ),
          //               ),
          //             ],
          //           ),
          //         ],
          //         ),
          //         SizedBox(height: 20),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //           child: Align(
          //             alignment: Alignment.topLeft,
          //             child: Text("Progress Timeline",
          //                 style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(0xFF000000),
          //                 ),
          //                 ),
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children:
          //             [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Icon(Icons.security_update_good_outlined, size: 26, color: Color(0xFFB3261E)),
          //                   Text(
          //                     "Joined App",
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       color:Color(0xFF000000),
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     ),
          //               ],
          //               ),
          //               //TODO: Replace with dynamic date
          //               Text("MMM-DD, YYYY",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color:Color(0xFF000000),
          //                 fontWeight: FontWeight.bold,
          //               ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children:
          //             [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Icon(Icons.edit_calendar_sharp, size: 26, color: Color(0xFFB3261E)),
          //                   Text(
          //                     "Booked 1st Session",
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       color:Color(0xFF000000),
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     ),
          //               ],
          //               ),
          //               //TODO: Replace with dynamic date
          //               Text("MMM-DD, YYYY",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color:Color(0xFF000000),
          //                 fontWeight: FontWeight.bold,
          //               ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(30, 0, 30, 0),
          //           child: Row(
          //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //             children:
          //             [
          //               Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //                 children: [
          //                   Icon(Icons.check_circle_outline, size: 26, color: Color(0xFFB3261E)),
          //                   Text(
          //                     "Completed 10 Sessions",
          //                     style: TextStyle(
          //                       fontSize: 16,
          //                       color:Color(0xFF000000),
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                     ),
          //               ],
          //               ),
          //               //TODO: Replace with dynamic date
          //               Text("MMM-DD, YYYY",
          //               style: TextStyle(
          //                 fontSize: 16,
          //                 color:Color(0xFF000000),
          //                 fontWeight: FontWeight.bold,
          //               ),
          //               ),
          //             ],
          //           ),
          //         ),
          //         SizedBox(height: 20),
          //         Padding(
          //           padding: const EdgeInsets.fromLTRB(30, 0, 0, 0),
          //           child: Align(
          //             alignment: Alignment.topLeft,
          //             child: Text("Self-Help Activity",
          //             style: TextStyle(
          //                   fontSize: 18,
          //                   fontWeight: FontWeight.bold,
          //                   color: Color(0xFF000000),
          //                 ),
          //             ),
          //           ),
          //         ),
          //         Text("Scroll up to view more activities"),
          //         SizedBox(height: 10),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.85,
          //           height: MediaQuery.of(context).size.height * 0.07,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //               BoxShadow(
          //                 // ignore: deprecated_member_use
          //                 color: Color(0xFF3E64FF).withOpacity(0.5),
          //                 spreadRadius: 0,
          //                 blurRadius: 4,
          //                 offset: Offset(0, 4), // changes position of shadow
          //               ),
          //             ],
          //             color: Color(0xFFFCF8F7),
          //             borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ElevatedButton(onPressed: (){
                      
          //             },
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Color(0xFFFCF8F7),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15),
          //               )
          //             ), 
          //             child: Text("🧘‍♀️Mindfulness / Breathing",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF000000),
          //             ),),
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.85,
          //           height: MediaQuery.of(context).size.height * 0.07,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //               BoxShadow(
          //                 // ignore: deprecated_member_use
          //                 color: Color(0xFF3E64FF).withOpacity(0.5),
          //                 spreadRadius: 0,
          //                 blurRadius: 4,
          //                 offset: Offset(0, 4), // changes position of shadow
          //               ),
          //             ],
          //             color: Color(0xFFFCF8F7),
          //             borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ElevatedButton(onPressed: (){
                      
          //             },
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Color(0xFFFCF8F7),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15),
          //               )
          //             ), 
          //             child: Text("📓Mood Journal",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF000000),
          //             ),),
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.85,
          //           height: MediaQuery.of(context).size.height * 0.07,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //               BoxShadow(
          //                 // ignore: deprecated_member_use
          //                 color: Color(0xFF3E64FF).withOpacity(0.5),
          //                 spreadRadius: 0,
          //                 blurRadius: 4,
          //                 offset: Offset(0, 4), // changes position of shadow
          //               ),
          //             ],
          //             color: Color(0xFFFCF8F7),
          //             borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ElevatedButton(onPressed: (){
                      
          //             },
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Color(0xFFFCF8F7),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15),
          //               )
          //             ), 
          //             child: Text("🙌Gratitude Practice",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF000000),
          //             ),),
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 10),
          //         SizedBox(
          //           width: MediaQuery.of(context).size.width * 0.85,
          //           height: MediaQuery.of(context).size.height * 0.07,
          //           child: Container(
          //             decoration: BoxDecoration(
          //               boxShadow: [
          //               BoxShadow(
          //                 // ignore: deprecated_member_use
          //                 color: Color(0xFF3E64FF).withOpacity(0.5),
          //                 spreadRadius: 0,
          //                 blurRadius: 4,
          //                 offset: Offset(0, 4), // changes position of shadow
          //               ),
          //             ],
          //             color: Color(0xFFFCF8F7),
          //             borderRadius: BorderRadius.circular(15),
          //             ),
          //             child: ElevatedButton(onPressed: (){
                      
          //             },
          //             style: ElevatedButton.styleFrom(
          //               backgroundColor: Color(0xFFFCF8F7),
          //               shape: RoundedRectangleBorder(
          //                 borderRadius: BorderRadius.circular(15),
          //               )
          //             ), 
          //             child: Text("✨Daily Sparks of Motivation",
          //             style: TextStyle(
          //               fontSize: 18,
          //               fontWeight: FontWeight.bold,
          //               color: Color(0xFF000000),
          //             ),),
          //             ),
          //           ),
          //         ),
          //         SizedBox(height: 20),
          //     ],
          //   ),
          // ),
        ),
      ),
    );
  }
}