import 'LoanDetailsClass.dart';
import 'DepositClass.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class Dashboard5 extends StatefulWidget {
  final int MemberID;

  Dashboard5({this.MemberID});
  @override
  _DashboardState createState() => _DashboardState(MemberID: MemberID);
}

enum TtsState { playing, stopped }

class _DashboardState extends State<Dashboard5> {
  final int MemberID;

  _DashboardState({this.MemberID});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'അമൃതശ്രീ-->തിരിച്ചടവ് അറിയിപ്പ് ',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 15,
          ),
        ),
      ),
      body: FutureBuilder<List<DepositClass>>(
        future: fetchPaymentAlert(),
        builder: (context, ss) {
          if (ss.hasError) print(ss.error);
          if (ss.hasData) {
            print("\n\nPAYMENT ALERT\n\n");
            return PaymentAlert(Details: ss.data);
          }
        },
      ),
    );
  }
}

class PaymentAlert extends StatefulWidget {
  final List<DepositClass> Details;

  PaymentAlert({this.Details});

  @override
  _PaymentAlertState createState() => _PaymentAlertState(Details: Details);
}

class _PaymentAlertState extends State<PaymentAlert> {
  final List<DepositClass> Details;

  _PaymentAlertState({this.Details});
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
        myItems(
            'assets/images/nextdue.jpg',
            "അവസാന അടവ് :  " + Details[0].LastPayment.toString() + " രൂപ",
            Colors.black54),
        myItems(
            'assets/images/nextdue.jpg',
            "അടവ് തീയതി  :       " + Details[0].DateofPayment.substring(0,10),
            Colors.black54),
        myItems('assets/images/pendingpayment.png', "ശരി", Colors.green[400]),
        myItems('assets/images/savings.jpg', "തെറ്റ്", Colors.red[200]),
      ],
      staggeredTiles: [
        StaggeredTile.extent(2, 240.0),
        StaggeredTile.extent(2, 240.0),
        StaggeredTile.extent(1, 150.0),
        StaggeredTile.extent(1, 150.0),
      ],
    );
  }
}

Future<List<DepositClass>> fetchPaymentAlert() async {
  Response response = await http.get('http://192.168.1.12:4000/paymentAlert');
  print(response.body);
  final parsed = json.decode(response.body);
  return parsed
      .map<DepositClass>((json) => DepositClass.fromJson(json))
      .toList();
}
