import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EmergencyRequestScreen extends StatefulWidget {
  const EmergencyRequestScreen({super.key});

  @override
  State<EmergencyRequestScreen> createState() =>
      _EmergencyRequestScreenState();
}

class _EmergencyRequestScreenState
    extends State<EmergencyRequestScreen> {

  final patientController =
      TextEditingController();

  final bloodController =
      TextEditingController();

  final hospitalController =
      TextEditingController();

  final phoneController =
      TextEditingController();

  final locationController =
      TextEditingController();

  final noteController =
      TextEditingController();

  Future<void> postRequest() async {

    if (patientController.text.isEmpty ||
        bloodController.text.isEmpty ||
        hospitalController.text.isEmpty ||
        phoneController.text.isEmpty ||
        locationController.text.isEmpty) {

      ScaffoldMessenger.of(context)
          .showSnackBar(
        const SnackBar(
          content: Text(
            "Please fill all required fields",
          ),
        ),
      );

      return;
    }

    final user =
        FirebaseAuth.instance.currentUser;

    await FirebaseFirestore.instance
        .collection('emergency_requests')
        .add({

      /// WHO SENT REQUEST
      'senderUid': user?.uid,

      'senderEmail': user?.email,

      'senderName':
          patientController.text.trim(),

      /// PATIENT DETAILS
      'patientName':
          patientController.text.trim(),

      'bloodGroup':
          bloodController.text.trim(),

      'hospital':
          hospitalController.text.trim(),

      'phone':
          phoneController.text.trim(),

      'location':
          locationController.text.trim(),

      'note':
          noteController.text.trim(),

      'status': 'active',

      'timestamp':
          FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(
      const SnackBar(
        content: Text(
          "Emergency Request Posted Successfully",
        ),
        backgroundColor: Colors.green,
      ),
    );

    patientController.clear();

    bloodController.clear();

    hospitalController.clear();

    phoneController.clear();

    locationController.clear();

    noteController.clear();

    Navigator.pop(context);
  }

  Widget buildField(
    TextEditingController controller,
    String label,
    IconData icon,
  ) {

    return Padding(
      padding:
          const EdgeInsets.only(bottom: 18),

      child: TextField(
        controller: controller,

        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: Colors.red,
          ),

          labelText: label,

          filled: true,

          fillColor: Colors.white,

          border: OutlineInputBorder(
            borderRadius:
                BorderRadius.circular(
                    15),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      backgroundColor: Colors.grey[100],

      appBar: AppBar(
        title: const Text(
          "Emergency Blood Request",
        ),

        backgroundColor: Colors.red,
      ),

      body: SingleChildScrollView(

        padding:
            const EdgeInsets.all(20),

        child: Column(
          children: [

            /// ALERT BOX
            Container(

              padding:
                  const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: Colors.red.shade50,

                borderRadius:
                    BorderRadius.circular(
                        20),
              ),

              child: const Row(
                crossAxisAlignment:
                    CrossAxisAlignment.start,

                children: [

                  Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.red,
                    size: 35,
                  ),

                  SizedBox(width: 12),

                  Expanded(
                    child: Text(
                      "Post urgent blood requirements here. Nearby donors can immediately contact and help the patient.",
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight:
                            FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 30),

            /// PATIENT NAME
            buildField(
              patientController,
              "Patient Name",
              Icons.person,
            ),

            /// BLOOD GROUP
            buildField(
              bloodController,
              "Blood Group Needed",
              Icons.bloodtype,
            ),

            /// HOSPITAL
            buildField(
              hospitalController,
              "Hospital Name",
              Icons.local_hospital,
            ),

            /// PHONE
            buildField(
              phoneController,
              "Phone Number",
              Icons.phone,
            ),

            /// LOCATION
            buildField(
              locationController,
              "Location",
              Icons.location_on,
            ),

            /// NOTE
            buildField(
              noteController,
              "Emergency Note (Optional)",
              Icons.note,
            ),

            const SizedBox(height: 20),

            /// BUTTON
            SizedBox(
              width: double.infinity,
              height: 58,

              child:
                  ElevatedButton.icon(

                onPressed:
                    postRequest,

                icon: const Icon(
                  Icons.warning,
                  color: Colors.white,
                ),

                label: const Text(
                  "Post Emergency Request",

                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.white,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.red,

                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                            15),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}