import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_travels_apps/core/constants/dismension_constants.dart';
import 'package:flutter_travels_apps/data/models/post_model.dart';
import 'package:flutter_travels_apps/services/post_service.dart';
import 'package:flutter_travels_apps/representation/widgets/common/app_bar_container.dart';
import 'package:flutter_travels_apps/representation/screen/create_post_screen.dart';
import 'package:flutter_travels_apps/representation/screen/edit_post_screen.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:cached_network_image/cached_network_image.dart';

class PostListScreen extends StatefulWidget {
  const PostListScreen({Key? key}) : super(key: key);

  static const String routeName = '/post_list_screen';

  @override
  State<PostListScreen> createState() => _PostListScreenState();
}

class _PostListScreenState extends State<PostListScreen> {
  final PostService _postService = PostService();
  final User? _currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return AppBarContainerWidget(
      titleString: 'Danh sách bài viết',
      child: Stack(
        children: [
          StreamBuilder<List<PostModel>>(
            stream: _postService.getPosts(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError) {
                return Center(
                  child: Text('Đã xảy ra lỗi: ${snapshot.error}'),
                );
              }

              final posts = snapshot.data ?? [];

              if (posts.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          FontAwesomeIcons.newspaper,
                          size: 64,
                          color: Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Chưa có bài viết nào',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color: Colors.grey[800],
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Hãy bấm nút + ở góc phải dưới để tạo bài viết',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: Colors.grey[600],
                            ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                padding: const EdgeInsets.all(kMediumPadding),
                itemCount: posts.length,
                itemBuilder: (context, index) {
                  final post = posts[index];
                  return _buildPostCard(post);
                },
              );
            },
          ),
          Positioned(
            bottom: kMediumPadding,
            right: kMediumPadding,
            child: FloatingActionButton(
              onPressed: () => _navigateToCreatePost(context),
              backgroundColor: Theme.of(context).primaryColor,
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPostCard(PostModel post) {
    return Card(
      margin: const EdgeInsets.only(bottom: kMediumPadding),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          ListTile(
            leading: CircleAvatar(
              backgroundImage: post.authorAvatar != null
                  ? CachedNetworkImageProvider(post.authorAvatar!)
                  : null,
              child: post.authorAvatar == null
                  ? const Icon(FontAwesomeIcons.user)
                  : null,
            ),
            title: Text(
              post.authorName ?? PostModel.defaultAuthorName,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              DateFormat('dd/MM/yyyy HH:mm').format(post.createdAt),
            ),
            trailing: post.userId == _currentUser?.uid
                ? PopupMenuButton<String>(
                    onSelected: (value) => _handlePostAction(value, post),
                    itemBuilder: (BuildContext context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit, size: 20),
                            SizedBox(width: 8),
                            Text('Chỉnh sửa'),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Row(
                          children: [
                            Icon(Icons.delete, size: 20, color: Colors.red),
                            SizedBox(width: 8),
                            Text('Xóa', style: TextStyle(color: Colors.red)),
                          ],
                        ),
                      ),
                    ],
                  )
                : null,
          ),

          // Images
          if (post.imageUrls != null && post.imageUrls!.isNotEmpty)
            SizedBox(
              height: 200,
              child: PageView.builder(
                itemCount: post.imageUrls!.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: post.imageUrls![index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => const Center(
                      child: CircularProgressIndicator(),
                    ),
                    errorWidget: (context, url, error) => const Icon(
                      Icons.error,
                      color: Colors.red,
                    ),
                  );
                },
              ),
            ),

          // Description
          Padding(
            padding: const EdgeInsets.all(kMediumPadding),
            child: Text(
              post.description ?? PostModel.defaultDescription,
              style: TextStyle(
                fontSize: 16,
                color: post.description == null ? Colors.grey : Colors.black,
              ),
            ),
          ),

          // Location
          Padding(
            padding: const EdgeInsets.only(
              left: kMediumPadding,
              right: kMediumPadding,
              bottom: kMediumPadding,
            ),
            child: Row(
              children: [
                Icon(
                  FontAwesomeIcons.locationDot,
                  size: 16,
                  color: post.locationName == null ? Colors.grey : Colors.red,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    post.locationName ?? PostModel.defaultLocationName,
                    style: const TextStyle(
                      color: Colors.grey,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _navigateToCreatePost(BuildContext context) async {
    final created = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const CreatePostScreen(),
      ),
    );
    if (created == true) {
      setState(() {}); // Refresh the list
    }
  }

  Future<void> _handlePostAction(String action, PostModel post) async {
    switch (action) {
      case 'edit':
        final edited = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EditPostScreen(post: post),
          ),
        );
        if (edited == true) {
          setState(() {}); // Refresh the list
        }
        break;
      case 'delete':
        _showDeleteConfirmationDialog(post);
        break;
    }
  }

  // Hàm này là một Future, vì nó sẽ hiển thị một Dialog và chờ người dùng tương tác.
Future<void> _showDeleteConfirmationDialog(PostModel post) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  return showDialog(
    // `context` này vẫn là context của màn hình chính
    context: context,
    
    // `builder` sẽ tạo ra một context MỚI, riêng biệt cho Dialog.
    // Chúng ta đổi tên nó thành `dialogContext` để phân biệt rõ ràng.
    builder: (BuildContext dialogContext) => AlertDialog(
      
      // --- NỘI DUNG CỦA DIALOG ---
      title: const Text('Xác nhận xóa'), // Tiêu đề
      content: const Text('Bạn có chắc chắn muốn xóa bài viết này không?'), // Nội dung
      
      // --- CÁC NÚT HÀNH ĐỘNG ---
      actions: [
        
        // --- NÚT "HỦY" ---
        TextButton(
          // Khi nhấn "Hủy", ta dùng `dialogContext` để đóng chính Dialog này
          onPressed: () => Navigator.pop(dialogContext),
          child: const Text('Hủy'),
        ),
        
        // --- NÚT "XÓA" ---
        TextButton(
          // Hàm `onPressed` này là `async` vì nó cần gọi hàm `await` (để xóa)
          onPressed: () async {

            Navigator.pop(dialogContext);
            try {
              // Bước 2: Thực hiện hành động `await` (xóa post)
              // Giao diện sẽ ở trạng thái "chờ" (await) cho đến khi hàm này xong
              await _postService.deletePost(post.id);
              if (!mounted) return;
              scaffoldMessenger.showSnackBar(
                const SnackBar(
                  content: Text('Đã xóa bài viết'),
                ),
              );

            } catch (e) {  
              if (!mounted) return;
              scaffoldMessenger.showSnackBar(
                SnackBar(
                  content: Text('Lỗi: $e'),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          // Tô màu đỏ cho nút "Xóa" để cảnh báo
          style: TextButton.styleFrom(foregroundColor: Colors.red),
          child: const Text('Xóa'),
        ),
      ],
    ),
  );
}
}