import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:qb_admin/models/models.dart';
import 'package:qb_admin/wrapper/wrapper.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderDataSource extends DataGridSource {
  BuildContext context;
  OrderDataSource({required this.context, required List<Orders> orderData}) {
    _ordersData = orderData.map<DataGridRow>((e) {
      var dropdown = e.status;
      return DataGridRow(cells: [
        DataGridCell<Widget>(
          columnName: 'Customer Details',
          value: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('USER DETAILS'),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('FULLNAME : '),
                              Text('MOBILE NO : '),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(e.customerDetails['fullname']),
                              Text(e.customerDetails['mobile']),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Text(
              'View User Details',
            ),
          ),
        ),
        DataGridCell<Widget>(
          columnName: 'Customer Address',
          value: ElevatedButton(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      title: Text('USER ADDRESS INFORMATION'),
                      content: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('ADDRESS : '),
                              Text('CITY : '),
                              Text('COUNTRY : '),
                              Text('ZIPCODE : '),
                            ],
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('${e.customerAddress['address']}'),
                              Text('${e.customerAddress['city']}'),
                              Text(e.customerAddress['country']),
                              Text(e.customerAddress['zipcode']),
                            ],
                          ),
                        ],
                      ),
                    );
                  });
            },
            child: Text('View Information'),
          ),
        ),
        DataGridCell<Widget>(
          columnName: 'Email',
          value: Text(e.customerEmail),
        ),
        DataGridCell<Widget>(
          columnName: 'Subtotal',
          value: Text(e.subtotal),
        ),
        DataGridCell<Widget>(
          columnName: 'Total',
          value: Text(e.total),
        ),
        DataGridCell<Widget>(
            columnName: 'Products',
            value: ElevatedButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) {
                      return AlertDialog(
                        title: Text('PRODUCT DETAILS'),
                        content: SizedBox(
                          height: 500,
                          width: 500,
                          child: ListView.builder(
                              itemCount: e.products.length,
                              itemBuilder: (BuildContext context, int index) {
                                return FutureBuilder(
                                    future: FirebaseFirestore.instance
                                        .collection('products')
                                        .doc(e.products[index])
                                        .get(),
                                    builder: (context,
                                        AsyncSnapshot<DocumentSnapshot>
                                            snapshot) {
                                      if (!snapshot.hasData &&
                                          snapshot.connectionState ==
                                              ConnectionState.done) {
                                        return SizedBox(
                                          width: 250,
                                          child: Text(
                                              'Unable to find suggested data. The product is either deleted or not existed.'),
                                        );
                                      }
                                      if (snapshot.hasError) {
                                        return Center(
                                          child: Text('The snapshot has error'),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return Center(
                                          child: SpinKitWanderingCubes(
                                            color: Colors.blueAccent,
                                          ),
                                        );
                                      }
                                      if (snapshot.connectionState ==
                                              ConnectionState.done &&
                                          snapshot.hasData) {
                                        return Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              decoration: BoxDecoration(),
                                              child: Row(
                                                children: [
                                                  SizedBox(
                                                      width: 75,
                                                      child: Image.network(
                                                        snapshot.data![
                                                            'imageUrl'][0],
                                                        fit: BoxFit.fill,
                                                      )),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                          'PRODUCT NAME : ${snapshot.data!['name']}'),
                                                      FutureBuilder(
                                                          future: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'categories')
                                                              .doc(snapshot
                                                                      .data![
                                                                  'category'])
                                                              .get(),
                                                          builder: (_,
                                                              AsyncSnapshot<
                                                                      DocumentSnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .hasData &&
                                                                snapshot.connectionState ==
                                                                    ConnectionState
                                                                        .done) {
                                                              return Row(
                                                                children: [
                                                                  Text(
                                                                      'CATEGORY : '),
                                                                  SizedBox(
                                                                      width: 50,
                                                                      child: Image
                                                                          .network(
                                                                        snapshot
                                                                            .data!['imageUrl'],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                  Text(snapshot
                                                                          .data![
                                                                      'name']),
                                                                ],
                                                              );
                                                            } else {
                                                              return Center(
                                                                child:
                                                                    SpinKitChasingDots(
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                      FutureBuilder(
                                                          future: FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'subcategories')
                                                              .doc(snapshot
                                                                      .data![
                                                                  'subcategory'])
                                                              .get(),
                                                          builder: (_,
                                                              AsyncSnapshot<
                                                                      DocumentSnapshot>
                                                                  snapshot) {
                                                            if (snapshot
                                                                    .hasData &&
                                                                snapshot.connectionState ==
                                                                    ConnectionState
                                                                        .done) {
                                                              return Row(
                                                                children: [
                                                                  Text(
                                                                      'SUBCATEGORY : '),
                                                                  SizedBox(
                                                                      width: 50,
                                                                      child: Image
                                                                          .network(
                                                                        snapshot
                                                                            .data!['imageUrl'],
                                                                        fit: BoxFit
                                                                            .fill,
                                                                      )),
                                                                  Text(snapshot
                                                                          .data![
                                                                      'name']),
                                                                ],
                                                              );
                                                            } else {
                                                              return Center(
                                                                child:
                                                                    SpinKitChasingDots(
                                                                  color: Colors
                                                                      .blue,
                                                                ),
                                                              );
                                                            }
                                                          }),
                                                      Text(
                                                          'PRICE : ${snapshot.data!['price'].toString()}'),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                            const Divider(
                                              height: 10,
                                              color: Colors.black,
                                            )
                                          ],
                                        );
                                      } else {
                                        return Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                    });
                              }),
                        ),
                      );
                    });
              },
              child: Text('View Products'),
            )),
        DataGridCell<Widget>(
          columnName: 'Status',
          value: DropdownButton<String>(
            value: dropdown,
            icon: const Icon(Icons.arrow_downward),
            elevation: 0,
            style: const TextStyle(color: Colors.black),
            underline: Container(
              height: 0,
              color: Colors.transparent,
            ),
            onChanged: (String? newValue) {
              showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return AlertDialog(
                      elevation: 0,
                      backgroundColor: Colors.transparent,
                      content: SpinKitCubeGrid(
                        color: Colors.blue,
                      ),
                    );
                  });
              FirebaseFirestore.instance
                  .collection('checkout')
                  .doc(e.orderId)
                  .update({'status': newValue.toString()}).then((value) {
                Navigator.pop(context);
                EasyLoading.showSuccess('Order Updated Successfully');
              }).onError((error, stackTrace) {
                Navigator.pop(context);
                EasyLoading.showError('Unable to update data');
              });
            },
            items: <String>[
              'Processing',
              'Shipping',
              'Shipped',
              'Recieved',
              'Rejected',
              'Refunding',
              'Refunded'
            ].map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
      ]);
    }).toList();
  }
  List<DataGridRow> _ordersData = [];

  @override
  List<DataGridRow> get rows => _ordersData;

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
