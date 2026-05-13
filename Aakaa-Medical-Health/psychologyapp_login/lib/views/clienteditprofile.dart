import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfile extends StatefulWidget {
  final String? currentAvatar;
  const EditProfile({super.key, this.currentAvatar});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

enum Gender { male, female, other }

class _EditProfileState extends State<EditProfile> {
  String _selectedAvatar = "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop"; 
  Gender? _selectedGender;
  final GlobalKey<FormState> _editProfileFormKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();

  // Premium Human Avatars
  final List<String> _avatars = [
    "https://images.unsplash.com/photo-1544005313-94ddf0286df2?w=400&h=400&fit=crop",
    "https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=400&h=400&fit=crop",
    "https://images.unsplash.com/photo-1531123897727-8f129e1688ce?w=400&h=400&fit=crop",
    "https://images.unsplash.com/photo-1552058544-f2b08422138a?w=400&h=400&fit=crop",
    "https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=400&h=400&fit=crop",
    "https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400&h=400&fit=crop",
  ];

  @override
  void initState() {
    super.initState();
    if (widget.currentAvatar != null && widget.currentAvatar!.startsWith("http")) {
      _selectedAvatar = widget.currentAvatar!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Premium Deep Green Gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF065643), Color(0xFF0A7D62), Color(0xFF065643)],
              ),
            ),
          ),
          
          CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              SliverAppBar(
                expandedHeight: 140.0,
                floating: false,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                  onPressed: () => Navigator.pop(context, _selectedAvatar),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  centerTitle: false,
                  title: Text(
                    "Edit Profile",
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
                  child: Form(
                    key: _editProfileFormKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 32),
                        
                        // Selected Avatar Preview
                        Center(child: _buildAvatarPreview()),
                        
                        const SizedBox(height: 48),
                        
                        _buildSectionLabel("Choose your Identity"),
                        const SizedBox(height: 16),
                        
                        _buildAvatarGrid(),
                        
                        const SizedBox(height: 40),
                        
                        _buildSectionLabel("Personal Information"),
                        const SizedBox(height: 16),
                        _buildTextField("First Name", _firstNameController, Icons.person_outline_rounded),
                        const SizedBox(height: 16),
                        _buildTextField("Last Name", _lastNameController, Icons.person_outline_rounded),
                        
                        const SizedBox(height: 32),
                        
                        _buildSectionLabel("Gender"),
                        const SizedBox(height: 12),
                        _buildGenderSelector(),
                        
                        const SizedBox(height: 48),
                        
                        _buildUpdateButton(),
                        
                        const SizedBox(height: 100),
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

  Widget _buildAvatarPreview() {
    return Container(
      width: 140,
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withOpacity(0.2), width: 3),
        image: DecorationImage(
          image: NetworkImage(_selectedAvatar),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return Container(
      height: 90,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        itemCount: _avatars.length,
        itemBuilder: (context, index) {
          bool isSelected = _selectedAvatar == _avatars[index];
          return GestureDetector(
            onTap: () => setState(() => _selectedAvatar = _avatars[index]),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.only(right: 12),
              width: 75,
              height: 75,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? Colors.white : Colors.white.withOpacity(0.1),
                  width: 3,
                ),
                image: DecorationImage(
                  image: NetworkImage(_avatars[index]),
                  fit: BoxFit.cover,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.bold,
        color: Colors.white.withOpacity(0.4),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.white, background: Colors.transparent),
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: Colors.white,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500, 
            color: Colors.white,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.outfit(color: Colors.white.withOpacity(0.3)),
            prefixIcon: Icon(icon, color: Colors.white.withOpacity(0.4), size: 20),
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            filled: false,
            floatingLabelBehavior: FloatingLabelBehavior.never,
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          ),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildGenderChip(Gender.male, "Male"),
        _buildGenderChip(Gender.female, "Female"),
        _buildGenderChip(Gender.other, "Other"),
      ],
    );
  }

  Widget _buildGenderChip(Gender gender, String label) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? const Color(0xFF065643) : Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: () => Navigator.pop(context, _selectedAvatar),
      child: Container(
        width: double.infinity,
        height: 65,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "SAVE CHANGES",
          style: GoogleFonts.outfit(
            color: const Color(0xFF065643),
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
