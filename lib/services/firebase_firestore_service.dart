import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:heychat/constants/AppStrings.dart';
import 'package:heychat/constants/ConstMethods.dart';
import 'package:heychat/constants/FbErrorsMessages.dart';
import 'package:heychat/constants/ShowSnackBar.dart';
import 'package:heychat/model/Chats.dart';
import 'package:heychat/model/Comments.dart';
import 'package:heychat/model/Messages.dart';
import 'package:heychat/model/PostWithUser.dart';
import 'package:heychat/model/Posts.dart';
import 'package:heychat/model/Users.dart';
import 'package:heychat/services/firebase_storage_service.dart';

class FirebaseFirestoreService {
  final String _users_db = AppStrings.users;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final Fberrorsmessages _fb_errors_messages = Fberrorsmessages();
  final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  final FirebaseStorageService _firebaseStorageService =
  FirebaseStorageService();

  //Kullanıcı bilgilerini kullanıcnın collection yapısına ekle
  Future<void> addUserInfoInDatabase(BuildContext context, Users user) async {
    try {
      _firebaseFirestore
          .collection(_users_db)
          .doc(user.uid)
          .set(user.toFirestore())
          .then((onValue) {
        ShowSnackBar.show(context, AppStrings.userCreatedSuccessfully);
        Navigator.pushReplacementNamed(context, "/home_page");
      });

    } on FirebaseAuthException catch (e) {
      String errorMessage = _fb_errors_messages.handleError(e.code);
      ShowSnackBar.show(context, errorMessage);
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.system_error);
    }
  }

// Kullanıcı bilgilerini database'den çekme
  Future<Users?> getUsersInfoFromDatabase(BuildContext context,
      String user_id) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(user_id)
          .get();
      if (snapshot.exists) {
        Users user = Users.fromFirestore(snapshot);

        // Kullanıcı verilerini kullanmak için burada userModel'i kullanabilirsiniz
        return user;
      } else {
        ShowSnackBar.show(context, AppStrings.userNotFound);
      }
    } catch (e) {
      ShowSnackBar.show(context, "${AppStrings.system_error}$e");
      throw e; // Hatanın yukarıya doğru taşınmasını sağlamak
    }
    return null;
  }

  //kullanıcı profil fotoğrafını database ve storage ekleme
  Future<String> addProfilePhotoInFirebaseDatabase(BuildContext context,
      File image) async {
    if (image != null) {
      try {
        // Fotoğrafı Firebase Storage'a yükle ve indirme bağlantısını al
        String profilePhotoUrl = await _firebaseStorageService
            .addProfilePhotoInStorage(image, _auth);

        // Kullanıcı verilerini güncelle
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(_auth.currentUser!.uid)
            .update({
          "profileImageUrl": profilePhotoUrl,
        });

        return profilePhotoUrl;
      } catch (e) {
        // Hata durumunda kullanıcıya bilgi ver
        ShowSnackBar.show(context, "${AppStrings.system_error}$e");
        return "";
      }
    } else {
      return AppStrings.noUploadProfilePhoto;
    }
  }

  //Kullanıcı kapak fotoğrafını firebase'e ve storage'e ekle
  Future<String> addCoverPhotoInFirebaseDatabase(BuildContext context,
      File image) async {
    if (image != null) {
      try {
        // Fotoğrafı Firebase Storage'a yükle ve indirme bağlantısını al
        String coverImageUrl =
        await _firebaseStorageService.addCoverPhotoInStorage(image, _auth);

        // Kullanıcı verilerini güncelle
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(_auth.currentUser!.uid)
            .update({
          "coverImageUrl": coverImageUrl,
        });

        return coverImageUrl;
      } catch (e) {
        // Hata durumunda kullanıcıya bilgi ver
        ShowSnackBar.show(context, "${AppStrings.system_error}$e");
        return "${AppStrings.system_error}$e";
      }
    } else {
      return AppStrings.noUploadCoverPhoto;
    }
  }

  //profil fotoğrafı silme metodu
  Future<String> deleteProfilePhotoInFirebaseDatabase(
      BuildContext context) async {
    try {
      // Kullanıcının UID'sini al
      String userId = _auth.currentUser!.uid;

      // Firebase Realtime Database'den profil fotoğrafı URL'sini al
      DocumentSnapshot userDoc = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Profil fotoğrafı URL'sini al
        String profilePhotoUrl = userDoc.get("profileImageUrl");

        if (profilePhotoUrl.isNotEmpty) {
          // Firebase Storage'dan profil fotoğrafını sil
          String status =
          await _firebaseStorageService.deleteProfilePhotoInStorage(_auth);

          // Firebase Realtime Database'den profil fotoğrafı URL'sini temizle
          await _firebaseFirestore
              .collection(AppStrings.users)
              .doc(userId)
              .update({
            "profileImageUrl": FieldValue.delete(), // URL'yi sil
          });

          // Başarı mesajı (isteğe bağlı)
          return status;
        } else {
          return AppStrings.noProfilePhoto;
        }
      } else {
        return AppStrings.failedToRetrieveUserInfo;
      }
    } catch (e) {
      // Hata durumunda kullanıcıya bilgi ver
      return "${AppStrings.failedToRetrieveUserInfo}$e";
    }
  }

//kapak fotoğrafı silme metodu
  Future<String> deleteCoverPhotoInFirebaseDatabase(
      BuildContext context) async {
    try {
      // Kullanıcının UID'sini al
      String userId = _auth.currentUser!.uid;

      // Firebase Realtime Database'den profil fotoğrafı URL'sini al
      DocumentSnapshot userDoc = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(userId)
          .get();

      if (userDoc.exists) {
        // Profil fotoğrafı URL'sini al
        String profilePhotoUrl = userDoc.get("coverImageUrl");

        if (profilePhotoUrl.isNotEmpty) {
          // Firebase Storage'dan profil fotoğrafını sil
          String status =
          await _firebaseStorageService.deleteCoverPhotoInStorage(_auth);

          // Firebase Realtime Database'den profil fotoğrafı URL'sini temizle
          await _firebaseFirestore
              .collection(AppStrings.users)
              .doc(userId)
              .update({
            "coverImageUrl": FieldValue.delete(), // URL'yi sil
          });

          // Başarı mesajı (isteğe bağlı)

          return status;
        } else {
          return AppStrings.noCoverPhoto;
        }
      } else {
        return AppStrings.noCoverPhoto;
      }
    } catch (e) {
      return "${AppStrings.failedToRetrieveUserInfo}$e";
    }
  }


// Takip isteği gönder
  Future<void> sendFollowRequest(String currentUserId,
      String targetUserId) async {
    try {
      //gönderdiğim isteklere gönderdiğim kullanıcın id'sini koy
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(currentUserId)
          .update({
        'sentFriendRequests': FieldValue.arrayUnion([targetUserId]),
      }).then((onValue) async {
        //gönderdiğim kullanıcıya benden giden istek olduğunu belirtmek için kendi kullanıcı id'mi koy
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(targetUserId)
            .update({
          'receivedFriendRequests': FieldValue.arrayUnion([currentUserId]),
        });
      });
    } catch (e) {
      print("İstek iptali sırasında hata oluştu: ${e.toString()}");
    }
  }

  // Takipten çık
  Future<void> unFollowRequest(String currentUserId,
      String targetUserId) async {
    try {
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(currentUserId)
          .update({
        'friends': FieldValue.arrayRemove([targetUserId])
      }).then((onValue) async {
        await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(targetUserId)
            .update({
          'friends': FieldValue.arrayRemove([currentUserId])
        });
      });
    } catch (e) {
      print("UnFollow işlemi başarısız oldu: ${e.toString()}");
    }
  }

  // Eğer takip isteği gönderildiyse, isteği iptal et
  Future<void> cancelFollowRequest(String currentUserId,
      String targetUserId) async {
    try {
      // Gönderilen isteği sil
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(currentUserId)
          .update({
        'sentFriendRequests': FieldValue.arrayRemove([targetUserId])
      });

      // Gelen isteği sil
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(targetUserId)
          .update({
        'receivedFriendRequests': FieldValue.arrayRemove([currentUserId])
      });


      // Gönderilen isteği sil
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(currentUserId)
          .update({
        'receivedFriendRequests': FieldValue.arrayRemove([targetUserId])
      });

      // Gelen isteği sil
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(targetUserId)
          .update({
        'sentFriendRequests': FieldValue.arrayRemove([currentUserId])
      });
    } catch (e) {
      print("İstek iptali sırasında hata oluştu: ${e.toString()}");
    }
  } // Gelen isteği kabul et
  //arkadaş isteğini kabul et
  Future<void> acceptFollowRequest(String currentUserId,
      String targetUserId) async {
    try {
      // Takipçi listesine ekle
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(currentUserId)
          .update({
        'friends': FieldValue.arrayUnion([targetUserId]),
      });

      // Hedef kullanıcının arkadaş listesine ekle
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(targetUserId)
          .update({
        'friends': FieldValue.arrayUnion([currentUserId]),
      });

      // Takip isteğini sil
      await cancelFollowRequest(currentUserId, targetUserId);
    } catch (e) {
      print("Takip isteği kabul edilirken hata oluştu: ${e.toString()}");
    }
  }

  // isteink gelen kullanıcı in buton durumunu ayarlama
  Future<bool> checkFollowReceive(String currentUserId,
      String targetUserId) async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore
        .collection(AppStrings.users)
        .doc(currentUserId)
        .get();
// Veriyi bir Map'e dönüştürüyoruz
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String,
        dynamic>?;

// Eğer friends listesi varsa alıyoruz, yoksa boş bir liste oluşturuyoruz
    List<
        dynamic> receivedFriendRequests = userData?['receivedFriendRequests'] ??
        [];

// Eğer arkadaş listesinde 'targetUserId' varsa
    if (receivedFriendRequests.contains(targetUserId)) {
      return true;
    } else {
      return false;
    }
  }

  //daha önce istek gönderildi mi
  Future<bool> checkFollowSend(String currentUserId,
      String targetUserId) async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore
        .collection(AppStrings.users)
        .doc(currentUserId)
        .get();

// Veriyi bir Map'e dönüştürüyoruz
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String,
        dynamic>?;

// Eğer friends listesi varsa alıyoruz, yoksa boş bir liste oluşturuyoruz
    List<dynamic> receivedFriendRequests = userData?['sentFriendRequests'] ??
        [];

// Eğer arkadaş listesinde 'targetUserId' varsa
    if (receivedFriendRequests.contains(targetUserId)) {
      return true;
    } else {
      return false;
    }
  }

  //takipleşiyor muyuz
  Future<bool> checkFollowing(String currentUserId, String targetUserId) async {
    DocumentSnapshot userSnapshot = await _firebaseFirestore
        .collection(AppStrings.users)
        .doc(currentUserId)
        .get();

// Veriyi bir Map'e dönüştürüyoruz
    Map<String, dynamic>? userData = userSnapshot.data() as Map<String,
        dynamic>?;

// Eğer friends listesi varsa alıyoruz, yoksa boş bir liste oluşturuyoruz
    List<dynamic> myFriends = userData?['friends'] ?? [];

// Eğer arkadaş listesinde 'targetUserId' varsa
    if (myFriends.contains(targetUserId)) {
      return true;
    } else {
      return false;
    }
  }


  //kullanıcıyı çevrimiçi yap
  Future<void> updateUserOnline(BuildContext context, User user,
      bool status) async {
    Map<String, bool> isOnline = {
      "isOnline": status,
    };
    _firebaseFirestore.collection(_users_db).doc(user.uid).update(isOnline);
  }


  // Kullanıcı adı daha önce kayıt olmuş mu?
  Future<bool> checkUsername(BuildContext context, String username) async {
    try {
      // Kullanıcılar koleksiyonunda username alanına göre sorgu yapın
      QuerySnapshot querySnapshot = await _firebaseFirestore
          .collection(AppStrings.users)
          .where('username', isEqualTo: username)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return true; // Kullanıcı adı zaten kullanılıyor
      }
    } catch (e) {
      ShowSnackBar.show(context, AppStrings.system_error);
    }
    return false; // Kullanıcı adı kullanılabilir
  }

  //bilgileri güncelleme
  Future<void> updateUserInfo(BuildContext context, String process,
      Map<String, dynamic> data, String errorMessage) async {
    if (process.isEmpty) {
      ShowSnackBar.show(context, errorMessage);
    } else {
      await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(_auth.currentUser!.uid)
          .update(data)
          .whenComplete(() {
        ShowSnackBar.show(context, AppStrings.updateSuccess);
      });
    }
  }

  //kullanıcı arama metodu
  Future<Map<String, dynamic>?> searchUsersFromFirebase(BuildContext context,
      String username,
      DocumentSnapshot<Map<String, dynamic>>? lastDocument) async {
    try {
      Query<Map<String, dynamic>> query = _firebaseFirestore
          .collection(AppStrings.users)
          .where('username', isLessThanOrEqualTo: '$username\uf8ff')
          .limit(5);

      if (lastDocument != null) {
        query = query.startAfterDocument(
            lastDocument); // Son dokümandan sonrasını al
      }


      QuerySnapshot<Map<String, dynamic>> snapshot = await query.get();

      if (snapshot.docs.isNotEmpty) {
        List<Users> users =
        snapshot.docs
            .map((doc) => Users.fromFirestore(doc))
            .where((user) => user.uid != _auth.currentUser!.uid)
            .toList();

        DocumentSnapshot<Map<String, dynamic>> lastVisible =
            snapshot.docs.last; // Son dokümanı alın

        return {
          'users': users,
          'lastDocument': lastVisible,
        };
      }
    } catch (e) {
      print(e);
      return null;
    }
    return null;
  }


// Kullanıcıya gelen arkadaşlık isteklerini zaman damgasına göre getir
  Future<List<Map<String, dynamic>>> getFriendRequests(
      String currentUserId) async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection(AppStrings.users)
          .doc(currentUserId)
          .get();

      final data = snapshot.data();
      if (data != null) {
        // Eğer gelen istekler String tipindeyse (userId'lerin listesi)
        final receivedRequests = List<String>.from(
            data['receivedFriendRequests'] ?? []);
        // Kullanıcı bilgilerini almak için id'leri listeye ekleyin
        List<Map<String, dynamic>> detailedRequests = [];
        for (var userId in receivedRequests) {
          final userSnapshot = await FirebaseFirestore.instance
              .collection(AppStrings.users)
              .doc(userId)
              .get();
          final userData = userSnapshot.data();

          if (userData != null) {
            final user = Users.fromFirestore(userSnapshot);
            detailedRequests.add({
              'user': user,
            });
          }
        }
        return detailedRequests;
      } else {
        return [];
      }
    } catch (e) {
      print("Takip isteklerini alırken hata oluştu: ${e.toString()}");
      return [];
    }
  }

  //Takip ettiğim kişileri çek
  Future<List<String>> getMyFriends(String currentUserId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot =
      await _firebaseFirestore.collection(AppStrings.users).doc(currentUserId).get();
      Map<String, dynamic>? userData = snapshot.data();
      if (userData != null && userData['friends'] is List) {
        return List<String>.from(userData['friends']);
      } else {
        return [];
      }
    } catch (e) {
      print("Error getting friend ids: $e");
      throw e;
    }
  }



  //Post paylaş
  Future<String> addPost(BuildContext context, File image,
      String caption) async {
    String userId = _auth.currentUser!.uid;
    String postId = FirebaseFirestore.instance
        .collection(AppStrings.posts)
        .doc()
        .id;

    DateTime date = DateTime.now();
    var timestamp = Timestamp.fromDate(date);

    List<String> likes = [];
    List<Comments> comments = []; //postu storage ekle ve linkini al
    String image_url = await _firebaseStorageService.addPostInStorage(
        image, userId);



    Posts post =
    Posts(postId: postId,
        userId: userId,
        imageUrl: image_url,
        likes: likes,
        comments: comments,
        caption: caption,
        createdAt: timestamp);

    //Postları fb ekle
    _firebaseFirestore
        .collection(AppStrings.posts)
        .doc(postId)
        .set(post.toFirestore());

    //postu paylaşanın postlarına ekleme yap
    await _firebaseFirestore.collection(AppStrings.users).doc(userId).update({
      'posts': FieldValue.arrayUnion([postId])
    });

    return image_url;
  }

  // Takip edilen kişilerin postlarını ve kullanıcı bilgilerini çek
  Future<List<PostWithUser>> getFeedPostsWithUserInfo(BuildContext context, String currentUserId) async {
    try {
      // Takip edilenlerin id'lerini al
      List<String> myFriends_id = await getMyFriends(currentUserId);

      // Takip edilenlerin postlarını al
      List<PostWithUser> postsWithUserInfo = [];

      for (String friendId in myFriends_id) {
        // Her takip edilen kişinin postlarını al
        QuerySnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
            .collection(AppStrings.posts)
            .where('userId', isEqualTo: friendId)
            .orderBy('createdAt', descending: true)
            .get();

        // Her bir post için post sahibinin kullanıcı bilgilerini al
        for (var doc in snapshot.docs) {
          Posts post = Posts.fromFirestore(doc);

          // Postu paylaşan kullanıcının bilgilerini al
          Users? user = await getUsersInfoFromDatabase(context, friendId);

          // Kullanıcı bulunmuşsa, post ile kullanıcıyı birleştir
          if (user != null) {
            postsWithUserInfo.add(PostWithUser(post: post, user: user));
          }
        }
      }

      return postsWithUserInfo;
    } catch (e) {
      print("Error getting posts with user info: $e");
      return [];
    }
  }

 //Post beğen
 Future<void> likePost(String posId, List<String> likes) async {
   await _firebaseFirestore
       .collection(AppStrings.posts).doc(posId)
       .update({'likes': likes});
 }



 //yorum yap
  Future<void> sendComment(String postId, String newComment) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return; // Kullanıcı giriş yapmamışsa çık

    final newCommentObj = Comments(
      userId: currentUser.uid,
      displayName: _auth.currentUser!.displayName!,
      text: newComment,
      createdAt: Timestamp.now(),
    );

    // Firestore'daki mevcut postu al
    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore.instance
        .collection(AppStrings.posts)
        .doc(postId)
        .get();

    // Yorumları al ya da boş bir liste oluştur
    List<dynamic> commentsData = postSnapshot.data()?['comments'] ?? [];
    List<Comments> comments = commentsData.map((data) => Comments.fromFirestore(data as Map<String, dynamic>)).toList();

    // Yeni yorumu ekle
    comments.add(newCommentObj);

    // Firestore'daki 'comments' alanını güncelle
    await FirebaseFirestore.instance
        .collection(AppStrings.posts)
        .doc(postId)
        .update({'comments': comments.map((c) => c.toFirestore()).toList()});
  }

  //yorumları getir
  Future<List<Comments>> getComments(String postId) async {
    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore.instance
        .collection(AppStrings.posts)
        .doc(postId)
        .get();

    List<dynamic> commentsData = postSnapshot.data()?['comments'] ?? [];
    return commentsData.map((data) => Comments.fromFirestore(data as Map<String, dynamic>)).toList();
  }


  //postu beğenenleri getir
  Future<List<Users>> getLikedPostsUser(BuildContext context, String postId) async {
    List<Users> likedUsers = [];

    // Post belgesini Firestore'dan al
    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await FirebaseFirestore.instance
        .collection(AppStrings.posts)
        .doc(postId)
        .get();

    // 'likes' alanından kullanıcı UID'lerini al
    List<dynamic> likesData = postSnapshot.data()?['likes'] ?? [];

    // Her bir UID için, ilgili kullanıcıyı kullanıcılar koleksiyonundan al ve listeye ekle
    for (var userId in likesData) {
      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore.instance
          .collection(AppStrings.users)
          .doc(userId)
          .get();

      // Kullanıcı belgesini al ve Users modeline dönüştür
      likedUsers.add(Users.fromFirestore(userDoc));
    }

    return likedUsers; // Liked users listesi döndürülüyor
  }


  //yapılan yorumu sil
  Future<void> deleteComment(String postId, String commentId) async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;

    final currentUser = _auth.currentUser;
    if (currentUser == null) return; // Kullanıcı giriş yapmamışsa çık

    DocumentSnapshot<Map<String, dynamic>> postSnapshot = await _firebaseFirestore
        .collection(AppStrings.posts)
        .doc(postId)
        .get();

    List<dynamic> commentsData = postSnapshot.data()?['comments'] ?? [];
    List<Map<String, dynamic>> comments = List.from(commentsData);

    // Yorumları bul ve yalnızca kendi yorumunu sil
    bool foundAndDeleted = false; // Yorumun silindiğini takip eder

    comments.removeWhere((comment) {
      if (comment['text'] == commentId && comment['userId'] == currentUser.uid) {
        foundAndDeleted = true; // Kullanıcı kendi yorumunu silerse
        return true;
      }
      return false;
    });

    // Yorum silindiyse Firebase Firestore'da güncelleme yap
    if (foundAndDeleted) {
      await _firebaseFirestore
          .collection(AppStrings.posts)
          .doc(postId)
          .update({
        'comments': comments,
      });
    } else {
      // Yorum kullanıcının değilse bir uyarı gösterilebilir
      print('Sadece kendi yorumunuzu silebilirsiniz.');
    }
  }


  //kendi paylaştığım postları profil için getir
  Future<List<Posts>> getMyPosts() async {
    // Kullanıcının postlarını almak için kullanıcı dokümanını çekiyoruz
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection(AppStrings.users)
        .doc(_auth.currentUser!.uid)
        .get();

    // Kullanıcının post ID'lerini alıyoruz
    List<dynamic> postData = snapshot.data()?['posts'] ?? [];

    // Post ID'leri üzerinden postları çekmek için bir liste oluşturuyoruz
    List<Posts> myPosts = [];

    for (String postId in postData) {
      // Her bir post ID için post dokümanını çekiyoruz
      DocumentSnapshot<Map<String, dynamic>> postSnapshot = await _firebaseFirestore
          .collection(AppStrings.posts)
          .doc(postId)
          .get();

      // Post verisini alıp Posts modeline dönüştürüyoruz
      if (postSnapshot.exists) {
        Posts post = Posts.fromFirestore(postSnapshot);
        myPosts.add(post); // Postu listeye ekliyoruz
      }
    }

    return myPosts; // Bütün postları döndürüyoruz
  }

  //postları silme
  Future<void> deletePost(String postId,String imageUrl) async {
    try{
      //postu storage'den sil
      await _firebaseStorageService.deletePostInStorage(imageUrl);

      // 2. Postu Firestore'dan sil
      DocumentReference postDocRef = _firebaseFirestore
          .collection(AppStrings.posts)
          .doc(postId);
      await postDocRef.delete();

      // 3. Kullanıcının post listesinden bu postu çıkar
      DocumentReference userDocRef = _firebaseFirestore
          .collection(AppStrings.users)
          .doc(_auth.currentUser!.uid);

      await userDocRef.update({
        'posts': FieldValue.arrayRemove([postId])
      });
    } catch (e) {
      print('Post silme işlemi sırasında hata oluştu: $e');
    }
  }


  //kendi paylaştığım postları profil için getir
  Future<List<Posts>> getTargetPosts(String targetUserId) async {
    // Kullanıcının postlarını almak için kullanıcı dokümanını çekiyoruz
    DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
        .collection(AppStrings.users)
        .doc(targetUserId)
        .get();

    // Kullanıcının post ID'lerini alıyoruz
    List<dynamic> postData = snapshot.data()?['posts'] ?? [];

    // Post ID'leri üzerinden postları çekmek için bir liste oluşturuyoruz
    List<Posts> myPosts = [];

    for (String postId in postData) {
      // Her bir post ID için post dokümanını çekiyoruz
      DocumentSnapshot<Map<String, dynamic>> postSnapshot = await _firebaseFirestore
          .collection(AppStrings.posts)
          .doc(postId)
          .get();

      // Post verisini alıp Posts modeline dönüştürüyoruz
      if (postSnapshot.exists) {
        Posts post = Posts.fromFirestore(postSnapshot);
        myPosts.add(post); // Postu listeye ekliyoruz
      }
    }

    return myPosts; // Bütün postları döndürüyoruz
  }

  
  //takip edilenleri getir 
  Future<List<Users>> getFollowers(BuildContext context, String targetUserId) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> snapshot = await _firebaseFirestore
          .collection(AppStrings.users)
          .doc(targetUserId)
          .get();

      List<dynamic> friendsData = snapshot.data()?['friends'] ?? [];
      List<Users> followers = [];

      for (String friendsId in friendsData) {
        Users? follower = await getUsersInfoFromDatabase(context, friendsId);
        if (follower != null) {
          followers.add(follower);
        }
      }
      return followers;
    } catch (e) {
      print('Error fetching followers: $e');
      return [];
    }
  }


  //mesaj gönder
  Future<void> sendMessage({
    required String senderId,
    required String receiverId,
    required String content,
  }) async {
    try {

      // Chat ID oluşturmak için katılımcıların UID'lerini sıralı bir şekilde birleştiriyoruz.
      List<String> userIds = [senderId, receiverId];
      userIds.sort(); // UID'leri sıralıyoruz ki chatId her iki kullanıcı için aynı olsun.

      String chatId = userIds.join('_'); // Örneğin: 'uid1_uid2'

      // Gönderilecek mesajın zaman damgasını alıyoruz.
      DateTime date = DateTime.now();
      var timestamp = Timestamp.fromDate(date);

      // Mesajı Firestore'a ekliyoruz.
      var messageRef =  await FirebaseFirestore.instance.collection(AppStrings.messages).add({
        'chatId': chatId,
        'senderId': senderId,
        'receiverId': receiverId,
        'content': content,
        'timestamp': timestamp,
        'isRead': false,
      });

      // Son mesajı güncellemek için gerekli verileri hazırlıyoruz.
      String lastMessage = content;
      Timestamp lastMessageTimestamp = Timestamp.fromDate(date);

      // Chat belgesini kontrol ediyoruz.
      final chatDoc = await FirebaseFirestore.instance.collection(AppStrings.chatsfb).doc(chatId).get();

      // Eğer chat belgesi yoksa, yeni bir chat oluşturuyoruz.
      if (!chatDoc.exists) {
        await FirebaseFirestore.instance.collection(AppStrings.chatsfb).doc(chatId).set({
          'userIds': userIds,
          'lastMessage': lastMessage,
          'lastMessageTimestamp': lastMessageTimestamp,
          'isRead': false, // Yeni mesaj okunmadı olarak işaretleniyor
        });
      } else {
        // Eğer chat belgesi varsa, son mesajı ve zaman damgasını güncelliyoruz.
        await FirebaseFirestore.instance.collection(AppStrings.chatsfb).doc(chatId).update({
          'lastMessage': lastMessage,
          'lastMessageTimestamp': lastMessageTimestamp,
          'isRead': false, // Yeni mesaj okunmadı olarak işaretleniyor
        });

        // Mesajın okunma durumunu dinle
        FirebaseFirestore.instance.collection(AppStrings.messages)
            .doc(messageRef.id)
            .snapshots()
            .listen((messageSnapshot) {
          if (messageSnapshot.exists) {
            bool isRead = messageSnapshot.data()!['isRead'];
            print("Okuma durumu $isRead");
            if (!isRead) {
                ConstMethods.sendNotification(receiverId, content, "Yeni Mesaj", "send_message_page", receiverId);
            }
          }
        });


      }
    } catch (e) {
      print('Hata oluştu: $e');
      // Hata durumunda uygun şekilde işleme alınabilir.
    }
  }
//mesajları getir
  Stream<List<Messages>> getMessages(
      String senderId,
      String receiverId,
      ) {
    List<String> userIds = [senderId, receiverId];
    userIds.sort(); // UID'leri sıralıyoruz ki chatId her iki kullanıcı için aynı olsun.
    String chatId = userIds.join('_'); // Örneğin: 'uid1_uid2'
    try {
      // Belirli bir chatId'ye ait mesajları Firestore'dan çekmek için bir stream döndürüyoruz.
      return FirebaseFirestore.instance
          .collection(AppStrings.messages)
          .where('chatId', isEqualTo: chatId)
          .orderBy('timestamp', descending: true)
          .snapshots()
          .map((snapshot) => snapshot.docs.map((doc) => Messages.fromFirestore(doc)).toList());
    } catch (e) {
      print('Hata oluştu: $e');
      throw e;
    }

  }

  //chat görüldü yani tüm mesajlar görüldü
  Future<void> markChatsAsRead(String messageId) async {
    await _firebaseFirestore.collection(AppStrings.chatsfb).doc(messageId).update({
      'isRead': true,
    }).catchError((e) {
      print('Mesaj okundu olarak işaretlenirken hata oluştu: $e');
    });
  }

  //mesaj görülmedi
  Future<void> markChatsAsUnread(String messageId) async {
    await _firebaseFirestore.collection(AppStrings.chatsfb).doc(messageId).update({
      'isRead': false,
    }).catchError((e) {
      print('Mesaj okunmamış olarak işaretlenirken hata oluştu: $e');
    });
  }

  //gönderilen mesaj anında görüldü
  Future<void> markMessageAsRead(String messageId) async {
    await _firebaseFirestore.collection(AppStrings.messages).doc(messageId).update({
      'isRead': true,
    }).catchError((e) {
      print('Mesaj okundu olarak işaretlenirken hata oluştu: $e');
    });
  }

  // Kullanıcının tüm sohbetlerini getiren metod
  Stream<List<Chats>> getChatsStream(String userId) {
    return _firebaseFirestore
        .collection(AppStrings.chatsfb)
        .where('userIds', arrayContains: userId)
        .orderBy('lastMessageTimestamp', descending: true)
        .snapshots()
        .asyncMap((snapshot) async {
      List<Chats> chats = [];
      for (var doc in snapshot.docs) {
        List<dynamic> userIds = doc['userIds'];
        String otherUserId = userIds.firstWhere((id) => id != userId);

        DocumentSnapshot<Map<String, dynamic>> userSnapshot = await _firebaseFirestore
            .collection(AppStrings.users)
            .doc(otherUserId)
            .get();

        if (userSnapshot.exists) {
          Users userModel = Users.fromFirestore(userSnapshot);

          Chats chatModel = Chats(
            chatId: doc.id,
            userIds: List<String>.from(doc['userIds']),
            lastMessage: doc['lastMessage'],
            lastMessageTimestamp: (doc['lastMessageTimestamp'] as Timestamp).toDate(),
            isRead: doc['isRead'],
            user: userModel,
          );

          chats.add(chatModel);
        }
      }
      return chats;
    });
  }


  // Chat ve mesajları silme
  Future<void> deleteChat({
    required String chatId,
  }) async {
    try {
      // Firestore referanslarını al
      final messagesCollection = FirebaseFirestore.instance.collection(AppStrings.messages);
      final chatsCollection = FirebaseFirestore.instance.collection(AppStrings.chatsfb);

      // Belirli bir chatId'ye ait tüm mesajları sil
      final messagesSnapshot = await messagesCollection.where('chatId', isEqualTo: chatId).get();
      for (var messageDoc in messagesSnapshot.docs) {
        await messageDoc.reference.delete();
      }

      // Chat belgesini sil
      await chatsCollection.doc(chatId).delete();

      print('Chat ve mesajlar başarıyla silindi.');
    } catch (e) {
      print('Mesajlar silininrken Hata oluştu: $e');
      // Hata durumunda uygun şekilde işleme alınabilir.
    }
  }


}
