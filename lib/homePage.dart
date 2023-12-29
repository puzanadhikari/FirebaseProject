import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui' as ui;
import 'package:contacts_service/contacts_service.dart';
import 'package:fluttertoast/fluttertoast.dart';
import "package:http/http.dart" as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:image_picker/image_picker.dart';
import 'package:local_auth/local_auth.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

import 'drawer_page.dart';
import 'employee_list.dart';
import 'map_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final mailController = TextEditingController();
  final contactController = TextEditingController();

   ByteData? bytes;
  DatabaseReference? dbRef;
  String selectedRadio = 'Male';
  File? imageFile;
  bool authorised = false;
  bool photo = false;
  bool fingerprint = false;

  @override
  void initstate() {
    super.initState();
    dbRef = FirebaseDatabase.instance.ref().child('Employee');
  }

  Future<void> authenticateUser(BuildContext context) async {
    final localAuth = LocalAuthentication();
    bool didAuthenticate = false;
    try {
      didAuthenticate = await localAuth.authenticate(
        localizedReason: 'Please Give your Biometric to continue',
      );
      log(didAuthenticate.toString());
      setState(() {
        authorised = didAuthenticate;
        Fluttertoast.showToast(
            msg: 'Fingerprint added successfully',
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
        log("auth" + authorised.toString());
      });
    } catch (e) {
      print('Error during authentication: $e');
    }
    // Navigator.of(context).pop();
    // onAuthenticationComplete(didAuthenticate);
  }

  GlobalKey<SfSignaturePadState> _signaturePadKey = GlobalKey();

  void _getFromCamera(context) async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      maxHeight: 1080,
      maxWidth: 1080,
    );

    if (pickedFile != null) {
      setState(() {
        imageFile = File(pickedFile.path);
      });

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Preview Image'),
            content: Column(
              children: [
                Image.file(File(pickedFile.path)),
                ElevatedButton(
                  onPressed: () async {
                    // Save the image to the gallery
                    final Uint8List bytes =
                        await File(pickedFile.path).readAsBytes();
                    // await ImageGallerySaver.saveImage(bytes);
                    Fluttertoast.showToast(
                        msg: 'Photo added successfully',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.TOP_RIGHT,
                        backgroundColor: Colors.green,
                        textColor: Colors.white,
                        fontSize: 16.0);
                    photo = true;
                    Navigator.pop(context); // Close the dialog
                    // Close the camera picker dialog
                  },
                  child: Text('Upload Image'),
                ),
              ],
            ),
          );
        },
      );
    }
  }

  void _handleSaveButtonPressed() async {
    final data = await _signaturePadKey.currentState!.toImage(pixelRatio: 3.0);
     bytes = await data.toByteData(format: ui.ImageByteFormat.png);

    // Save the image to the gallery
    await ImageGallerySaver.saveImage(
        Uint8List.fromList(bytes!.buffer.asUint8List()));

    // Show a message to indicate that the image has been saved
    Fluttertoast.showToast(
        msg: 'Fingerprint saved to gallery',
        backgroundColor: Colors.green,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.TOP_RIGHT,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  // Widget _previewImages() {
  //   if (retrieveError != null) {
  //     return retrieveError;
  //   }
  //   if (_mediaFileList != null) {
  //     return Semantics(
  //       label: 'image_picker_example_picked_images',
  //       child: ListView.builder(
  //         key: UniqueKey(),
  //         itemBuilder: (BuildContext context, int index) {
  //           final String? mime = lookupMimeType(_mediaFileList![index].path);
  //
  //           // Why network for web?
  //           // See https://pub.dev/packages/image_picker_for_web#limitations-on-the-web-platform
  //           return Semantics(
  //             label: 'image_picker_example_picked_image',
  //             child: kIsWeb
  //                 ? Image.network(_mediaFileList![index].path)
  //                 : (mime == null || mime.startsWith('image/')
  //                 ? Image.file(
  //               File(_mediaFileList![index].path),
  //               errorBuilder: (BuildContext context, Object error,
  //                   StackTrace? stackTrace) {
  //                 return const Center(
  //                     child:
  //                     Text('This image type is not supported'));
  //               },
  //             )
  //                 : _buildInlineVideoPlayer(index)),
  //           );
  //         },
  //         itemCount: _mediaFileList!.length,
  //       ),
  //     );
  //   } else if (_pickImageError != null) {
  //     return Text(
  //       'Pick image error: $_pickImageError',
  //       textAlign: TextAlign.center,
  //     );
  //   } else {
  //     return const Text(
  //       'You have not yet picked an image.',
  //       textAlign: TextAlign.center,
  //     );
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Employee Details"),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Card(
          color: Colors.white70,
          margin: EdgeInsets.all(10.0),
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  "Employee Information",
                  style: TextStyle(
                      fontSize: 25,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 30),
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
                      hintText: "Enter Full Name",
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
                      hintText: "Enter Address",
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
                      hintText: "Enter Mail",
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
                      hintText: "Enter Contact Number",
                      border: InputBorder.none,
                      prefixIcon: Icon(
                        Icons.phone_rounded,
                        color: Colors.black,
                      ),
                      suffixIcon: GestureDetector(
                        onTap: ()async {
                          await _pickContact();
                        },
                        child: Icon(Icons.contacts_rounded),
                      )
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Gender :",
                      style: TextStyle(
                          fontSize: 15,
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 'Male',
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value.toString();
                              log(selectedRadio.toString());
                            });
                          },
                        ),
                        Text('Male'),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: 'Female',
                          groupValue: selectedRadio,
                          onChanged: (value) {
                            setState(() {
                              selectedRadio = value.toString();
                            });
                          },
                        ),
                        Text('Female'),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            authenticateUser(context);
                          },
                          icon: Icon(
                            Icons.fingerprint_rounded,
                          ),
                          color: Colors.green,
                          iconSize: 45,
                        ),
                        Text(
                          "FingerPrint",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            authorised == true
                                ? _getFromCamera(context)
                                : ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text('First add Fingerprint'),
                                    duration: Duration(seconds: 3),
                                    action: SnackBarAction(
                                      label: 'Action',
                                      onPressed: () {},
                                    ),
                                  ));
                          },
                          icon: Icon(Icons.camera_alt_outlined),
                          color: Colors.green,
                          iconSize: 45,
                        ),
                        Text(
                          "Camera",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        IconButton(
                          onPressed: () {
                            photo == true && authorised == true
                                ? showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Signature'),
                                        content:
                                            Text('Please add your Signature'),
                                        actions: <Widget>[
                                          Container(
                                            child: SfSignaturePad(
                                              minimumStrokeWidth: 2,
                                              maximumStrokeWidth: 3,
                                              strokeColor: Colors.yellow,
                                              backgroundColor: Colors.grey,
                                              key: _signaturePadKey,
                                            ),
                                            height: 200,
                                            width: 300,
                                          ),
                                          ElevatedButton(
                                              child: Text("Upload FingerPrint"),
                                              onPressed: () async {
                                                _handleSaveButtonPressed();
                                                Navigator.of(context).pop();
                                              }),
                                          // TextButton(
                                          //   onPressed: () {
                                          //     Navigator.of(context).pop();
                                          //   },
                                          //   child: Text('OK'),
                                          // ),
                                        ],
                                      );
                                    },
                                  )
                                : ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                    content: Text(photo == false &&
                                            authorised == true
                                        ? 'Add the photo first'
                                        : 'Add fingerprint and photo to continue'),
                                    duration: Duration(seconds: 3),
                                    action: SnackBarAction(
                                      label: 'Action',
                                      onPressed: () {},
                                    ),
                                  ));
                          },
                          icon: Icon(
                            Icons.book,
                          ),
                          color: Colors.green,
                          iconSize: 45,
                        ),
                        Text(
                          "signature",
                          style: TextStyle(color: Colors.green),
                        )
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 50),
               Row(
                 mainAxisAlignment: MainAxisAlignment.spaceAround,
                 children: [
                   ElevatedButton(
                     onPressed: () {
                       postDataToFirebase();
                     },
                     child: Text(
                       "Add",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.white),
                     ),
                     style: ElevatedButton.styleFrom(primary: Colors.green),
                   ),
                   ElevatedButton(
                     onPressed: () {
                       Navigator.push(context, MaterialPageRoute(builder: (context)=>EmployeeListPage()));
                     },
                     child: Text(
                       "View Data",
                       style: TextStyle(
                           fontSize: 20,
                           fontWeight: FontWeight.bold,
                           color: Colors.white),
                     ),
                     style: ElevatedButton.styleFrom(primary: Colors.green),
                   ),
                   IconButton(onPressed: (){
                     _mapScreen();
                   }, icon: Icon(Icons.map))
                 ],
               )
              ],
            ),
          ),
        ),
      ),
      drawer: DrawerPage(),
    );
  }

  void postDataToFirebase() async {
    String firebaseUrl =
        "https://emloyeedetails-default-rtdb.firebaseio.com/employee.json";

    Map<String, dynamic> postData = {
      'FullName': fullNameController.text,
      'Address': addressController.text,
      'Mail': mailController.text,
      'Contact': contactController.text,
      'Gender': selectedRadio.toString(),
      'FingerPrint': authorised,
      'Signature': bytes!.buffer.asUint8List()
    };

    try {
      final response = await http.post(
        Uri.parse(firebaseUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode(postData),
      );

      if (response.statusCode == 200) {
        print("Data successfully posted to Firebase");
        // Show success message
        Fluttertoast.showToast(
            msg: 'Data Added successfully',
            backgroundColor: Colors.green,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            textColor: Colors.white,
            fontSize: 16.0);
        // Reset input values
        fullNameController.clear();
        addressController.clear();
        mailController.clear();
        contactController.clear();
        setState(() {
          selectedRadio = 'Male';
          imageFile = null;
          authorised = false;
          photo = false;
        });
        if (_signaturePadKey.currentState != null) {
          _signaturePadKey.currentState!.clear();
        }
      } else {
        print(
            "Failed to post data to Firebase. Status code: ${response.statusCode}");
        print("Response body: ${response.body}");
        Fluttertoast.showToast(
            msg: 'Data Added Failed',
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            textColor: Colors.white,
            fontSize: 16.0);
        // Show error message
        Fluttertoast.showToast(
            msg: 'Failed to add data.Please try again',
            backgroundColor: Colors.red,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP_RIGHT,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    } catch (error) {
      print("Error posting data to Firebase: $error");
     // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error adding data. Please try again.'),
        ),
      );
    }
  }
  void _mapScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
  }
  Future<void> _pickContact() async {
    PermissionStatus permissionStatus = await Permission.contacts.request();

    if (permissionStatus == PermissionStatus.granted) {
      // Pick a contact
      Contact? contact = await ContactsService.openDeviceContactPicker();

      if (contact != null) {
        // Update the contactController with the selected contact's number
        setState(() {
          contactController.text = contact.phones?.isNotEmpty == true
              ? contact.phones!.first.value ?? ""
              : "";
        });
      }
    } else {
      // Handle denied or restricted permission
      // You may want to show a message or request the permission again
    }
  }
}
