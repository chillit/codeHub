import 'package:flutter/material.dart';

class Ranking extends StatelessWidget {
  final List<Map<String, dynamic>> usersData = [
    {
      'Name': 'User 1',
      'MyPoints': 100,
      'photoUrl': 'url_to_user1_photo',
    },
    {
      'Name': 'User 2',
      'MyPoints': 80,
      'photoUrl': 'url_to_user2_photo',
    },
    // Добавьте остальных пользователей в список
  ];

  @override
  Widget build(BuildContext context) {
    var r = TextStyle(color: Colors.purpleAccent, fontSize: 34);

    return Stack(
      children: <Widget>[
        Scaffold(
          body: Container(
            margin: EdgeInsets.only(top: 65.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(left: 15.0, top: 10.0),
                  child: RichText(
                    text: TextSpan(
                      text: "Leader",
                      style: TextStyle(
                        color: Colors.deepPurple,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                      children: [
                        TextSpan(
                          text: " Board",
                          style: TextStyle(
                            color: Colors.pink,
                            fontSize: 30.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 15.0),
                  child: Text(
                    'Global Rank Board: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Flexible(
                  child: ListView.builder(
                    itemCount: usersData.length,
                    itemBuilder: (context, index) {
                      final userData = usersData[index];
                      final name = userData['Name'];
                      final myPoints = userData['MyPoints'];
                      final photoUrl = userData['photoUrl'];

                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 5.0,
                          vertical: 5.0,
                        ),
                        child: InkWell(
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.white,
                                width: 3.0,
                                style: BorderStyle.solid,
                              ),
                              borderRadius: BorderRadius.circular(5.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10.0,
                                        left: 15.0,
                                      ),
                                      child: Row(
                                        children: <Widget>[
                                          CircleAvatar(
                                            child: Container(
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: NetworkImage(photoUrl),
                                                  fit: BoxFit.fill,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                        left: 20.0,
                                        top: 10.0,
                                      ),
                                      child: Column(
                                        mainAxisAlignment:
                                        MainAxisAlignment.center,
                                        crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            alignment: Alignment.centerLeft,
                                            child: Text(
                                              name,
                                              style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontWeight: FontWeight.w500,
                                              ),
                                              maxLines: 6,
                                            ),
                                          ),
                                          Text("Points: $myPoints"),
                                        ],
                                      ),
                                    ),
                                    Flexible(child: Container()),
                                    Padding(
                                      padding: EdgeInsets.only(
                                        left: 20.0,
                                        top: 13.0,
                                        right: 20.0,
                                      ),
                                      child: Text("$myPoints")
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
