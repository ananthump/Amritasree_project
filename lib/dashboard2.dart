import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'LoanDetailsClass.dart';
import 'DepositClass.dart';

class Dashboard2 extends StatefulWidget {
  final int MemberID;
  Dashboard2({this.MemberID});

  @override
  _DashboardState createState() => _DashboardState(MemberID: MemberID);
}

enum TtsState { playing, stopped }

class _DashboardState extends State<Dashboard2> {
  final int MemberID;
  _DashboardState({this.MemberID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'അമൃതശ്രീ-->ലോൺ വിവരങ്ങൾ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: FutureBuilder<List<DepositClass>>(
        future: fetchDepositDetails(),
        builder: (context, ss) {
          print(ss);
          if (ss.hasError) print(ss.error);
          if (ss.hasData) {
            print("Pending loan amount");
            return RetrieveLoanDetail(Details: ss.data);
          }
        },
      ),
    );
  }
}

class RetrieveLoanDetail extends StatefulWidget {
  final List<DepositClass> Details;

  RetrieveLoanDetail({this.Details});

  @override
  _RetrieveLoanDetailState createState() => _RetrieveLoanDetailState(Details: Details);
}

class _RetrieveLoanDetailState extends State<RetrieveLoanDetail> {
  final List<DepositClass> Details;

  _RetrieveLoanDetailState({this.Details});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<LoanDetailsClass>>(
      future: fetchLoanDetails(),
      builder: (context, ss) {
        if (ss.hasError) print(ss.error);
        if (ss.hasData) {
          print("Pending loan amount");
          return OverallLoanDetail(LoanDetails: ss.data, Details: Details);
        }
      },
    );
  }
}

class OverallLoanDetail extends StatefulWidget {
  final List<LoanDetailsClass> LoanDetails;
  final List<DepositClass> Details;

  OverallLoanDetail({this.LoanDetails, this.Details});

  @override
  _OverallLoanDetailState createState() => _OverallLoanDetailState(LoanDetails: LoanDetails, Details: Details);
}

class _OverallLoanDetailState extends State<OverallLoanDetail> {
  final List<LoanDetailsClass> LoanDetails;
  final List<DepositClass> Details;

  _OverallLoanDetailState({this.LoanDetails, this.Details});

  FlutterTts flutterTts;
  dynamic languages;
  String language;
  double volume = 10;
  double pitch = 1;
  double rate = .7;
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

  Material myItems(String icon, String heading, int color1) {
    return Material(
      color: Colors.black54,
      elevation: 14.0,
      shadowColor: Color(0x802196F3),
      borderRadius: BorderRadius.circular(24.0),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
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
                      width: 220,
                      child: Text(
                        heading,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 28.0,
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
                    child: Text(
                      'കേൾക്കു',
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
                ],
              ),
            ],
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
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      children: <Widget>[
        myItems('assets/images/nextdue.jpg', "ലോൺ തുക:          "+LoanDetails[0].LoanAmount.toString()+" രൂപ", 0xffed622b),
        myItems('assets/images/nextdue.jpg', "പലിശ: 2% പ്രതിമാസം", 0xffed622b),
        myItems(
            'assets/images/nextdue.jpg', "ലോൺ അടച്ചത്:       "+Details[0].LoanPaid.toString()+" രൂപ", 0xffed622b),
        myItems(
            'assets/images/nextdue.jpg', "പലിശ അടച്ചത്:           "+Details[0].InterestPaid.toString()+" രൂപ", 0xffed622b),
        myItems('assets/images/nextdue.jpg', "ഇനി ലോൺ ഉള്ളത് :          "+Details[0].RemainingLoanAmount.toString()+" രൂപ",
            0xffed622b),
        myItems('assets/images/nextdue.jpg', "ഇനി പലിശ ഉള്ളത് :           "+Details[0].RemainingInterest.toString()+" രൂപ",
            0xffed622b),
        myItems('assets/images/nextdue.jpg', "ആകെ അടവ് ബാക്കി :          "+Details[0].Balance.toString()+" രൂപ",
            0xffed622b),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
        StaggeredTile.extent(2, 150.0),
      ],
    );
  }
}

Future<List<DepositClass>> fetchDepositDetails() async {
  Response response =
      await http.get('http://192.168.1.12:4000/depositDetails');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<DepositClass>((json) => DepositClass.fromJson(json))
      .toList();
}

Future<List<LoanDetailsClass>> fetchLoanDetails() async {
  Response response = await http.get('http://192.168.1.12:4000/loanAmount');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<LoanDetailsClass>((json) => LoanDetailsClass.fromJson(json))
      .toList();
}
