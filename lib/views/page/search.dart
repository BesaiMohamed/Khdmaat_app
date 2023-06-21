import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:newprojectflutter/resources/favorite.dart';
import 'package:newprojectflutter/resources/bookmark.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/project/service_details.dart';

class Search extends StatefulWidget {
  const Search({super.key});
  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController value = TextEditingController();
  Icon customIcon = const Icon(Icons.search);
  bool pagecondition = true;
  Widget customSearchBar = const Text(
    'قم بالبحث هنا',
    style: TextStyle(
      fontSize: 20,
      color: Colors.black,
      fontFamily: 'Alexandria',
      fontWeight: FontWeight.bold,
    ),
  );
  @override
  void dispose() {
    value.dispose();
    super.dispose();
  }

  verfiheart(String uid) async {
    await favorite().verfieheart(uid);
  }

  verfibookmark(String uid) async {
    await bookmark().verfibookmark(uid);
  }

  ServItem(
    String Servid,
  ) {
    return InkWell(
      onTap: () {
        setState(() {
          globals.uidServ = Servid;
          verfiheart(globals.uidServ);
          verfibookmark(globals.uidServ);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const servdetail(),
          ),
        );
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Services")
              .doc(Servid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(40, 0, 0, 0),
                      blurRadius: 4,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ],
                ),
                height: 155,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: snapshot.data!.get('imgUrl'),
                      imageBuilder: (context, imageProvider) => Container(
                        width: MediaQuery.of(context).size.width / 3,
                        padding: const EdgeInsets.all(1),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            image: DecorationImage(
                                image: imageProvider, fit: BoxFit.cover)),
                      ),
                    ),
                    Column(
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          child: Text(snapshot.data!.get('title'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Alexandria')),
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          padding: const EdgeInsets.only(right: 7),
                          child: Text(snapshot.data!.get('description'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 10,
                                  fontFamily: 'Alexandria')),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              );
            }
          })),
    );
  }

  userItem(
    String uid,
  ) {
    return InkWell(
      onTap: () {
        /*
        setState(() {
          globals.uidServ = Servid;
          verfiheart(globals.uidServ);
          verfibookmark(globals.uidServ);
        });
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const profileuser(),
          ),
        );
        */
      },
      child: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection("Users")
              .doc(uid)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Container();
            } else {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: const [
                    BoxShadow(
                      color: Color.fromARGB(40, 0, 0, 0),
                      blurRadius: 4,
                      offset: Offset(4, 8), // Shadow position
                    ),
                  ],
                ),
                height: 90,
                width: MediaQuery.of(context).size.width,
                child: Row(
                  children: [
                    CachedNetworkImage(
                      imageUrl: snapshot.data!.get('photoUrl'),
                      imageBuilder: (context, imageProvider) => CircleAvatar(
                        radius: 35,
                        backgroundImage: imageProvider,
                      ),
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          width: MediaQuery.of(context).size.width / 2.2,
                          height: 60,
                          padding: const EdgeInsets.all(10),
                          child: Text(snapshot.data!.get('name'),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 2,
                              softWrap: false,
                              style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontFamily: 'Alexandria')),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                ),
              );
            }
          })),
    );
  }

  requetlist() {
    if (pagecondition) {
      if (value.text.isEmpty) {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("Services")
              .orderBy("Count", descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    "لا توجد أعمال",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Alexandria",
                        color: Colors.blue[900]),
                  ),
                ],
              );
            } else {
              return ListView.separated(
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ServItem(snapshot.data!.docs[index]['serviceuid']);
                  });
            }
          }),
        );
      } else {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Services')
              .orderBy("Count", descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    "لا توجد أعمال",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Alexandria",
                        color: Colors.blue[900]),
                  ),
                ],
              );
            } else {
              List<String> listitem = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                String description = snapshot.data!.docs[i]['description'];
                if (description.contains(value.text.toString())) {
                  listitem.add(snapshot.data!.docs[i]['serviceuid']);
                }
              }
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 10);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  itemCount: listitem.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ServItem(listitem[index]);
                  });
            }
          }),
        );
      }
    } else {
      if (value.text.isEmpty) {
        return const Text(
          "ادخل اسم الحساب للبحث",
          style: TextStyle(
            color: Colors.black,
            fontSize: 14,
            fontFamily: 'Alexandria',
          ),
        );
      } else {
        return StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('Users')
              .orderBy("Nserviccomplet", descending: true)
              .snapshots(),
          builder: ((context, snapshot) {
            if (!snapshot.hasData) {
              return Column(
                children: [
                  Text(
                    "قائمة المستخدمين فارغة",
                    style: TextStyle(
                        fontSize: 17,
                        fontFamily: "Alexandria",
                        color: Colors.blue[900]),
                  ),
                ],
              );
            } else {
              List<String> listuser = [];
              for (int i = 0; i < snapshot.data!.docs.length; i++) {
                String nametarget = snapshot.data!.docs[i]['name'];
                if (nametarget.contains(value.text.toString())) {
                  listuser.add(snapshot.data!.docs[i]["uid"]);
                }
              }
              return ListView.separated(
                  separatorBuilder: (BuildContext context, int index) {
                    return const SizedBox(height: 9);
                  },
                  physics: const NeverScrollableScrollPhysics(),
                  primary: true,
                  shrinkWrap: true,
                  itemCount: listuser.length,
                  itemBuilder: (BuildContext context, int index) {
                    return userItem(listuser[index]);
                  });
            }
          }),
        );
      }
    }
  }

  pageselctor() {
    return Row(
      children: [
        const Icon(Icons.design_services),
        TextButton(
            onPressed: () {
              setState(() {
                pagecondition = true;
                value.text = '';
              });
            },
            child: const Text(
              "الخدمات",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Alexandria',
              ),
            )),
        const SizedBox(
          width: 15,
        ),
        const Icon(Icons.person_2),
        TextButton(
            onPressed: () {
              setState(() {
                pagecondition = false;
                value.text = '';
              });
            },
            child: const Text(
              "المستخدمين",
              style: TextStyle(
                color: Colors.black,
                fontSize: 15,
                fontFamily: 'Alexandria',
              ),
            )),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: TextField(
          onSubmitted: (value) {
            setState(() {});
          },
          controller: value,
          decoration: const InputDecoration(
            hintText: ' قم بالبحث هنا...',
            hintStyle: TextStyle(
              color: Colors.black,
              fontFamily: 'Alexandria',
              fontSize: 18,
              fontStyle: FontStyle.italic,
            ),
            border: InputBorder.none,
          ),
          style: const TextStyle(
            color: Colors.black,
          ),
        ),
        leading: const Icon(
          Icons.search,
          color: Colors.black,
          size: 28,
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          physics: const PageScrollPhysics(),
          child: Container(
            decoration: const BoxDecoration(color: Colors.white),
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [pageselctor(), requetlist()],
            ),
          )),
    ));
  }
}
