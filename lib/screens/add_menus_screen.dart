import 'dart:io';
import 'package:flutter/material.dart';
import 'package:foodfair_seller_app/exceptions/progress_bar.dart';
import 'package:foodfair_seller_app/global/global_instance_or_variable.dart';
import 'package:foodfair_seller_app/widgets/container_decoration.dart';
import 'package:image_picker/image_picker.dart';
import '../exceptions/error_dialog.dart';
import '../presentation/color_manager.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddMenusScreen extends StatefulWidget {
  @override
  State<AddMenusScreen> createState() => _AddMenusScreenState();
}

class _AddMenusScreenState extends State<AddMenusScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _titleController = TextEditingController();
  final __shortInformationController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();

  XFile? _imageXFile;
  final ImagePicker _picker = ImagePicker();
  bool? _isUploading;
  String? _uniqueIdOfMenuImage;
  var _imagePath;
  String? _menuImageUrl;

  

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
          .collection("menus");

      ref.doc(_uniqueIdOfMenuImage).set({
        "menuID": _uniqueIdOfMenuImage,
        "sellerUID": sPref!.getString("uid"),
        "menuTitle": _titleController.text.toString(),
        "menuShortInformation": __shortInformationController.text.toString(),
        "publishedDate": DateTime.now(),
        "status": "avialable",
        "menuImageUrl": _menuImageUrl,
      });
    } catch (error) {
      ErrorDialog(
        message: "something wrong!. Try later",
      );
    }

    setState(() {
      _uniqueIdOfMenuImage = DateTime.now().microsecondsSinceEpoch.toString();
      _isUploading = false;
      clearMenusUploadForm();
    });
  }

  uploadMenuImage() async {
    _uniqueIdOfMenuImage = DateTime.now().microsecondsSinceEpoch.toString();
    UploadTask? uploadTask;
    try {
      Reference refer = FirebaseStorage.instance.ref().child("menuImages");
      uploadTask = refer.child(_uniqueIdOfMenuImage! + ".jpg").putFile(_imagePath);
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
      _menuImageUrl = url;
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

    uploadMenuImage();
  }

  clearMenusUploadForm() {
    setState(() {
      _titleController.clear();
      __shortInformationController.clear();
      _imageXFile = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: ContainerDecoration().decoaration(),
        ),
        title: const Text("Add new Menu"),
        actions: [
          IconButton(
            onPressed: _isUploading == true
                ? null
                : () => checkingValidateAndUploadData(),
            icon: const Icon(Icons.save),
          ),
        ],
      ),
      body:  _isUploading == true ? circularProgress() : SingleChildScrollView(
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
                            height: MediaQuery.of(context).size.height * 0.20,
                            width: MediaQuery.of(context).size.width * 0.60,
                            decoration: BoxDecoration(
                              color: ColorManager.whiteOnly,
                              //border: Border.all(width: 1, color: ColorManager.grey2),
                            ),
                            child: const Center(
                                child: Text(
                              "Upload an image",
                              style:
                                  TextStyle(fontSize: 24, color: Colors.black),
                            )),
                          ),
                        )
                      : Container(
                          //margin: const EdgeInsets.only(),
                          height: MediaQuery.of(context).size.height * 0.30,
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
                    return 'Please provide a value.';
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
                  labelText: 'short Information',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                ),
                maxLines: 3,
                keyboardType: TextInputType.multiline,
                controller: __shortInformationController,
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
