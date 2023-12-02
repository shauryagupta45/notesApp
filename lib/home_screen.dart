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
  late Future<List<NotesModel>> notesList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbHelper = DbHelper();
    loadData();
  }

  loadData() async {
    notesList = dbHelper!.getNotesList();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Notes App"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder(
                future: notesList,
                builder: (context, AsyncSnapshot<List<NotesModel>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data?.length,
                        reverse: false,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              dbHelper!.update(
                                NotesModel(
                                  id: snapshot.data![index].id!,
                                  title: 'Changed node',
                                  age: 25,
                                  description: 'the node has been changed',
                                  email: 'abc@kimkmd',
                                ),
                              );
                              setState(() {
                                notesList = dbHelper!.getNotesList();
                              });
                            },
                            child: Dismissible(
                              background: Container(
                                child: Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                              ),
                              onDismissed: (DismissDirection direction) {
                                setState(() {
                                  dbHelper!.delete(snapshot.data![index].id!);
                                  notesList = dbHelper!.getNotesList();
                                  snapshot.data!.remove(snapshot.data![index]);
                                });
                              },
                              key: ValueKey<int>(snapshot.data![index].id!),
                              child: Card(
                                child: ListTile(
                                  title: Text(
                                      snapshot.data![index].title.toString()),
                                  subtitle: Text(snapshot
                                      .data![index].description
                                      .toString()),
                                  trailing: Text(
                                      snapshot.data![index].age.toString()),
                                ),
                              ),
                            ),
                          );
                        });
                  } else {
                    return Container();
                  }
                }),
          ),
        ],
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
                setState(() {
                  notesList = dbHelper!.getNotesList();
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
