import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/global/global_instance_or_variable.dart';
import 'package:foodfair_seller_app/screens/add_menus_screen.dart';
import 'package:foodfair_seller_app/widgets/my_drawer.dart';
import 'package:foodfair_seller_app/widgets/text_widget_header.dart';
import '../exceptions/error_dialog.dart';
import '../models/menus.dart';
import '../widgets/container_decoration.dart';
import '../widgets/menus_widget.dart';
import '../widgets/loading_container.dart';

class SellerMenusScreen extends StatefulWidget {
  const SellerMenusScreen({Key? key}) : super(key: key);

  @override
  State<SellerMenusScreen> createState() => _SellerMenusScreenState();
}

class _SellerMenusScreenState extends State<SellerMenusScreen> {
  @override
  Widget build(BuildContext context) {
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
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => AddMenusScreen()));
            },
            icon: const Icon(Icons.post_add),
          ),
        ],
      ),
      drawer: MyDrawer(),
      body: CustomScrollView(
        slivers: [
          /*SliverAppBar(
                  actions: [
                    IconButton(onPressed: () {}, icon: Icon(Icons.favorite)),
                  ],
                  //appbar will not disapper
                  pinned: true,
                  //when scroll down star then image will start showing
                  floating: true,
                  expandedHeight: MediaQuery.of(context).size.height * 0.12,
                  title: Transform(
                    // you can forcefully translate values left side using Transform
                    transform: Matrix4.translationValues(-20.0, 0.0, 0.0),
                    child: Text("title"),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: Container(
                      decoration: const ContainerDecoration().decoaration(),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        //crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 35.0, right: 40, bottom: 3, top: 2),
                            child: SizedBox(
                              height: 30,
                              child: TextField(
                                controller: searchController,
                                decoration: InputDecoration(
                                  //isCollapsed: true,
                                  //isDense: true,
                                  contentPadding:
                                      EdgeInsets.only(top: 0, bottom: 0),
                                  border: const OutlineInputBorder(
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(60),
                                    ),
                                    borderSide: BorderSide.none,
                                  ),
                                  /*prefixIcon: const Icon(
                                    Icons.search,
                                    color: Colors.black,
                                    //color: Colors.cyan,
                                  ),*/
                                  prefixIcon: const Align(
                                    widthFactor: 0.5,
                                    //heightFactor: 5.0,
                                    child: Icon(
                                      Icons.search,
                                    ),
                                  ),
                                  filled: true,
                                  fillColor: ColorManager.grey3,
                                  hintText: "search with food or Restaurant",
                                  hintStyle: const TextStyle(
                                    //fontFamily: 'Lexend Deca ',
                                    //color: Color(0xFF95A1AC),
                                    fontSize: 14,
                                    fontWeight: FontWeight.normal,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),*/

          SliverPersistentHeader(
            pinned: true,
            delegate: TextWidgetHeader(title: "My Menus"),
          ),
          StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("sellers")
                .doc(sPref!.getString("uid"))
                .collection("menus")
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
                          Menus menuModel = Menus.fromJson(
                              snapshot.data!.docs[index].data()
                                  as Map<String, dynamic>);
                          print(
                              "MenuId sellerHome = ${menuModel.menuID} + HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
                          print(
                              "image sellerHome = ${menuModel.menuID} + HHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHHH");
                          return MenusWidget(
                            model: menuModel,
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
