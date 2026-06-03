import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'donor_list_screen.dart';
import 'register_screen.dart';
import 'edit_profile_screen.dart';
import 'login_screen.dart';
import 'emergency_request_screen.dart';
import 'donor_profile_screen.dart';
import 'emergency_list_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  Future<void> logout(BuildContext context) async {

    await FirebaseAuth.instance.signOut();

    Navigator.pushAndRemoveUntil(
      context,

      MaterialPageRoute(
        builder: (_) =>
            const LoginScreen(),
      ),

      (route) => false,
    );
  }

  Widget actionButton({
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {

    return Card(
      elevation: 5,

      child: ListTile(

        leading: CircleAvatar(
          backgroundColor: color,

          child: Icon(
            icon,
            color: Colors.white,
          ),
        ),

        title: Text(
          title,

          style: const TextStyle(
            fontWeight:
                FontWeight.bold,
          ),
        ),

        trailing:
            const Icon(Icons.arrow_forward_ios),

        onTap: onTap,
      ),
    );
  }

  Future<void> handleBecomeDonor(
      BuildContext context) async {

    final uid =
        FirebaseAuth.instance.currentUser!.uid;

    final donorDoc =
        await FirebaseFirestore.instance
            .collection('donors')
            .doc(uid)
            .get();

    if (donorDoc.exists) {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const DonorProfileScreen(),
        ),
      );

    } else {

      Navigator.push(
        context,

        MaterialPageRoute(
          builder: (_) =>
              const RegisterScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(

        title: const Text(
          "Blood Donor Finder",
        ),

        backgroundColor: Colors.red,

        actions: [

          IconButton(
            icon: const Icon(Icons.search),

            onPressed: () {

              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (_) =>
                      const DonorListScreen(),
                ),
              );
            },
          ),

          IconButton(
            icon: const Icon(Icons.edit),

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

          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () =>
                logout(context),
          ),
        ],
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(15),

        child: Column(
          children: [

            /// WELCOME BOX
            Container(

              width: double.infinity,

              padding:
                  const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: Colors.red,

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: const Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Text(
                    "Welcome ❤️",

                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 5),

                  Text(
                    "Donate Blood, Save Lives",

                    style: TextStyle(
                      color:
                          Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            /// LIVE COUNTS
            StreamBuilder<QuerySnapshot>(

              stream:
                  FirebaseFirestore.instance
                      .collection('donors')
                      .snapshots(),

              builder: (
                context,
                donorSnapshot,
              ) {

                if (!donorSnapshot.hasData) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final donors =
                    donorSnapshot.data!.docs;

                final totalDonors =
                    donors.length;

                final availableDonors =
                    donors.where((doc) {

                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  return data[
                          'availability'] ==
                      true;

                }).length;

                return StreamBuilder<
                    QuerySnapshot>(

                  stream:
                      FirebaseFirestore
                          .instance
                          .collection(
                              'emergency_requests')
                          .snapshots(),

                  builder: (
                    context,
                    requestSnapshot,
                  ) {

                    if (!requestSnapshot
                        .hasData) {

                      return const Center(
                        child:
                            CircularProgressIndicator(),
                      );
                    }

                    final emergencyCount =
                        requestSnapshot
                            .data!
                            .docs
                            .length;

                    return Row(
                      children: [

                        /// DONORS CARD
                        Expanded(
                          child:
                              GestureDetector(

                            onTap: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DonorListScreen(),
                                ),
                              );
                            },

                            child: Card(
                              elevation: 5,

                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(15),

                                child: Column(
                                  children: [

                                    Text(
                                      totalDonors
                                          .toString(),

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            24,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            Colors.red,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            5),

                                    const Text(
                                      "Donors",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// AVAILABLE CARD
                        Expanded(
                          child:
                              GestureDetector(

                            onTap: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const DonorListScreen(
                                        showOnlyAvailable:
                                            true,
                                      ),
                                ),
                              );
                            },

                            child: Card(
                              elevation: 5,

                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(15),

                                child: Column(
                                  children: [

                                    Text(
                                      availableDonors
                                          .toString(),

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            24,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            Colors.green,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            5),

                                    const Text(
                                      "Available",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),

                        /// EMERGENCY CARD
                        Expanded(
                          child:
                              GestureDetector(

                            onTap: () {

                              Navigator.push(
                                context,

                                MaterialPageRoute(
                                  builder: (_) =>
                                      const EmergencyListScreen(),
                                ),
                              );
                            },

                            child: Card(
                              elevation: 5,

                              child: Container(
                                padding:
                                    const EdgeInsets
                                        .all(15),

                                child: Column(
                                  children: [

                                    Text(
                                      emergencyCount
                                          .toString(),

                                      style:
                                          const TextStyle(
                                        fontSize:
                                            24,

                                        fontWeight:
                                            FontWeight.bold,

                                        color:
                                            Colors.red,
                                      ),
                                    ),

                                    const SizedBox(
                                        height:
                                            5),

                                    const Text(
                                      "Emergency",
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),

            const SizedBox(height: 25),

            /// FIND DONOR
            actionButton(
              icon: Icons.search,

              title: "Find Donor",

              color: Colors.red,

              onTap: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const DonorListScreen(),
                  ),
                );
              },
            ),

            /// BECOME DONOR
            actionButton(
              icon:
                  Icons.volunteer_activism,

              title:
                  "Become / Manage Donor",

              color: Colors.green,

              onTap: () =>
                  handleBecomeDonor(
                      context),
            ),

            /// EMERGENCY REQUEST
            actionButton(
              icon: Icons.warning,

              title:
                  "Emergency Request",

              color: Colors.orange,

              onTap: () {

                Navigator.push(
                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        const EmergencyRequestScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}