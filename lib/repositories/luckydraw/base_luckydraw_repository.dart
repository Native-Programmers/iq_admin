import 'package:qb_admin/models/luckydraw.dart';

abstract class BaseLuckyDrawRepository {
  Stream<List<LuckyDraw>> getAllLuckyDraw();
}
