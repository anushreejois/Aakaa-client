import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/zen_background.dart';
import '../controllers/user_controller.dart';

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
    final user = UserController.currentUser;
    _firstNameController.text = user.firstName;
    _lastNameController.text = user.lastName;
    _selectedAvatar = user.avatarUrl;
    if (widget.currentAvatar != null && widget.currentAvatar!.startsWith("http")) {
      _selectedAvatar = widget.currentAvatar!;
    }
    if (user.gender.toLowerCase() == "male") {
      _selectedGender = Gender.male;
    } else if (user.gender.toLowerCase() == "female") {
      _selectedGender = Gender.female;
    } else {
      _selectedGender = Gender.other;
    }
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
              expandedHeight: 140.0,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF065643)),
                onPressed: () => Navigator.pop(context, _selectedAvatar),
              ),
              flexibleSpace: FlexibleSpaceBar(
                titlePadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                centerTitle: false,
                title: Text(
                  "Edit Profile",
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
                      const SizedBox(height: 16),
                      _buildGenderSelector(),
                      
                      const SizedBox(height: 56),
                      
                      _buildUpdateButton(),
                      
                      const SizedBox(height: 100),
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

  Widget _buildAvatarPreview() {
    return Container(
      width: 150,
      height: 150,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: const Color(0xFF065643), width: 4),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.15),
            blurRadius: 25,
            offset: const Offset(0, 10),
          ),
        ],
        image: DecorationImage(
          image: NetworkImage(_selectedAvatar),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildAvatarGrid() {
    return SizedBox(
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
              duration: const Duration(milliseconds: 250),
              margin: const EdgeInsets.only(right: 16, top: 4, bottom: 4),
              width: 78,
              height: 78,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF065643) : const Color(0xFF065643).withValues(alpha: 0.1),
                  width: isSelected ? 4 : 2,
                ),
                boxShadow: isSelected ? [
                  BoxShadow(
                    color: const Color(0xFF065643).withValues(alpha: 0.25),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ] : null,
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
        fontSize: 13,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF065643).withValues(alpha: 0.6),
        letterSpacing: 1.5,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF065643).withValues(alpha: 0.05)),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF065643).withValues(alpha: 0.06),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(
          colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF065643), surface: Colors.transparent),
        ),
        child: TextFormField(
          controller: controller,
          cursorColor: const Color(0xFF065643),
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500, 
            color: const Color(0xFF065643),
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: label,
            hintStyle: GoogleFonts.outfit(color: const Color(0xFF065643).withValues(alpha: 0.4)),
            prefixIcon: Icon(icon, color: const Color(0xFF065643).withValues(alpha: 0.6), size: 22),
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
        Expanded(child: _buildGenderChip(Gender.male, "Male")),
        const SizedBox(width: 12),
        Expanded(child: _buildGenderChip(Gender.female, "Female")),
        const SizedBox(width: 12),
        Expanded(child: _buildGenderChip(Gender.other, "Other")),
      ],
    );
  }

  Widget _buildGenderChip(Gender gender, String label) {
    bool isSelected = _selectedGender == gender;
    return GestureDetector(
      onTap: () => setState(() => _selectedGender = gender),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          gradient: isSelected
            ? const LinearGradient(
                colors: [Color(0xFF065643), Color(0xFF0A7D62)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              )
            : null,
          color: isSelected ? null : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isSelected ? Colors.transparent : const Color(0xFF065643).withValues(alpha: 0.1)),
          boxShadow: [
            BoxShadow(
              color: isSelected ? const Color(0xFF065643).withValues(alpha: 0.25) : const Color(0xFF065643).withValues(alpha: 0.04),
              blurRadius: 15,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.outfit(
            color: isSelected ? Colors.white : const Color(0xFF065643).withValues(alpha: 0.8),
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget _buildUpdateButton() {
    return GestureDetector(
      onTap: () {
        String genderStr = "Female";
        if (_selectedGender == Gender.male) {
          genderStr = "Male";
        } else if (_selectedGender == Gender.other) {
          genderStr = "Other";
        }

        UserController.updateProfile(
          firstName: _firstNameController.text.trim(),
          lastName: _lastNameController.text.trim(),
          avatarUrl: _selectedAvatar,
          gender: genderStr,
        );
        Navigator.pop(context, _selectedAvatar);
      },
      child: Container(
        width: double.infinity,
        height: 65,
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
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          "SAVE CHANGES",
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.2,
          ),
        ),
      ),
    );
  }
}
