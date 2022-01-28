import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:qb_admin/models/banners.dart';
import 'package:qb_admin/repositories/banners/base_banners_repository.dart';

class BannersRepository extends BaseBannersRepository {
  final FirebaseFirestore _firebaseFirestore;

  BannersRepository({FirebaseFirestore? firebaseFirestore})
      : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;

  @override
  Stream<List<Banners>> getAllBanners() {
    return _firebaseFirestore.collection('banners').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Banners.fromSnapshot(doc)).toList();
    });
  }
}
