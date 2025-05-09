class Comment {
  final int? id;
  final int? postId;
  final String? name;
  final String? email;
  final String? body;

  Comment(
      {required this.id,
      required this.body,
      required this.postId,
      required this.name,
      required this.email});

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'],
        body: json['body'],
        postId: json['postId'],
        name: json['name'],
        email: json['email']);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'postId': this.postId,
      'email': this.email,
      'name': this.name,
      'body': this.body
    };
  }
}
