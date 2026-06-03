import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() =>
      _EditProfileScreenState();
}

class _EditProfileScreenState
    extends State<EditProfileScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final locationController = TextEditingController();

  bool availability = true;
  DateTime? lastDonationDate;

  @override
  void initState() {
    super.initState();
    loadUserData();
  }

  Future<void> loadUserData() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    final doc = await FirebaseFirestore.instance
        .collection('donors')
        .doc(uid)
        .get();

    final data = doc.data()!;

    nameController.text = data['name'];
    phoneController.text = data['phone'];
    locationController.text = data['location'];
    availability = data['availability'] ?? true;

    if (data['lastDonationDate'] != '') {
      lastDonationDate = DateTime.parse(
        data['lastDonationDate'],
      );
    }

    setState(() {});
  }

  Future<void> pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        lastDonationDate = picked;
      });
    }
  }

  Future<void> updateProfile() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;

    await FirebaseFirestore.instance
        .collection('donors')
        .doc(uid)
        .update({
      'name': nameController.text.trim(),
      'phone': phoneController.text.trim(),
      'location': locationController.text.trim(),
      'availability': availability,
      'lastDonationDate':
          lastDonationDate?.toIso8601String() ?? '',
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Profile Updated"),
      ),
    );

    Navigator.pop(context);
  }

  String getEligibilityText() {
    if (lastDonationDate == null) {
      return "No donation history";
    }

    final eligibleDate =
        lastDonationDate!.add(const Duration(days: 90));

    return "Eligible Again: ${eligibleDate.day}/${eligibleDate.month}/${eligibleDate.year}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: Colors.red,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: ListView(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Name",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: phoneController,
              decoration: const InputDecoration(
                labelText: "Phone",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: "Location",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 15),

            SwitchListTile(
              title: const Text("Available to Donate"),
              value: availability,
              onChanged: (value) {
                setState(() {
                  availability = value;
                });
              },
            ),

            const SizedBox(height: 15),

            ElevatedButton(
              onPressed: pickDate,
              child: Text(
                lastDonationDate == null
                    ? "Select Last Donation Date"
                    : "Last Donation: ${lastDonationDate!.day}/${lastDonationDate!.month}/${lastDonationDate!.year}",
              ),
            ),

            const SizedBox(height: 10),

            Text(
              getEligibilityText(),
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              onPressed: updateProfile,
              child: const Text("Update Profile"),
            ),
          ],
        ),
      ),
    );
  }
}