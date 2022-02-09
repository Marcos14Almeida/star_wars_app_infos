const String tableFavorites = 'favorites';

class FavoriteFields{
  static final List<String> values = [
    //Add all fields
    id, name
  ];

  static const String id = '_id';
  static const String name = 'name';

}

class Favorites{

  final int? id;
  final String name;

  const Favorites({
        this.id,
        required this.name,
      });

  static Favorites fromJson(Map<String, Object?> json) => Favorites(
    id: json[FavoriteFields.id] as int?,
    name: json[FavoriteFields.name] as String,
  );

  Map<String, Object?> toJson() => {
    FavoriteFields.id: id,
    FavoriteFields.name: name,
  };

  Favorites copy({
    int? id,
    String? name,
  }) =>
        Favorites(id: id ?? this.id, name: name ?? this.name);

 }