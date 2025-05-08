class Post {
  final int? id;
  final int userId;
  final String? title;
  final String? body;

  Post(
      {required this.id,
      required this.title,
      required this.body,
      required this.userId});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
        id: json['id'],
        title: json['title'],
        body: json['body'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'userId': this.userId,
      'title': this.title,
      'body': this.body
    };
  }
}
