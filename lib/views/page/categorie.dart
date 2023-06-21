import 'package:flutter/material.dart';
import 'package:newprojectflutter/resources/globel.dart' as globals;
import 'package:newprojectflutter/views/page/trending.dart';

class Categorie extends StatefulWidget {
  const Categorie({super.key});

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  List<String> listitem = [
    'كهرباء',
    'نجارة',
    'كهرباء',
    'طبخ',
    'خياطة',
    'دهن',
    'بناء',
    'حلاق',
    'سمكري',
    'سباك',
    'لحام'
  ];
  itemCati(String title) {
    return InkWell(
      onTap: () {
        globals.titelpageService = title;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const Trending(),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height / 15,
            width: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.grey[100],
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(40, 0, 0, 0),
                  blurRadius: 4,
                  offset: Offset(4, 8), // Shadow position
                ),
              ],
            ),
            padding: const EdgeInsets.all(7),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                color: Color.fromARGB(255, 75, 68, 83),
                fontFamily: 'Alexandria',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: const Text(
          "الفئات",
          style: TextStyle(
            fontSize: 22,
            color: Colors.purple,
            fontFamily: 'Alexandria',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        leading: const BackButton(
          color: Colors.purple,
        ),
      ),
      body: ListView.builder(
        itemCount: listitem.length,
        itemBuilder: (context, index) {
          return itemCati(listitem[index]);
        },
      ),
    ));
  }
}
