class CastMember {
  final bool adult;
  final int? gender;
  final int id;
  final String? knownForDepartment;
  final String name;
  final String? originalName;
  final double popularity;
  final String? profilePath;
  final int? castId;
  final String? character;
  final String? creditId;
  final int? order;
  final String? biography;

  CastMember({
    required this.adult,
    required this.gender,
    required this.id,
    required this.knownForDepartment,
    required this.name,
    this.originalName,
    required this.popularity,
    required this.profilePath,
    this.castId,
    this.character,
    required this.creditId,
    this.order,
    this.biography,
  });

  CastMember.fromJson(Map item)
      : adult = item["adult"],
        gender = item["gender"],
        id = item["id"],
        knownForDepartment = item["known_for_department"],
        name = item["name"],
        originalName = item["original_name"],
        popularity = item["popularity"],
        profilePath = item["profile_path"],
        castId = item['cast_id'],
        character = item['character'],
        creditId = item['credit_id'],
        order = item['order'],
        biography = item['biography'];
}
