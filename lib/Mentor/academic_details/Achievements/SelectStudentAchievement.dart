import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vidyaamrutham/Mentor/academic_details/Achievements/Achievements.dart';

class AchievementSelection extends StatefulWidget {
  const AchievementSelection({Key? key}) : super(key: key);

  @override
  State<AchievementSelection> createState() => _AchievementSelectionState();
}

class _AchievementSelectionState extends State<AchievementSelection> {
  Future<Map<String, dynamic>> getStudents() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String username = prefs.getString('username') ?? '';
    var link = "dlsatestserver.serveo.net";
    String url = 'http://$link/mentor/student/$username';
    var data = await http.get(
      Uri.parse(url),
    );
    var jsonData = json.decode(data.body);
    var count = jsonData['result'][jsonData['result'].length - 1]['COUNT(id)'];
    jsonData['result'].removeLast();
    return {"count": count, "data": jsonData['result']};
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Student'),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue, Colors.cyan, Colors.deepPurple],
          ),
        ),
        child: FutureBuilder(
          future: getStudents(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasData) {
                var data = snapshot.data;
                var count = data!['count'];
                var students = data['data'];
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: students.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Card(
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          title: Container(
                            padding: const EdgeInsets.all(10),
                            alignment: Alignment.center,
                            child: Text(
                              students[index]['name'],
                              style: const TextStyle(
                                color: Colors.black,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Achievements(
                                  id: students[index]['username'].toString(),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                );
              } else {
                return const Center(
                  child: Text(
                    'No data found',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                );
              }
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }
}
