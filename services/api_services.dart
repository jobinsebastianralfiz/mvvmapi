import 'dart:convert';

import 'package:apimvvm/core/api_constants.dart';
import 'package:apimvvm/models/comment_model.dart';

import '../models/post_model.dart';
import 'package:http/http.dart' as http;

class APIServices {
  // base url
  final String baseUrl = APIConstants.baseUrl; //string

  // get all posts

  Future<List<Post>> getPosts() async {
    // uniform resource identifier
    final url = Uri.parse('${baseUrl}/${APIConstants.getPosts}');
    //https://jsonplaceholder.typicode.com/posts
    final response = await http.get(url);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(response.body);

      return jsonList.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load Posts");
    }
  }

  // Get a specific post

  Future<Post> getPost(int id) async {
    final url = Uri.parse('${baseUrl}/${APIConstants.getPost}/${id}');
    //https://jsonplaceholder.typicode.com/posts/1
    final response = await http.get(url);

    if (response.statusCode == 200) {
      return Post.fromJson(jsonDecode(response.body));
    } else {
      throw Exception("Failed to load Post");
    }
  }

  Future<List<Comment>> getPostComments(int postId) async {
    final url =
        Uri.parse('$baseUrl/posts/${postId}/${APIConstants.postComment}');

    final respose = await http.get(url);

    if (respose.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(respose.body);

      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception("Failed to laod Comments");
    }
  }

  Future<List<Comment>> getCommentsByPostId(int postId) async {
    final url = Uri.parse('$baseUrl/comments?postId=${postId}');

    final respose = await http.get(url);

    if (respose.statusCode == 200) {
      List<dynamic> jsonList = jsonDecode(respose.body);

      return jsonList.map((json) => Comment.fromJson(json)).toList();
    } else {
      throw Exception("Failed to laod Comments");
    }
  }
}
