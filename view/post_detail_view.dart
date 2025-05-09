import 'package:apimvvm/viewmodel/post_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';

class PostDetailView extends StatefulWidget {
  final int postId;
  const PostDetailView({super.key, required this.postId});

  @override
  State<PostDetailView> createState() => _PostDetailViewState();
}

class _PostDetailViewState extends State<PostDetailView> {
  bool _showComments = false;

  @override
  void initState() {
    super.initState();
    // Fetch post details when the screen loads
    Future.microtask(() {
      final viewModel = Provider.of<PostViewModel>(context, listen: false);
      viewModel.fetchPost(widget.postId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1E1E24),
      appBar: AppBar(
        title: Text("Post Detail Screen ${widget.postId}"),
        backgroundColor: const Color(0xFF1E1E24),
        foregroundColor: Colors.white,
      ),
      body: Consumer<PostViewModel>(builder: (context, postViewModel, child) {
        if (postViewModel.isLoading && postViewModel.post == null) {
          return const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF50C4ED),
            ),
          );
        }
        if (postViewModel.error.isNotEmpty && postViewModel.post == null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.error_outline,
                  color: Colors.redAccent,
                  size: 60,
                ),
                const SizedBox(height: 16),
                Text(
                  postViewModel.error,
                  style: const TextStyle(
                    color: Colors.redAccent,
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: () => postViewModel.fetchPost(widget.postId),
                  icon: const Icon(Icons.refresh),
                  label: const Text('Retry'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF50C4ED),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
              ],
            ),
          );
        }

        final post = postViewModel.post;

        if (post == null) {
          return const Center(
              child: Text('Post not found',
                  style: TextStyle(color: Colors.white)));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Post ID badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF50C4ED).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Post #${post.id}',
                  style: const TextStyle(
                    color: Color(0xFF50C4ED),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Post title
              Text(
                post.title!,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),

              const SizedBox(height: 12),

              // Post body
              Text(
                post.body!,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white70,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 24),

              // Comments section
              Row(
                children: [
                  const Text(
                    "Comments",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _showComments = !_showComments;
                      });

                      if (_showComments) {
                        // Only fetch comments if we're showing them and they're not already loaded
                        postViewModel.fetchPostComments(widget.postId);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF50C4ED),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    ),
                    child: Text(_showComments ? 'Hide Comments' : 'Show Comments'),
                  ),
                ],
              ),

              // Show comments if the button was clicked
              if (_showComments) ...[
                const SizedBox(height: 16),

                // Show loading indicator if comments are being fetched
                if (postViewModel.isLoading)
                  const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 24.0),
                      child: CircularProgressIndicator(color: Color(0xFF50C4ED)),
                    ),
                  )

                // Show error message if comment fetching failed
                else if (postViewModel.error.isNotEmpty && postViewModel.comments.isEmpty)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 24.0),
                      child: Column(
                        children: [
                          const Icon(Icons.error_outline, color: Colors.redAccent, size: 40),
                          const SizedBox(height: 8),
                          Text(
                            'Failed to load comments: ${postViewModel.error}',
                            style: const TextStyle(color: Colors.redAccent),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => postViewModel.fetchPostComments(widget.postId),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF50C4ED),
                              foregroundColor: Colors.white,
                            ),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )

                // Show message if there are no comments
                else if (postViewModel.comments.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 24.0),
                        child: Text(
                          'No comments found for this post.',
                          style: TextStyle(color: Colors.white70, fontSize: 16),
                        ),
                      ),
                    )

                  // Show the comments list
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: postViewModel.comments.length,
                      itemBuilder: (context, index) {
                        final comment = postViewModel.comments[index];
                        return CommentCard(comment: comment);
                      },
                    ),
              ],
            ],
          ),
        );
      }),
    );
  }
}

class CommentCard extends StatelessWidget {
  final Comment comment;

  const CommentCard({
    super.key,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF2D2D39),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Comment header with name and email
          Row(
            children: [
              // Avatar circle with first letter of name
              CircleAvatar(
                backgroundColor: _getAvatarColor(comment.email!),
                radius: 20,
                child: Text(
                  comment.name!.isNotEmpty ? comment.name![0].toUpperCase() : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Name and email
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      comment.name!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 16,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      comment.email!,
                      style: const TextStyle(
                        color: Colors.white60,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Comment body
          Text(
            comment.body!,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              height: 1.5,
            ),
          ),

          // Comment actions
          const SizedBox(height: 12),
          Row(
            children: [
              _buildActionButton(Icons.thumb_up_outlined, 'Like'),
              const SizedBox(width: 16),
              _buildActionButton(Icons.reply_outlined, 'Reply'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: Colors.white60,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white60,
          ),
        ),
      ],
    );
  }

  Color _getAvatarColor(String email) {
    // Generate a consistent color based on the email
    final int hashCode = email.hashCode;
    final colors = [
      const Color(0xFF50C4ED),
      const Color(0xFFFF6B6B),
      const Color(0xFF4ECDC4),
      const Color(0xFFFFD166),
      const Color(0xFF9B5DE5),
    ];

    return colors[hashCode.abs() % colors.length];
  }
}