import 'package:flutter/material.dart';

class VentouSubscriptionScreen extends StatelessWidget {
  const VentouSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'images/logo.png',
          height: 25,
        ),
        actions: [
          Image.asset(
            'images/menu.png',
            width: 24,
          ),
          const SizedBox(width: 16),
        ],
        backgroundColor: Colors.white,
        elevation: 10,
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Sans abonnement, vous avez la possibilité de faire 10 publications de produit (vente) gratuite. Une fois cette limite atteinte vous allez devoir vous abonner pour faire des publications en illimitées.',
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 32),
            SubscriptionOption(
              duration: '05 mois',
              price: '1000 Fcfa',
              features: [
                'Publication illimités',
                'Visibilité de tous les cadeaux',
                'Publications en tête de liste',
              ],
            ),
            SizedBox(height: 16),
            SubscriptionOption(
              duration: '12 mois',
              price: '2000 Fcfa',
              features: [
                'Publication illimités',
                'Visibilité de tous les cadeaux',
                'Publications en tête de liste',
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionOption extends StatelessWidget {
  final String duration;
  final String price;
  final List<String> features;

  const SubscriptionOption({
    required this.duration,
    required this.price,
    required this.features,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color.fromARGB(255, 5, 6, 80),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              duration,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              price,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: features
                  .map((feature) => Padding(
                        padding: EdgeInsets.only(bottom: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.check,
                                color: Colors.white, size: 16),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                feature,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
