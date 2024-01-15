class Post{
  final int? id_post;
  final int account;
  final String content;
  final String date;
  final int? post_commented;

  Post({
    required this.id_post,
    required this.account,
    required this.content,
    required this.date,
    required this.post_commented,
  });

  static Post fromJson(Map<String, dynamic> json) {
    return Post(
      id_post: json['id_post'] as int?,
      account: json['id_account'] as int,
      content: json['message'] as String,
      date: json['send_date'] as String,
      post_commented: json['id_post_commented'] as int?,
    );
  }

}

