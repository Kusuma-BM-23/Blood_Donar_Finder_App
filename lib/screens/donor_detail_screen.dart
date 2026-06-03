import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class DonorDetailScreen extends StatelessWidget {
  final dynamic donor;

  const DonorDetailScreen({super.key, required this.donor});

  Future<void> callDonor(String phone) async {
    final Uri uri = Uri.parse("tel:$phone");

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Donor Details"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              donor['name'],
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Text("Blood Group: ${donor['bloodGroup']}"),
            Text("Phone: ${donor['phone']}"),
            Text("Location: ${donor['location']}"),
            Text("Email: ${donor['email']}"),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () =>
                  callDonor(donor['phone']),
              icon: const Icon(Icons.call),
              label: const Text("Call Donor"),
            ),
          ],
        ),
      ),
    );
  }
}