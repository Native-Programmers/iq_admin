import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qb_admin/models/luckydraw.dart';
import 'base_luckydraw_repository.dart';

class LuckyDrawRepository extends BaseLuckyDrawRepository {
  final FirebaseFirestore _firebaseFirestore;

  LuckyDrawRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<LuckyDraw>> getAllLuckyDraw() {
    return _firebaseFirestore
        .collection('luckydraw')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) => LuckyDraw.fromSnapshot(doc)).toList();
    });
  }
}
