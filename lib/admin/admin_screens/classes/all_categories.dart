import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qb_admin/models/category_model.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toggle_switch/toggle_switch.dart';

String _imageUrl = '';
TextEditingController _name = TextEditingController();

class CategoryDataSource extends DataGridSource {
  BuildContext context;

  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("categories");

  CategoryDataSource(
      {required List<Categories> categoryData, required this.context}) {
    _categoryData = categoryData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<Widget>(
                columnName: 'image',
                value: SizedBox(
                    height: 50,
                    width: 50,
                    child: Image.network(e.imageUrl, fit: BoxFit.contain))),
            DataGridCell<Widget>(columnName: 'name', value: Text(e.name)),
            DataGridCell<Widget>(
                columnName: 'edit',
                value: Center(
                  child: ElevatedButton(
                    child: Text("Edit Category"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return StatefulBuilder(
                                builder: (context, setState) {
                              Future<String> downloadUrl(String name) async {
                                return FirebaseStorage.instance
                                    .refFromURL(
                                        'gs://qbazar-19c41.appspot.com/categories')
                                    .child(name)
                                    .getDownloadURL();
                              }

                              void uploadImage(
                                  {required Function(File file) onSelected}) {
                                final uploadInput = FileUploadInputElement()
                                  ..accept = 'image/*';
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

                              void uploadToStorage() {
                                final date = DateTime.now();
                                final path = date.toString();
                                EasyLoading.show();
                                uploadImage(onSelected: (file) {
                                  FirebaseStorage.instance
                                      .refFromURL(
                                          'gs://qbazar-19c41.appspot.com/categories')
                                      .child(path)
                                      .putBlob(file)
                                      .then((p0) {
                                    EasyLoading.dismiss();

                                    return downloadUrl(path).then((value) {
                                      EasyLoading.showSuccess('Image Uploaded');
                                      setState(() {
                                        _imageUrl = value;
                                        print(_imageUrl);
                                      });
                                    });
                                  }).onError((error, stackTrace) {
                                    EasyLoading.showError(
                                        'Something went wrong');
                                    return Future.delayed(
                                        const Duration(milliseconds: 500),
                                        () {});
                                  });
                                });
                              }

                              return AlertDialog(
                                  content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      print(_imageUrl);
                                      uploadToStorage();
                                    },
                                    child: SizedBox(
                                      width: 200,
                                      height: 100,
                                      child: Image.network(_imageUrl),
                                    ),
                                  ),
                                  TextFormField(
                                    controller: _name,
                                    style: TextStyle(fontSize: 10),
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter some text';
                                      }
                                      return null;
                                    },
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(0),
                                      ),
                                    ),
                                  ),
                                  const Divider(
                                    height: 10,
                                    color: Colors.transparent,
                                  ),
                                  ElevatedButton(
                                      onPressed: () {
                                        try {
                                          EasyLoading.show();
                                          _firebaseFirestore
                                              .doc(e.uid)
                                              .update({
                                                'imageUrl': _imageUrl,
                                                'name': _name.text,
                                              })
                                              .then((value) =>
                                                  EasyLoading.showSuccess(
                                                      'Data has been updated'))
                                              .onError((error, stackTrace) =>
                                                  EasyLoading.showError(
                                                      'Unable to update.'));
                                        } catch (e) {}
                                      },
                                      child: Text('Update Data'))
                                ],
                              ));
                            });
                          });
                    },
                  ),
                )),
            DataGridCell<Widget>(
              columnName: 'activity',
              value: Center(
                child: ToggleSwitch(
                    initialLabelIndex: (e.isActive ? 0 : 1),
                    minWidth: 50.0,
                    cornerRadius: 25.0,
                    activeBgColors: const [
                      [Colors.cyan],
                      [Colors.redAccent]
                    ],
                    activeFgColor: Colors.white,
                    inactiveBgColor: Colors.grey,
                    inactiveFgColor: Colors.white,
                    totalSwitches: 2,
                    labels: const ['YES', 'NO'],
                    onToggle: (index) {
                      EasyLoading.show();
                      if (index == 1) {
                        _firebaseFirestore
                            .doc(e.uid)
                            .update({'active': false})
                            .then(
                              (value) =>
                                  EasyLoading.showSuccess("Set To Inactive"),
                            )
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      } else {
                        _firebaseFirestore
                            .doc(e.uid)
                            .update({'active': true})
                            .then((value) =>
                                EasyLoading.showSuccess("Set To Active"))
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      }
                    }),
              ),
            ),
          ]),
        )
        .toList();
  }

  List<DataGridRow> _categoryData = [];

  @override
  List<DataGridRow> get rows => _categoryData;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    return DataGridRowAdapter(
        cells: row.getCells().map<Widget>((e) {
      return Container(
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.all(8.0),
        child: e.value,
      );
    }).toList());
  }
}
