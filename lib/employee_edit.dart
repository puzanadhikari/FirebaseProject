import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'employee_model.dart';

class EmployeeEditPage extends StatefulWidget {
  final Employee employee;
  final Function(Employee) onUpdate;

  EmployeeEditPage({required this.employee, required this.onUpdate});

  @override
  _EmployeeEditPageState createState() => _EmployeeEditPageState();
}

class _EmployeeEditPageState extends State<EmployeeEditPage> {
  late TextEditingController fullNameController;
  late TextEditingController addressController;
  late TextEditingController mailController;
  late TextEditingController contactController;
  late TextEditingController genderController;

  @override
  void initState() {
    super.initState();

    // Initialize controllers with the existing employee data
    fullNameController = TextEditingController(text: widget.employee.fullName);
    addressController = TextEditingController(text: widget.employee.address);
    mailController = TextEditingController(text: widget.employee.mail);
    contactController = TextEditingController(text: widget.employee.contact);
    genderController = TextEditingController(text: widget.employee.gender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Employee'),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white70,
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,           // Border width
                    ),
                  ),
                  child: TextField(
                    controller: fullNameController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.person_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,           // Border width
                    ),
                  ),
                  child: TextField(
                    controller: addressController,
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.home_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,           // Border width
                    ),
                  ),
                  child: TextField(
                    controller: mailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.email_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,           // Border width
                    ),
                  ),
                  child: TextField(
                    controller: contactController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    border: Border.all(
                      color: Colors.black, // Border color
                      width: 1.0,           // Border width
                    ),
                  ),
                  child: TextField(
                    controller: genderController,
                    decoration: InputDecoration(border: InputBorder.none,prefixIcon: Icon(
                      Icons.male
                    )
                    ),
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    // Handle save button pressed
                    _saveChanges();
                  },
                  child: Text('Save Changes',style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                  style: ElevatedButton.styleFrom(primary: Colors.green),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _saveChanges() async {
    try {
      final updatedEmployee = Employee(
        id: widget.employee.id,
        fullName: fullNameController.text,
        address: addressController.text,
        mail: mailController.text,
        contact: contactController.text,
        gender: genderController.text,
        fingerPrint: widget.employee.fingerPrint,
      );

      // Send the updatedEmployee data to Firebase
      String firebaseUrl =
          "https://emloyeedetails-default-rtdb.firebaseio.com/employee/${updatedEmployee.id}.json";

      final response = await http.put(
        Uri.parse(firebaseUrl),
        body: jsonEncode(updatedEmployee.toJson()),
      );

      if (response.statusCode == 200) {
        // If the update request is successful, call the onUpdate callback
        // to update the employee in the parent EmployeeListPage
        widget.onUpdate(updatedEmployee);

        print("Employee updated successfully");
        Fluttertoast.showToast(
          msg: 'Data Updated successfully',
          backgroundColor: Colors.green,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.TOP_RIGHT,
          textColor: Colors.white,
          fontSize: 16.0,
        );

        // Close the EmployeeEditPage
        Navigator.pop(context);
      } else {
        print("Failed to update employee. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error updating employee: $error");
    }
  }
}
