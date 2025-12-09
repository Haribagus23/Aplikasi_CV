class Rating {
  final int? id;
  final String nama;
  final int rating;
  final String saran;
  final String? createdAt;

  Rating({
    this.id,
    required this.nama,
    required this.rating,
    required this.saran,
    this.createdAt,
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    // Safely parse rating which might come as String or int
    int parsedRating = 0;
    if (json['rating'] != null) {
      if (json['rating'] is int) {
        parsedRating = json['rating'];
      } else if (json['rating'] is String) {
        parsedRating = int.tryParse(json['rating']) ?? 0;
      }
    }

    return Rating(
      id: json['id'],
      nama: json['nama'] ?? 'Anonymous',
      rating: parsedRating,
      saran: json['saran'] ?? '',
      createdAt: json['created_at'],
    );
  }
}
