// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_integrate/model/user_model.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// class UserRepository extends GetxController {
//   static UserRepository get instance => Get.find();

//   final _db = FirebaseFirestore.instance;

//   // createUser(User user) async {
//   //   await _db
//   //       .collection("Users")
//   //       .add(user.toJson())
//   //       .whenComplete(
//   //         () => Get.snackbar("Success", "Your information has been logged",
//   //             snackPosition: SnackPosition.BOTTOM,
//   //             backgroundColor: Colors.green.withOpacity(0.2),
//   //             colorText: Colors.green),
//   //       )
//   //       .catchError((error, stackTrace) {
//   //     Get.snackbar(
//   //       "Error",
//   //       "Try Again",
//   //       snackPosition: SnackPosition.BOTTOM,
//   //       backgroundColor: Colors.redAccent.withOpacity(0.2),
//   //       colorText: Colors.red,
//   //     );
//   //   });
//   // }
// }
