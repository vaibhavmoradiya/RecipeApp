import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:recipe_app/auth/auth.dart';
import 'package:recipe_app/login_admin/contentPage.dart';
import 'package:recipe_app/widgets/home_page.dart';
import 'package:recipe_app/pages/admin/MenuPage.dart';
//import 'package:recipe_app/pages/admin/mostrargrid_page.dart';
import 'package:recipe_app/widgets/home_page.dart';

const PrimaryColor = const Color(0xFF19212B);

class HomePage extends StatefulWidget {
  HomePage({this.auth, this.onSignedOut});
  final BaseAuth auth;
  final VoidCallback onSignedOut;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String user = 'User';//user
  String userEmail = 'Email';//userEmail
  String id;

  Content page = ContentPage() ;

  Widget contentPage = HomePageRecipes();//Page principal recetas


  void _signOut() async {
    try {
      widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.auth.infoUser().then((onValue) {
      setState(() {
        user = onValue.displayName;
        userEmail = onValue.email;
        id=onValue.uid;
        print('ID $id');
      });
    }
    );
  }

  //from now you can see the code in Github of all this
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          elevation: 30.0,
          child: Container(
            color: Color(0xFF19212B),
            child: ListView(
              children: <Widget>[
                UserAccountsDrawerHeader(
                  currentAccountPicture: CircleAvatar(
                    maxRadius: 10.0,
                    backgroundImage: AssetImage('assets/images/cocina.jpg'),
                    //backgroundImage: NetworkImage('https://abc'),
                  ),
                  accountName: Text(
                    '$user',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  accountEmail: Text('$userEmail',
                      style: TextStyle(color: Colors.white)),
                  decoration: BoxDecoration(
                      color: Color(0xFF262F3D),
                      image: DecorationImage(
                        alignment: Alignment(1.0, 0),
                        image: AssetImage(
                          'assets/images/misanplas.jpg',
                        ),
                        fit: BoxFit.scaleDown, //BoxFit.fitHeight
                      )),
                ),

                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.lista().then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(Icons.home, color: Color(0xFF4FC3F7),),
                  title: Text('Home', style: TextStyle(color: Colors.white),),
                ),
                Divider(height: 2.0, color: Colors.white,),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.myrecipe(id).then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(FontAwesomeIcons.pizzaSlice, color: Color(0xFF4FC3F7),),
                  title: Text('My Recipe', style: TextStyle(color: Color(0xFF4FC3F7)),),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.admin().then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                  },
                  leading: Icon(Icons.contact_mail, color: Color(0xFF4FC3F7),),
                  title: Text('Admin', style: TextStyle(color: Color(0xFF4FC3F7)),),
                ),
                ListTile(
                  onTap: () {
                    Navigator.of(context).pop();
                    page.menu().then((value) {
                      print(value);
                      setState(() {
                        contentPage = value;
                      });
                    });
                 },
                  leading: Icon(Icons.restaurant_menu, color: Color(0xFF4FC3F7),),
                  title: Text('Menu', style: TextStyle(color: Color(0xFF4FC3F7)),),
                 
                ),
                ListTile(
                  title: Text('Logout', style: TextStyle(color: Color(0xFF4FC3F7)),),
                  leading: Icon(Icons.exit_to_app, color: Color(0xFF4FC3F7),),
                  onTap: () {
                    Navigator.of(context).pop();
                    _signOut();
                  },
                ),
              ],
            ),
          )),
      appBar: AppBar(
        backgroundColor: PrimaryColor,
        title: Text('Recipes'),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(Icons.grid_on),
        //     tooltip: 'Grid',
        //     onPressed: () {
        //       //   Route route = MaterialPageRoute(builder: (context) => GridPageInicio());
        //       //  Navigator.push(context, route);
        //     },
        //   ),
        // ],
      ),
      body: contentPage,
    );
  }
}