import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/exceptions/progress_bar.dart';

class ErrorDialog extends StatelessWidget {
  final String? message;
  ErrorDialog({this.message});

  @override
  Widget build(BuildContext context) {
    // return AlertDialog(
    //   key: key,
    //   title: const Text("An error occurred!", style: TextStyle(color: Colors.red, fontSize: 17),),
    //   content: Text(message!),
    //   actions: [
    // TextButton(
    //   onPressed: () {
    //     Navigator.pop(context);
    //   },
    //   child: const Text("Ok",style: TextStyle(fontSize: 17,)),
    //   style: TextButton.styleFrom(
    //     primary: Colors.red,
    //   ),
    // ),
    //   ],
    // );
    return AlertDialog(
      key: key,
      title: Text(message!),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Ok!",
                style: TextStyle(
                  fontSize: 17,
                )),
            style: TextButton.styleFrom(
              primary: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
