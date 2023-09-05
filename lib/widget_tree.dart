import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bs_youth/auth.dart';
import 'package:bs_youth/main.dart';
import 'package:bs_youth/login_register_page.dart';
import 'package:flutter/material.dart';
import 'package:bs_youth/sub/quietTime.dart';


class WidgetTree extends StatefulWidget{
  const WidgetTree({Key? key}) : super(key:key);

  @override
  State<WidgetTree> createState() => _WidgetTreeState();
}
class _WidgetTreeState extends State<WidgetTree>{
  @override
  Widget build(BuildContext context){
    return StreamBuilder(stream: Auth().authStateChanges,builder: (context,snapshot){
      if(snapshot.hasData){
        return QuietTime();
      }else{
        return const LoginPage();
      }
    },);
  }
}