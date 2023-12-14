import 'package:flutter/material.dart';

import 'loginpage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: double.infinity,
            height: double.infinity,
            child: Image.network('https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcTqP1pQ1iNUprptmpHEBYELzWp-l_gRzc20ow&usqp=CAU',fit: BoxFit.fill),
            // child: Image.asset('assets/images/img_1.png',fit: BoxFit.cover,)
        ),  // Replace with your splash screen image path
      ),
    );
  }
}
