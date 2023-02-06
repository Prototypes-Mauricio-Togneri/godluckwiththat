import 'package:cloud_firestore/cloud_firestore.dart';

class Database {
  static Future createUser(String id) async {
    final DocumentReference doc =
        FirebaseFirestore.instance.collection('accounts').doc(id);
    await doc.set({'campaign_last_level': 1});
  }
}
