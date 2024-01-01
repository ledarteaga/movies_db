// {
//       "id": 28,
//       "name": "Action"
//     },

class Genre {
  final int id;
  final String name;

  Genre({
    required this.id,
    required this.name,
  });

  Genre.fromJson(Map item)
      : id = item["id"],
        name = item["name"];
}
