import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qb_admin/models/models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';

class ProductsDataSource extends DataGridSource {
  BuildContext context;
  final CollectionReference _firebaseFirestore =
      FirebaseFirestore.instance.collection("products");
  ProductsDataSource(
      {required List<Product> productData, required this.context}) {
    _productData = productData.map<DataGridRow>((e) {
      TextEditingController _name = new TextEditingController();
      TextEditingController _desc = new TextEditingController();
      TextEditingController _price = new TextEditingController();
      _name.text = e.name;
      _price.text = e.price.toString();
      _desc.text = e.desc;
      return DataGridRow(
        cells: [
          DataGridCell<Widget>(
              columnName: 'name',
              value: TextFormField(
                controller: _name,
                maxLines: 10,
                style: TextStyle(fontSize: 10),
              )),
          DataGridCell<Widget>(
              columnName: 'category',
              value: InkWell(onTap: () {}, child: Text(e.category))),
          DataGridCell<Widget>(
              columnName: 'sub category',
              value: InkWell(
                  onTap: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            content: StatefulBuilder(
                              builder:
                                  (BuildContext context, StateSetter setState) {
                                return FutureBuilder<Object>(
                                    future: FirebaseFirestore.instance
                                        .collection('subcategories')
                                        .doc(e.uid)
                                        .get(),
                                    builder: (context, snapshot) {
                                      if (!snapshot.hasData ||
                                          snapshot.connectionState ==
                                              ConnectionState.waiting) {
                                        return Center(
                                          child: SpinKitFadingCube(
                                            color: Colors.blue,
                                          ),
                                        );
                                      } else if (snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        print(snapshot.data);
                                        return Column(
                                          children: [],
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    });
                              },
                            ),
                          );
                        });
                  },
                  child: Text(e.subCategory))),
          DataGridCell<Widget>(
              columnName: 'price',
              value: TextFormField(
                controller: _price,
                maxLines: 10,
                style: TextStyle(fontSize: 10),
              )),
          DataGridCell<Widget>(
              columnName: 'desc',
              value: TextFormField(
                controller: _desc,
                maxLines: 10,
                style: TextStyle(fontSize: 10),
              )),
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
            columnName: 'isPopular',
            value: Center(
              child: ToggleSwitch(
                  initialLabelIndex: (e.isPopular ? 0 : 1),
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
                          .update({'isPopular': false})
                          .then(
                            (value) =>
                                EasyLoading.showSuccess("Set To Not Popular"),
                          )
                          .onError((error, stackTrace) =>
                              {EasyLoading.showError("Unable to update")});
                    } else {
                      _firebaseFirestore
                          .doc(e.uid)
                          .update({'isPopular': true})
                          .then((value) =>
                              EasyLoading.showSuccess("Set To Popular"))
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
              columnName: 'EDIT',
              value: ElevatedButton(
                  child: const Text('Edit Product'),
                  onPressed: () async {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor: Colors.transparent,
                            elevation: 0,
                            content: SpinKitChasingDots(
                              color: Colors.blue,
                            ),
                          );
                        });
                    FirebaseFirestore.instance
                        .collection("products")
                        .doc(e.uid)
                        .update({
                      'name': _name.text,
                      'price': int.parse(_price.text),
                      'desc': _desc.text,
                    }).then((value) {
                      EasyLoading.showSuccess('Data Updated');
                      Navigator.pop(context);
                    }).onError((error, stackTrace) {
                      EasyLoading.showError('Unable to update data');
                      Navigator.pop(context);
                      print(error);
                    });
                  })),
        ],
      );
    }).toList();
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
