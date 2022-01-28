import 'package:qb_admin/models/banners.dart';

abstract class BaseBannersRepository {
  Stream<List<Banners>> getAllBanners();
}
