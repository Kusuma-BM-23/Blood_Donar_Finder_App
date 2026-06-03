import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'edit_profile_screen.dart';
import 'login_screen.dart';

class DonorProfileScreen extends StatefulWidget {
  const DonorProfileScreen({super.key});

  @override
  State<DonorProfileScreen> createState() =>
      _DonorProfileScreenState();
}

class _DonorProfileScreenState
    extends State<DonorProfileScreen> {
  final uid = FirebaseAuth.instance.currentUser!.uid;

  Future<void> toggleAvailability(bool value) async {
    await FirebaseFirestore.instance
        .collection('donors')
        .doc(uid)
        .update({'availability': value});
  }

  Future<void> deleteAccount() async {
    await FirebaseFirestore.instance
        .collection('donors')
        .doc(uid)
        .delete();

    await FirebaseAuth.instance.currentUser!.delete();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const LoginScreen(),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Donor Profile"),
        backgroundColor: Colors.red,
      ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: FirebaseFirestore.instance
            .collection('donors')
            .doc(uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          final data =
              snapshot.data!.data()
                  as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundColor: Colors.red,
                  child: Text(
                    data['bloodGroup'],
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                Text(
                  data['name'],
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                Text(data['email']),
                Text(data['phone']),
                Text(data['location']),

                const SizedBox(height: 25),

                SwitchListTile(
                  value: data['availability'] ?? true,
                  activeColor: Colors.green,
                  title: const Text("Available to Donate"),
                  onChanged: toggleAvailability,
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  icon: const Icon(Icons.edit),
                  label: const Text("Edit Profile"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const EditProfileScreen(),
                      ),
                    );
                  },
                ),

                const SizedBox(height: 15),

                ElevatedButton.icon(
                  icon: const Icon(Icons.delete),
                  label: const Text("Delete Account"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                  onPressed: deleteAccount,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}