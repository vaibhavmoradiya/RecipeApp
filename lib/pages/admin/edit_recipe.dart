import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart' as img;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/auth/auth.dart';
import 'package:recipe_app/model/recipe_model.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class EditRecipe extends StatefulWidget {

  EditRecipe({this.recipe, this.idRecipe, this.uid});
  final String idRecipe;
  final String uid;
  final Recipe recipe;

  @override
  _EditRecipeState createState() => _EditRecipeState();
}

enum SelectSource { camara, galeria }

class _EditRecipeState extends State<EditRecipe> {

  final formKey = GlobalKey<FormState>();
  String _name;
  String _recipe;
  File _image; //
  String urlFoto = '';
  Auth auth = Auth();
  bool _isInAsyncCall = false;
  String usuario;

  BoxDecoration box = BoxDecoration(
      border: Border.all(width: 1.0, color: Colors.black),
      shape: BoxShape.circle,
      image: DecorationImage(
          fit: BoxFit.fill,
          image:AssetImage('assets/images/azucar.gif') ));

  @override
  void initState() {
    setState(() {
      this._name = widget.recipe.name;
      this._recipe = widget.recipe.recipe;
      captureImage(null, widget.recipe.image);
    });

    print('uid recipe : '+widget.idRecipe);
    super.initState();
  }

  //create method for download url image
  static var httpClient = new HttpClient();
  Future<File> _downloadFile(String url, String filename) async {
    var request = await httpClient.getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    String dir = (await getApplicationDocumentsDirectory()).path;
    File file = new File('$dir/$filename');
    await file.writeAsBytes(bytes);
    return file;
  }

  Future captureImage(SelectSource opcion, String url) async {
    File image;
    if (url == null) {
      print('image');
      opcion == SelectSource.camara
          ? image = await img.ImagePicker.pickImage(
          source: img.ImageSource.camera) //source: ImageSource.camera)
          : image =
      await img.ImagePicker.pickImage(source: img.ImageSource.gallery);

      setState(() {
        _image = image;
        box = BoxDecoration(
            border: Border.all(width: 1.0, color: Colors.black),
            shape: BoxShape.circle,
            image: DecorationImage(
                fit: BoxFit.fill,
                image:FileImage(_image) ));

      });
    } else {
      print('download the image');
      _downloadFile(url, widget.recipe.name).then((onValue) {
        _image = onValue;
        setState(() {
          box = BoxDecoration(
              border: Border.all(width: 1.0, color: Colors.black),
              shape: BoxShape.circle,
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image:FileImage(_image) ));
          ////  imageReceta = FileImage(_foto);
        });

        // : FileImage(_imagen)))

      });
    }
  }

  Future getImage() async {
    AlertDialog alerta = new AlertDialog(
      content: Text('Select to capture the image'),
      title: Text('Select Image'),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.camara;
            captureImage(SelectSource.camara, null);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Camera'), Icon(Icons.camera)],
          ),
        ),
        FlatButton(
          onPressed: () {
            // seleccion = SelectSource.galeria;
            captureImage(SelectSource.galeria, null);
            Navigator.of(context, rootNavigator: true).pop();
          },
          child: Row(
            children: <Widget>[Text('Gallery'), Icon(Icons.image)],
          ),
        )
      ],
    );
    showDialog(context: context, child: alerta);
  }

  bool _validar() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  void _enviar() { //send the information to firestore
    if (_validar()) {
      setState(() {
        _isInAsyncCall = true;
      });
      auth.currentUser().then((onValue) {
        setState(() {
          usuario = onValue;
        });
        if (_image != null) {
          final StorageReference fireStoreRef = FirebaseStorage.instance
              .ref()
              .child('colrecipes')
              .child('$_name.jpg');
          final StorageUploadTask task = fireStoreRef.putFile(
              _image, StorageMetadata(contentType: 'image/jpeg'));

          task.onComplete.then((onValue) {
            onValue.ref.getDownloadURL().then((onValue) {
              setState(() {
                urlFoto = onValue.toString();
                Firestore.instance
                    .collection('colrecipes')
                    .document(widget.idRecipe).updateData({
                  'name': _name,
                  'image': urlFoto,
                  'recipe': _recipe,
                }).then((value) => Navigator.of(context).pop())
                    .catchError((onError) =>
                    print('Error editing the recipe in the database'));
                _isInAsyncCall = false;
              });
            });
          });
        } else {
          Firestore.instance
              .collection('colrecipes')
              .add({
            'name': _name,
            'image': urlFoto,
            'recipe': _recipe
          })
              .then((value) => Navigator.of(context).pop())
              .catchError(
                  (onError) => print('Error editing the recipe in the database'));
          _isInAsyncCall = false;
        }
      }).catchError((onError) => _isInAsyncCall = false);
    } else {
      print('object not validated');
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Recipe Edit'),
        ),
        body: ModalProgressHUD(
            inAsyncCall: _isInAsyncCall,
            opacity: 0.5,
            dismissible: false,
            progressIndicator: CircularProgressIndicator(),
            color: Colors.blueGrey,
            child: SingleChildScrollView(
              padding: EdgeInsets.only(left: 10, right: 15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: <
                        Widget>[
                      Container(
                          child: GestureDetector(
                            onDoubleTap: getImage,
                          ),
                          margin: EdgeInsets.only(top: 20),
                          height: 120,
                          width: 120,
                          decoration: box
                      )
                    ]),
                    Text('Double click to change image'),
                    Padding(
                      padding: EdgeInsets.only(top: 10),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _name,
                      decoration: InputDecoration(
                        labelText: 'Name',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _name = value.trim(),
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      initialValue: _recipe,
                      decoration: InputDecoration(
                        labelText: 'Recipe',
                      ),
                      validator: (value) =>
                      value.isEmpty ? 'The Name field is empty' : null,
                      onSaved: (value) => _recipe = value.trim(),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 50),
                    )
                  ],
                ),
              ),
            )),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.orange,
            onPressed: _enviar,
            child: Icon(Icons.edit)),
        bottomNavigationBar: BottomAppBar(
          elevation: 20.0,
          color: Colors.blue,
          child: ButtonBar(),
        ));
  }
}