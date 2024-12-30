// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:ventou/page/publication/produit.dart';

class PublicationHomeScreen extends StatelessWidget {
  const PublicationHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              child: const Text('Je Vend', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const VentouProductScreen(),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: ElevatedButton(
              child:
                  const Text('Je fais un don', style: TextStyle(fontSize: 18)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => JeFaisUnDonPage(),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class JeVendPage extends StatelessWidget {
  const JeVendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Je Vend'),
      ),
      body: const Center(
        child: Text('Page Je Vend'),
      ),
    );
  }
}

class JeFaisUnDonPage extends StatelessWidget {
  const JeFaisUnDonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Je fais un don'),
      ),
      body: const Center(
        child: Text('Page Je fais un don'),
      ),
    );
  }
}
