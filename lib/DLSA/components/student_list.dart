import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class StudentList extends StatelessWidget {
  Future<Map<String, dynamic>> getStudentList() async {
    try {
      var url = dotenv.env['SERVER'];
      var response = await http.get(Uri.parse('http://$url/dlsa/student/list'));

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch student list');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student List'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: getStudentList(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData) {
              Map<String, dynamic> data = snapshot.data as Map<String, dynamic>;
              print(data);
              return ListView.builder(
                itemCount: data['result'].length,
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(data['result'][index]['name']),
                    subtitle: Text(data['result'][index]['roll_no'].toString()),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text(data['result'][index]['name']),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Roll Number: ${data['result'][index]['roll_no']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Class: ${data['result'][index]['class']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Section: ${data['result'][index]['section']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Date of Birth: ${data['result'][index]['dob']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                  Text(
                                    'Mentor: ${data['result'][index]['mentor_name']}',
                                    style: const TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  child: const Text('Close'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                ),
                              ],
                            );
                          });
                    },
                  );
                },
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            }
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
