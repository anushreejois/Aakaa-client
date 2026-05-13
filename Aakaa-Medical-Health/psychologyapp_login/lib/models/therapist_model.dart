class Therapist {
  final String name;
  final String specialization;
  final double rating;
  final int reviews;
  final bool isOnline;
  final String initials; // Used for our premium placeholder
  final String? imageUrl;

  Therapist({
    required this.name,
    required this.specialization,
    required this.rating,
    required this.reviews,
    required this.isOnline,
    required this.initials,
    this.imageUrl,
  });
}
