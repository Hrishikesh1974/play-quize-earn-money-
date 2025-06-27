import 'dart:convert'; import 'package:flutter/material.dart'; import 'package:http/http.dart' as http; import 'dart:math';

import 'package:quizapp/quiz.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget { @override Widget build(BuildContext context) { return MaterialApp( home: HomePage(), debugShowCheckedModeBanner: false, theme: ThemeData(primaryColor: Colors.white), ); } }

class HomePage extends StatefulWidget { @override _HomePageState createState() => _HomePageState(); }

class _HomePageState extends State<HomePage> { Quiz quiz; List<Results> results; int score = 0; Random random = Random(); bool showWithdraw = false; bool showRecharge = false;

Future<void> fetchQuestions() async { var res = await http.get(Uri.parse("https://opentdb.com/api.php?amount=20")); var decRes = jsonDecode(res.body); quiz = Quiz.fromJson(decRes); results = quiz.results; setState(() {}); }

Future<void> sendWithdrawRequest() async { final String botToken = '8155886115:AAGv1kV4DNa2qw4sFHEAVV28SdUTeVDmaBU'; final String chatId = '7231111069'; final message = '🔔 Withdraw Request!\nUser has reached 500৳.\nPlease review and process.';

final url = Uri.parse("https://api.telegram.org/bot\$botToken/sendMessage");
await http.post(url, body: {
  "chat_id": chatId,
  "text": message,
});

}

@override void initState() { super.initState(); fetchQuestions(); }

@override Widget build(BuildContext context) { return Scaffold( appBar: AppBar( title: Text("Play Quiz - Earn Real Money"), elevation: 0.0, actions: [ Padding( padding: const EdgeInsets.all(10.0), child: Center(child: Text("৳$score")), ), ], ), body: results == null ? Center(child: CircularProgressIndicator()) : ListView.builder( itemCount: results.length, itemBuilder: (context, index) => Card( color: Colors.white, elevation: 2.0, child: ExpansionTile( title: Padding( padding: const EdgeInsets.all(10.0), child: Text( results[index].question, style: TextStyle(fontWeight: FontWeight.bold), ), ), children: results[index].allAnswers.map((answer) { return ListTile( title: Text(answer), onTap: () { setState(() { if (answer == results[index].correctAnswer) { score += 5; if (score >= 500) showWithdraw = true; if (score >= 100) showRecharge = true; } }); }, ); }).toList(), ), ), ), bottomNavigationBar: (showWithdraw || showRecharge) ? Padding( padding: const EdgeInsets.all(8.0), child: Row( mainAxisAlignment: MainAxisAlignment.spaceAround, children: [ if (showRecharge) ElevatedButton( onPressed: () { ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Recharge Requested!"))); }, child: Text("Recharge Now (৳100)"), ), if (showWithdraw) ElevatedButton( onPressed: () async { await sendWithdrawRequest(); ScaffoldMessenger.of(context).showSnackBar( SnackBar(content: Text("Withdraw Request Sent to Admin!"))); }, child: Text("Withdraw (৳500)"), ), ], ), ) : null, ); } }
