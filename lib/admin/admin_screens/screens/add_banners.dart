// import 'dart:html';

import 'dart:html';

import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:qb_admin/blocs/banners/banners_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

String _imageUrl = '';

class Banners extends StatefulWidget {
  const Banners({Key? key}) : super(key: key);

  @override
  _BannersState createState() => _BannersState();
}

class _BannersState extends State<Banners> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Banners"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: SingleChildScrollView(
        child: BlocBuilder<BannersBloc, BannersState>(
          builder: (context, state) {
            if (state is BannersLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (state is BannersLoaded) {
              return SizedBox(
                width: double.infinity,
                height: 500,
                child: Swiper(
                  itemBuilder: (BuildContext context, int index) {
                    return Stack(
                      children: [
                        Image.network(state.banners[index].imageUrl,
                            fit: BoxFit.cover,
                            height: (kIsWeb ? 500 : 225),
                            width: double.infinity),
                        Positioned(
                            right: 50,
                            child: IconButton(
                              icon: const Icon(
                                Icons.delete,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                EasyLoading.show();
                                try {
                                  if (state.banners.length <= 4) {
                                    Get.snackbar('Error',
                                        'Banners must be more than 4.');
                                    EasyLoading.dismiss();
                                  } else {
                                    FirebaseFirestore.instance
                                        .collection("banners")
                                        .doc(state.banners[index].id)
                                        .delete()
                                        .then((value) {
                                      EasyLoading.showSuccess(
                                          'Data Removed Successfully');
                                      setState(() {
                                        state.banners.removeAt(index);
                                      });
                                    }).onError((error, stackTrace) {
                                      EasyLoading.showError(
                                          'Unable to remove data');
                                    });
                                  }
                                } catch (e) {
                                  Get.snackbar('Error',
                                      'Check your internet connection');
                                }
                              },
                            )),
                      ],
                    );
                  },
                  autoplay: false,
                  itemCount: state.banners.length,
                  scrollDirection: Axis.horizontal,
                  pagination:
                      const SwiperPagination(alignment: Alignment.centerRight),
                  control: const SwiperControl(),
                ),
              );
            } else {
              return Center(
                child: Text(
                  'Please Check your connection',
                  style: Theme.of(context).textTheme.headline6!.copyWith(
                      fontWeight: FontWeight.bold, color: Colors.grey[600]),
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          TextEditingController _name = TextEditingController();
          add_banner_popup(context, _formKey, _name);
        },
        label: const Text("Add New Banner"),
        icon: const FaIcon(FontAwesomeIcons.ad),
        backgroundColor: Colors.brown,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> add_banner_popup(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController _name,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  InkWell(
                    onTap: () async {
                      uploadToStorage();
                    },
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            border: const Border(),
                            color: Colors.blue,
                            borderRadius: BorderRadius.circular(5.00),
                          ),
                          height: 100,
                          width: double.infinity,
                        ),
                        Center(
                            child: Column(
                          children: [
                            SizedBox(
                                height: 50,
                                width: double.infinity,
                                child: Image.asset('assets/images/upload.png')),
                            const Text(
                              'Click to add Image',
                              style:
                                  TextStyle(fontSize: 10, color: Colors.white),
                            ),
                          ],
                        )),
                      ],
                    ),
                  ),
                ],
              ),
              title: const Text('New Banner'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Add Banner'),
                  onPressed: () {
                    if (_imageUrl.isEmpty) {
                      const ScaffoldMessenger(
                        child: SnackBar(
                          content: Text('Please add banner image'),
                        ),
                      );
                    } else {
                      EasyLoading.show();
                      FirebaseFirestore.instance.collection('banners').add({
                        'imageUrl': _imageUrl,
                      }).then((value) {
                        var data = FirebaseFirestore.instance
                            .collection("length")
                            .doc("Banners")
                            .get();
                        print(data.toString());
                        EasyLoading.dismiss();
                        EasyLoading.showSuccess('Product Added Successfully');

                        setState() {
                          _name.text = '';
                          _imageUrl = '';
                        }

                        Navigator.of(context).pop();
                      }).onError((error, stackTrace) {
                        EasyLoading.showError('Unable to add banner');
                      });
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  Future<String> downloadUrl(String name) async {
    return FirebaseStorage.instance
        .refFromURL('gs://qbazar-19c41.appspot.com/Banners')
        .child(name)
        .getDownloadURL();
  }

  void uploadToStorage() {
    final date = DateTime.now();
    final path = date.toString();
    EasyLoading.show();
    uploadImage(onSelected: (file) {
      FirebaseStorage.instance
          .refFromURL('gs://qbazar-19c41.appspot.com/Banners')
          .child(path)
          .putBlob(file)
          .then((p0) {
        EasyLoading.dismiss();

        return downloadUrl(path).then((value) {
          EasyLoading.showSuccess('Image Uploaded');
          setState(() {
            _imageUrl = value;
          });
        });
      }).onError((error, stackTrace) {
        EasyLoading.showError('Something went wrong');
        return Future.delayed(const Duration(milliseconds: 500), () {});
      });
    });
  }

  void uploadImage({required Function(File file) onSelected}) {
    final uploadInput = FileUploadInputElement()..accept = 'image/*';
    uploadInput.click();
    uploadInput.onChange.listen((event) {
      final file = uploadInput.files!.first;
      final reader = FileReader();
      reader.readAsDataUrl(file);
      reader.onLoadEnd.listen((event) {
        onSelected(file);
      });
    });
  }
}
