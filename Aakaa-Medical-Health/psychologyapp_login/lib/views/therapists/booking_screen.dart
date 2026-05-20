import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import '../../widgets/zen_background.dart';
import 'payment_screen.dart';

class BookingScreen extends StatefulWidget {
  final Therapist therapist;
  final ConsultationType consultationType;

  const BookingScreen({
    super.key,
    required this.therapist,
    required this.consultationType,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  DateTime _selectedDate = DateTime.now();
  int _selectedTimeIndex = -1;
  String _selectedGender = 'Male';
  bool _acceptedTerms = false;
  bool _isLoading = false;

  final _nameController = TextEditingController();
  final _problemController = TextEditingController();

  final List<String> _times = [
    '09:00 AM', '09:30 AM', '10:00 AM', '10:30 AM',
    '12:00 PM', '12:30 PM', '01:30 PM', '02:00 PM',
    '03:00 PM', '04:30 PM', '05:00 PM', '05:30 PM',
  ];

  List<String> get _availableTimes {
    final now = DateTime.now();
    if (_selectedDate.year == now.year &&
        _selectedDate.month == now.month &&
        _selectedDate.day == now.day) {
      return _times.where((time) {
        final parts = time.split(' ');
        final hm = parts[0].split(':');
        int hour = int.parse(hm[0]);
        int minute = int.parse(hm[1]);
        if (parts[1] == 'PM' && hour != 12) hour += 12;
        if (parts[1] == 'AM' && hour == 12) hour = 0;
        
        if (hour > now.hour) return true;
        if (hour == now.hour && minute > (now.minute + 30)) return true; // Give 30 min buffer
        return false;
      }).toList();
    }
    return _times;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _problemController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pinned: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                title: Text(
                  "Book Appointment",
                  style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold, fontSize: 22),
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
                      _buildTherapistBrief(),
                      const SizedBox(height: 36),

                      _buildSectionTitle("Select Date"),
                      const SizedBox(height: 16),
                      _buildCalendarPicker(),

                      const SizedBox(height: 36),

                      _buildSectionTitle("Available Time"),
                      const SizedBox(height: 16),
                      _buildTimeGrid(),

                      const SizedBox(height: 36),

                      _buildSectionTitle("Patient Details"),
                      const SizedBox(height: 16),
                      _buildPremiumTextField("Full Name", "Enter your name", _nameController),
                      const SizedBox(height: 24),
                      _buildGenderSelector(),
                      const SizedBox(height: 24),
                      _buildPremiumTextField("Describe Problem", "How can we help you?", _problemController, maxLines: 4),

                      const SizedBox(height: 28),
                      _buildTermsCheckbox(),

                      const SizedBox(height: 48),

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
                          onPressed: _handleBookingButton,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            elevation: 0,
                          ),
                          child: _isLoading 
                            ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2.5))
                            : Text("Proceed to Payment", style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
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

  void _handleBookingButton() {
    if (_selectedTimeIndex == -1) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please select an available time for your session.", style: GoogleFonts.outfit(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please agree to the terms and privacy policy to proceed.", style: GoogleFonts.outfit(color: Colors.white)),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    _handleBooking();
  }

  void _handleBooking() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        PageRouteBuilder(
          transitionDuration: const Duration(milliseconds: 300),
          pageBuilder: (context, animation, secondaryAnimation) => PaymentScreen(
            therapist: widget.therapist,
            consultationType: widget.consultationType,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(opacity: animation, child: child);
          },
        ),
      );
    }
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643)));
  }

  Widget _buildTherapistBrief() {
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
        children: [
          Container(
            width: 56, height: 56,
            decoration: BoxDecoration(color: const Color(0xFF065643).withValues(alpha: 0.1), borderRadius: BorderRadius.circular(16)),
            alignment: Alignment.center,
            child: Text(widget.therapist.initials, style: GoogleFonts.outfit(fontSize: 20, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.therapist.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF065643))),
                const SizedBox(height: 4),
                Text(widget.therapist.specialization, style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF065643).withValues(alpha: 0.6))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarPicker() {
    return GestureDetector(
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context,
          initialDate: _selectedDate,
          firstDate: DateTime.now(),
          lastDate: DateTime.now().add(const Duration(days: 30)),
        );
        if (picked != null) {
          setState(() {
            _selectedDate = picked;
            _selectedTimeIndex = -1; // Reset selection on date change
          });
        }
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white, 
          borderRadius: BorderRadius.circular(20), 
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
          children: [
            const Icon(Icons.calendar_today_rounded, color: Color(0xFF065643), size: 22),
            const SizedBox(width: 16),
            Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.w600, color: const Color(0xFF065643))),
            const Spacer(),
            Icon(Icons.keyboard_arrow_down_rounded, color: const Color(0xFF065643).withValues(alpha: 0.5)),
          ],
        ),
      ),
    );
  }

  Widget _buildTimeGrid() {
    final availableTimes = _availableTimes;
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 12, crossAxisSpacing: 12, childAspectRatio: 2.2),
      itemCount: availableTimes.length,
      itemBuilder: (context, index) {
        bool selected = _selectedTimeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              gradient: selected 
                ? const LinearGradient(
                    colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                  )
                : null,
              color: selected ? null : Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: selected ? const Color(0xFF065643).withValues(alpha: 0.25) : const Color(0xFF065643).withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
              border: Border.all(color: selected ? Colors.transparent : const Color(0xFF065643).withValues(alpha: 0.05)),
            ),
            alignment: Alignment.center,
            child: Text(availableTimes[index], style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF065643))),
          ),
        );
      },
    );
  }

  Widget _buildPremiumTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: const Color(0xFF065643).withValues(alpha: 0.6))),
        const SizedBox(height: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF065643).withValues(alpha: 0.04),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
            border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
          ),
          child: TextField(
            controller: controller,
            maxLines: maxLines,
            style: GoogleFonts.outfit(color: const Color(0xFF065643), fontSize: 16),
            decoration: InputDecoration(
              hintText: hint,
              hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4), fontSize: 15),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.all(20),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _genderTile("Male"),
        const SizedBox(width: 16),
        _genderTile("Female"),
      ],
    );
  }

  Widget _genderTile(String gender) {
    bool selected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            gradient: selected 
              ? const LinearGradient(
                  colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                )
              : null,
            color: selected ? null : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: selected ? const Color(0xFF065643).withValues(alpha: 0.25) : const Color(0xFF065643).withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: selected ? Colors.transparent : const Color(0xFF065643).withValues(alpha: 0.05)),
          ),
          alignment: Alignment.center,
          child: Text(gender, style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF065643))),
        ),
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return Row(
      children: [
        Checkbox(
          value: _acceptedTerms,
          activeColor: const Color(0xFF065643),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          side: BorderSide(color: const Color(0xFF065643).withValues(alpha: 0.3), width: 1.5),
          onChanged: (v) => setState(() => _acceptedTerms = v!),
        ),
        Expanded(child: Text("I agree to the terms and privacy policy.", style: GoogleFonts.outfit(fontSize: 14, color: const Color(0xFF065643).withValues(alpha: 0.7)))),
      ],
    );
  }
}
