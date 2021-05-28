import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'DepositClass.dart';

class Dashboard3  extends StatefulWidget{
  final int MemberID;

  Dashboard3({this.MemberID});
  @override
  _DashboardState createState() => _DashboardState(MemberID : MemberID);
}

enum TtsState { playing, stopped }

class _DashboardState extends State<Dashboard3> {
  final int MemberID;
  _DashboardState({this.MemberID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('അമൃതശ്രീ--ലോൺ അടവ് ',
        style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
        ),
      ),
      ),
      body:  FutureBuilder<List<DepositClass>>(
        future: fetchDepositDetails(),
        builder: (context, ss) {
          if (ss.hasError) print(ss.error);
          if (ss.hasData) {
            print("Pending loan amount");
            return PendingLoanAmount(Details: ss.data);
          }
        },
      ),
    );
  }
}

class PendingLoanAmount extends StatefulWidget {

  final List<DepositClass> Details;

  PendingLoanAmount({this.Details});

  @override
  _PendingLoanAmountState createState() => _PendingLoanAmountState(Details: Details);
}

class _PendingLoanAmountState extends State<PendingLoanAmount> {
  final List<DepositClass> Details;
  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 10;
  double pitch = 1;
  double rate = .7;
  _PendingLoanAmountState({this.Details});

  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;

  get isStopped => ttsState == TtsState.stopped;

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

  Material myItems  (String icon, String heading, int color1){
    return Material(
      color: Colors.black54,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      // height: 20,
                      // width: 400,
                      child: Text(heading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 36.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
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
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                // crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  MaterialButton(
                    child: Text('കൂടുതൽ വിവരങ്ങൾ',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    height: 50,
                    minWidth: 30,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    color: Colors.blueAccent,
                    onPressed: () {
                      ; //Do something
                    },
                  )
                ],
              ),
            ],
            // ),

          ),
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {
    print(Details[0].TotalPaid.toString());
    return StaggeredGridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,

      padding: EdgeInsets.symmetric(horizontal: 16.0,vertical: 8.0),
      children: <Widget>[
        myItems('assets/images/nextdue.jpg',"ലോൺ ആകെ അടച്ചത്:           "+Details[0].TotalPaid.toString()+" രൂപ",0xffed622b),
        myItems('assets/images/nextdue.jpg',"ആകെ അടവ് ബാക്കി :          "+Details[0].RemainingAmount.toString()+" രൂപ",0xffed622b),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 300.0),
        StaggeredTile.extent(2, 300.0),
      ],
    );
  }
}


Future<List<DepositClass>> fetchDepositDetails() async {
  Response response = await http.get('http://192.168.1.10:4000/totalloan');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<DepositClass>((json) => DepositClass.fromJson(json))
      .toList();
}