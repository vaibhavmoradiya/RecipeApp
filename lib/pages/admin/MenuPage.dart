import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../Dishes/gujratiDish.dart';
import '../Dishes/punjabiDish.dart';
import '../Dishes/chaineseDish.dart';
import '../Dishes/southIndianDish.dart';




class MyHomePage extends StatefulWidget {

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

 
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
     // appBar: AppBar(
      
      //),
      body: ListView(
          padding: const EdgeInsets.all(8),
          children: <Widget>[
                Container(  
                  width: 300,  
                  height: 200,  
                  padding: new EdgeInsets.all(10.0),  
                  child: Card(  
                    shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(15.0),  
                    ),  
                    color: Colors.lightGreenAccent,  
                    elevation: 10,  
                    child: Column(  
                      mainAxisSize: MainAxisSize.min,  
                      children: <Widget>[  
                        const ListTile(  
                          leading: Icon(Icons.fastfood, size: 60),  
                          title: Text(  
                            'Gujarati Dishes',  
                            style: TextStyle(fontSize: 30.0)  
          
                          ),   
                        ),  
                        ButtonBar(  
                          children: <Widget>[  
                            RaisedButton(  
                              child: const Text('View'),  
                              onPressed: () {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => GujaratiDish()),
                                  );
                              },  
                            ),  
                          
                          ],  
                        ),  
                      ],  
                    ),  
              ),
                
            ),

            Container(  
                  width: 300,  
                  height: 200,  
                  padding: new EdgeInsets.all(10.0),  
                  child: Card(  
                    shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(15.0),  
                    ),  
                    color: Colors.orangeAccent,  
                    elevation: 10,  
                    child: Column(  
                      mainAxisSize: MainAxisSize.min,  
                      children: <Widget>[  
                        const ListTile(  
                          leading: Icon(Icons.fastfood, size: 60),  
                          title: Text(  
                            'Punjabi Dishes',  
                            style: TextStyle(fontSize: 30.0)  
          
                          ),   
                        ),  
                        ButtonBar(  
                          children: <Widget>[  
                            RaisedButton(  
                              child: const Text('View'),  
                              onPressed: () {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => PunjabiDish()),
                                  );
                              },  
                            ),  
                          
                          ],  
                        ),  
                      ],  
                    ),  
              ),
                
            ), 


Container(  
                  width: 300,  
                  height: 200,  
                  padding: new EdgeInsets.all(10.0),  
                  child: Card(  
                    shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(15.0),  
                    ),  
                    color: Colors.tealAccent,  
                    elevation: 10,  
                    child: Column(  
                      mainAxisSize: MainAxisSize.min,  
                      children: <Widget>[  
                        const ListTile(  
                          leading: Icon(Icons.fastfood, size: 60),  
                          title: Text(  
                            'Southindian Dishes',  
                            style: TextStyle(fontSize: 30.0)  
          
                          ),   
                        ),  
                        ButtonBar(  
                          children: <Widget>[  
                            RaisedButton(  
                              child: const Text('View'),  
                              onPressed: () { 
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => SouthIndianDish()),
                                  );
                                  },  
                            ),  
                          
                          ],  
                        ),  
                      ],  
                    ),  
              ),
                
            ),
            Container(  
                  width: 300,  
                  height: 200,  
                  padding: new EdgeInsets.all(10.0),  
                  child: Card(  
                    shape: RoundedRectangleBorder(  
                      borderRadius: BorderRadius.circular(15.0),  
                    ),  
                    color: Colors.greenAccent,  
                    elevation: 10,  
                    child: Column(  
                      mainAxisSize: MainAxisSize.min,  
                      children: <Widget>[  
                        const ListTile(  
                          leading: Icon(Icons.fastfood, size: 60),  
                          title: Text(  
                            'Chainese Dishes',  
                            style: TextStyle(fontSize: 30.0)  
          
                          ),   
                        ),  
                        ButtonBar(  
                          children: <Widget>[  
                            RaisedButton(  
                              child: const Text('View'),  
                              onPressed: () {
                                 Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) => ChaineseDish()),
                                  );
                              },  
                            ),  
                          
                          ],  
                        ),  
                      ],  
                    ),  
              ),
                
            ) 


          ],
      ),
    );
  }
}