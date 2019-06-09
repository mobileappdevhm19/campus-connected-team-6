import 'package:cloud_firestore/cloud_firestore.dart';

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
}
