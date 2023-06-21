import 'dart:typed_data';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:newprojectflutter/utils/img_picker.dart';
import 'package:newprojectflutter/widgets/custom_loader.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newprojectflutter/resources/proj_res.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class updateProject extends StatefulWidget {
  final String? servid;
  const updateProject({super.key, this.servid});
  @override
  State<updateProject> createState() => _updateProjectState();
}

class _updateProjectState extends State<updateProject> {
  final TextEditingController _title = TextEditingController();
  final TextEditingController _description = TextEditingController();
  final TextEditingController _type = TextEditingController();
  final CustomLoader _loader = CustomLoader();
  Uint8List? _image;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String type = 'فئة الخدمة';

  @override
  void dispose() {
    _title.dispose();
    _description.dispose();
    _type.dispose();
    super.dispose();
  }

  pickImage() async {
    PermissionStatus p = await Permission.camera.request();
    if (p == PermissionStatus.granted) {
      Uint8List? im = await getPickedImage(ImageSource.gallery);
      setState(() {
        _image = im;
      });
    }
    if (p == PermissionStatus.denied) {
      Fluttertoast.showToast(
          msg: "تحتاج سماح على الأذونات",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: const Color.fromARGB(255, 0, 138, 196),
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  updateProject(String servid) async {
    String name = _title.text.toString().trim();
    String description = _description.text.toString().trim();
    String type = _type.text.toString().trim();
    String res;
    if (_type.text == 'فئة الخدمة') {
      Fluttertoast.showToast(
          msg: "يرجي إختيار الفئة",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16.0);
    } else {
      if (_image != null) {
        res = await ProjectRes().updateProject(
          servid,
          name,
          description,
          type,
          _image!,
        );
      } else {
        res = await ProjectRes().updateProjectwithoutimg(
          servid,
          name,
          description,
          type,
        );
      }
      if (res == 'success') {
        _loader.hideLoader();
        Navigator.pop(context);
        Fluttertoast.showToast(
            msg: "تم تحديث الخدمة بنجاح",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.green,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        _loader.hideLoader();
        Fluttertoast.showToast(
            msg: res,
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIosWeb: 1,
            backgroundColor: Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      }
    }
  }

  ////
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0,
        iconTheme: const IconThemeData(
          color: Color.fromARGB(255, 0, 138, 196),
        ),
        title: const Text(
          "تحديث خدمة",
          style: TextStyle(
            color: Color.fromARGB(255, 0, 138, 196),
            fontFamily: "Alexandria",
          ),
        ),
      ),
      body: StreamBuilder(
        stream:
            _firestore.collection("Services").doc(widget.servid).snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Text("fgdfgf");
          } else {
            print(widget.servid.toString());
            _description.text = snapshot.data!.get("description");
            type = snapshot.data!.get("catogry");
            _title.text = snapshot.data!.get("title");
            return Container(
              alignment: Alignment.topRight,
              height: double.infinity,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
              ),
              child: SingleChildScrollView(
                ///يا الطاهر هذي هيا الودجت لي قتلك عليها
                child: Form(
                  // هذا المفتاح هو لي نفاليدي بيه الحقول كاملين
                  //  key: _glonlfey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 10),
                        child: GestureDetector(
                          onTap: () {
                            pickImage();
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(25),
                            child: _image != null
                                ? Container(
                                    height: 250,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      color: const Color.fromARGB(
                                          80, 182, 177, 235),
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: MemoryImage(_image!),
                                      ),
                                    ),
                                  )
                                : Container(
                                    height: 250,
                                    width: 400,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25.0),
                                      border:
                                          Border.all(color: Colors.blueAccent),
                                      color: Colors.grey[300],
                                    ),
                                    child: Image.network(
                                      snapshot.data!.get("imgUrl"),
                                      fit: BoxFit.cover,
                                    )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 7),
                        width: 400,
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xF4f4f4f4),
                        ),

                        /// الاسم full name
                        ///
                        child: TextFormField(
                          controller: _title,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.design_services),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 17),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 32.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: "اسم الخدمة",
                            labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(97, 61, 60, 60),
                                fontFamily: "Alexandria"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 7),
                        width: 400,
                        height: 150,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: const Color(0xF4f4f4f4),
                        ),
                        child: TextFormField(
                          expands: true,
                          maxLines: null,
                          controller: _description,
                          decoration: InputDecoration(
                            suffixIcon: const Icon(Icons.description),
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 17),
                            border: OutlineInputBorder(
                              borderSide: const BorderSide(
                                  color: Colors.black, width: 32.0),
                              borderRadius: BorderRadius.circular(25.0),
                            ),
                            labelText: "الوصف",
                            labelStyle: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color.fromARGB(97, 61, 60, 60),
                                fontFamily: "Alexandria"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      /*
                Container(
                  margin: const EdgeInsets.only(right: 7),
                  width: 400,
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: const Color(0xF4f4f4f4),
                  ),
                  //الوصف
                  child: TextFormField(
                    controller: _type,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 17),
                      border: OutlineInputBorder(
                        borderSide:
                            const BorderSide(color: Colors.black, width: 32.0),
                        borderRadius: BorderRadius.circular(25.0),
                      ),
                      labelText: "نوع الخدمة ",
                      labelStyle: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(97, 61, 60, 60),
                          fontFamily: "Alexandria"),
                      suffixIcon: const Icon(Icons.tag),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 25,
                ),
                */
                      Container(
                        padding: const EdgeInsets.only(right: 12, left: 10),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            color: const Color(0xF4f4f4f4),

                            border: Border.all(
                                color: Colors.grey,
                                width: 1), //border of dropdown button
                            borderRadius: BorderRadius.circular(
                                50), //border raiuds of dropdown button
                          ),
                          child: Container(
                            padding: const EdgeInsets.only(right: 20, left: 20),
                            child: DropdownButton<String>(
                              hint: const Text(
                                "فئة الخدمة",
                                style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(97, 61, 60, 60),
                                    fontFamily: "Alexandria"),
                              ),
                              icon: const Icon(
                                Icons.arrow_drop_down,
                                size: 30,
                              ),
                              underline: Container(),
                              isExpanded: true,
                              onChanged: (String? newValue) {
                                setState(() {
                                  type = newValue!;
                                  _type.text = type;
                                  print(_type.text);
                                });
                              },
                              value: type,
                              items: <String>[
                                'فئة الخدمة',
                                'بناء',
                                'صيانة الأجهزة',
                                'تصليح سيارات',
                                'سمكرة',
                                'نجارة',
                                'دهن',
                                'خياطة',
                                'طبخ',
                                'كهرباء',
                                'تنظيف'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: "Alexandria"),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Container(
                        margin: const EdgeInsets.only(right: 20),
                        child: ElevatedButton(
                          //الطاهر هنا لازم المستخدم كي يدخل للالصفحة الرئسية لازم ديرلوا انوا ما يقدرش يرج للور باBrake
                          onPressed: () async {
                            if (_image != null) {
                              _loader.showLoader(context);
                              updateProject(widget.servid!);
                            } else {
                              updateProject(widget.servid!);
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.yellow[700]),
                            padding: MaterialStateProperty.all(
                                const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 15)),
                            shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20))),
                          ),
                          child: Text(
                            "تحديث الخدمة ",
                            style: TextStyle(
                                fontSize: 23,
                                fontFamily: 'Alexandria',
                                color: Colors.grey[800],
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
