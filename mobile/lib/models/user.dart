class User {
  const User({required this.name});

  final String name;

  static const empty = User(name: '-');

  @override
  String toString() => 'User(name: $name)';
}
