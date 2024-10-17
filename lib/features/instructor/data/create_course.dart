import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateCourse {
  String? courseID;
  String? name;
  Color? color;
  String? description;
  List<String>? logo;

  CreateCourse({
     this.courseID,
     this.name,
     this.color,
     this.description,
     this.logo,
  });

  Map<String, dynamic> toMap() {
    return {
      'courseID': courseID,
      'name': name,
      'color': color,
      'description': description,
      'logo': logo,
    };
  }

  factory CreateCourse.fromDocument(DocumentSnapshot doc) {
    return CreateCourse(
      courseID: doc['courseID'],
      name: doc['name'],
      color: doc['color'],
      description: doc['description'],
      logo: List<String>.from(doc["logo"]),
    );
  }

  factory CreateCourse.fromJson(Map<String, dynamic> doc) {
    return CreateCourse(
      courseID: doc['courseID'],
      name: doc['name'],
      color: doc['color'],
      description: doc['description'],
      logo: List<String>.from(doc["logo"]),
    );
  }
}
