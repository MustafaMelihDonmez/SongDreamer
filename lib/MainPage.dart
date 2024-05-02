import 'package:flutter/material.dart';
import 'package:songdreamer_project00/MusicNewsPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        backgroundColor: Colors.blueGrey.shade100,
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blueGrey.shade500,
              ),
              child: Center(
                child: Text(
                  'SongDreamer',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
              ),
            ),
            ListTile(
              tileColor: Colors.teal.shade50,
              leading: Icon(Icons.newspaper),
              title: Text(
                'Music News',
                style: TextStyle(fontSize: 20, color: Colors.grey.shade600),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MusicNewsPage()),
                );
              },
            ),
          ],
        ),
      ),
      backgroundColor: Colors.orange.shade50,
      appBar: AppBar(
        backgroundColor: Colors.teal.shade200,
        title: Text("SongDreamer"),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 100.0,
                ),
                Card(
                  color: Colors.indigoAccent.shade100,
                  margin: EdgeInsets.symmetric(horizontal: 90.0),
                  child: ListTile(
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        "\musicListTab",
                      );
                    },
                    iconColor: Colors.white,
                    leading: Icon(Icons.music_note),
                    title: Text(
                      "Music List",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    trailing: Icon(Icons.menu),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
