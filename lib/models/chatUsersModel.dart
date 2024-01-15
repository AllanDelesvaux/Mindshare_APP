
class ChatUsers{
  int id;
  String lastName;
  String firstName;
  int age;
  String ?biography;
  ChatUsers({required this.id,required this.lastName,required this.firstName, required this.age, required this.biography});

  static ChatUsers fromJson(Map<String, dynamic> json) {
    return ChatUsers(
      id: json['id_account'] as int,
      lastName: json['last_name'] as String,
      firstName: json['first_name'] as String,
      age: json['years_old'] as int,
      biography: json['biography'] as String?,
    );
  }
}