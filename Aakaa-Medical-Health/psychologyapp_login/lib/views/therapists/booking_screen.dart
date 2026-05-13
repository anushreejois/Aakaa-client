import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
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
      body: Stack(
        children: [
          // Header Gradient
          Container(
            height: 220,
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
                expandedHeight: 120,
                backgroundColor: Colors.transparent,
                elevation: 0,
                pinned: true,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Book Appointment",
                    style: GoogleFonts.outfit(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
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
                        _buildTherapistBrief(),
                        const SizedBox(height: 32),

                        _buildSectionTitle("Select Date"),
                        const SizedBox(height: 16),
                        _buildCalendarPicker(),

                        const SizedBox(height: 32),

                        _buildSectionTitle("Available Time"),
                        const SizedBox(height: 16),
                        _buildTimeGrid(),

                        const SizedBox(height: 32),

                        _buildSectionTitle("Patient Details"),
                        const SizedBox(height: 16),
                        _buildPremiumTextField("Full Name", "Enter your name", _nameController),
                        const SizedBox(height: 20),
                        _buildGenderSelector(),
                        const SizedBox(height: 20),
                        _buildPremiumTextField("Describe Problem", "How can we help you?", _problemController, maxLines: 4),

                        const SizedBox(height: 24),
                        _buildTermsCheckbox(),

                        const SizedBox(height: 40),

                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: (_acceptedTerms && _selectedTimeIndex != -1) ? _handleBooking : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF065643),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 18),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                              elevation: 0,
                              disabledBackgroundColor: Colors.grey[300],
                            ),
                            child: _isLoading 
                              ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text("Proceed to Payment", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
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
        ],
      ),
    );
  }

  void _handleBooking() async {
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (mounted) {
      setState(() => _isLoading = false);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentScreen(
            therapist: widget.therapist,
            consultationType: widget.consultationType,
          ),
        ),
      );
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(32)),
        child: Container(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: const Color(0xFF065643).withOpacity(0.1), shape: BoxShape.circle),
                child: const Icon(Icons.check_circle_rounded, color: Color(0xFF065643), size: 60),
              ),
              const SizedBox(height: 24),
              Text("Appointment Set!", style: GoogleFonts.outfit(fontSize: 22, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
              const SizedBox(height: 12),
              Text("Your session with ${widget.therapist.name} is confirmed for ${_times[_selectedTimeIndex]}.", textAlign: TextAlign.center, style: GoogleFonts.outfit(color: Colors.grey[600])),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog
                    Navigator.of(context).pop(); // Exit BookingScreen
                    Navigator.of(context).pop(); // Exit TherapistDetailScreen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065643),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  ),
                  child: Text("Back to Home", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(title, style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643)));
  }

  Widget _buildTherapistBrief() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withOpacity(0.05)),
      ),
      child: Row(
        children: [
          Container(
            width: 50, height: 50,
            decoration: BoxDecoration(color: const Color(0xFF065643).withOpacity(0.1), borderRadius: BorderRadius.circular(14)),
            alignment: Alignment.center,
            child: Text(widget.therapist.initials, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.therapist.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
              Text(widget.therapist.specialization, style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey[600])),
            ],
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
        if (picked != null) setState(() {
          _selectedDate = picked;
          _selectedTimeIndex = -1; // Reset selection on date change
        });
      },
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: const Color(0xFF065643).withOpacity(0.05))),
        child: Row(
          children: [
            const Icon(Icons.calendar_today_rounded, color: Color(0xFF065643), size: 20),
            const SizedBox(width: 16),
            Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}", style: GoogleFonts.outfit(fontWeight: FontWeight.w600, color: const Color(0xFF065643))),
            const Spacer(),
            const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF065643)),
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
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3, mainAxisSpacing: 10, crossAxisSpacing: 10, childAspectRatio: 2.5),
      itemCount: availableTimes.length,
      itemBuilder: (context, index) {
        bool selected = _selectedTimeIndex == index;
        return GestureDetector(
          onTap: () => setState(() => _selectedTimeIndex = index),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: selected ? const Color(0xFF065643) : Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: selected ? const Color(0xFF065643) : const Color(0xFF065643).withOpacity(0.05)),
            ),
            alignment: Alignment.center,
            child: Text(availableTimes[index], style: GoogleFonts.outfit(fontSize: 13, fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF065643))),
          ),
        );
      },
    );
  }

  Widget _buildPremiumTextField(String label, String hint, TextEditingController controller, {int maxLines = 1}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: GoogleFonts.outfit(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[600])),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: GoogleFonts.outfit(color: Colors.grey[400], fontSize: 14),
            fillColor: Colors.white,
            filled: true,
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(16), borderSide: BorderSide.none),
            contentPadding: const EdgeInsets.all(18),
          ),
        ),
      ],
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      children: [
        _genderTile("Male"),
        const SizedBox(width: 12),
        _genderTile("Female"),
      ],
    );
  }

  Widget _genderTile(String gender) {
    bool selected = _selectedGender == gender;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedGender = gender),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFF065643) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? const Color(0xFF065643) : const Color(0xFF065643).withOpacity(0.05)),
          ),
          alignment: Alignment.center,
          child: Text(gender, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: selected ? Colors.white : const Color(0xFF065643))),
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
          onChanged: (v) => setState(() => _acceptedTerms = v!),
        ),
        Expanded(child: Text("I agree to the terms and privacy policy.", style: GoogleFonts.outfit(fontSize: 13, color: Colors.grey[600]))),
      ],
    );
  }
}
