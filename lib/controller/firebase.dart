import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:pivagas_candidado/model/vaga.dart';
import 'package:pivagas_candidado/view/nova_vaga.dart';

final notesReference = FirebaseDatabase.instance.reference().child('vaga');

class ControllerFirebase extends StatefulWidget {
  @override
  _ControllerFirebaseState createState() => new _ControllerFirebaseState();
}

class _ControllerFirebaseState extends State<ControllerFirebase> {
  List<Vaga> items;
  StreamSubscription<Event> _onNoteAddedSubscription;
  StreamSubscription<Event> _onNoteChangedSubscription;

  @override
  void initState() {
    super.initState();

    items = new List();

    _onNoteAddedSubscription = notesReference.onChildAdded.listen(_onNoteAdded);
    _onNoteChangedSubscription = notesReference.onChildChanged.listen(_onNoteUpdated);
  }

  @override
  void dispose() {
    _onNoteAddedSubscription.cancel();
    _onNoteChangedSubscription.cancel();
    super.dispose();
  }

  void _onNoteAdded(Event event) {
    setState(() {
      items.add(new Vaga.fromSnapshot(event.snapshot));
    });
  }

  void _onNoteUpdated(Event event) {
    var oldNoteValue = items.singleWhere((vaga) => vaga.id == event.snapshot.key);
    setState(() {
      items[items.indexOf(oldNoteValue)] = new Vaga.fromSnapshot(event.snapshot);
    });
  }

  void _deleteNote(BuildContext context, Vaga vaga, int position) async {
    await notesReference.child(vaga.id).remove().then((_) {
      setState(() {
        items.removeAt(position);
      });
    });
  }

  void _navigateToNote(BuildContext context, Vaga vaga) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageVaga(vaga)),
    );
  }

  void _createNewNote(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => PageVaga(Vaga(null, '', ''))),
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return null;
  }
}