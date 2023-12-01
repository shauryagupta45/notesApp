import 'package:flutter/material.dart';
import 'package:notesapp/db_handler.dart';
import 'package:notesapp/notes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DbHelper? dbHelper;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double buttonHeight = 56.0;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: Column(
        children: [],
      ),
      floatingActionButton: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Positioned(
            left: screenWidth * 0.48,
            bottom: 50.0, // Adjust the value for desired spacing
            child: FloatingActionButton(
              onPressed: () {
                dbHelper!
                    .insert(NotesModel(
                  id: 1,
                  title: 'First Note',
                  age: 22,
                  description: 'Shaurya Notes',
                  email: 'abc@gmail.com',
                ))
                    .then((value) {
                  print('Data Stored');
                }).onError((error, stackTrace) {
                  print(error.toString());
                });
              },
              child: const Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}
