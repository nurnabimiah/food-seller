import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/exceptions/progress_bar.dart';
import 'package:foodfair_seller_app/global/global_instance_or_variable.dart';
import 'package:foodfair_seller_app/widgets/container_decoration.dart';
import 'package:image_picker/image_picker.dart';
import '../exceptions/error_dialog.dart';
import '../models/menus.dart';
import '../presentation/color_manager.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddItemsScreen extends StatefulWidget {
  Menus? model;
  AddItemsScreen({this.model});

  @override
  State<AddItemsScreen> createState() => _AddItemsScreenState();
}

class _AddItemsScreenState extends State<AddItemsScreen> {
  final _informationController = TextEditingController();
  final _titleController = TextEditingController();
  final _pirceController = TextEditingController();
  final _descriptionController = TextEditingController();

  final _informationFocusNode = FocusNode();
  final _titlelFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  XFile? _imageXFile;
  final ImagePicker _picker = ImagePicker();
  bool? _isUploading;
  String? _uniqueIdOfItemImage;
  var _imagePath;
  String? _itemImageUrl;

  CaptureImageWithCamera() async {
    Navigator.pop(context);
    _imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      _imagePath = File(_imageXFile!.path);
    });
  }

  CaptureImageWithGallery() async {
    Navigator.pop(context);
    _imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
    );
    setState(() {
      _imagePath = File(_imageXFile!.path);
    });
  }

  takeImage(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            //title: Text("Menu Image"),
            alignment: Alignment.topCenter,
            //shape: ShapeBorder.lerp(a, b, t),
            children: [
              SimpleDialogOption(
                child: const Text(
                  "Camera",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: CaptureImageWithCamera,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Gallery",
                  style: TextStyle(color: Colors.grey),
                ),
                onPressed: CaptureImageWithGallery,
              ),
              SimpleDialogOption(
                child: const Text(
                  "Cancel",
                  style: TextStyle(color: Colors.red),
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          );
        });
  }

  saveDataToFireStore() {
    try {
      final ref = FirebaseFirestore.instance
          .collection("sellers")
          .doc(sPref!.getString("uid"))
          .collection("menus")
          .doc(widget.model!.menuID)
          .collection("items");

      ref.doc(_uniqueIdOfItemImage).set({
        "itemID": _uniqueIdOfItemImage,
        "menuID": widget.model!.menuID,
        "sellerUID": sPref!.getString("uid"),
        "sellerName": sPref!.getString("name"),
        "shortInformation": _informationController.text.toString(),
        "itemTitle": _titleController.text.toString(),
        "itemDescription": _descriptionController.text.toString(),
        "price": double.parse(_pirceController.text),
        "publishedDate": DateTime.now(),
        "status": "avialable",
        "itemImageUrl": _itemImageUrl,
      }).then((value) {
        //this for duplicate storing in fireStore database.
        final itemRef = FirebaseFirestore.instance.collection("items");

        itemRef.doc(_uniqueIdOfItemImage).set({
          "itemId": _uniqueIdOfItemImage,
          "menuID": widget.model!.menuID,
          "sellerUID": sPref!.getString("uid"),
          "sellerName": sPref!.getString("name"),
          "shortInformation": _informationController.text.toString(),
          "itemTitle": _titleController.text.toString(),
          "itemDescription": _descriptionController.text.toString(),
          "price": double.parse(_pirceController.text),
          "publishedDate": DateTime.now(),
          "status": "avialable",
          "itemImageUrl": _itemImageUrl,
        });
      }).then((value) {
        clearMenusUploadForm();
        _uniqueIdOfItemImage = DateTime.now().microsecondsSinceEpoch.toString();
        _isUploading = false;
      });
    } catch (error) {
      ErrorDialog(
        message: "something wrong!. Try later",
      );
    }

    // setState(() {
    //   _uniqueIdOfItemImage = DateTime.now().microsecondsSinceEpoch.toString();
    //   _isUploading = false;

    // });
  }

  uploadItemImage() async {
    _uniqueIdOfItemImage = DateTime.now().microsecondsSinceEpoch.toString();
    UploadTask? uploadTask;
    try {
      Reference refer = FirebaseStorage.instance.ref().child("ItemImages");
      uploadTask =
          refer.child(_uniqueIdOfItemImage! + ".jpg").putFile(_imagePath);
    } on FirebaseException catch (error) {
      ErrorDialog(
        message: error.message,
      );
    } catch (error) {
      var err =
          "An unknown error occurrred.\n\nplease check internet connection";
      ErrorDialog(
        message: err,
      );
    }
    TaskSnapshot snapshot = await uploadTask!.whenComplete(() {});
    await snapshot.ref.getDownloadURL().then((url) {
      _itemImageUrl = url;
      saveDataToFireStore();
    });
  }

  checkingValidateAndUploadData() {
    if (_imageXFile == null) {
      return showDialog(
          context: context,
          builder: (context) {
            return ErrorDialog(
              message: "Please upload an image",
            );
          });
    }
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    setState(() {
      _isUploading = true;
    });

    uploadItemImage();
  }

  clearMenusUploadForm() {
    setState(() {
      _titleController.clear();
      _descriptionController.clear();
      _pirceController.clear();
      _informationController.clear();
      _imageXFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    print(
        " 2 menuId = ${widget.model!.menuID} + MMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM");
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: ContainerDecoration().decoaration(),
        ),
        title: const Text("Add new Item"),
        actions: [
          IconButton(
            onPressed: _isUploading == true
                ? null
                : () => checkingValidateAndUploadData(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body: _isUploading == true
          ? circularProgress()
          : SingleChildScrollView(
              child: Container(
                decoration: const ContainerDecoration().decoaration(),
                height: MediaQuery.of(context).size.height,
                width: double.infinity,
                child: Column(
                  children: [
                    // _isUploading == true ? circularProgress() : const Text(""),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: InkWell(
                        onTap: () {
                          takeImage(context);
                        },
                        child: _imageXFile == null
                            ? Card(
                                elevation: 10,
                                child: Container(
                                  //margin: const EdgeInsets.only(top: 15),
                                  height:
                                      MediaQuery.of(context).size.height * 0.20,
                                  width:
                                      MediaQuery.of(context).size.width * 0.60,
                                  decoration: BoxDecoration(
                                    color: ColorManager.whiteOnly,
                                    //border: Border.all(width: 1, color: ColorManager.grey2),
                                  ),
                                  child: const Center(
                                      child: Text(
                                    "Upload an image",
                                    style: TextStyle(
                                        fontSize: 24, color: Colors.black),
                                  )),
                                ),
                              )
                            : Container(
                                //margin: const EdgeInsets.only(),
                                height:
                                    MediaQuery.of(context).size.height * 0.30,
                                width: MediaQuery.of(context).size.width * 0.95,
                                decoration: BoxDecoration(
                                  color: ColorManager.whiteOnly,
                                  image: DecorationImage(
                                    image: FileImage(File(_imageXFile!.path)),
                                    //scale: 2,
                                    fit: BoxFit.fill,
                                  ),
                                  //border: Border.all(width: 1, color: ColorManager.grey2),
                                ),
                              ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    formOfItem(context),
                  ],
                ),
              ),
            ),
    );
  }

  formOfItem(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'info',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                textInputAction: TextInputAction.next,
                controller: _informationController,
                focusNode: _informationFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_titlelFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please give short information.';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Title',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                textInputAction: TextInputAction.next,
                controller: _titleController,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please give a title.';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Price',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                controller: _pirceController,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (_) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a price.';
                  }
                  //tryParse may check wheather it is null or not
                  if (double.tryParse(value) == null) {
                    return 'Please enter a valid number.';
                  }
                  if (double.parse(value) <= 0) {
                    return 'Please enter a number greater than zero.';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
              const SizedBox(
                height: 15,
              ),
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Description',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: _descriptionController,
                focusNode: _descriptionFocusNode,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter a description.';
                  }
                  if (value.length < 3) {
                    return 'Should be at least 3 characters long.';
                  }
                  return null;
                },
                onSaved: (value) {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
