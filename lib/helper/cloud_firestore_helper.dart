import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/models/event_user_model.dart';
import 'package:flutter_campus_connected/models/user_entity_add.dart';

class FireCloudStoreHelper {
  CollectionReference userReference = Firestore.instance.collection('/users');
  CollectionReference eventReference = Firestore.instance.collection('/events');
  CollectionReference eventUserReference =
      Firestore.instance.collection('/eventUsers');

  //creating new organizer
  Future<bool> storeNewUser(user) async {
    var result = await userReference.add({
      'email': user.email,
      'uid': user.uid,
      'displayName': user.displayName,
      'photoUrl': user.photoUrl
    });
    if (result.documentID != null) {
      return true;
    } else {
      return false;
    }
  }

  // update organizer profile
  Future<void> updateUser(user, UserEntityAdd entity) async {
    var documentID;
    await userReference
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((queryDocumentSnapshot) {
      documentID = queryDocumentSnapshot.documents[0].documentID;
    });

    var res = userReference.document(documentID).updateData({
      'displayName': entity.displayName,
      'photoUrl': entity.photoUrl,
      'age': entity.age,
      'hobby': entity.hobby,
      'faculty': entity.faculty
    });

    return res;
  }

  //TODO: Delete user

  //adding a new event
  addEvents(EventModel model) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      await eventReference.add(model.toJson());
    });
  }

  //TODO: Update Event

  //adding a new event participant
  addEventUser(EventUserModel model) async {
    Firestore.instance.runTransaction((Transaction tx) async {
      await eventUserReference.add(model.toJson());
    });
  }

  //deleting an event
  deleteEvent(docId) {
    eventReference.document(docId).delete().catchError((e) {
      print(e);
    });
  }

  deleteEventUser(docId) {
    eventUserReference.document(docId).delete().catchError((e) {
      print(e);
    });
  }
}
