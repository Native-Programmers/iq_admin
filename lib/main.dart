import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_phone_auth_handler/firebase_phone_auth_handler.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:qb_admin/blocs/luckydraw/luckydraw_bloc.dart';
import 'package:qb_admin/blocs/products/products_bloc.dart';
import 'package:qb_admin/repositories/banners/banners_repository.dart';
import 'package:qb_admin/repositories/categories/category_repository.dart';
import 'package:qb_admin/repositories/luckydraw/luckydraw_repository.dart';
import 'package:url_strategy/url_strategy.dart';

import 'blocs/banners/banners_bloc.dart';
import 'blocs/category/category_bloc.dart';
import 'config/app_router.dart';
import 'repositories/product/product_repository.dart';
import 'services/AuthController.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  setPathUrlStrategy();
  runApp(const Admin());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.fadingCircle
    ..loadingStyle = EasyLoadingStyle.dark
    ..indicatorSize = 45.0
    ..radius = 10.0
    ..progressColor = Colors.yellow
    ..backgroundColor = Colors.green
    ..indicatorColor = Colors.yellow
    ..textColor = Colors.yellow
    ..maskColor = Colors.blue.withOpacity(0.5)
    ..userInteractions = true
    ..dismissOnTap = false;
  // ..customAnimation = CustomAnimation();
}

class Admin extends StatefulWidget {
  const Admin({Key? key}) : super(key: key);

  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> with WidgetsBindingObserver {
  @override
  void dispose() {
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Future.delayed(const Duration(seconds: 60)).then((value) => showDialog(
    //     context: context,
    //     builder: (_) {
    //       return const AlertDialog(
    //         title: Text('Inactive for too long.'),
    //       );
    //     }));
  }

  @override
  Widget build(BuildContext context) {
    return FirebasePhoneAuthProvider(
      child: MultiProvider(
        providers: [
          Provider<AuthService>(
            create: (_) => AuthService(),
          ),
        ],
        child: MultiBlocProvider(
          providers: [
            BlocProvider(
              create: (_) => CategoryBloc(
                categoryRepository: CategoryRepository(),
              )..add(LoadCategories()),
            ),
            BlocProvider(
              create: (_) => BannersBloc(
                BannersRepository: BannersRepository(),
              )..add(LoadBanners()),
            ),
            BlocProvider(
              create: (_) => ProductBloc(
                productRepository: ProductRepository(),
              )..add(LoadProduct()),
            ),
            BlocProvider(
              create: (_) => LuckyDrawBloc(
                LuckyDrawRepository: LuckyDrawRepository(),
              )..add(LoadLuckyDraw()),
            ),
          ],
          child: GetMaterialApp(
            locale: Get.deviceLocale,
            debugShowCheckedModeBanner: false,
            builder: EasyLoading.init(),
            initialRoute: '/wrapper',
            onGenerateRoute: AppRouter.onGenerateRoute,
          ),
        ),
      ),
    );
  }
}
