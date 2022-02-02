import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qb_admin/models/models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductsDataSource extends DataGridSource {
  BuildContext context;
  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("products");
  ProductsDataSource(
      {required List<Product> productData, required this.context}) {
    _productData = productData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<Widget>(columnName: 'name', value: Text(e.name)),
            DataGridCell<Widget>(
                columnName: 'category', value: Text(e.category)),
            DataGridCell<Widget>(
                columnName: 'price', value: Text(e.price.toString())),
            DataGridCell<Widget>(columnName: 'desc', value: Text(e.desc)),
            DataGridCell<Widget>(
              columnName: 'isRecommended',
              value: Center(
                child: ToggleSwitch(
                    initialLabelIndex: (e.isRecommended ? 0 : 1),
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
                            .update({'isRecommended': false})
                            .then(
                              (value) => EasyLoading.showSuccess(
                                  "Set To Not Recommended"),
                            )
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      } else {
                        _firebaseFirestore
                            .doc(e.uid)
                            .update({'isRecommended': true})
                            .then((value) =>
                                EasyLoading.showSuccess("Set To Recommended"))
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      }
                    }),
              ),
            ),
            DataGridCell<Widget>(
              columnName: 'isActive',
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
                            .update({'isActive': false})
                            .then(
                              (value) =>
                                  EasyLoading.showSuccess("Set To Inactive"),
                            )
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      } else {
                        _firebaseFirestore
                            .doc(e.uid)
                            .update({'isActive': true})
                            .then((value) =>
                                EasyLoading.showSuccess("Set To Active"))
                            .onError((error, stackTrace) =>
                                {EasyLoading.showError("Unable to update")});
                      }
                    }),
              ),
            ),
            DataGridCell<Widget>(
                columnName: 'Qismat draw',
                value: ElevatedButton(
                  child: const Text('Edit Product'),
                  onPressed: () async {
                    final GlobalKey<FormState> _formKey =
                        GlobalKey<FormState>();
                    var _name = TextEditingController();
                    var _discount = TextEditingController();
                    var _charges = TextEditingController();
                    DateTime date;
                    return await showDialog(
                        context: context,
                        builder: (context) {
                          return StatefulBuilder(builder: (context, setState) {
                            return AlertDialog(
                              content: Form(
                                  key: _formKey,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('PRODUCT'),
                                      TextFormField(
                                        controller: _name,
                                        validator: (value) {
                                          return value!.isNotEmpty
                                              ? null
                                              : "Enter any name";
                                        },
                                        decoration: const InputDecoration(
                                            hintText:
                                                "Please Enter Lucky Draw Name"),
                                      ),
                                      const Divider(
                                        height: 10,
                                      ),
                                      const Text('DISCOUNT'),
                                      TextFormField(
                                        controller: _discount,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]')),
                                        ],
                                        validator: (value) {
                                          return value!.isNotEmpty
                                              ? null
                                              : "Enter discount";
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Please Enter Discount"),
                                      ),
                                      const Divider(
                                        height: 10,
                                      ),
                                      const Text('CHARGES'),
                                      TextFormField(
                                        controller: _charges,
                                        inputFormatters: [
                                          FilteringTextInputFormatter.allow(
                                              RegExp('[0-9]')),
                                        ],
                                        validator: (value) {
                                          return value!.isNotEmpty
                                              ? null
                                              : "Enter any charges";
                                        },
                                        decoration: const InputDecoration(
                                            hintText: "Please Enter Charges"),
                                      ),
                                      const Divider(
                                        height: 10,
                                      ),
                                      InkWell(
                                        child: const Text("Select Date & Time"),
                                        onTap: () {
                                          DatePicker.showDateTimePicker(
                                            context,
                                            showTitleActions: true,
                                            minTime: DateTime.now(),
                                            onChanged: (date) {
                                              print('change $date');
                                            },
                                            onConfirm: (date) {
                                              print('confirm $date');
                                            },
                                            currentTime: DateTime.now(),
                                            locale: LocaleType.en,
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                              title: const Center(
                                  child: Text('EDITING (enabled)')),
                              actions: <Widget>[
                                ElevatedButton(
                                  child: const Text('Complete Editing'),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      EasyLoading.show();
                                      FirebaseFirestore.instance
                                          .collection('luckydraw')
                                          .add({
                                        'product_id': e.uid,
                                        'charges': _charges.text,
                                        'name': _name.text,
                                        'discount': _discount.text,
                                        'isActive': true,
                                        'date':
                                            Timestamp.fromDate(DateTime.now()),
                                      }).then((value) {
                                        EasyLoading.showSuccess(
                                                'Data added successfully')
                                            .then((value) =>
                                                Navigator.of(context).pop());
                                      }).onError((error, stackTrace) {
                                        EasyLoading.showError(
                                            'Unable to load data');
                                      });
                                    }
                                  },
                                ),
                              ],
                            );
                          });
                        });
                  },
                )),
          ]),
        )
        .toList();
  }
  List<DataGridRow> _productData = [];

  @override
  List<DataGridRow> get rows => _productData;

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
