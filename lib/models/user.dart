import 'package:flutter/foundation.dart';
import 'package:timwan/models/reports_stats.dart';

class User {
  String uid;
  String fullName;
  String email;
  String photoUrl;
  ReportsStats stats;

  User({
    @required this.uid,
    this.fullName,
    this.email,
    this.photoUrl,
    this.stats,
  });

  User.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    fullName = json['full_name'];
    email = json['email'];
    photoUrl = json['photo_url'];
    stats = json['stats'] != null
        ? new ReportsStats.fromJson(
            json['stats'],
          )
        : null;
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'full_name': fullName,
      'email': email,
      'photo_url': photoUrl,
      'stats': stats?.toJson() ?? null,
    };
  }
}
