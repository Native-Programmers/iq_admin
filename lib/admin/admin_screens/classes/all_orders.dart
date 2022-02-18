import 'package:flutter/material.dart';
import 'package:qb_admin/models/models.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class OrderDataSource extends DataGridSource {
  BuildContext context;
  OrderDataSource({required this.context, required List<Orders> orderData}) {
    _ordersData = orderData.map<DataGridRow>((e) {
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
              style: TextStyle(color: Colors.black),
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
            value: InkWell(
              child: Text('View Products'),
            )),
        DataGridCell<Widget>(
          columnName: 'Status',
          value: Text(e.status),
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
