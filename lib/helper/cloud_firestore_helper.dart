import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_campus_connected/models/event_model.dart';
import 'package:flutter_campus_connected/models/event_user_model.dart';
import 'package:flutter_campus_connected/models/user_model.dart';

class FireCloudStoreHelper {
  CollectionReference userReference = Firestore.instance.collection('/users');
  CollectionReference eventReference = Firestore.instance.collection('/events');
  CollectionReference eventUserReference =
      Firestore.instance.collection('/eventUsers');

  //creating new organizer
  Future<bool> storeNewUser(UserModel entity) async {
    var result = await userReference.add(entity.toJson());
    if (result.documentID != null) {
      return true;
    } else {
      return false;
    }
  }

  // update organizer profile
  Future<void> updateUser(user, UserModel entity) async {
    var documentID;
    await userReference
        .where('uid', isEqualTo: user.uid)
        .getDocuments()
        .then((queryDocumentSnapshot) {
      documentID = queryDocumentSnapshot.documents[0].documentID;
    });

    var res = userReference.document(documentID).updateData(entity.toJson());
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
    //When event gets deleted -> delete all event users to prevent mal function
    eventUserReference.where('eventId', isEqualTo: docId).snapshots().listen(
        (data) =>
            data.documents.forEach((doc) => deleteEventUser(doc.documentID)));
  }

  deleteEventUser(docId) {
    eventUserReference.document(docId).delete().catchError((e) {
      print(e);
    });
  }
}
