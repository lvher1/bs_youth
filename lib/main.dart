import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:bs_youth/MenuBottom.dart';
import 'package:bs_youth/sub/myQT.dart';
import 'package:bs_youth/widget_tree.dart';
import 'package:bs_youth/sub/quietTime.dart';
import 'package:bs_youth/sub/qna.dart';
import 'package:bs_youth/sub/schedule.dart';
import 'package:bs_youth/sub/fileUpload.dart';
import 'auth.dart';
import 'firebase_options.dart';
import 'package:bs_youth/MenuBottom.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp()); //app 시작
}
//먼저 플러커 코어 초기화

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget platformUI() {
    /*if (Platform.isIOS) {
      return CupertinoApp(
        title: 'BanseoYouth',
        debugShowCheckedModeBanner: false,
        theme: CupertinoThemeData(brightness: Brightness.light),
        home: WidgetTree(),
      );
    } else if (Platform.isAndroid) {
      return MaterialApp(
          /*routes: {
          '/': (context) => WidgetTree(),
          '/qna': (context) => QuietTime(),
          '/schedule': (context) => QuietTime(),
          '/fileUpload': (context) => QuietTime(),
        },
        initialRoute: '/',*/

          title: 'BanseoYouth',
          theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              backgroundColor: Colors.lightGreenAccent),
          debugShowCheckedModeBanner: false,
          home: WidgetTree()
          //
          );
    } else {
      return MaterialApp(
          /*routes: {
          '/': (context) => WidgetTree(),
          '/qna': (context) => QuietTime(),
          '/schedule': (context) => QuietTime(),
          '/fileUpload': (context) => QuietTime(),
        },
        initialRoute: '/',*/
          title: 'BanseoYouth',
          theme: ThemeData(
              primarySwatch: Colors.lightGreen,
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
              backgroundColor: Colors.lightGreenAccent),
          debugShowCheckedModeBanner: false,
          home: WidgetTree()
          //
          );
    }*/return MaterialApp(
      /*routes: {
          '/': (context) => WidgetTree(),
          '/qna': (context) => QuietTime(),
          '/schedule': (context) => QuietTime(),
          '/fileUpload': (context) => QuietTime(),
        },
        initialRoute: '/',*/
        title: 'BanseoYouth',
        theme: ThemeData(
            primarySwatch: Colors.lightGreen,
            useMaterial3: true,
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            backgroundColor: Colors.lightGreenAccent),
        debugShowCheckedModeBanner: false,
        home: WidgetTree()
      //
    );
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return platformUI();
  }
}

class QuietTime extends StatefulWidget {
  const QuietTime({super.key});

  @override
  State<QuietTime> createState() => _QuietTimeState();
}

class _QuietTimeState extends State<QuietTime>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  User? user = Auth().currentUser;
  final currentUser = FirebaseAuth.instance;

  //late String id;

  //Future<String> nameGet = getID();
  Future<int> getCount() async {
    DocumentSnapshot countDoc = await FirebaseFirestore.instance
        .collection('QuietTime')
        .doc('total')
        .get();
    var count = countDoc['total'];
    return count;
  }

  final List<Widget> _widgetOptions = <Widget>[
    QuietTime1(
      count: 30,
    ),
    Schedule(),
    MyQT(),
    FileUpload()
  ];

  Future<String> getID() async {
    //DocumentSnapshot Doc = (await FirebaseFirestore.instance.collection('User').where("uid",isEqualTo: ).get()) as DocumentSnapshot<Object?>;
    DocumentSnapshot Doc = await FirebaseFirestore.instance
        .collection('User')
        .doc(currentUser.currentUser!.email.toString())
        .get();
    print("uid: ${currentUser.currentUser!.email.toString()}");
    var id = await Doc['name'];
    print("id: ${id}");
    return id;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    /*switch (index) {
      case 0:
        Navigator.pushNamed(context, '/');
        break;
      case 1:
        Navigator.pushNamed(context, '/schedule');
        break;
      case 2:
        Navigator.pushNamed(context, '/qna');
        break;
      case 3:
        Navigator.pushNamed(context, '/fileUpload');
    }*/
  }

  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
  );

  //late TabController controller;

  @override
  void initState() {
    super.initState();
    //controller = TabController(length: 4, vsync: this);
    //length: tab개수, vsync: tab이동시 호출되는 콜백함수 처리 위치 지정
  }

  @override
  void dispose() {
    //controller.dispose();
    super.dispose();
  } //메모리 누수 방지
  final TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff8BC34A),
        title: Container(
          child: Text(
            'Banseo Youth',
            style: TextStyle(
                color: Colors.white, fontFamily: 'Billabong', fontSize: 35),
          ),
        ),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text("로그아웃"),
                        content: Text("로그아웃 하시겠습니까?"),
                        actions: [
                          TextButton(
                              onPressed: () {
                                Auth().signOut();
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "예",
                                style: TextStyle(color: Colors.red),
                              )),
                          TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: Text(
                                "아니오",
                                style: TextStyle(color: Colors.blue),
                              ))
                        ],
                      );
                    });
              },
              icon: Icon(Icons.logout))
        ],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(13))),
      ),
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: FutureBuilder(
                future: getID(),
                builder: (context, snapshot) {
                  var nameA = snapshot.data;
                  return Row(
                    children: [
                      Container(
                        height: 40.0,
                        width: 40.0,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          /*image: new DecorationImage(
                                          fit: BoxFit.fill,
                                          image: new NetworkImage(
                                              "https://pbs.twimg.com/profile_images/916384996092448768/PF1TSFOE_400x400.jpg")),
                                    */
                        ),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      Text(
                        '${nameA}',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 10.0,
                      ),
                      IconButton(onPressed: (){
                        showDialog(context: context, barrierDismissible: false, builder: (BuildContext context){
                          return AlertDialog(
                            title: Text("이름 변경하기"),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                TextField(
                                  controller: nameController,
                                  decoration: InputDecoration(border: OutlineInputBorder(),labelText: '${snapshot.data}'),
                                ),
                              ],
                            ),actions: [
                            TextButton(onPressed: (){
                              setState(() {
                                nameA = nameController.text;
                              });
                              final String name = nameController.text;
                              FirebaseFirestore.instance.collection('User').doc(currentUser.currentUser!.email.toString()).update({
                                "name":name
                              });
                              Navigator.of(context).pop();
                            }, child: Text('변경'))
                          ],
                          );
                        });

                      }, icon: Icon(Icons.edit))
                    ],
                  );
                }),
          ),
          ListTile(
            title: Text(''),
          ),
          ListTile(
            title: Text(''),
          ),
          ListTile(
            title: Text(''),
          ),
        ],
      )),
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      /*TabBarView(
        children: <Widget>[QuietTime1(),QuietTime2(),QuietTime(),QuietTime1()],
        controller: controller,
      ),*/
      bottomNavigationBar: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
            bottomLeft: Radius.circular(15.0),
            bottomRight: Radius.circular(15.0)),
        child: BottomNavigationBar(
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.bookBible,
                  color: Colors.lightGreen,
                ),
                label: '큐티'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.calendar_month_rounded,
                  color: Colors.lightGreen,
                ),
                label: '일정'),
            BottomNavigationBarItem(
                icon: Icon(
                  FontAwesomeIcons.book,
                  color: Colors.lightGreen,
                ),
                label: '내QT'),
            BottomNavigationBarItem(
                icon: Icon(
                  Icons.photo_camera,
                  color: Colors.lightGreen,
                ),
                label: '추억')
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          onTap: _onItemTapped,
        ),
      ),
      backgroundColor: Color(0xffDCEDC8),
    );
  }

/*@override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }*/
}
