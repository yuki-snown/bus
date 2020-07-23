import 'package:flutter/material.dart';
import 'dart:async';
import "package:intl/intl.dart";
import 'package:flutter/services.dart' show rootBundle;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Generated App',
      debugShowCheckedModeBanner: false, // これを追加するだけ
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF2196f3),
        accentColor: const Color(0xFF2196f3),
        canvasColor: const Color(0xFFfafafa),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
    var _now;
    String _next1 = " ", _next2 = " ", _next3 = " ", _dia = "平日ダイヤ";
    String _botton = "行きor帰りを選択";
    String load_filename;
    DateTime time;
    bool _date = false;
    @override
    void initState() {
    super.initState();
    Timer.periodic(
        Duration(milliseconds: 1),
        (Timer t) => setState(() {
              time = DateTime.now().toLocal();
              _now = DateFormat('yyyy-MM-dd  kk:mm:ss').format(time);
            }));
    }

    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Bus Timer',
            style: TextStyle(fontSize:32.0,
            color: Colors.white,
            fontWeight: FontWeight.w500,
            fontFamily: "Roboto"),
          ),
          ),
        body:
          Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              
              Padding(
                padding: const EdgeInsets.all(24.0),
              ),
              
             Container(
                child:
                  Text(
                  '$_now',
                    style: TextStyle(fontSize:42.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w500,
                    fontFamily: "Roboto"),
                  ),
    
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
              ),

              Padding(
                  padding: const EdgeInsets.all(12.0),
              ),

             Container(
                child:
                  Text(
                  '$_botton',
                    style: TextStyle(fontSize:36.0,
                    color: Colors.black38,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
                  ),
    
                padding: const EdgeInsets.all(0.0),
                alignment: Alignment.center,
              ),

              Padding(
                  padding: const EdgeInsets.all(16.0),
              ),

              Center(
                child:Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(12.0),
                      color: Colors.lightBlue,
                      onPressed: () {
                        _botton = "新三田 → 関学";
                        if (_date==false){
                          load_filename = "平日行き.txt";                          
                        }
                        else if (_date==true){
                          load_filename = "祝日行き.txt";
                        }
                        setState(() => nextbus(load_filename));
                        },
                        child: Text('行き',
                        style: TextStyle(fontSize:24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Roboto"),
                        ),
                        ),
                    Padding(
                      padding: const EdgeInsets.all(28.0),
                    ),
                    FlatButton(
                      padding: EdgeInsets.all(12.0),
                      color: Colors.lightBlue,
                      onPressed: () {
                        _botton = "関学 → 新三田";
                        if (_date==false){
                          load_filename = "平日帰り.txt";                          
                        }
                        else if (_date==true){
                          load_filename = "祝日帰り.txt";
                        }
                        setState(() => nextbus(load_filename));
                        },
                        child: Text('帰り',
                        style: TextStyle(fontSize:24.0,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontFamily: "Roboto"),
                        ),
                        ),
                  ],
                ),
              ),

              Padding(
                  padding: const EdgeInsets.all(20.0),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(20.0),
                  ),
                  Switch(
                    onChanged: switchChanged, 
                    value:_date
                  ),
                  Text(
                  '$_dia',
                    style: TextStyle(fontSize:32.0,
                    color: Colors.black38,
                    fontWeight: FontWeight.w700,
                    fontFamily: "Roboto"),
                  ),
                ]    
              ),

              Padding(
                  padding: const EdgeInsets.all(20.0),
              ),

              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(48.0),
                  ),
                  Text(
                  '$_next1\n$_next2\n$_next3',
                    style: TextStyle(fontSize:32.0,
                    color: const Color(0xFF000000),
                    fontWeight: FontWeight.w600,
                    fontFamily: "Roboto"),
                  ),
                ]    
              )
              
            ]
    
          ),
    
      );
    }

    void switchChanged(bool value) {
      _date = value;
      if(value==true){
        _dia = "祝日ダイヤ";
      }
      else {
        _dia = "平日ダイヤ";
      }
    }
        
    Future<void> nextbus(String filename) async{
      final file = await rootBundle.loadString('assets/' + filename);
      int i;
      String stack = "";
      List<String> data = [];
      List<int> hour = [];
      List<int> min = [];
      List<String> place = [];

      for(i=0;i<file.length;i++){
        if(file[i] == "," ){
          data.add(stack);
          stack = "";
        }
        else {
          stack += file[i];
        }
      }

      for (i=0;i<data.length;i+=3){
        hour.add(int.parse(data[i]));
        min.add(int.parse(data[i+1]));
        place.add(data[i+2]);
      }

    var time = DateTime.now();
    int year = time.year;
    int month = time.month;
    int day = time.day;
    var out;

    for (i = 0; i<place.length-1;i++){
      final startTime = DateTime(year, month, day, hour[i], min[i]);
      final endTime = DateTime(year, month, day, hour[i+1], min[i+1]);
      final currentTime = DateTime.now();
      if(currentTime.isAfter(startTime) && currentTime.isBefore(endTime)) {
        out = DateTime(year, month, day, hour[i+1], min[i+1]);
        _next1 = DateFormat('kk:mm  ').format(out) + place[i+1];
        if (i == place.length-2){
          _next2 =" ";
          _next3 = " ";
        }
        else if (i == place.length-3){
          //2個出力
          out = DateTime(year, month, day, hour[i+2], min[i+2]);    
          _next2 = DateFormat('kk:mm  ').format(out) + place[i+2];
          _next3 = " ";
        }
        else {
          //3個出力
          out = DateTime(year, month, day, hour[i+2], min[i+2]);    
          _next2 = DateFormat('kk:mm  ').format(out) + place[i+2];
          out = DateTime(year, month, day, hour[i+3], min[i+3]);    
          _next3 = DateFormat('kk:mm  ').format(out) + place[i+3];
        }
        break;
      }
      if (i == place.length-2){
        out = DateTime(year, month, day, hour[0], min[0]);
        _next1 = DateFormat('kk:mm  ').format(out) + place[0];
        out = DateTime(year, month, day, hour[1], min[1]);    
        _next2 = DateFormat('kk:mm  ').format(out) + place[1];
        out = DateTime(year, month, day, hour[2], min[2]);    
        _next3 = DateFormat('kk:mm  ').format(out) + place[2];

        break;
      }
    }
  }
}