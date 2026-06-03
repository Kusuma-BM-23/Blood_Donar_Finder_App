import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyListScreen extends StatelessWidget {
  const EmergencyListScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: const Text(
          "Emergency Requests",
        ),
        backgroundColor: Colors.red,
      ),

      body: StreamBuilder<QuerySnapshot>(

        stream: FirebaseFirestore.instance
            .collection('emergency_requests')
            .orderBy('timestamp',
                descending: true)
            .snapshots(),

        builder: (context, snapshot) {

          if (!snapshot.hasData) {

            return const Center(
              child:
                  CircularProgressIndicator(),
            );
          }

          final requests =
              snapshot.data!.docs;

          if (requests.isEmpty) {

            return const Center(
              child: Text(
                "No Emergency Requests",
              ),
            );
          }

          return ListView.builder(

            itemCount: requests.length,

            itemBuilder: (context, index) {

              final data =
                  requests[index].data()
                      as Map<String, dynamic>;

              return Card(

                margin: const EdgeInsets.all(12),

                elevation: 5,

                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                          15),
                ),

                child: Padding(

                  padding:
                      const EdgeInsets.all(16),

                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,

                    children: [

                      Row(
                        children: [

                          Container(
                            padding:
                                const EdgeInsets
                                    .all(10),

                            decoration:
                                BoxDecoration(
                              color:
                                  Colors.red,

                              borderRadius:
                                  BorderRadius
                                      .circular(
                                          10),
                            ),

                            child: Text(
                              data[
                                      'bloodGroup'] ??
                                  '',

                              style:
                                  const TextStyle(
                                color:
                                    Colors.white,
                                fontWeight:
                                    FontWeight
                                        .bold,
                                fontSize: 18,
                              ),
                            ),
                          ),

                          const SizedBox(
                              width: 15),

                          Expanded(
                            child: Text(
                              data['patientName'] ??
                                  '',

                              style:
                                  const TextStyle(
                                fontSize: 20,
                                fontWeight:
                                    FontWeight
                                        .bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(
                          height: 15),

                      Text(
                        "Hospital: ${data['hospital']}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 8),

                      Text(
                        "Location: ${data['location']}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 8),

                      Text(
                        "Phone: ${data['phone']}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 8),

                      Text(
                        "Note: ${data['note']}",
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),

                      const SizedBox(
                          height: 15),

                      Container(

                        width: double.infinity,

                        padding:
                            const EdgeInsets
                                .all(12),

                        decoration:
                            BoxDecoration(
                          color:
                              Colors.red.shade50,

                          borderRadius:
                              BorderRadius
                                  .circular(10),
                        ),

                        child: const Row(
                          children: [

                            Icon(
                              Icons.warning,
                              color:
                                  Colors.red,
                            ),

                            SizedBox(width: 10),

                            Expanded(
                              child: Text(
                                "Urgent Blood Needed",
                                style: TextStyle(
                                  color:
                                      Colors.red,
                                  fontWeight:
                                      FontWeight
                                          .bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}