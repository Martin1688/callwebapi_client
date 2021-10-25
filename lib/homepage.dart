import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
const serverIP = 'http://192.168.1.167:5000';

class HomePage extends StatelessWidget {
  const HomePage(this.jwt, this.payload);

  factory HomePage.fromBase64(String jwt) =>
      HomePage(
          jwt,
          json.decode(
              ascii.decode(
                  base64.decode(base64.normalize(jwt.split(".")[1]))
              )
          )
      );

  final String jwt;
  final Map<String, dynamic> payload;

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: Text("Secret Data Screen")),
        body: Center(
          child: FutureBuilder(
              future: http.read(Uri.parse('$serverIP/data'), headers: {"Authorization": jwt}),
              builder: (context, snapshot) =>
              snapshot.hasData ?
              Column(children: <Widget>[
                Text("${payload['username']}, here's the data:"),
                Text(snapshot.data!.toString(), style: Theme.of(context).textTheme.bodyText1)
              ],)
                  :
              snapshot.hasError ? Text("An error occurred") : CircularProgressIndicator()
          ),
        ),
      );
}
