import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:newapp/homePage.dart';
import 'package:newapp/signupPage.dart';

import 'firebase_auth.dart';

// import 'firebase_auth.dart';

class LoginPage extends StatefulWidget {
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final FirebaseAuthService _auth=FirebaseAuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    // TODO: implement dispose
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white70,
      appBar: AppBar(
        title: Text(
          'Login Page',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15.0),
              color: Colors.blueGrey,
            ),
            width: 400,
            height: 400,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "LOGIN",
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        color: Colors.green),
                  ),
                  SizedBox(height: 40),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.email_outlined)
                      ),
                    ),
                  ),
                  SizedBox(height: 16.0),Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.0),
                      color: Colors.grey[200],
                    ),
                    child: TextField(
                      controller: passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        border: InputBorder.none,
                        prefixIcon: Icon(Icons.lock)
                      ),
                    ),
                  ),

                  SizedBox(height: 16.0),
                  ElevatedButton(
                    onPressed: () {
                     _auth.signInWithEmailAndPassword(context,emailController.text,passwordController.text);
                    },
                    child: Text('Login', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(primary: Colors.green),
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account?",
                        style: TextStyle(color: Colors.black, fontSize: 15),
                      ),
                      GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpLogin()),
                          );
                        },
                        child: Text(
                          "    Sign Up",
                          style: TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  // Future<void> login() async {
  //
  //
  //   // Replace the URL with your actual signup API endpoint
  //   final String apiUrl = 'https://emloyeedetails-default-rtdb.firebaseio.com/login.json';
  //
  //   try {
  //     final response = await http.post(
  //       Uri.parse(apiUrl),
  //       body: jsonEncode(
  //           {
  //             'username': emailController.text.toString(),
  //             'password': passwordController.text.toString()
  //           }
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       Fluttertoast.showToast(
  //           msg: 'Login successfully',
  //           backgroundColor: Colors.green,
  //           toastLength: Toast.LENGTH_SHORT,
  //           gravity: ToastGravity.TOP_RIGHT,
  //           textColor: Colors.white,
  //           fontSize: 16.0);
  //       // Successful signup
  //       print('login successful');
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => HomePage()),
  //       );
  //     } else {
  //       // Handle errors, e.g., display an error message
  //       print('login failed. Status code: ${response.statusCode}');
  //       print('Response body: ${response.body}');
  //     }
  //   } catch (e) {
  //     // Handle network or other errors
  //     print('Error during signup: $e');
  //   }
  // }
  void _Login() async{

    String email= emailController.text;
    String password= passwordController.text;

    // User? user =await _auth.signInWithEmailAndPassword(email, password);
    if(email!=null){
      print("User is successfully Signed In.");
      // Navigator
    }else{
      print("Some error happened");
    }

  }
}
