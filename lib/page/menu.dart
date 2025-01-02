// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:ventou/page/paiment/plan_abommennt.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Name
              const Row(
                children: [
                  Text(
                    'Mike',
                    style: TextStyle(
                      fontSize: 24,
                      color: Color.fromARGB(255, 15, 29, 116),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: Color.fromARGB(255, 15, 29, 116),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              // Dashboard
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.orange),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tableaux de bord :',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildStatRow(
                        'Total de publications :', '07', Colors.orange),
                    _buildStatRow(
                      'Total de clics :',
                      '5024',
                      const Color.fromARGB(255, 15, 29, 116),
                    ),
                    _buildStatRow('Total d\'appels :', '120', Colors.orange),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Subscription Button
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const VentouSubscriptionScreen(),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 15, 29, 116),
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.attach_money, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      'Prendre l\'abonnement',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Menu Options
              _buildMenuButton(
                'Options',
                Icons.settings,
                const Color.fromARGB(255, 15, 29, 116),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                'Partage',
                Icons.share,
                const Color.fromARGB(255, 15, 29, 116),
              ),
              const SizedBox(height: 12),
              _buildMenuButton(
                'Foire aux questions',
                Icons.help,
                const Color.fromARGB(255, 15, 29, 116),
              ),
              const SizedBox(height: 12),
              _buildMenuButton('Se déconnecter', Icons.exit_to_app,
                  const Color.fromARGB(255, 163, 17, 6)),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 14,
              color: valueColor,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuButton(String text, IconData icon, Color color) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        foregroundColor: color,
        side: BorderSide(color: color),
        minimumSize: const Size(double.infinity, 50),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(icon),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(IconData icon) {
    return IconButton(
      icon: Icon(icon, color: Colors.white),
      onPressed: () {},
    );
  }
}
