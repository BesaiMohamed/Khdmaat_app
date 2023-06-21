import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:newprojectflutter/widgets/custom_loader.dart';
import '../../resources/auth_res.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:image_picker/image_picker.dart';
import 'package:newprojectflutter/utils/img_picker.dart';

class MyInfo extends StatefulWidget {
  const MyInfo({super.key});
  @override
  State<MyInfo> createState() => _MyInfo();
}

class _MyInfo extends State<MyInfo> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final TextEditingController _name = TextEditingController();
  final TextEditingController _date = TextEditingController();
  final TextEditingController _bio = TextEditingController();
  final TextEditingController _Addrasse = TextEditingController();
  String currentAddress = '';
  Position? currentPosition;
  double latitude = 0;
  double longitude = 0;
  final TextEditingController _phone = TextEditingController();
  final CustomLoader _loader = CustomLoader();
  String sex = '';
  Uint8List? _image;
  String avtarurl = '';
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

  Future<bool> handleLocationPermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('خدمة تحديد المواقع غير مفعلة ')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('لا يوجد أذن الوصول إلى الموقع')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }

  Future<void> getCurrentPosition() async {
    final hasPermission = await handleLocationPermission();

    if (!hasPermission) return;
    await Geolocator.getCurrentPosition().then((Position position) {
      setState(() => currentPosition = position);
      getAddressFromLatLng(currentPosition!);
    }).catchError((e) {
      debugPrint(e);
    });
    latitude = currentPosition!.latitude;
    longitude = currentPosition!.longitude;
  }

  Future<void> getAddressFromLatLng(Position position) async {
    await placemarkFromCoordinates(
            currentPosition!.latitude, currentPosition!.longitude)
        .then((List<Placemark> placemarks) {
      Placemark place = placemarks[0];
      setState(() {
        currentAddress =
            '${place.street}, ${place.subAdministrativeArea}, ${place.country}, ${place.postalCode}';
      });
    }).catchError((e) {
      debugPrint(e);
    });
    _Addrasse.text = currentAddress;
  }

  updateinfo() async {
    String name = _name.text.toString().trim();
    String res = '';
    String phone = _phone.text.toString().trim();
    String date = _date.text.toString().trim();
    String bio = _bio.text.toString().trim();
    String sex2 = sex;
    String addreass = _Addrasse.text.toString().trim();
    double lat = latitude;
    double lang = longitude;
    if (_image != null) {
      res = await AuthRes().updateinfo(
          name, _image!, avtarurl, phone, bio, sex2, date, addreass, lat, lang);
    } else {
      res = await AuthRes().updateinfowithoutphoto(
          name, avtarurl, phone, bio, sex2, date, addreass, lat, lang);
    }
    if (res == 'success') {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: "نجحت العملية",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.green,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      Navigator.pop(context);
    } else {
      _loader.hideLoader();
      Fluttertoast.showToast(
        msg: res,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: const Color.fromARGB(255, 0, 138, 196),
        textColor: Colors.white,
        fontSize: 16.0,
      );
    }
  }

  @override
  void dispose() {
    _name.dispose();
    _date.dispose();
    _bio.dispose();
    _phone.dispose();
    _Addrasse.dispose();

    super.dispose();
  }

  @override
  void initState() {
    _Addrasse;
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text(
          "معلوماتي الشخصية",
          style: TextStyle(
              color: Colors.blue[900],
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Alexandria'),
        ),
        backgroundColor: Colors.white,
        leading: BackButton(
          color: Colors.blue[900],
        ),
      ),
      body: SingleChildScrollView(
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("Users")
                .doc(_auth.currentUser!.uid)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container();
              } else {
                _name.text = snapshot.data!.get("name");
                if (_date.text == '') {
                  _date.text = snapshot.data!.get("dateBirth");
                }
                if (sex == '') {
                  sex = snapshot.data!.get("sex");
                }

                _phone.text = snapshot.data!.get("phone");
                _bio.text = snapshot.data!.get("bio");
                avtarurl = snapshot.data!.get("photoUrl");
                return Column(
                  children: [
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      alignment: Alignment.center,
                      child: _image != null
                          ? CircleAvatar(
                              radius: 57,
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(57),
                                  border: Border.all(
                                      color: Colors.lightBlue, width: 2),
                                  color:
                                      const Color.fromARGB(80, 182, 177, 235),
                                  image: DecorationImage(
                                    fit: BoxFit.cover,
                                    image: MemoryImage(_image!),
                                  ),
                                ),
                              ),
                            )
                          : CachedNetworkImage(
                              imageUrl: snapshot.data!.get("photoUrl"),
                              imageBuilder: (context, imageProvider) =>
                                  CircleAvatar(
                                backgroundColor: Colors.lightBlue[300],
                                radius: 60,
                                child: CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 57,
                                  child: CircleAvatar(
                                    radius: 57,
                                    backgroundColor:
                                        Colors.black.withOpacity(0.5),
                                    child: IconButton(
                                      icon: const Icon(
                                        Icons.image,
                                        size: 30,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        pickImage();
                                      },
                                    ),
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        controller: _name,
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.person),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "الاسم كامل",
                          labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(97, 61, 60, 60),
                              fontFamily: "Alexandria"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.none,
                        controller: _date,
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(1950),
                              lastDate: DateTime(2100));
                          if (pickedDate != null) {
                            _date.text =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                          }
                          setState(() {});
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.date_range),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "تاريخ الميلاد",
                          labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(97, 61, 60, 60),
                              fontFamily: "Alexandria"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.grey,
                              width: 1), //border of dropdown button
                          borderRadius: BorderRadius.circular(
                              50), //border raiuds of dropdown button
                        ),
                        child: Container(
                          padding: const EdgeInsets.only(right: 20, left: 20),
                          child: DropdownButton<String>(
                            icon: const Icon(
                              Icons.arrow_drop_down,
                              size: 30,
                            ),
                            underline: Container(),
                            isExpanded: true,
                            onChanged: (String? newValue) {
                              setState(() {
                                sex = newValue!;
                              });
                            },
                            value: sex,
                            items: <String>['غير محدد', 'ذكر', 'أنثى']
                                .map<DropdownMenuItem<String>>((String value) {
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
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        controller: _phone,
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                        ],
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.phone),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "رقم الهاتف",
                          labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(97, 61, 60, 60),
                              fontFamily: "Alexandria"),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    //       IntrinsicWidth(child: هذي فكرته مليحة ترجع تاكس فيبد دينميكي
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        maxLines: 5,
                        controller: _bio,
                        decoration: InputDecoration(
                          suffixIcon: Container(
                            padding: const EdgeInsets.only(bottom: 90),
                            child: const Icon(Icons.pageview),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "حول",
                          labelStyle: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(97, 61, 60, 60),
                              fontFamily: "Alexandria"),
                        ),
                      ),
                    ),
                    //  )
                    const SizedBox(
                      height: 10,
                    ),
                    Container(
                      padding: const EdgeInsets.only(right: 20, left: 20),
                      child: TextFormField(
                        controller: _Addrasse,
                        decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.add_location),
                            onPressed: () {
                              getCurrentPosition();
                              initState();
                            },
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 17),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                color: Colors.black, width: 32.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          labelText: "موقعك",
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
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {
                                latitude;
                                longitude;
                              });
                              _loader.showLoader(context);
                              updateinfo();
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.blue[900]),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 15)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            child: const Text(
                              "حفظ",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: 'Alexandria',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          margin: const EdgeInsets.only(left: 10),
                          child: ElevatedButton(
                            onPressed: () async {
                              setState(() {});
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.redAccent),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.symmetric(
                                      horizontal: 60, vertical: 15)),
                              shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(20))),
                            ),
                            child: const Text(
                              "إلغاء",
                              style: TextStyle(
                                  fontSize: 23,
                                  fontFamily: 'Alexandria',
                                  color: Colors.white,
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                );
              }
            }),
      ),
    ));
  }
}
