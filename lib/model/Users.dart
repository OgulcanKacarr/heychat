import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:heychat/constants/AppStrings.dart';

class Users {
  String? uid;
  String email;
  String username;
  String displayName;
  String bio;
  String profileImageUrl;
  String coverImageUrl;
  bool isOnline;
  List<String>? followers;
  List<String>? sentFriendRequests;
  List<String>? receivedFriendRequests;
  List<String>? posts;
  String? token;

  Users({
    this.uid,
    required this.email,
    required this.username,
    required this.displayName,
    this.bio = '',
    this.isOnline = true,
    this.profileImageUrl = '',
    this.coverImageUrl = '',
    this.followers = const [],
    this.sentFriendRequests = const [],
    this.receivedFriendRequests = const [],
    this.posts = const [],
    this.token = "",
  });

  factory Users.fromFirestore(DocumentSnapshot<Map<String, dynamic>> snapshot) {
    final data = snapshot.data();
    return Users(
      uid: data?['uid'] as String?,
      email: data?['email'] as String? ?? '',
      username: data?['username'] as String? ?? '',
      displayName: data?['displayName'] as String? ?? '',
      bio: data?['bio'] as String? ?? '',
      isOnline: data?['isOnline'] as bool? ?? true,
      profileImageUrl: data?['profileImageUrl'] as String? ?? '',
      coverImageUrl: data?['coverImageUrl'] as String? ?? '',
      followers: List<String>.from(data?['followers'] ?? []),
      sentFriendRequests: List<String>.from(data?['sentFriendRequests'] ?? []),
      receivedFriendRequests: List<String>.from(data?['receivedFriendRequests'] ?? []),
      posts: List<String>.from(data?['posts'] ?? []),
      token: data?['token'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'username': username,
      'displayName': displayName,
      'bio': bio,
      'isOnline': isOnline,
      'profileImageUrl': profileImageUrl,
      'coverImageUrl': coverImageUrl,
      'friends': followers,
      'sentFriendRequests': sentFriendRequests,
      'receivedFriendRequests': receivedFriendRequests,
      'posts': posts,
      'token': token,
    };
  }

  @override
  String toString() {
    return 'UserModel(displayName: $displayName, email: $email, bio: $bio, username: $username, profileImageUrl: $profileImageUrl, coverImageUrl: $coverImageUrl)';
  }
}