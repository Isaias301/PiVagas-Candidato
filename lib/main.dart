import 'package:flutter/material.dart';
import 'package:pivagas_candidado/view/login.dart';
import 'package:pivagas_candidado/view/listar_vaga.dart';

void main() => runApp(
  MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'PiVagas Empresa',
    theme: ThemeData(
      primarySwatch: Colors.lightBlue,
      fontFamily: 'Nunito',
    ),
    home: LoginPage(),
    // home: ListViewVaga(),
  ),
);