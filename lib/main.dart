import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WebViewController? _webViewController;
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(),
      body: WebView(
        javascriptMode: JavascriptMode.unrestricted,
        // initialUrl:
        //     'data:text/html;base64,${base64Encode(Utf8Encoder().convert(state.lessonResponse.content))}',
        initialUrl: 'https://ovh.net',

        navigationDelegate: (action) async {
          if (action.url.contains('pdf')) {
            print('Trying to open pdf');
            print(action.url);
            String url = action.url;
            if (await canLaunch(url)) {
              await launch(url, forceSafariVC: false);
            } else {
              throw 'Could not launch $url';
            }
            //  Navigator.pop(context); // Close current window
            return NavigationDecision.navigate; // Prevent opening url
          } else if (action.url.contains('http')) {
            print('Trying to open http');
            print(action.url);
            String url = action.url;
            if (await canLaunch(url)) {
              await launch(url, forceSafariVC: false);
            } else {
              throw 'Could not launch $url';
            }

            return NavigationDecision.navigate; // Allow opening url
          } else {
            return NavigationDecision.navigate; // Default decision
          }
        },
        onPageFinished: (some) async {},
        onWebViewCreated: (controller) async {
          controller.clearCache();
          // print(state.lessonResponse.content);
          print('state.lessonResponse.content');
          this._webViewController = controller;
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
