// import 'dart:html';

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:qb_admin/admin/admin_screens/classes/all_categories.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

import '../../../../blocs/category/category_bloc.dart';

String _imageUrl = '';
List dumb = [];

class Categories extends StatefulWidget {
  const Categories({Key? key}) : super(key: key);

  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      appBar: AppBar(
        title: const Text("Categories"),
        centerTitle: true,
        backgroundColor: Colors.brown,
      ),
      body: BlocBuilder<CategoryBloc, CategoryState>(
        builder: (context, state) {
          if (state is CategoryLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is CategoryLoaded) {
            return SfDataGrid(
              source: CategoryDataSource(
                  categoryData: state.categories, context: context),
              columnWidthMode: ColumnWidthMode.fill,
              gridLinesVisibility: GridLinesVisibility.both,
              sortingGestureType: SortingGestureType.tap,
              allowTriStateSorting: true,
              columns: <GridColumn>[
                GridColumn(
                  columnName: 'image',
                  label: Container(
                    padding: const EdgeInsets.all(16.0),
                    child: const Text(
                      'IMAGE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'name',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'NAME',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Edit',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'EDIT',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
                GridColumn(
                  columnName: 'Activity',
                  label: Container(
                    padding: const EdgeInsets.all(8.0),
                    child: const Text(
                      'ACTIVITy',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                  ),
                ),
              ],
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
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          TextEditingController _name = TextEditingController();
          add_category_popup(context, _formKey, _name);
        },
        label: const Text("Add New Category"),
        icon: const FaIcon(FontAwesomeIcons.ad),
        backgroundColor: Colors.brown,
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> add_category_popup(
    BuildContext context,
    GlobalKey<FormState> _formKey,
    TextEditingController _name,
  ) {
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              content: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: _name,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Enter Category Name";
                      },
                      decoration: const InputDecoration(
                        hintText: "Name",
                      ),
                    ),
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
                                  child:
                                      Image.asset('assets/images/upload.png')),
                              const Text(
                                'Click to add image',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              title: const Text('New Category'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Add Category'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (_imageUrl.isEmpty) {
                        const ScaffoldMessenger(
                          child: SnackBar(
                            content: Text('Please add category image'),
                          ),
                        );
                      } else {
                        EasyLoading.show();
                        FirebaseFirestore.instance
                            .collection('categories')
                            .add({
                          'name': _name.text,
                          'imageUrl': _imageUrl,
                          'active': true,
                        }).then((value) {
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess('Product Added Successfully');

                          setState() {
                            _name.text = '';
                            _imageUrl = '';
                            dumb.clear();
                          }

                          Navigator.of(context).pop();
                        }).onError((error, stackTrace) {
                          EasyLoading.showError('Unable to add product');
                        });
                      }
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
        .refFromURL('gs://qbazar-19c41.appspot.com/categories')
        .child(name)
        .getDownloadURL();
  }

  void uploadToStorage() {
    final date = DateTime.now();
    final path = date.toString();
    EasyLoading.show();
    uploadImage(onSelected: (file) {
      FirebaseStorage.instance
          .refFromURL('gs://qbazar-19c41.appspot.com/categories')
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
//un-comment while building web application

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
