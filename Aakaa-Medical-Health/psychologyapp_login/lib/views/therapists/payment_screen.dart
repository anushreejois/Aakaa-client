import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
import '../../widgets/zen_background.dart';
import 'payment_success_screen.dart';

enum PaymentMethod { upi, card, wallet }

class PaymentScreen extends StatefulWidget {
  final Therapist therapist;
  final ConsultationType consultationType;

  const PaymentScreen({
    super.key,
    required this.therapist,
    required this.consultationType,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selectedMethod = PaymentMethod.upi;
  bool _addExtraTime = false;
  final int _extraPrice = 250;

  int _getBasePrice() {
    switch (widget.consultationType) {
      case ConsultationType.message: return 499;
      case ConsultationType.audio: return 799;
      case ConsultationType.video: return 999;
    }
  }

  @override
  Widget build(BuildContext context) {
    int basePrice = _getBasePrice();
    int totalPrice = basePrice + (_addExtraTime ? _extraPrice : 0);

    return Scaffold(
      backgroundColor: const Color(0xFFFFF7F5),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          "Checkout",
          style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: _buildPayButton(totalPrice),
      body: ZenBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTherapistBrief(),
              const SizedBox(height: 36),
              Text("Payment Method", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
              const SizedBox(height: 16),
              _buildPaymentMethod(PaymentMethod.upi, "UPI", "Google Pay, PhonePe, Paytm", Icons.qr_code_rounded),
              _buildPaymentMethod(PaymentMethod.card, "Credit / Debit Card", "Visa, Mastercard, RuPay", Icons.credit_card_rounded),
              _buildPaymentMethod(PaymentMethod.wallet, "Digital Wallet", "Amazon Pay, Mobikwik", Icons.account_balance_wallet_rounded),
              const SizedBox(height: 36),
              _buildAddon(),
              const SizedBox(height: 36),
              _buildOrderSummary(basePrice, totalPrice),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
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
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF065643).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(16),
            ),
            alignment: Alignment.center,
            child: Text(
              widget.therapist.name.split(' ').last[0],
              style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold, fontSize: 20),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.therapist.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF065643))),
                const SizedBox(height: 4),
                Text(_getTypeLabel(), style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 14)),
              ],
            ),
          ),
          Text("₹${_getBasePrice()}", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 20, color: const Color(0xFF065643))),
        ],
      ),
    );
  }

  String _getTypeLabel() {
    switch (widget.consultationType) {
      case ConsultationType.message: return "Messaging Session";
      case ConsultationType.audio: return "Audio Call Session";
      case ConsultationType.video: return "Video Call Session";
    }
  }

  Widget _buildPaymentMethod(PaymentMethod method, String title, String subtitle, IconData icon) {
    bool isSelected = _selectedMethod == method;
    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = method),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.05), width: 2),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF065643).withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: const Color(0xFF065643).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
              child: Icon(icon, color: const Color(0xFF065643), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
                  const SizedBox(height: 2),
                  Text(subtitle, style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 13)),
                ],
              ),
            ),
            Icon(isSelected ? Icons.check_circle_rounded : Icons.radio_button_off_rounded, color: isSelected ? const Color(0xFF065643) : Colors.grey[300]),
          ],
        ),
      ),
    );
  }

  Widget _buildAddon() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.1), width: _addExtraTime ? 2 : 1),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFF065643).withValues(alpha: 0.08), borderRadius: BorderRadius.circular(14)),
            child: const Icon(Icons.timer_outlined, color: Color(0xFF065643)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Extend Session", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
                const SizedBox(height: 2),
                Text("Add 30 extra minutes", style: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.6), fontSize: 13)),
              ],
            ),
          ),
          Text("+₹$_extraPrice", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16, color: const Color(0xFF065643))),
          const SizedBox(width: 12),
          Switch(
            value: _addExtraTime,
            activeThumbColor: const Color(0xFF065643),
            activeTrackColor: const Color(0xFF065643).withValues(alpha: 0.3),
            onChanged: (v) => setState(() => _addExtraTime = v),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(int base, int total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Summary", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
          const SizedBox(height: 20),
          _summaryRow("Consultation Fee", "₹$base"),
          if (_addExtraTime) _summaryRow("Extended Time", "₹$_extraPrice"),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Divider(color: const Color(0xFF065643).withValues(alpha: 0.1)),
          ),
          _summaryRow("Total Amount", "₹$total", isBold: true),
        ],
      ),
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: isBold ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.7), fontWeight: isBold ? FontWeight.bold : FontWeight.w500, fontSize: isBold ? 18 : 15)),
          Text(value, style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold, fontSize: isBold ? 20 : 16)),
        ],
      ),
    );
  }

  Widget _buildPayButton(int total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.08), 
            blurRadius: 20, 
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Container(
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
              Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                  transitionDuration: const Duration(milliseconds: 300),
                  pageBuilder: (context, animation, secondaryAnimation) => PaymentSuccessScreen(
                    therapist: widget.therapist, 
                    consultationType: widget.consultationType
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
            child: Text("Pay ₹$total", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
          ),
        ),
      ),
    );
  }
}
