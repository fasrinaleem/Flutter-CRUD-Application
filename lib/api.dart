import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutterapplab06/user.dart';

class APIService {
  bool showTextField = false;
  final String collectionName;
  final TextEditingController controller;
  bool isEditing;
  User curUser;

  APIService.InitAPI({this.collectionName, this.controller, this.isEditing});




  getUsers() {
    return Firestore.instance.collection(collectionName).snapshots();
  }

  addUser(TextEditingController controller) {
    User user = User(name: controller.text);
//    user.name = controller.text;

    try {
      Firestore.instance.runTransaction(
            (Transaction transaction) async {
          await Firestore.instance
              .collection(collectionName)
              .document()
              .setData(user.toJson());
        },
      );
    } catch (e) {
      print(e.toString());

    }
  }

  add(TextEditingController controller) {
    if (isEditing) {
      //Update
      update(curUser, controller.text);
//      setState(() {
        isEditing = false;
//      });
    }
    else {
      addUser(controller);
    }
    controller.text = '';
  }

  update(User curUser, String newName) {
    try {
      Firestore.instance.runTransaction((transaction) async {
        await transaction.update(curUser.reference, {'name': newName});
      });
    } catch (e) {
      print(e.toString());
    }
  }

  delete(User user) {
    Firestore.instance.runTransaction(
          (Transaction transaction) async {
        await transaction.delete(user.reference);
      },
    );
  }
}