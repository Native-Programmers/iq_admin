// ignore_for_file: camel_case_types, avoid_web_libraries_in_flutter

//un-comment while building web application
// import 'dart:html';

import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:qb_admin/admin/admin_screens/classes/all_products.dart';
import 'package:qb_admin/blocs/products/products_bloc.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:toggle_switch/toggle_switch.dart';

import 'admin_screens/screens/drawer.dart';

final List imageUrl = [];

class dash_Board extends StatefulWidget {
  static const String routeName = '/dash';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (_) => const dash_Board());
  }

  const dash_Board({Key? key}) : super(key: key);

  @override
  _dash_BoardState createState() => _dash_BoardState();
}

class _dash_BoardState extends State<dash_Board> {
  var dropdownValue = 'smartwatch';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('ADMIN PANEL'),
        centerTitle: true,
      ),
      drawer: const Drawers(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder(
                stream:
                    FirebaseFirestore.instance.collection("length").snapshots(),
                builder: (BuildContext context,
                    AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (!snapshot.hasData ||
                      snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Container(
                    margin:
                        const EdgeInsets.symmetric(vertical: 25, horizontal: 5),
                    width: MediaQuery.of(context).size.width,
                    height: 100,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs.map((data) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.grey[100],
                          ),
                          margin: const EdgeInsets.only(right: 25),
                          padding: const EdgeInsets.fromLTRB(10, 10, 0, 10),
                          width: 200,
                          height: 50,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              FittedBox(
                                child: Text(
                                  data['length'].toString(),
                                  style: Theme.of(context).textTheme.headline4,
                                ),
                              ),
                              FittedBox(
                                child: Text(
                                  data['name'],
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  );
                }),
            BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state is ProductLoading) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else if (state is ProductLoaded) {
                  return SfDataGrid(
                    source: ProductsDataSource(
                        productData: state.products, context: context),
                    columnWidthMode: ColumnWidthMode.fill,
                    gridLinesVisibility: GridLinesVisibility.both,
                    sortingGestureType: SortingGestureType.tap,
                    allowTriStateSorting: true,
                    columns: <GridColumn>[
                      GridColumn(
                        columnName: 'name',
                        label: Container(
                          padding: const EdgeInsets.all(16.0),
                          child: const Text(
                            'Name',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      GridColumn(
                        columnName: 'category',
                        label: Container(
                          padding: const EdgeInsets.all(8.0),
                          child: const Text(
                            'Category',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20),
                          ),
                        ),
                      ),
                      GridColumn(
                          columnName: 'price',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Price (PKR)',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
                      GridColumn(
                          columnName: 'desc',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Description',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
                      GridColumn(
                          columnName: 'isRecommended',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Recommended',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
                      GridColumn(
                          columnName: 'isActive',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Availability Status',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
                      GridColumn(
                          columnName: 'Qismat draw',
                          label: Container(
                              padding: const EdgeInsets.all(8.0),
                              child: const Text(
                                'Qismat Draw',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ))),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.brown,
        onPressed: () async {
          final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
          TextEditingController _name = TextEditingController();
          TextEditingController _price = TextEditingController();
          TextEditingController _desc = TextEditingController();
          final String category;
          bool isRecommended = false;
          bool isPopular = false;
          return await add_product_popup(context, _formKey, _name, _price,
              _desc, isPopular, isRecommended);
        },
        label: const Text('Add Product'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Future<void> add_product_popup(
      BuildContext context,
      GlobalKey<FormState> _formKey,
      TextEditingController _name,
      TextEditingController _price,
      TextEditingController _desc,
      bool isPopular,
      bool isRecommended) {
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
                    ...imageUrl.map((items) {
                      return Text(items);
                    }).toList(),
                    TextFormField(
                      controller: _name,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Enter Product Name";
                      },
                      decoration: const InputDecoration(
                        hintText: "Name",
                      ),
                    ),
                    TextFormField(
                      controller: _price,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Enter price";
                      },
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp('[0-9]')),
                      ],
                      decoration: const InputDecoration(
                        hintText: "Price",
                      ),
                    ),
                    TextFormField(
                      controller: _desc,
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      validator: (value) {
                        return value!.isNotEmpty ? null : "Enter description";
                      },
                      decoration: const InputDecoration(
                        hintText: "Description",
                      ),
                    ),
                    const Divider(
                      height: 15,
                      color: Colors.transparent,
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
                              border: Border(),
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
                                'Drop Image Here',
                                style: TextStyle(
                                    fontSize: 10, color: Colors.white),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('categories')
                          .snapshots(),
                      builder: (BuildContext context,
                          AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return const Center(
                            child: Text(
                              'Loading...',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: (kIsWeb ? 16 : 12),
                              ),
                            ),
                          );
                        }
                        return Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: Colors.black),
                            borderRadius:
                                const BorderRadius.all(Radius.circular(30)),
                          ),
                          margin: const EdgeInsets.symmetric(
                            vertical: 10.0,
                            horizontal: 25,
                          ),
                          padding: const EdgeInsets.all(10.0),
                          width: 250,
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              isDense: true,
                              isExpanded: false,
                              hint: const Text("Select"),
                              value: dropdownValue,
                              icon: const Icon(
                                Icons.arrow_drop_down_circle,
                                color: Colors.blue,
                              ),
                              onChanged: (String? newValue) {
                                setState(() {
                                  dropdownValue = newValue.toString();
                                });
                              },
                              items: snapshot.data!.docs.map((map) {
                                return DropdownMenuItem<String>(
                                  value: map["name"].toString(),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                          height: 40,
                                          width: 50,
                                          child:
                                              Image.network(map["imageUrl"])),
                                      Text(
                                        map["name"],
                                        style: const TextStyle(
                                          color: Colors.black,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      height: 15,
                      color: Colors.transparent,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          children: [
                            const Text("is Popular"),
                            ToggleSwitch(
                              minWidth: 40.0,
                              minHeight: 35.0,
                              initialLabelIndex: 0,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              icons: const [
                                Icons.cancel,
                                Icons.done,
                              ],
                              iconSize: 30.0,
                              activeBgColors: const [
                                [Colors.red, Colors.redAccent],
                                [Colors.green, Colors.greenAccent]
                              ],
                              animate:
                                  true, // with just animate set to true, default curve = Curves.easeIn
                              curve: Curves
                                  .bounceInOut, // animate must be set to true when using custom curve
                              onToggle: (index) {
                                if (index == 0) {
                                  isPopular = true;
                                } else {
                                  isPopular = false;
                                }
                              },
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            const Text("isRecommended"),
                            ToggleSwitch(
                              minWidth: 40.0,
                              minHeight: 35.0,
                              initialLabelIndex: 0,
                              cornerRadius: 20.0,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.white,
                              totalSwitches: 2,
                              icons: const [
                                Icons.cancel,
                                Icons.done,
                              ],
                              iconSize: 30.0,
                              activeBgColors: const [
                                [Colors.red, Colors.redAccent],
                                [Colors.green, Colors.greenAccent]
                              ],
                              animate: true,
                              curve: Curves.bounceInOut,
                              onToggle: (index) {
                                if (index == 0) {
                                  isRecommended = true;
                                } else {
                                  isRecommended = false;
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              title: const Text('Product Details'),
              actions: <Widget>[
                ElevatedButton(
                  child: const Text('Submit Product'),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      if (imageUrl.isEmpty) {
                        const ScaffoldMessenger(
                          child: SnackBar(
                            content: Text('Please add product pictures'),
                          ),
                        );
                      } else {
                        EasyLoading.show();
                        FirebaseFirestore.instance.collection('products').add({
                          'category': dropdownValue.toString(),
                          'desc': _desc.text,
                          'name': _name.text,
                          'price': int.parse(_price.text),
                          'imageUrl': imageUrl,
                          'isActive': true,
                          'isRecommended': isRecommended,
                          'isPopular': isPopular,
                        }).then((value) {
                          EasyLoading.dismiss();
                          EasyLoading.showSuccess('Product Added Successfully');

                          setState() {
                            _price.text = '';
                            _name.text = '';
                            _desc.text = '';
                            imageUrl.clear();
                          }

                          Navigator.of(context).pop();
                        }).onError((error, stackTrace) {});
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
        .refFromURL('gs://qbazar-19c41.appspot.com/products')
        .child(name)
        .getDownloadURL();
  }

  void uploadToStorage() {
    final date = DateTime.now();
    final path = '${date.toString()}';
    EasyLoading.show();
    uploadImage(onSelected: (file) {
      EasyLoading.dismiss();
      FirebaseStorage.instance
          .refFromURL('gs://qbazar-19c41.appspot.com/products')
          .child(path)
          .putBlob(file)
          .then((p0) {
        EasyLoading.dismiss();

        return downloadUrl(path).then((value) {
          EasyLoading.showSuccess('Image Uploaded');
          setState(() {
            imageUrl.add(value);
            print(imageUrl.toSet());
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
