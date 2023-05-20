import 'package:flutter/material.dart';

class LoadingContainer extends StatelessWidget {
  var value;
  LoadingContainer({this.value});
  Widget build(context) {
    return Column(
      children: [
        buildContainer(context),
        buildContainer(context),
        buildContainer(context),
        buildContainer(context),
      ],
    );
  }

  Widget buildContainer(BuildContext context) {
    return InkWell(
      onTap: (){},
      //excludeFromSemantics: true,
      child: Container(
        color: Colors.grey[200],
        height: MediaQuery.of(context).size.height * 0.05,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 5, bottom: 5),
      ),
    );
  }
}
