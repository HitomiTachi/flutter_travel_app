import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Stream theo dõi trạng thái đăng nhập
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Lấy User hiện tại (nếu có)
  User? get currentUser => _auth.currentUser;

  // Đăng nhập với Email & Password
  Future<UserCredential?> signInWithEmail(String email, String password) async {
    try {
      final userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Đảm bảo document trong Firestore tồn tại
      if (userCredential.user != null) {
        final user = userCredential.user!;
        final userDoc = await _firestore.collection('users').doc(user.uid).get();
        
        // Nếu document chưa tồn tại, tạo mới
        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': user.email,
            'name': user.displayName ?? 'User', // Sử dụng displayName nếu có, nếu không dùng 'User'
            'avatarUrl': user.photoURL ?? 'https://i.pravatar.cc/200?img=5',
            'joinDate': Timestamp.now(),
            'favoritePlaceIds': [],
            'isAnonymous': false,
          }, SetOptions(merge: true)); // Dùng merge để không ghi đè nếu có dữ liệu cũ
        }
      }
      
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  // 4. ĐĂNG KÝ (Đã nâng cấp theo cấu trúc ảnh)
  // *** LƯU Ý: Thêm tham số 'String name' ***
  Future<UserCredential?> registerWithEmail(String email, String password, String name) async {
    try {
      // 4.1. Tạo user trong Firebase Auth
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      User? user = userCredential.user;

      if (user != null) {
        // 4.2. Tạo document cho user trong Firestore
        await _firestore.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'email': user.email,
          'name': name, // THAY ĐỔI: Lấy từ tham số
          'avatarUrl': 'https://i.pravatar.cc/200?img=5', // THAY ĐỔI: Thêm avatar mặc định
          'joinDate': Timestamp.now(), // THAY ĐỔI: Tên trường
          'favoritePlaceIds': [], // THAY ĐỔI: Thêm mảng rỗng
          'isAnonymous': false,
        });
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  // 5. ĐĂNG NHẬP KHÁCH (Đã nâng cấp theo cấu trúc ảnh)
  Future<UserCredential?> signInAnonymously() async {
    try {
      UserCredential userCredential = await _auth.signInAnonymously();
      User? user = userCredential.user;

      if (user != null) {
        final userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (!userDoc.exists) {
          await _firestore.collection('users').doc(user.uid).set({
            'uid': user.uid,
            'email': null,
            'name': 'Guest User', // THAY ĐỔI
            'avatarUrl': 'https://i.pravatar.cc/200?img=1', // THAY ĐỔI: Avatar mặc định cho khách
            'joinDate': Timestamp.now(), // THAY ĐỔI
            'favoritePlaceIds': [], // THAY ĐỔI
            'isAnonymous': true,
          });
        }
      }
      return userCredential;
    } on FirebaseAuthException catch (e) {
      rethrow;
    }
  }

  // 6. Đăng xuất
  Future<void> signOut() async {
    await _auth.signOut();
  }
}