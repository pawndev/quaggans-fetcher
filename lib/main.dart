import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'dart:developer';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quaggans',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: MyHomePage(title: 'Quaggans fetcher'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _baseUri = "https://api.guildwars2.com/";
  final _version = "v2/";
  final _quaggansEndpoint = "quaggans/";
  final _quaggans = [ "404", "aloha", "attack", "bear", "bowl", "box", "breakfast", "bubble", "cake", "cheer", "coffee", "construction", "cow", "cry", "elf", "ghost", "girl", "hat", "helmut", "hoodie-down", "hoodie-up", "killerwhale", "knight", "lollipop", "lost", "moving", "party", "present", "quaggan", "rain", "scifi", "seahawks", "sleep", "summer", "vacation"];
  String _currentQuaggans = "";
  String _currentQuaggansName = "";

  dynamic _fetchQuaggans() async {
    var randomItem = (_quaggans.toList()..shuffle()).first;
    var res = await http.get("$_baseUri$_version$_quaggansEndpoint$randomItem");
    log("$_baseUri$_version$_quaggansEndpoint$randomItem");
    log("${res.statusCode}");
    log("${res.reasonPhrase}");
    if (res.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(res.body);
      return { "name": jsonResponse['id'], "url": jsonResponse['url'] };
    } else {
      return { "name": "", "url": "" };
    }
  }

  void _displayQuaggans() async {
    var img = await _fetchQuaggans();
    setState(()  {
      _currentQuaggans = img['url'];
      _currentQuaggansName = img['name'];
    });
    log(_currentQuaggans);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: NetworkImage('$_currentQuaggans'),
            ),
            Center(
              child: Text(
              _currentQuaggansName,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.grey[800],
                fontWeight: FontWeight.w900,
                fontStyle: FontStyle.italic,
                fontFamily: 'Open Sans',
                fontSize: 40),
              )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayQuaggans,
        tooltip: 'Re-fetch Quaggans',
        child: Icon(Icons.refresh),
      ),
    );
  }
}
