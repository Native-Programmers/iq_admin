import 'package:flutter/material.dart';
import 'package:qb_admin/models/banners.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';

class BannersDataSource extends DataGridSource {
  BuildContext context;

  BannersDataSource(
      {required List<Banners> bannerData, required this.context}) {
    _bannerData = bannerData
        .map<DataGridRow>(
          (e) => DataGridRow(cells: [
            DataGridCell<Widget>(
              columnName: 'image',
              value: SizedBox(
                height: 150,
                width: 150,
                child: Image.network(e.imageUrl, fit: BoxFit.contain),
              ),
            ),
          ]),
        )
        .toList();
  }

  List<DataGridRow> _bannerData = [];

  @override
  List<DataGridRow> get rows => _bannerData;

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
