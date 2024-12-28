import 'package:flutter/material.dart';
import 'package:ventou/page/screens/home/category_selection.dart';
import 'package:ventou/page/screens/home/producr_items.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
          child: Column(
        children: [
          mySearchBar(),
          // for a list of category,
          const CategorySelection(),
          // for disply all product itmes
          const ProductItems(),
        ],
      )),
    );
  }

  Padding mySearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        width: double.infinity,
        height: 50,
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
        ),
        child: const TextField(
          decoration: InputDecoration(
              border: OutlineInputBorder(borderSide: BorderSide.none),
              contentPadding:
                  EdgeInsets.symmetric(vertical: 20, horizontal: 30),
              fillColor: Colors.white,
              hintText: "Recherche...",
              hintStyle: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Colors.black26,
              ),
              prefixIcon: Icon(
                Icons.search,
                size: 30,
                color: Colors.black26,
              )),
        ),
      ),
    );
  }
}
