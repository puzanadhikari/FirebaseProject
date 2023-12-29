import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:newapp/task_page.dart';
import 'package:newapp/timer_page.dart';

import 'nestedDataFetch.dart';

class DrawerPage extends StatefulWidget {
  const DrawerPage({super.key});

  @override
  State<DrawerPage> createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  final imageUrl="https://annapurnaexpress.prixacdn.net/media/albums/E6KiRKOVIAIrXBa_20210929144455_zbLExOqOo2.jpg";
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.green,
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: Colors.green
            ),
            child: UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white60
              ),
              margin: EdgeInsets.zero,
              accountName: Text(
                "Employee Records",
                style: TextStyle(fontSize: 25,color: Colors.black),
              ),
              accountEmail: Text("puzanadhikary@gmail.com",style: TextStyle(
                color: Colors.black
              ),),
              currentAccountPicture: CircleAvatar(
                backgroundImage: NetworkImage(imageUrl),
              ),
            ),
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.add,
              color: Colors.white,
            ),
            title: Text(
              "Task",
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TaskPage()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.timer_fill,
              color: Colors.white,
            ),
            title: Text(
              "Timer",
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => TimerPage()));
            },
          ),
          ListTile(
            leading: Icon(
              CupertinoIcons.app_fill,
              color: Colors.white,
            ),
            title: Text(
              "Data Fetch",
              textScaleFactor: 1.2,
              style: TextStyle(color: Colors.white),
            ),
            onTap: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => NestedDataFetch()));
            },
          ),
        ],
      ),
    );
  }
}
