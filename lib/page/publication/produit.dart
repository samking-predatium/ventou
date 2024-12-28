import 'package:flutter/material.dart';

class VentouProductScreen extends StatelessWidget {
  const VentouProductScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Image.asset(
          'images/logo.png', // Assurez-vous que ce chemin est correct
          height: 30, // Ajustez la taille selon vos besoins
        ),
        actions: [
          Image.asset(
            'images/menu.png', // Assurez-vous que ce chemin est correct
            width: 24, // Ajustez la taille selon vos besoins
          ),
          const SizedBox(width: 16), // Espace après les points
        ],
        backgroundColor: const Color.fromARGB(255, 174, 6, 6),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Nom du produit',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Prix',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: 'Catégorie',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [], // Ajouter les catégories ici
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField(
              decoration: InputDecoration(
                hintText: 'Etat',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              items: const [], // Ajouter les états ici
              onChanged: (value) {},
            ),
            const SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(
                hintText: 'Contact WhatsApp',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 3,
              decoration: InputDecoration(
                hintText: 'Description',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: 100,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate, size: 40),
                    Text('Ajouter des photos'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text('Lieu'),
                const Spacer(),
                const Text('Abidjan'),
                TextButton(
                  child: const Text('Modifier'),
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {},
              child: const Text('Publier'),
            ),
          ],
        ),
      ),
    );
  }
}
