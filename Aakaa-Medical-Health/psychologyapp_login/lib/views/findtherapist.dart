import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:psychologyapp_login/widgets/zen_background.dart';
import 'package:psychologyapp_login/models/therapist_model.dart';
import 'package:psychologyapp_login/views/therapists/therapist_detail_screen.dart';

class FindTherapist extends StatefulWidget {
  final String? selectedTag;
  const FindTherapist({super.key, this.selectedTag});

  @override
  State<FindTherapist> createState() => _FindTherapistState();
}

class _FindTherapistState extends State<FindTherapist> {
  final List<Map<String, dynamic>> _therapists = [
    {
      "name": "Dr. Sarah Chen",
      "specialty": "Cognitive Behavioral Therapy",
      "rating": 4.9,
      "reviews": 124,
      "experience": "12 years",
      "avatar": "https://images.unsplash.com/photo-1559839734-2b71ea197ec2?w=400&h=400&fit=crop",
      "tags": ["Anxiety", "Depression", "CBT"],
    },
    {
      "name": "Dr. Marcus Thorne",
      "specialty": "Sleep & Wellness Specialist",
      "rating": 4.8,
      "reviews": 89,
      "experience": "8 years",
      "avatar": "https://images.unsplash.com/photo-1622253692010-333f2da6031d?w=400&h=400&fit=crop",
      "tags": ["Insomnia", "Stress", "Meditation"],
    },
    {
      "name": "Elena Rodriguez",
      "specialty": "Mindfulness Coach",
      "rating": 5.0,
      "reviews": 210,
      "experience": "15 years",
      "avatar": "https://images.unsplash.com/photo-1594824476967-48c8b964273f?w=400&h=400&fit=crop",
      "tags": ["Mindfulness", "Life Coaching", "Zen"],
    },
  ];

  List<Map<String, dynamic>> _filteredTherapists = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredTherapists = _therapists;
    
    // Set initial filtering if a tag was passed (e.g. from screening quizzes or specific detail pages)
    if (widget.selectedTag != null && widget.selectedTag!.isNotEmpty) {
      _searchController.text = widget.selectedTag!;
    }
    
    _searchController.addListener(_filterTherapists);
    _filterTherapists();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTherapists() {
    final query = _searchController.text.toLowerCase().trim();
    setState(() {
      if (query.isEmpty) {
        _filteredTherapists = _therapists;
      } else {
        _filteredTherapists = _therapists.where((t) {
          final name = t['name'].toString().toLowerCase();
          final specialty = t['specialty'].toString().toLowerCase();
          final tags = (t['tags'] as List).map((e) => e.toString().toLowerCase()).toList();
          return name.contains(query) || 
                 specialty.contains(query) || 
                 tags.any((tag) => tag.contains(query));
        }).toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ZenBackground(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 120.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                centerTitle: false,
                title: Text(
                  "Find Therapists",
                  style: GoogleFonts.outfit(
                    color: const Color(0xFF065643),
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
                    _buildPremiumSearchBar(),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),

            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              sliver: _filteredTherapists.isEmpty
                  ? SliverToBoxAdapter(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            "No matching specialists found.",
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF065643).withValues(alpha: 0.5),
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildTherapistCard(_filteredTherapists[index]),
                        childCount: _filteredTherapists.length,
                      ),
                    ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 120)),
          ],
        ),
      ),
    );
  }

  Widget _buildPremiumSearchBar() {
    return Container(
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: TextField(
        controller: _searchController,
        style: GoogleFonts.outfit(color: const Color(0xFF065643), fontWeight: FontWeight.w600),
        cursorColor: const Color(0xFF065643),
        decoration: InputDecoration(
          hintText: "Search specialists...",
          hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4), fontSize: 15),
          prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF065643), size: 22),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, color: Color(0xFF065643), size: 20),
                  onPressed: () => _searchController.clear(),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 18),
        ),
      ),
    );
  }

  Widget _buildTherapistCard(Map<String, dynamic> therapist) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 300),
            pageBuilder: (context, animation, secondaryAnimation) => TherapistDetailScreen(
              therapist: Therapist(
                name: therapist['name'],
                specialization: therapist['specialty'],
                rating: therapist['rating'].toDouble(),
                reviews: therapist['reviews'],
                isOnline: true,
                initials: therapist['name'].split(' ').last[0],
                imageUrl: therapist['avatar'],
              ),
            ),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              return FadeTransition(opacity: animation, child: child);
            },
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.08)),
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 15, offset: const Offset(0, 5))],
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 35,
                    backgroundImage: NetworkImage(therapist['avatar']),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          therapist['name'],
                          style: GoogleFonts.outfit(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF065643),
                          ),
                        ),
                        Text(
                          therapist['specialty'],
                          style: GoogleFonts.outfit(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 18),
                            const SizedBox(width: 4),
                            Text(
                              "${therapist['rating']} (${therapist['reviews']} reviews)",
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                color: Colors.grey[700],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF065643).withValues(alpha: 0.03),
                borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: (therapist['tags'] as List).map((tag) => Container(
                      margin: const EdgeInsets.only(right: 8),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF065643).withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        tag,
                        style: GoogleFonts.outfit(fontSize: 11, color: const Color(0xFF065643)),
                      ),
                    )).toList(),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, color: Colors.grey[400], size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
