import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import '../../widgets/zen_background.dart';
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
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 220,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 30),
                      Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.08),
                              blurRadius: 25,
                              offset: const Offset(0, 10),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05), width: 2),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          widget.therapist.initials,
                          style: GoogleFonts.outfit(
                            color: const Color(0xFF065643),
                            fontSize: 32,
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
                  color: Colors.transparent,
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
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF065643),
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              widget.therapist.specialization,
                              style: GoogleFonts.outfit(
                                fontSize: 15,
                                color: const Color(0xFF065643).withValues(alpha: 0.6),
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 36),

                      // Stats Row
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.06),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildStatItem(Icons.groups_rounded, "1.2k+", "Patients"),
                            _buildStatDivider(),
                            _buildStatItem(Icons.workspace_premium_rounded, "10 Yrs", "Exp."),
                            _buildStatDivider(),
                            _buildStatItem(Icons.star_rounded, "4.9", "Rating"),
                          ],
                        ),
                      ),

                      const SizedBox(height: 40),

                      _buildSectionTitle("About Therapist"),
                      const SizedBox(height: 12),
                      Text(
                        "Dr. ${widget.therapist.name.split(' ').last} is a highly experienced clinical specialist dedicated to providing compassionate mental health support. With a focus on evidence-based practices, they help individuals navigate life's challenges and achieve emotional balance.",
                        style: GoogleFonts.outfit(
                          fontSize: 15,
                          color: const Color(0xFF065643).withValues(alpha: 0.7),
                          height: 1.6,
                        ),
                      ),

                      const SizedBox(height: 36),

                      _buildSectionTitle("Availability"),
                      const SizedBox(height: 16),
                      _buildAvailabilityCalendar(),

                      const SizedBox(height: 36),

                      _buildSectionTitle("Consultation Type"),
                      const SizedBox(height: 16),
                      _buildConsultationTypeSelector(),

                      const SizedBox(height: 48),

                      // Action Button
                      Container(
                        width: double.infinity,
                        height: 60,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF065643).withValues(alpha: 0.25),
                              blurRadius: 15,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageRouteBuilder(
                                transitionDuration: const Duration(milliseconds: 300),
                                pageBuilder: (context, animation, secondaryAnimation) => BookingScreen(
                                  therapist: widget.therapist,
                                  consultationType: _selectedType,
                                ),
                                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                  return FadeTransition(opacity: animation, child: child);
                                },
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          child: Text(
                            "Book Appointment",
                            style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(height: 60),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
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
        Icon(icon, color: const Color(0xFF0A7D62), size: 26),
        const SizedBox(height: 8),
        Text(value, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF065643))),
        Text(label, style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF065643).withValues(alpha: 0.5))),
      ],
    );
  }

  Widget _buildStatDivider() {
    return Container(height: 36, width: 1, color: const Color(0xFF065643).withValues(alpha: 0.1));
  }

  Widget _buildAvailabilityCalendar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: _weeklyAvailability.entries.map((entry) {
          return Column(
            children: [
              Text(entry.key, style: GoogleFonts.outfit(fontSize: 12, color: const Color(0xFF065643).withValues(alpha: 0.5), fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: entry.value ? const Color(0xFF065643).withValues(alpha: 0.1) : Colors.grey[100],
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
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          gradient: isSelected 
            ? const LinearGradient(
                colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xFF065643).withValues(alpha: 0.2) : const Color(0xFF065643).withValues(alpha: 0.06),
              blurRadius: isSelected ? 15 : 15,
              offset: isSelected ? const Offset(0, 6) : const Offset(0, 6),
            ),
          ],
          border: Border.all(
            color: isSelected ? Colors.transparent : const Color(0xFF065643).withValues(alpha: 0.05),
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
