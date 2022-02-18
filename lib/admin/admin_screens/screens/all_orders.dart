import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qb_admin/admin/admin_screens/classes/all_orders.dart';
import 'package:qb_admin/admin/admin_screens/classes/all_products.dart';
import 'package:qb_admin/blocs/orders/orders_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class Orders extends StatefulWidget {
  const Orders({Key? key}) : super(key: key);

  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrdersBloc, OrdersState>(
      builder: (context, state) {
        if (state is OrdersLoading) {
          return Container(
            color: Colors.white,
            child: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (state is OrdersLoaded) {
          String dropdownValue = 'Status';
          String drpdwnValue = 'Ascending';
          return Scaffold(
            appBar: AppBar(
              title: Text('USER ORDERS'),
              actions: [
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 35,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    value: dropdownValue,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    elevation: 0,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        dropdownValue = newValue!;
                      });
                    },
                    items: <String>['Total', 'Status', 'No. of Products']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                VerticalDivider(
                  width: 15,
                  color: Colors.transparent,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 5),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  height: 35,
                  width: 150,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)),
                  child: DropdownButton<String>(
                    value: drpdwnValue,
                    icon: const Icon(
                      Icons.arrow_downward,
                      color: Colors.black,
                    ),
                    elevation: 0,
                    style: const TextStyle(color: Colors.black),
                    underline: Container(
                      height: 0,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? newValue) {
                      setState(() {
                        drpdwnValue = newValue!;
                      });
                    },
                    items: <String>['Ascending', 'Descending']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ),
                VerticalDivider(
                  width: 25,
                  color: Colors.transparent,
                ),
              ],
            ),
            body: SingleChildScrollView(
              child: SfDataGrid(
                source:
                    OrderDataSource(orderData: state.orders, context: context),
                columnWidthMode: ColumnWidthMode.fill,
                gridLinesVisibility: GridLinesVisibility.both,
                sortingGestureType: SortingGestureType.tap,
                allowTriStateSorting: true,
                columns: <GridColumn>[
                  GridColumn(
                    columnName: 'Customer Details',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Customer Details',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Customer Address',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Customer Address',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  GridColumn(
                    columnName: 'Customer Email',
                    label: Container(
                      padding: const EdgeInsets.all(16.0),
                      child: const Text(
                        'Customer Email',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ),
                  GridColumn(
                      columnName: 'SUBTOTAL',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'SUBTOTAL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                  GridColumn(
                      columnName: 'TOTAL',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'TOTAL',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                  GridColumn(
                      columnName: 'PRODUCTS',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'PRODUCTS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                  GridColumn(
                      columnName: 'STATUS',
                      label: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'STATUS',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ))),
                ],
              ),
            ),
          );
        } else {
          return Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
    );
  }
}
