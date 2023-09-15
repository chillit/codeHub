import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final DatabaseReference _databaseReference =
  FirebaseDatabase.instance.reference().child('users/dBrR5mUnFKhGu9gatXZTlw1odo82');

  String name = '';
  int userPoints = 0;
  String rank = '';
  String language = '';
  @override
  void initState() {
    super.initState();
    _getDataFromDatabase();
  }

  Future<void> _getDataFromDatabase() async {
    try {
      final DatabaseEvent dataSnapshot = await _databaseReference.once();
      final Map<dynamic, dynamic> data = dataSnapshot.snapshot.value;
      print(data);

      setState(() {
        name = data['Username'];
        userPoints = data['points'];
        rank = data['rank'];
        language = data['language'];

      });
    } catch (error) {
      print('Error: $error');
    }
  }


_titleText(String text) {
    return Text(
      text,
      style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _titleText(name),
                    const SizedBox(width: 100),
                    ClipOval(
                      child: Image.asset(
                        userPoints>=400?"assets/images/ranks/r.png":userPoints>=350?"assets/images/ranks/i.png":userPoints>=300?"assets/images/ranks/a.png":userPoints>=250?"assets/images/ranks/d.png":userPoints>=200?"assets/images/ranks/p.png":userPoints>=150?"assets/images/ranks/g.png":userPoints>100?"assets/images/ranks/s.png":userPoints>=50?"assets/images/ranks/b.png":"assets/images/ranks/ir.png",
                        height: 120,
                      ),
                    ),
                  ],
                ),
                Divider(color: Colors.grey.shade500),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _titleText("Information"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 80,
                            width: 170,
                            child: ListTile(
                                leading: Icon(
                                  Icons.score,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  "$userPoints",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                        ),
                        Card(
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            height: 80,
                            width: 170,
                            child: ListTile(
                                leading: Icon(
                                  Icons.language,
                                  color: Colors.amber,
                                ),
                                title: Text(
                                  "$language",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                )),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        _titleText("achievements"),/*ну если время будет то можно и такое релизовать, всякие достижения типа для мотивации*/
                        Text("ADICIONAR AMIGOS", style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold,
                          color: Colors.lightBlue),),
                      ],
                    ),
                    Card(
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        height: 80,
                        width: 170,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
}
