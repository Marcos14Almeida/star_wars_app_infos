class Favorite {
  final int id;
  final String name;

  Favorite({
    required this.id,
    required this.name,
  });

  // Convert a Favorite into a Map. The keys must correspond to the names of the
  // columns in the database.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
    };
  }

  // Implement toString to make it easier to see information about
  // each dog when using the print statement.
  @override
  String toString() {
    return 'Favorite{id: $id, name: $name}';
  }
}