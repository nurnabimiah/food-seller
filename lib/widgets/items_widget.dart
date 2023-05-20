import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/screens/items_screen.dart';

import '../models/items.dart';
import '../presentation/color_manager.dart';
import 'loading_container.dart';
import '../models/menus.dart';

class ItemsWidget extends StatefulWidget {
  Items? itemModel;
  BuildContext? context;
  bool? netValue;
  ItemsWidget({Key? key, this.itemModel, this.context, this.netValue})
      : super(key: key);

  @override
  State<ItemsWidget> createState() => _ItemsWidgetState();
}

class _ItemsWidgetState extends State<ItemsWidget> {
  bool isLoading = false;
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 2, left: 15, right: 15),
      child: InkWell(
        // height: MediaQuery.of(context).size.height * 0.4,
        // width: MediaQuery.of(context).size.width,
        onTap: () {},
        splashColor: Colors.red,
        child: Column(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "${widget.itemModel!.itemTitle}",
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: widget.itemModel!.itemImageUrl == null
                  ? Container(
                      color: ColorManager.purple1,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                          child: Text(
                        "Image not found", /*style: TextStyle(height: ),*/
                      )))
                  : /*widget.netValue == false
                          ? LoadingContainer()
                          : */
                  Image.network(
                      widget.itemModel!.itemImageUrl!,
                      height: MediaQuery.of(context).size.height * 0.3,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.fill,
                      loadingBuilder: (BuildContext context, Widget child,
                          ImageChunkEvent? loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Center(
                          child: /*CircularProgressIndicator*/ LoadingContainer(
                            value: loadingProgress.expectedTotalBytes != null
                                ? loadingProgress.cumulativeBytesLoaded /
                                    loadingProgress.expectedTotalBytes!
                                : null,
                          ),
                        );
                      },
                    ),
            ),
            Text(
              "${widget.itemModel!.shortInformation}",
              style: TextStyle(fontSize: 16),
              maxLines: 2,
            )
          ],
        ),
      ),
    );
  }
}
