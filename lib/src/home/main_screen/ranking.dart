import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
class Ranking extends StatefulWidget {
  @override
  _RankingState createState() => _RankingState();
}

class _RankingState extends State<Ranking> {
  DatabaseReference _userRef;
  List<Map<dynamic, dynamic>> _users = [];
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseDatabase _database = FirebaseDatabase.instance;
  String currentUserUID;
  String currentUsername;
  DatabaseReference _databaseReference;
  int rankNumber;

  bool _isLoading = true;
  User user;




  @override
  void initState() {
    super.initState();
    _userRef = FirebaseDatabase.instance.reference().child('users');
    _fetchUserData();
    _fetchUsers();
    _getUserData();
  }

  Future<void> _fetchUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      currentUserUID = user.uid;
      final nameRef = _database.reference().child('users/$currentUserUID/Username');
      DatabaseEvent nameSnapshot = await nameRef.once();

      setState(() {
        currentUsername = nameSnapshot.snapshot.value?.toString() ?? '';
      });
    }
  }



  void _fetchUsers() {
    _userRef.orderByChild('points').once().then((DatabaseEvent snapshot) {
      if (snapshot.snapshot.value != null) {
        Map<dynamic, dynamic> values = snapshot.snapshot.value;
        values.forEach((key, value) {
          if (value != null && value['Username'] != null && value['points'] != null) {
            setState(() {
              _users.add(value);
            });
          }
        });
        _users.sort((a, b) => b['points'].compareTo(a['points']));
      }
      rankNumber = _users.indexWhere((user) => user['Username'] == currentUsername) + 1;
      setState(() {
        _isLoading = false; // Устанавливаем _isLoading в false после загрузки данных
      });
    });
  }
  Color my = Colors.brown, CheckMyColor = Colors.white;


  int userPoints = 0;
  String rank = '';
  String language = '';



  Future<void> _getUserData() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        _databaseReference = FirebaseDatabase.instance.reference().child('users/${user.uid}');
        final dataSnapshot = await _databaseReference.once();
        final Map<dynamic, dynamic> data = dataSnapshot.snapshot.value;
        print(data);

        setState(() {
          userPoints = data['points'];
          rank = data['rank'];
          language = data['language'];
        });
      }
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

  String getOrdinalSuffix(int number) {
    if (number % 100 >= 11 && number % 100 <= 13) {
      return '$number' + 'th';
    } else {
      switch (number % 10) {
        case 1:
          return '$number' + 'st';
        case 2:
          return '$number' + 'nd';
        case 3:
          return '$number' + 'rd';
        default:
          return '$number' + 'th';
      }
    }
  }



  @override

  Widget build(BuildContext context) {

    String pointsProfile = rankNumber != null ? getOrdinalSuffix(rankNumber) : '';
    return Scaffold(
      body: _isLoading?
        Center(child: CircularProgressIndicator(),):
      Stack(
        children: <Widget>[
          Scaffold(
              body: Container(
                margin: EdgeInsets.only(top: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Leaderboard",style: TextStyle(fontFamily: 'Feather',fontSize: 17),),

                      ],
                    ),
                    Container(
                      margin: EdgeInsets.only( top: 10.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[

                      Expanded(
                      child: Text("$pointsProfile",style: TextStyle(fontFamily: 'Feather', fontSize: 25),
                        textAlign: TextAlign.center,),
    ),

                              Center(
                                child: ClipOval(
                                  child: Image.asset(
                                    userPoints>=400?"assets/images/ranks/r.png":userPoints>=350?"assets/images/ranks/i.png":userPoints>=300?"assets/images/ranks/a.png":userPoints>=250?"assets/images/ranks/d.png":userPoints>=200?"assets/images/ranks/p.png":userPoints>=150?"assets/images/ranks/g.png":userPoints>100?"assets/images/ranks/s.png":userPoints>=50?"assets/images/ranks/b.png":"assets/images/ranks/ir.png",
                                    height: 120,
                                  ),
                                ),
                              ),

                              Expanded(
                                child: Text(
                                  "$userPoints pts",
                                  style: TextStyle(fontFamily: 'Feather', fontSize: 20),
                                  textAlign: TextAlign.center,
                                ),
                              )
                            ],
                          ),
                          Divider(color: Colors.grey.shade500),
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                    Flexible(
                      child: ListView.builder(
                        itemCount: _users.length,
                        itemBuilder: (BuildContext context, int index) {
                          final userName = _users[index]['Username'] ?? 'Unknown';
                          final userPoints = _users[index]['points'] ?? 0;
                          final rankNumber = index + 1;
                          final isCurrentUser = userName == currentUsername;

                          return ListTile(
                            tileColor: isCurrentUser ? Colors.green.withOpacity(0.25) : null,
                            leading: Container(
                              width: 80.0,
                              child: Row(
                                children: [
                                  Text('$rankNumber',style: TextStyle(fontSize: 15,fontFamily: 'Feather'),),
                                  SizedBox(width: 8,),
                                  Image.asset(
                                    userPoints>=400?"assets/images/ranks/r.png":userPoints>=350?"assets/images/ranks/i.png":userPoints>=300?"assets/images/ranks/a.png":userPoints>=250?"assets/images/ranks/d.png":userPoints>=200?"assets/images/ranks/p.png":userPoints>=150?"assets/images/ranks/g.png":userPoints>100?"assets/images/ranks/s.png":userPoints>=50?"assets/images/ranks/b.png":"assets/images/ranks/ir.png",
                                  ),
                                ],
                              ),
                            ),
                            title: Text(userName,style: TextStyle(
                                color: isCurrentUser ? Colors.green : null,
                                fontSize: 15,
                                fontFamily: 'Feather'
                            ),),
                            trailing: Text('$userPoints points',style: TextStyle(
                              fontFamily: 'Feather',
                              fontSize: 15,
                            ),),
                          );
                        },
                      ),
                    )
                  ],
                ),
              )),
        ],
      ),
    );
  }
}