import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'therapists/session_hub.dart';
import '../models/session_model.dart';
import '../models/consultation_type.dart';
import '../controllers/session_controller.dart';

class ClientMySession extends StatefulWidget {
  const ClientMySession({super.key});

  @override
  State<ClientMySession> createState() => _ClientMySessionState();
}

class _ClientMySessionState extends State<ClientMySession>{
  int _selectedTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF065643),
                  Color(0xFF0A7D62),
                  Color(0xFF065643),
                ],
              ),
            ),
          ),
          
          // Decorative Circles
          Positioned(
            top: -50,
            right: -100,
            child: CircleAvatar(
              radius: 150,
              backgroundColor: Colors.white.withOpacity(0.03),
            ),
          ),

          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // AppBar
              SliverAppBar(
                expandedHeight: 120.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  centerTitle: false,
                  title: Text(
                    "My Sessions",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      
                      // Refined Segmented Control
                      _buildSegmentedControl(),
                      
                      const SizedBox(height: 32),
                      
                      // Session List
                      _selectedTabIndex == 0 
                        ? _buildUpcomingSessions()
                        : _buildPastSessions(),
                        
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          _buildSegmentTile(0, "Upcoming"),
          _buildSegmentTile(1, "History"),
        ],
      ),
    );
  }

  Widget _buildSegmentTile(int index, String label) {
    bool isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: GoogleFonts.outfit(
              color: isSelected ? const Color(0xFF065643) : Colors.white.withOpacity(0.6),
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUpcomingSessions() {
    if (SessionController.upcomingSessions.isEmpty) return _buildEmptyState();
    return Column(
      children: SessionController.upcomingSessions.map((session) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _buildSessionCard(
            therapistName: session.therapistName,
            date: "${session.startTime.day}/${session.startTime.month}/${session.startTime.year}",
            time: "${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')}",
            status: "Confirmed",
            isUpcoming: true,
            initials: session.therapistInitials,
            type: session.consultationType,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildPastSessions() {
    if (SessionController.pastSessions.isEmpty) return _buildEmptyState();
    return Column(
      children: SessionController.pastSessions.map((session) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 20.0),
          child: _buildSessionCard(
            therapistName: session.therapistName,
            date: "${session.startTime.day}/${session.startTime.month}/${session.startTime.year}",
            time: "${session.startTime.hour}:${session.startTime.minute.toString().padLeft(2, '0')}",
            status: "Completed",
            isUpcoming: false,
            initials: session.therapistInitials,
            type: session.consultationType,
          ),
        );
      }).toList(),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 60),
          Icon(Icons.calendar_today_rounded, size: 60, color: Colors.white.withOpacity(0.1)),
          const SizedBox(height: 16),
          Text(
            "No sessions found.",
            style: GoogleFonts.outfit(color: Colors.white.withOpacity(0.4)),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required String therapistName,
    required String date,
    required String time,
    required String status,
    required bool isUpcoming,
    required String initials,
    required ConsultationType type,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    initials,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        therapistName,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      Text(
                        "Clinical Specialist",
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey[500],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(status).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    status.toUpperCase(),
                    style: GoogleFonts.outfit(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: _getStatusColor(status),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(height: 1, color: Colors.grey[100]),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildInfoRow(Icons.calendar_today_rounded, date),
                _buildInfoRow(Icons.access_time_rounded, time),
              ],
            ),
            if (isUpcoming) ...[
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(color: const Color(0xFF065643).withOpacity(0.1)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                      ),
                      child: Text(
                        "Reschedule",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context, 
                          MaterialPageRoute(
                            builder: (context) => SessionHub(
                              session: TherapySession(
                                id: "123",
                                therapistName: therapistName,
                                therapistInitials: initials,
                                startTime: DateTime.now(),
                                endTime: DateTime.now().add(const Duration(minutes: 45)),
                                consultationType: type,
                              ),
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        backgroundColor: const Color(0xFF065643),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        elevation: 0,
                      ),
                      child: Text(
                        "Join Call",
                        style: GoogleFonts.outfit(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF065643).withOpacity(0.3)),
        const SizedBox(width: 8),
        Text(
          text,
          style: GoogleFonts.outfit(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF065643).withOpacity(0.7),
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Confirmed": return const Color(0xFF0A7D62);
      case "Pending": return Colors.orange;
      case "Completed": return Colors.grey;
      default: return Colors.grey;
    }
  }
}
