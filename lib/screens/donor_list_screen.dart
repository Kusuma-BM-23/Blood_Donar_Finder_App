import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DonorListScreen extends StatefulWidget {

  final bool showOnlyAvailable;

  const DonorListScreen({
    super.key,
    this.showOnlyAvailable = false,
  });

  @override
  State<DonorListScreen> createState() =>
      _DonorListScreenState();
}

class _DonorListScreenState
    extends State<DonorListScreen> {

  String searchBlood = "";

  String searchLocation = "";

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title: Text(
          widget.showOnlyAvailable
              ? "Available Donors"
              : "Blood Donors",
        ),

        backgroundColor: Colors.red,
      ),

      body: Column(
        children: [

          /// SEARCH BOXES
          Padding(
            padding:
                const EdgeInsets.all(12),

            child: Column(
              children: [

                TextField(

                  decoration:
                      InputDecoration(
                    hintText:
                        "Search Blood Group",

                    prefixIcon:
                        const Icon(
                      Icons.bloodtype,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                    ),
                  ),

                  onChanged: (value) {

                    setState(() {

                      searchBlood =
                          value
                              .toLowerCase();
                    });
                  },
                ),

                const SizedBox(height: 10),

                TextField(

                  decoration:
                      InputDecoration(
                    hintText:
                        "Search Location",

                    prefixIcon:
                        const Icon(
                      Icons.location_on,
                    ),

                    border:
                        OutlineInputBorder(
                      borderRadius:
                          BorderRadius
                              .circular(
                                  12),
                    ),
                  ),

                  onChanged: (value) {

                    setState(() {

                      searchLocation =
                          value
                              .toLowerCase();
                    });
                  },
                ),
              ],
            ),
          ),

          /// DONOR LIST
          Expanded(

            child:
                StreamBuilder<QuerySnapshot>(

              stream:
                  FirebaseFirestore
                      .instance
                      .collection(
                          'donors')
                      .snapshots(),

              builder:
                  (context, snapshot) {

                if (!snapshot.hasData) {

                  return const Center(
                    child:
                        CircularProgressIndicator(),
                  );
                }

                final donors =
                    snapshot.data!.docs
                        .where((doc) {

                  final data =
                      doc.data()
                          as Map<String,
                              dynamic>;

                  /// AVAILABLE FILTER
                  if (widget
                          .showOnlyAvailable &&
                      data['availability'] !=
                          true) {

                    return false;
                  }

                  /// BLOOD SEARCH
                  final bloodMatch =
                      data['bloodGroup']
                          .toString()
                          .toLowerCase()
                          .contains(
                              searchBlood);

                  /// LOCATION SEARCH
                  final locationMatch =
                      data['location']
                          .toString()
                          .toLowerCase()
                          .contains(
                              searchLocation);

                  return bloodMatch &&
                      locationMatch;

                }).toList();

                if (donors.isEmpty) {

                  return const Center(
                    child: Text(
                      "No Donors Found",
                    ),
                  );
                }

                return ListView.builder(

                  itemCount:
                      donors.length,

                  itemBuilder:
                      (context, index) {

                    final data =
                        donors[index]
                                .data()
                            as Map<String,
                                dynamic>;

                    return Card(

                      margin:
                          const EdgeInsets
                              .all(10),

                      elevation: 5,

                      shape:
                          RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius
                                .circular(
                                    15),
                      ),

                      child: ListTile(

                        leading:
                            CircleAvatar(
                          radius: 28,

                          backgroundColor:
                              Colors.red,

                          child: Text(
                            data[
                                    'bloodGroup'] ??
                                '',

                            style:
                                const TextStyle(
                              color: Colors
                                  .white,

                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        title: Text(
                          data['name'] ??
                              '',

                          style:
                              const TextStyle(
                            fontWeight:
                                FontWeight
                                    .bold,

                            fontSize: 18,
                          ),
                        ),

                        subtitle: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,

                          children: [

                            const SizedBox(
                                height:
                                    5),

                            Text(
                              "Phone: ${data['phone']}",
                            ),

                            Text(
                              "Location: ${data['location']}",
                            ),

                            const SizedBox(
                                height:
                                    5),

                            Row(
                              children: [

                                Icon(
                                  data['availability'] ==
                                          true
                                      ? Icons
                                          .check_circle
                                      : Icons
                                          .cancel,

                                  color:
                                      data['availability'] ==
                                              true
                                          ? Colors
                                              .green
                                          : Colors
                                              .red,

                                  size: 18,
                                ),

                                const SizedBox(
                                    width:
                                        5),

                                Text(
                                  data['availability'] ==
                                          true
                                      ? "Available"
                                      : "Unavailable",
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}