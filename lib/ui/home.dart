import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utility/util.dart' as util;



class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

String gotCity = util.defaultCity;

class _KlimaticState extends State<Klimatic> {


  Future change() async {
    var router = new MaterialPageRoute<Map>(builder: (BuildContext context) {
      return new NextScreen();
    });

    Map result = await Navigator.of(context).push(router);

    if(result!=null && result.containsKey('enter')){
      gotCity = result['enter'];
    }
    else{
      gotCity=0.toString();
    }

  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Klimatic"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
          actions: <Widget>[
            new IconButton(icon: new Icon(Icons.search),
                onPressed: change)
          ],
        ),
        body:
        new Stack(
          children: <Widget>[

            new Image.asset("images/umbrella.png",
              width: 490.0,
              height: 1200.0,
              fit: BoxFit.fill,),

            new Container(
              alignment: Alignment.center,
              child: new Image.asset("images/light_rain.png",),
            ),


            new Container(
              alignment: Alignment.topRight,
              margin: new EdgeInsets.fromLTRB(0.0, 20.0, 20.0, 300.0),
              child: new Text(gotCity == null ? util.defaultCity : gotCity,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.0,
                    fontWeight: FontWeight.w500,
                    fontStyle: FontStyle.italic

                ),),
            ),
            getcity(gotCity==null?util.defaultCity:gotCity),


          ]
          ,
        )
    );
  }

  Future<Map> getWeather(String id, String city) async {
    String url = "https://api.openweathermap.org/data/2.5/weather?q=$city&APPID=$id&units=metric";

    http.Response response = await http.get(url);

    return json.decode(response.body);
  }

  Widget getcity(String city) {
    return new FutureBuilder(
        future: getWeather(util.appId, city),
        builder: (BuildContext context, AsyncSnapshot<Map> snapshot) {
          if (snapshot.hasData) {
            Map content = snapshot.data;
            return new Container(
              alignment: Alignment.bottomCenter,
              margin: new EdgeInsets.fromLTRB(0.0, 250.0, 0.0, 0.0),
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  new ListTile(
                    title: new Text(content['main']['temp'].toString() + " C",
                      style: new TextStyle(
                          color: Colors.white,
                          fontStyle: FontStyle.normal,
                          fontSize: 45.9,
                          fontWeight: FontWeight.w500
                      ),),
                    subtitle: new ListTile(
                      title: new Text(
                        "Humidity: ${content['main']['humidity'].toString()} \n"
                            "Min: ${content['main']['temp_min'].toString()} C\n"
                            "Max: ${content['main']['temp_max'].toString()} C",
                        style: new TextStyle(
                            color: Colors.white,
                            fontSize: 19.0
                        ),),
                    ),
                  ),

                ],
              ),
            );
          }
          else {
            return new Container();
          }
        });
  }

}

class NextScreen extends StatelessWidget {
  var _cityController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Change City"),
          centerTitle: true,
          backgroundColor: Colors.redAccent,
        ),
        body: new Stack(

            children: <Widget>[
              new Image.asset("images/white_snow.png",
                height: 1200.0,
                width: 490.0,
                fit: BoxFit.fill,),

              new Center(
                  child: new Column(
                    children: <Widget>[
                      new ListTile(
                        title: new TextField(
                          controller: _cityController == null
                              ? util.defaultCity
                              : _cityController,
                          keyboardType: TextInputType.text,
                          decoration: new InputDecoration(
                            hintText: "Enter City",
                          ),
                        ),
                      ),

                      new Padding(padding: new EdgeInsets.all(8.0)),

                      new ListTile(
                        title: new FlatButton(onPressed: () {
                          Navigator.pop(context, {

                            "enter": _cityController.text
                          });
                        },
                          color: Colors.redAccent,
                          textColor: Colors.white,
                          child: new Text("Get Weather",
                            style: new TextStyle(
                                fontSize: 20.0
                            ),
                          ),
                        ),
                      )

                    ],
                  )
              ),


            ]
        )

    );
  }
}
