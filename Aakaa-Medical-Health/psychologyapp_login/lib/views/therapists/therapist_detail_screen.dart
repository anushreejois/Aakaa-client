import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import 'booking_screen.dart';

class TherapistDetailScreen extends StatefulWidget {
  final Therapist therapist;

  const TherapistDetailScreen({super.key, required this.therapist});

  @override
  State<TherapistDetailScreen> createState() => _TherapistDetailScreenState();
}

class _TherapistDetailScreenState extends State<TherapistDetailScreen> {
  ConsultationType _selectedType = ConsultationType.message;

  final Map<String, bool> _weeklyAvailability = {
    'Mon': true, 'Tue': true, 'Wed': true, 'Thu': true, 'Fri': true, 'Sat': false, 'Sun': false,
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient (Hero Header)
          Container(
            height: 300,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62)],
              ),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 200,
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 40),
                        Container(
                          width: 90,
                          height: 90,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            widget.therapist.initials,
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SliverToBoxAdapter(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFF7F5),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Column(
                            children: [
                              Text(
                                widget.therapist.name,
                                style: GoogleFonts.outfit(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: const Color(0xFF065643),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                widget.therapist.specialization,
                                style: GoogleFonts.outfit(
                                  fontSize: 14,
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Stats Row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(Icons.groups_rounded, "1.2k+", "Patients"),
                            _buildStatDivider(),
                            _buildStatItem(Icons.workspace_premium_rounded, "10 Yrs", "Exp."),
                            _buildStatDivider(),
                            _buildStatItem(Icons.star_rounded, "4.9", "Rating"),
                          ],
                        ),

                        const SizedBox(height: 40),

                        _buildSectionTitle("About Therapist"),
                        const SizedBox(height: 12),
                        Text(
                          "Dr. ${widget.therapist.name.split(' ').last} is a highly experienced clinical specialist dedicated to providing compassionate mental health support. With a focus on evidence-based practices, they help individuals navigate life's challenges and achieve emotional balance.",
                          style: GoogleFonts.outfit(
                            fontSize: 15,
                            color: Colors.grey[700],
                            height: 1.6,
                          ),
                        ),

                        const SizedBox(height: 32),

                        _buildSectionTitle("Availability"),
                        const SizedBox(height: 16),
                        _buildAvailabilityCalendar(),

                        const SizedBox(height: 32),

                        _buildSectionTitle("Consultation Type"),
                        const SizedBox(height: 16),
                        _buildConsultationTypeSelector(),

                        const SizedBox(height: 40),

                        // Action Button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BookingScreen(
                                    therapist: widget.therapist,
                                    consultationType: _selectedType,
                                  ),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF065643),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                            ),
                            child: Text(
                              "Book Appointment",
                              style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF065643),
      ),
    );
  }

  Widget _buildStatItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF065643), size: 24),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
        Text(label, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[500])),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 30, width: 1, color: Colors.grey[200]);
  }

  Widget _buildAvailabilityCalendar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withOpacity(0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weeklyAvailability.entries.map((entry) {
          return Column(
            children: [
              Text(entry.key, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[400], fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: entry.value ? const Color(0xFF065643).withOpacity(0.1) : Colors.grey[100],
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  entry.value ? Icons.check_rounded : Icons.close_rounded,
                  size: 16,
                  color: entry.value ? const Color(0xFF065643) : Colors.grey[400],
                ),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildConsultationTypeSelector() {
    return Column(
      children: [
        _buildConsultationOption(ConsultationType.message, "Messaging", Icons.chat_bubble_outline_rounded),
        const SizedBox(height: 12),
        _buildConsultationOption(ConsultationType.audio, "Audio Call", Icons.call_rounded),
        const SizedBox(height: 12),
        _buildConsultationOption(ConsultationType.video, "Video Call", Icons.videocam_rounded),
      ],
    );
  }

  Widget _buildConsultationOption(ConsultationType type, String title, IconData icon) {
    bool isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF065643) : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withOpacity(0.05),
          ),
        ),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? Colors.white : const Color(0xFF065643), size: 24),
            const SizedBox(width: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : const Color(0xFF065643),
              ),
            ),
            const Spacer(),
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_off_rounded,
              color: isSelected ? Colors.white : Colors.grey[300],
            ),
          ],
        ),
      ),
    );
  }
}
