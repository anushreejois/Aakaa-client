import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/therapist_model.dart';
import '../../models/consultation_type.dart';
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
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTherapistBrief(),
            const SizedBox(height: 32),
            Text("Payment Method", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
            const SizedBox(height: 16),
            _buildPaymentMethod(PaymentMethod.upi, "UPI", "Google Pay, PhonePe, Paytm", Icons.qr_code_rounded),
            _buildPaymentMethod(PaymentMethod.card, "Credit / Debit Card", "Visa, Mastercard, RuPay", Icons.credit_card_rounded),
            _buildPaymentMethod(PaymentMethod.wallet, "Digital Wallet", "Amazon Pay, Mobikwik", Icons.account_balance_wallet_rounded),
            const SizedBox(height: 32),
            _buildAddon(),
            const SizedBox(height: 32),
            _buildOrderSummary(basePrice, totalPrice),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildTherapistBrief() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 20)],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF065643).withOpacity(0.1),
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
                Text(widget.therapist.name, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 16)),
                Text(_getTypeLabel(), style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 13)),
              ],
            ),
          ),
          Text("₹${_getBasePrice()}", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 18, color: const Color(0xFF065643))),
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
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? const Color(0xFF065643) : Colors.transparent, width: 2),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: const Color(0xFF065643).withOpacity(0.05), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: const Color(0xFF065643), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 15)),
                  Text(subtitle, style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 12)),
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
        gradient: LinearGradient(colors: [const Color(0xFF065643).withOpacity(0.05), Colors.white]),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF065643).withOpacity(0.1)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: Color(0xFF065643)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Extend Session", style: GoogleFonts.outfit(fontWeight: FontWeight.bold)),
                Text("Add 30 extra minutes", style: GoogleFonts.outfit(color: Colors.grey[500], fontSize: 12)),
              ],
            ),
          ),
          Text("+₹$_extraPrice", style: GoogleFonts.outfit(fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
          const SizedBox(width: 12),
          Switch(
            value: _addExtraTime,
            activeColor: const Color(0xFF065643),
            onChanged: (v) => setState(() => _addExtraTime = v),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderSummary(int base, int total) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Summary", style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF065643))),
        const SizedBox(height: 16),
        _summaryRow("Consultation Fee", "₹$base"),
        if (_addExtraTime) _summaryRow("Extended Time", "₹$_extraPrice"),
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 12.0),
          child: Divider(),
        ),
        _summaryRow("Total Amount", "₹$total", isBold: true),
      ],
    );
  }

  Widget _summaryRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: GoogleFonts.outfit(color: isBold ? const Color(0xFF065643) : Colors.grey[600], fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.bold, fontSize: isBold ? 18 : 14)),
        ],
      ),
    );
  }

  Widget _buildPayButton(int total) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: SafeArea(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => PaymentSuccessScreen(therapist: widget.therapist, consultationType: widget.consultationType)),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF065643),
            minimumSize: const Size(double.infinity, 60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          ),
          child: Text("Pay ₹$total", style: GoogleFonts.outfit(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }
}
