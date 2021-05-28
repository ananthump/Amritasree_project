import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'LoanDetailsClass.dart';
import 'DepositClass.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Dashboard6  extends StatefulWidget{
  final int MemberID;

  Dashboard6({this.MemberID});
  @override
  _DashboardState createState() => _DashboardState(MemberID : MemberID);
}

enum TtsState { playing, stopped }

class _DashboardState extends State<Dashboard6> {
  final int MemberID;

  _DashboardState({this.MemberID});

  // speak( String word){
  //  flutterTts.speak(word);
  // }

    //  Future speak() async{
    //     var result = await flutterTts.speak("Hello World");
    //     if (result == 1) setState(() => ttsState = TtsState.playing);
    //  }

    //  Future stop() async{
    //    var result = await flutterTts.stop();
    //    if (result == 1) setState(() => ttsState = TtsState.stopped);
    //  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('അമൃതശ്രീ-->നിക്ഷേപം',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
        ),
      ),
      ),
      body:  FutureBuilder<List<DepositClass>>(
        future: fetchSavings(),
        builder: (context, ss) {
          if (ss.hasError) print(ss.error);
          if (ss.hasData) {
            print("Pending loan amount");
            return Savings(Details: ss.data);
          }
        },
      ),
    );
  }
}

class Savings extends StatefulWidget {
  final List<DepositClass> Details;

  Savings({this.Details});

  @override
  _SavingsState createState() => _SavingsState(Details :Details);
}

class _SavingsState extends State<Savings> {
  final List<DepositClass> Details;
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 10;
  double pitch = 1;
  double rate = .7;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

  _SavingsState({this.Details});

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    flutterTts = FlutterTts();

    flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    flutterTts.setErrorHandler((msg) {
      setState(() {
        print("error: $msg");
        ttsState = TtsState.stopped;
      });
    });
  }

  Future _speak(word) async {
    await flutterTts.setVolume(volume);
    await flutterTts.setSpeechRate(rate);
    await flutterTts.setPitch(pitch);
    // print(await flutterTts.getLanguages);
    flutterTts.setLanguage("ml-IN");
    // print("check");
    if (word != null) {
      if (word.isNotEmpty) {
        var result = await flutterTts.speak(word);
        if (result == 1) setState(() => ttsState = TtsState.playing);
      }
    }
  }

  Future _stop() async {
    var result = await flutterTts.stop();
    if (result == 1) setState(() => ttsState = TtsState.stopped);
  }

  Material myItems  (String icon, String heading, Color color1){
    return Material(
      color: color1 ,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // height: 20,
                      // width: 400,
                      child: Text(heading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // Center(
              //   child: Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     // crossAxisAlignment: CrossAxisAlignment.end,
              //     children: <Widget>[
              //        Material(
              //         color: Colors.white,
              //         borderRadius: BorderRadius.circular(24.0),
              //         child: Padding(padding: const EdgeInsets.all(16.0),
              //         // child: Icon(icon,
              //         // color: Colors.black,
              //         // size: 30.0),
              //         child: Image(image: AssetImage(icon),
              //           height: 80,
              //           width: 100)
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    child: Text('കേൾക്കു',
                      style: TextStyle(
                        fontSize: 8,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 50,
                    minWidth: 30,
                    shape: CircleBorder(),
                    color: Colors.red,
                    onPressed: () {
                      _speak(heading); //Do something
                    },
                  )
                  // IconButton(icon: new Icon(Icons.audiotrack),
                  // onPressed: _speak(),
                  // iconSize: 40),
                  //  Material(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(24.0),
                  //   child: Padding(padding: const EdgeInsets.all(16.0),
                  //   child: Icon(Icons.audiotrack,
                  //   color: Colors.black,
                  //   size: 15.0,),
                  //   ),
                  // ),
                  // Container(
                  //   color: Colors.white,
                  // )
                ],
              ),
              // Column(
              //     mainAxisAlignment: MainAxisAlignment.center,
              //     // crossAxisAlignment: CrossAxisAlignment.end,
              //     children: <Widget>[
              //        MaterialButton(
              //         child: Text('കൂടുതൽ വിവരങ്ങൾ',
              //           style: TextStyle(
              //           fontSize: 18,
              //           color: Colors.white,
              //           fontWeight: FontWeight.bold,
              //           ),
              //         ),
              //         height: 50,
              //         minWidth: 30,
              //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              //         color: Colors.blueAccent,
              //         onPressed: () {
              //           ; //Do something
              //         },
              //   )
              //     ],
              //   ),
            ],
            // ),

          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,

      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
      children: <Widget>[
        myItems('assets/images/nextdue.jpg',"ഇതുവരെ നിക്ഷേപം:                "+Details[0].PresentSavings.toString()+" രൂപ",Colors.black54),
        myItems('assets/images/nextdue.jpg',"ലോൺ തുക ബാക്കി  :                 "+Details[0].RemainingLoanAmount.toString()+" രൂപ",Colors.black54),
        myItems('assets/images/nextdue.jpg',"നിക്ഷേപം  :           "+Details[0].Savings.toString()+" രൂപ",Colors.black54)
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 240.0),
        StaggeredTile.extent(2, 240.0),
        StaggeredTile.extent(2, 240.0),
      ],
    );
  }
}

Future<List<DepositClass>> fetchSavings() async {
  Response response = await http.get('http://192.168.1.10:4000/savings');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<DepositClass>((json) => DepositClass.fromJson(json))
      .toList();
}
