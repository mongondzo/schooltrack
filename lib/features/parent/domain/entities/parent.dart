class Parent {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;

  // 🔴 IMPORTANT : doit exister ici
  final List<String> childrenIds;

  const Parent({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.childrenIds = const [],
  });
}
