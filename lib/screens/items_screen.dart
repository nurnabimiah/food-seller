import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/models/menus.dart';
import 'package:foodfair_seller_app/widgets/text_widget_header.dart';

import '../exceptions/error_dialog.dart';
import '../global/global_instance_or_variable.dart';
import '../models/items.dart';
import '../widgets/container_decoration.dart';
import '../widgets/items_widget.dart';
import '../widgets/loading_container.dart';
import '../widgets/menus_widget.dart';
import '../widgets/my_drawer.dart';
import 'add_items_screen.dart';

class ItemsScreen extends StatefulWidget {
  final Menus? model;
  ItemsScreen({this.model});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState();
}

class _ItemsScreenState extends State<ItemsScreen> {
  @override
  Widget build(BuildContext context) {
    print(
        " 1 menuId = ${widget.model!.menuID} + MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
    return Scaffold(
      appBar: AppBar(
        title: Text("${sPref!.getString("name")}"),
        centerTitle: true,
        //automaticallyImplyLeading: false,
        flexibleSpace: Container(
          decoration: const ContainerDecoration().decoaration(),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddItemsScreen(
                            model: widget.model,
                          )));
            },
            icon: const Icon(Icons.library_add),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
              pinned: true,
              delegate: TextWidgetHeader(
                  title:
                      "My " + widget.model!.menuTitle.toString() + " Items")),
          StreamBuilder(
            // stream: getDataFromFirebase()!.snapshots(),
            // stream: FirebaseFirestore.instance.collection("sellers").snapshots(),
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sPref!.getString("uid"))
                .collection("menus")
                .doc(widget.model!.menuID)
                .collection("items")
                .orderBy("publishedDate", descending: true)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot?> snapshot) {
              //print("m = ${snapshot[""]} + KKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKKK");
              // snapshot.forEach((movieObject) {
              //  print(movieObject);
              // }).toList();
              if (snapshot.hasError) {
                ErrorDialog(
                  message: "${snapshot.error}",
                );
                //return  Text('Error: ${snapshot.error}');
              }
              if (snapshot.hasError) {
                return Text("No net");
              }

              return !snapshot.hasData
                  ? SliverToBoxAdapter(
                      child: Center(
                        child: LoadingContainer(),
                      ),
                    )
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          Items itemModel = Items.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          print(
                              "MenuId sellerHome = ${itemModel.menuID} + HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
                          print(
                              "image sellerHome = ${itemModel.menuID} + HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
                          return ItemsWidget(
                            itemModel: itemModel,
                            context: context,
                            //netValue: model.isOnline,
                          );
                        },
                        childCount: snapshot.data!.docs.length,
                      ),
                    );
            },
          ),
        ],
      ),
    );
  }
}
