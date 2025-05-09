import 'package:apimvvm/models/comment_model.dart';
import 'package:apimvvm/models/post_model.dart';
import 'package:apimvvm/services/api_services.dart';
import 'package:flutter/material.dart';

class PostViewModel extends ChangeNotifier {
  final APIServices _apiServices = APIServices();

  List<Post> _posts = [];
  Post? _selectedPost;
  List<Comment> _comments = [];

  bool _isLoading = false;
  String _error = '';

  // getters

  List<Post> get posts => _posts;
  Post? get post => _selectedPost;
  bool get isLoading => _isLoading;
  String get error => _error;

  List<Comment> get comments => _comments;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  // fetcch all posts

  Future<void> fetchPosts() async {
    _setLoading(true);
    _error = "";

    try {
      _posts = await _apiServices.getPosts();
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPost(int id) async {
    _setLoading(true);
    _error = "";

    try {
      _selectedPost = await _apiServices.getPost(id);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchPostComments(int postId) async {
    _setLoading(true);
    _error = "";

    try {
      _comments = await _apiServices.getPostComments(postId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCommentByPostId(int postId) async {
    _setLoading(true);
    _error = "";

    try {
      _comments = await _apiServices.getCommentsByPostId(postId);
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
