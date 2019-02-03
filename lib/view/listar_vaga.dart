import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import "package:pivagas_candidado/model/vaga.dart";
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:pivagas_candidado/view/login.dart';

final db = FirebaseDatabase.instance.reference().child('vaga');

class ListViewVaga extends StatefulWidget {
  @override
  _ListViewVagaState createState() => new _ListViewVagaState();
}

class _ListViewVagaState extends State<ListViewVaga> {
  _ListViewVagaState(){
    _getCurrentUser();
  }
  
  List<Vaga> items;
  StreamSubscription<Event> _creatVagaSubscription;
  StreamSubscription<Event> _updateVagaSubscription;  
  final FirebaseAuth _fAuth = FirebaseAuth.instance;
  final GoogleSignIn _gSignIn = new GoogleSignIn();
  String userName = "";
  String userEmail = "";
  String userImage = "";
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PiVagas Candidato',
      home: Scaffold(
        appBar: AppBar(
          title: Text('PiVagas Candidato'),
          centerTitle: true,
          backgroundColor: Colors.blue,
        ),
      drawer: new Drawer(
        child: new ListView(
          children: <Widget> [
            UserAccountsDrawerHeader(
              accountName: Text("${userName}"),
              accountEmail: Text("${userEmail}"),
              currentAccountPicture: CircleAvatar(
                backgroundColor: const Color(0xFF212121),
                child: Image.network(
                  "${userImage}"
                ),
              ),
            ),
            ListTile(
              title: Text('Inicio'),
              onTap: () {
                _HomeNavegate();
              },
            ),           
            new Divider(),
            ListTile(
              title: Text('Sair'),
              onTap: () {
                _signOut();
              },
            ),
          ],
        )
      ),
        body: Center(
          child: ListView.builder(
              itemCount: items.length,
              padding: const EdgeInsets.all(15.0),
              itemBuilder: (context, position) {
                return Column(
                  children: <Widget>[
                    Divider(height: 5.0),
                    ListTile(
                      title: Text(
                        '${items[position].title}',
                        style: TextStyle(
                          fontSize: 22.0,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                      subtitle: Text(
                        'Descrição: ${items[position].description}',
                        style: new TextStyle(
                          fontSize: 18.0,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ),
                  ],
                );
              }),
        ),
      ),
    );
  }

  Future <void> _signOut() async{
    await _gSignIn.signOut();
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();

    items = new List();

    _creatVagaSubscription = db.onChildAdded.listen(_creatVaga);
    _updateVagaSubscription = db.onChildChanged.listen(_vagaUpdated);
  }

  @override
  void dispose() {
    _creatVagaSubscription.cancel();
    _updateVagaSubscription.cancel();
    super.dispose();
  }

  _getCurrentUser() async {
    FirebaseUser user = await FirebaseAuth.instance.currentUser();
    userName = user.displayName;
    userEmail = user.email;
    userImage = user.photoUrl;
  }

  void _creatVaga(Event event) {
    setState(() {
      items.add(new Vaga.fromSnapshot(event.snapshot));
    });
  }

  void _vagaUpdated(Event event) {
    var oldNoteValue = items.singleWhere((vaga) => vaga.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Vaga.fromSnapshot(event.snapshot);
    });
  }

  void _deleteVaga(BuildContext context, Vaga vaga, int position) async {
    await db.child(vaga.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _HomeNavegate() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => ListViewVaga()),
    );
  }

}
