import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserPresenceService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final CollectionReference _presenceCollection = FirebaseFirestore.instance.collection('user');

  Future<void> setUserOnline() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _presenceCollection.doc(user.uid).set({
        'isOnline': true,
        'lastSeen': DateTime.now(),
      },SetOptions(merge: true));
    }
  }

  Future<void> setUserOffline() async {
    final User? user = _auth.currentUser;
    if (user != null) {
      await _presenceCollection.doc(user.uid).set({
        'isOnline': false,
        'lastSeen': DateTime.now(),
      },SetOptions(merge: false));
    }
  }

  Stream<DocumentSnapshot> getUserPresenceStream(String userId) {
    return _presenceCollection.doc(userId).snapshots();
  }

}
//
// void main() async {
//   UserPresenceService presenceService = UserPresenceService();
//
//   await presenceService.setUserOnline();
//   String userId = FirebaseAuth.instance.currentUser!.uid;
//   Stream<DocumentSnapshot> userPresenceStream = presenceService.getUserPresenceStream(userId);
//   userPresenceStream.listen((DocumentSnapshot snapshot) {
//     bool isOnline = snapshot['isOnline'] ?? false;
//     print('User is ${isOnline
//         ? 'online'
//         : 'offline'}'
//     );
//   });
// }
