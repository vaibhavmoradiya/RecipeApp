import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:recipe_app/auth/auth.dart';
import 'package:recipe_app/login_admin/menu_page.dart';
import 'package:recipe_app/model/user_model.dart';
import 'package:google_fonts/google_fonts.dart';


class LoginPage extends StatefulWidget {
  LoginPage({this.auth, this.onSignIn});

  final BaseAuth auth;
  final VoidCallback onSignIn;

  @override
  _LoginPageState createState() => _LoginPageState();
}

enum FormType { login, Register }
enum SelectSource { camera, gallery }

class _LoginPageState extends State<LoginPage> {

  final formKey = GlobalKey<FormState>();
  //Declaration Of  variables
  String _email;
  String _password;
  String _name;
  String _mobileno;
  String _itemCity;
  String _Address;
  String _urlphoto = '';
  String user;


  bool _obscureText = true;
  FormType _formType = FormType.login;
  List<DropdownMenuItem<String>> _cityItems;//list city from Firestore


  @override
  void initState() {
    super.initState();
    setState(() {
      _cityItems = getCityItems();
      _itemCity = _cityItems[0].value;
    });
  }

  getData() async {
    return await Firestore.instance.collection('cities').getDocuments();
  }

  //Dropdownlist from firestore
  List<DropdownMenuItem<String>> getCityItems() {
    List<DropdownMenuItem<String>> items = List();
    QuerySnapshot dataCiudades;
    getData().then((data) {

      dataCiudades = data;
      dataCiudades.documents.forEach((obj) {
        print('${obj.documentID} ${obj['name']}');
        items.add(DropdownMenuItem(
          value: obj.documentID,
          child: Text(obj['name']),
        ));
      });
    }).catchError((error) => print(' error.....' + error));

    items.add(DropdownMenuItem(
      value: '0',
      child: Text('- Select city -'),
    ));

    return items;
  }


  bool _validatesave() {
    final form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  //we create a method validate and send
  void _validateSubmit() async {
    if (_validatesave()) {
      try {
        String userId = await widget.auth.signInEmailPassword(_email, _password);
        print('User logged in: $userId ');//ok
        widget.onSignIn();
        HomePage(auth: widget.auth);  //return menu_page.dart
        Navigator.of(context).pop();
      } catch (e) {
        print('Error .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Error in Autenticación'),
          title: Text('Error'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }

  //Now create a method validate and register
  void _validateRegister() async {
    if (_validatesave()) {
      try{
        User usuario = User(//model/user_model.dart instance usuario
            name: _name,
            city: _itemCity,
            address: _Address,
            email: _email,
            password: _password,
            mobileno: _mobileno,
            photo: _urlphoto);
        String userId = await widget.auth.signUpEmailPassword(usuario);
        print('User logged in : $userId');//ok
        widget.onSignIn();
        HomePage(auth: widget.auth);  //menu_page.dart
        Navigator.of(context).pop();
      }catch (e){
        print('Error .... $e');
        AlertDialog alerta = new AlertDialog(
          content: Text('Error in register'),
          title: Text('Error'),
          actions: <Widget>[],
        );
        showDialog(context: context, child: alerta);
      }
    }
  }
  //method go register
  void _isRegister() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.Register;
    });
  }

  //method go Login
  void _irLogin() {
    setState(() {
      formKey.currentState.reset();
      _formType = FormType.login;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Recipes'),
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Container(
              padding: EdgeInsets.all(16.0),
              child: Center(
                  child: Form(
                    key: formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment
                            .stretch, //ajusta los widgets a lso extremos
                        children: [
                          Padding(padding: EdgeInsets.only(top: 15.0)),
                          Text(
                            'World Recipes \n My recipes',
                            textAlign: TextAlign.center,
                            style: GoogleFonts.lato(),
                          ),
                          Padding(padding: EdgeInsets.only(bottom: 15.0)),
                        ] +
                            buildInputs() +
                            buildSubmitButtons()),
                  )))
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.login) {
      return [ //list or array
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
          value.isEmpty ? 'Email field is empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.text,
          obscureText: _obscureText,
          decoration: InputDecoration(
              labelText: 'Password',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )
          ),
          validator: (value) => value.isEmpty
              ? 'The password field must be \n at least 6 characters'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    } else {
      return [
        Row(mainAxisAlignment: MainAxisAlignment.center,),
        Text('User Registration', style: TextStyle(color: Colors.black, fontStyle: FontStyle.italic, fontWeight: FontWeight.bold),),
        TextFormField(
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              labelText: 'Name', icon: Icon(FontAwesomeIcons.user)),
          validator: (value) =>
          value.isEmpty ? 'The Name field is empty' : null,
          onSaved: (value) => _name = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.phone,
          decoration: InputDecoration(
            labelText: 'Mobile No.',
            icon: Icon(FontAwesomeIcons.mobile),
          ),
          validator: (value) =>
          value.isEmpty ? 'Mobile No. field is empty' : null,
          onSaved: (value) => _mobileno = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        DropdownButtonFormField(
          validator: (value) =>
          value == '0' ? 'You must select a city' : null,
          decoration: InputDecoration(
              labelText: 'city', icon: Icon(FontAwesomeIcons.city)),
          value: _itemCity,
          items: _cityItems,
          onChanged: (value) {
            setState(() {
              _itemCity = value;
            });
          }, //seleccionarCiudadItem,
          onSaved: (value) => _itemCity = value,
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
            keyboardType: TextInputType.text,
            decoration: InputDecoration(
              labelText: 'Address',
              icon: Icon(Icons.person_pin_circle),
            ),
            validator: (value) =>
            value.isEmpty ? 'The Address field is empty' : null,
            onSaved: (value) => _Address = value.trim()),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
            labelText: 'Email',
            icon: Icon(FontAwesomeIcons.envelope),
          ),
          validator: (value) =>
          value.isEmpty ? 'The Email field is empty' : null,
          onSaved: (value) => _email = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
        ),
        TextFormField(
          obscureText: _obscureText,//password
          decoration: InputDecoration(
                labelText: 'Password',
              icon: Icon(FontAwesomeIcons.key),
              suffixIcon: GestureDetector(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: Icon(
                  _obscureText ? Icons.visibility : Icons.visibility_off,
                ),
              )),
          validator: (value) => value.isEmpty
              ? 'The password field must be \n nal least 6 characters'
              : null,
          onSaved: (value) => _password = value.trim(),
        ),
        Padding(
          padding: EdgeInsets.all(10.0),
        ),
      ];
    }
  }

  List<Widget> buildSubmitButtons() {
    if (_formType == FormType.login) {
      return [
        RaisedButton(
          onPressed: _validateSubmit,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Log In",
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
          child: Text(
            'Create New Account',//create new acount
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
          onPressed: _isRegister,
        ),
      ];
    } else {
      return [
        RaisedButton(
          onPressed:  _validateRegister,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                "Register New account",//register new acount
                style: TextStyle(color: Colors.white, fontSize: 15.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
              ),
              Icon(
                FontAwesomeIcons.plusCircle,
                color: Colors.white,
              )
            ],
          ),
          color: Colors.orangeAccent,
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(7.0)),
          ),
          elevation: 8.0,
        ),
        FlatButton(
          child: Text(
            'Do you already have an account?',
            style: TextStyle(fontSize: 20.0, color: Colors.grey),
          ),
          onPressed: _irLogin,
        )
      ];
    }
  }
}