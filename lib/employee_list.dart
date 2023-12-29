import 'dart:convert';
import 'dart:developer';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'employee_edit.dart';
import 'employee_model.dart';

class EmployeeListPage extends StatefulWidget {
  @override
  _EmployeeListPageState createState() => _EmployeeListPageState();
}

class _EmployeeListPageState extends State<EmployeeListPage> {
  List<Employee> employees = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    List<Employee> fetchedEmployees = await fetchDataFromFirebase();
    setState(() {
      employees = fetchedEmployees;
      log(employees.toString());
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Employee List'),
        backgroundColor: Colors.green,
      ),
      body: isLoading ? _buildShimmerEffect( employees.length > 0 ? employees.length : 1) : ListView.builder(
        itemCount: employees.length,
        itemBuilder: (context, index) {
          Employee employee = employees[index];
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Text('Name:${employee.fullName}'),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Address: ${employee.address}'),
                  Text('Email: ${employee.mail}'),
                  Text('Contact: ${employee.contact}'),
                  Text('Gender: ${employee.gender}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: Icon(Icons.edit),
                    color: Colors.green,
                    onPressed: () {
                      // Handle edit action
                      _editEmployee(employee);
                    },
                  ),
                  IconButton(
                    icon: Icon(Icons.delete),
                    color: Colors.red,
                    onPressed: () {
                      // Handle delete action
                      _deleteEmployee(employee);
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildShimmerEffect(int itemCount) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: ListView.builder(
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return Card(
            elevation: 4,
            margin: EdgeInsets.all(8),
            child: ListTile(
              title: Container(
                height: 16,
                width: double.infinity,
                color: Colors.white,
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 12,
                    width: double.infinity,
                    color: Colors.white,
                  ),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                  SizedBox(width: 8),
                  Container(
                    width: 24,
                    height: 24,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Future<List<Employee>> fetchDataFromFirebase() async {
    List<Employee> employeeList = [];
    try {
      String firebaseUrl =
          "https://emloyeedetails-default-rtdb.firebaseio.com/employee.json";

      final response = await http.get(Uri.parse(firebaseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        data.forEach((key, value) {
          employeeList.add(Employee.fromJson(key, value));
          // log(employeeList.toString());
          log(jsonDecode(response.body).toString());
        });
      } else {
        print("Failed to fetch data from Firebase. Status code: ${response
            .statusCode}");
      }
    } catch (error) {
      print("Error fetching data from Firebase: $error");
    }
    return employeeList;
  }

  void _deleteEmployee(Employee employee) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this employee?'),
          actions: [
            TextButton(
              onPressed: () {
                // If the user clicks "Yes," proceed with deletion
                Navigator.of(context).pop();
                _performDelete(employee);
              },
              child: Text('Yes'),
            ),
            TextButton(
              onPressed: () {
                // If the user clicks "No" or closes the dialog, do nothing
                Navigator.of(context).pop();
              },
              child: Text('No'),
            ),
          ],
        );
      },
    );
  }

  void _performDelete(Employee employee) async {
    try {
      String firebaseUrl =
          "https://emloyeedetails-default-rtdb.firebaseio.com/employee/${employee
          .id}.json";
      // const dataRef = database.ref(dataPath);

      final response = await http.delete(Uri.parse(firebaseUrl));

      if (response.statusCode == 200) {
        // If the delete request is successful, remove the employee from the local list
        setState(() {
          employees.remove(employee);
        });
        print("Employee deleted successfully");
        Fluttertoast.showToast(
            msg: 'Data Deleted successfully',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            textColor: Colors.white,
            fontSize: 16.0
        );
      } else {
        print("Failed to delete employee. Status code: ${response.statusCode}");
      }
    } catch (error) {
      print("Error deleting employee: $error");
    }
  }

  void _editEmployee(Employee employee) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EmployeeEditPage(
              employee: employee,
              onUpdate: _updateEmployee,
            ),
      ),
    );
  }

  void _updateEmployee(Employee updatedEmployee) {
    int index = employees.indexWhere((e) => e.id == updatedEmployee.id);
    if (index != -1) {
      setState(() {
        employees[index] = updatedEmployee;
      });
    }
  }


}
