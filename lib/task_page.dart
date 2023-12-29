import 'package:flutter/material.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({super.key});

  @override
  State<TaskPage> createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Task",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Card(
            color: Colors.white70,
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Employee Task",
                    style: TextStyle(
                        fontSize: 25,
                        color: Colors.black,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Title",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        border: Border.all(color: Colors.black, width: 1.0)),
                    child: TextField(
                      keyboardType: TextInputType.text,
                      decoration: InputDecoration(
                        hintText: "Title",
                        border: InputBorder.none,
                        prefixIcon: Icon(
                          Icons.title_outlined,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Description",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  SizedBox(height: 10),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      border: Border.all(
                        color: Colors.black,
                        width: 1.0,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      // Adjust horizontal padding as needed
                      child: TextField(
                        keyboardType: TextInputType.multiline,
                        maxLines: null,
                        // Allows for an unlimited number of lines
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.symmetric(vertical: 20.0),
                          // Adjust vertical padding as needed
                          hintText: "Enter Description",
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.description,
                            color: Colors.black,
                          ),
                        ),
                        style: TextStyle(fontSize: 18.0),
                        // Adjust font size as needed
                        textInputAction:
                            TextInputAction.done, // Specifies the "Done" button
                      ),
                    ),
                  ),
                  SizedBox(height: 60),
                  ElevatedButton(
                      onPressed: () {},
                      child: Text(
                        "ADD",
                        style:
                            TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
