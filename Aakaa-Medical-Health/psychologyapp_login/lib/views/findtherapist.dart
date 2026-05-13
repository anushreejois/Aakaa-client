import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'therapists/therapist_detail_screen.dart';
import '../models/therapist_model.dart';

class FindTherapist extends StatefulWidget {
  const FindTherapist({super.key});

  @override
  State<FindTherapist> createState() => _FindTherapistState();
}

class _FindTherapistState extends State<FindTherapist> {
  String _selectedCategory = "All";
  final List<String> _categories = ["All", "Anxiety", "Depression", "Relationships", "Stress", "Trauma"];

  final List<Therapist> _therapists = [
    Therapist(
      name: "Dr. Sarah Johnson",
      specialization: "Clinical Psychologist",
      rating: 4.9,
      reviews: 124,
      isOnline: true,
      initials: "SJ",
    ),
    Therapist(
      name: "Dr. Michael Chen",
      specialization: "CBT Specialist",
      rating: 4.8,
      reviews: 89,
      isOnline: true,
      initials: "MC",
    ),
    Therapist(
      name: "Dr. Emily White",
      specialization: "Relationship Counselor",
      rating: 4.7,
      reviews: 56,
      isOnline: false,
      initials: "EW",
    ),
    Therapist(
      name: "Dr. David Miller",
      specialization: "Child Psychologist",
      rating: 4.9,
      reviews: 210,
      isOnline: true,
      initials: "DM",
    ),
  ];

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
                    "Find Specialist",
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 24,
                    ),
                  ),
                ),
              ),

              // Search and Filters
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),
                      _buildPremiumSearchBar(),
                      const SizedBox(height: 24),
                      _buildCategoryFilters(),
                      const SizedBox(height: 32),
                      Text(
                        "Available Specialists",
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white.withOpacity(0.9),
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // Therapist List
              SliverPadding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final therapist = _therapists[index];
                      return _buildTherapistCard(therapist);
                    },
                    childCount: _therapists.length,
                  ),
                ),
              ),
              
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: TextField(
        style: GoogleFonts.outfit(color: Colors.white),
        decoration: InputDecoration(
          hintText: "Search specialists...",
          hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.4), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Colors.white70, size: 22),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildCategoryFilters() {
    return SizedBox(
      height: 38,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedCategory == _categories[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = _categories[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? Colors.white : Colors.white.withOpacity(0.1)),
              ),
              alignment: Alignment.center,
              child: Text(
                _categories[index],
                style: GoogleFonts.outfit(
                  color: isSelected ? const Color(0xFF065643) : Colors.white70,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTherapistCard(Therapist therapist) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
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
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 64,
                  height: 64,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    therapist.initials,
                    style: GoogleFonts.outfit(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        therapist.name,
                        style: GoogleFonts.outfit(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF065643),
                        ),
                      ),
                      Text(
                        therapist.specialization,
                        style: GoogleFonts.outfit(
                          fontSize: 13,
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                          const SizedBox(width: 4),
                          Text(
                            therapist.rating.toString(),
                            style: GoogleFonts.outfit(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF065643),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Icon(Icons.history_rounded, color: Colors.grey[400], size: 16),
                          const SizedBox(width: 4),
                          Text(
                            "10+ Years",
                            style: GoogleFonts.outfit(
                              fontSize: 12,
                              color: Colors.grey[500],
                            ),
                          ),
                        ],
                      ),
                    ],
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
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Session Fee",
                      style: GoogleFonts.outfit(fontSize: 11, color: Colors.grey[500]),
                    ),
                    Text(
                      "₹1200",
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF065643),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => TherapistDetailScreen(therapist: therapist),
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF065643),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    "Book Now",
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
