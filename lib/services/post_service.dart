import 'dart:io';  // For File type in parameters
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_travels_apps/data/models/post_model.dart';

class PostService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  
  // Constant for local image path
  static const String defaultImagePath = 'assets/images/img4.jpg';

  // Create Post
  Future<void> createPost({
    String? description,
    List<File>? images,  // This parameter will be ignored as we're using local image
    String? locationName,
    GeoPoint? location,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      // Get user data
      final userDoc = await _firestore.collection('users').doc(user.uid).get();
      final userData = userDoc.data() as Map<String, dynamic>;

      // Create post document
      final postRef = _firestore.collection('posts').doc();
      final post = PostModel(
        id: postRef.id,
        userId: user.uid,
        description: description ?? PostModel.defaultDescription,
        imageUrls: null, // Make image optional
        locationName: locationName ?? PostModel.defaultLocationName,
        location: location,
        createdAt: DateTime.now(),
        authorName: userData['name'] ?? PostModel.defaultAuthorName,
        authorAvatar: userData['avatarUrl'],
      );

      await postRef.set(post.toMap());
    } catch (e) {
      rethrow;
    }
  }

  // Read Posts (Stream)
  Stream<List<PostModel>> getPosts() {
    return _firestore
        .collection('posts')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // Trả về danh sách rỗng nếu không có bài viết
        return [];
      }
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Read User Posts
  Stream<List<PostModel>> getUserPosts(String userId) {
    return _firestore
        .collection('posts')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      if (snapshot.docs.isEmpty) {
        // Trả về danh sách rỗng nếu không có bài viết
        return [];
      }
      return snapshot.docs
          .map((doc) => PostModel.fromMap(doc.data()))
          .toList();
    });
  }

  // Update Post
  Future<void> updatePost({
    required String postId,
    String? description,
    List<File>? newImages,  // This parameter will be ignored as we're using local image
    String? locationName,
    GeoPoint? location,
  }) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final postDoc = await _firestore.collection('posts').doc(postId).get();
      if (!postDoc.exists) throw Exception('Post not found');

      final post = PostModel.fromMap(postDoc.data()!);
      if (post.userId != user.uid) throw Exception('Not authorized to update this post');

      Map<String, dynamic> updateData = {
        'updatedAt': DateTime.now(),
        'description': description ?? PostModel.defaultDescription,
        'locationName': locationName ?? PostModel.defaultLocationName,
      };

      if (location != null) updateData['location'] = location;

      await _firestore.collection('posts').doc(postId).update(updateData);
    } catch (e) {
      rethrow;
    }
  }

  // Delete Post
  Future<void> deletePost(String postId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      final postDoc = await _firestore.collection('posts').doc(postId).get();
      if (!postDoc.exists) throw Exception('Post not found');

      final post = PostModel.fromMap(postDoc.data()!);
      if (post.userId != user.uid) throw Exception('Not authorized to delete this post');

      // Simply delete the document from Firestore
      await _firestore.collection('posts').doc(postId).delete();
    } catch (e) {
      rethrow;
    }
  }
}