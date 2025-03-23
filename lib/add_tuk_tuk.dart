import 'package:flutter/material.dart';
import 'admin_services.dart';

class AddTukTukPage extends StatefulWidget {
  @override
  _AddTukTukPageState createState() => _AddTukTukPageState();
}

class _AddTukTukPageState extends State<AddTukTukPage> {
  final AdminFirestoreService _adminService = AdminFirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  bool _isSubmitting = false;

  void addTukTuk(BuildContext context) async {
    // Basic validation
    if (nameController.text.trim().isEmpty ||
        plateController.text.trim().isEmpty ||
        cityController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill all fields"))
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      await _adminService.addTukTuk(
        nameController.text.trim(),
        plateController.text.trim(),
        cityController.text.trim(),
      );
      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _isSubmitting = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error adding Tuk-Tuk: ${e.toString()}"))
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header image section
            Container(
              height: 120,
              width: double.infinity,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.indigo[700]!, Colors.indigo[500]!],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.directions_car,
                    size: 48,
                    color: Colors.white,
                  ),
                  SizedBox(height: 10),
                  Text(
                    "New Tuk-Tuk Details",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // Form section
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Driver Information",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[700],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Driver Name Field
                      TextField(
                        controller: nameController,
                        decoration: InputDecoration(
                          labelText: "Driver Name",
                          prefixIcon: Icon(Icons.person, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // Vehicle Details Section
                      Text(
                        "Vehicle Details",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.indigo[700],
                        ),
                      ),
                      SizedBox(height: 20),

                      // Auto Number Plate Field
                      TextField(
                        controller: plateController,
                        decoration: InputDecoration(
                          labelText: "Auto Number Plate",
                          prefixIcon: Icon(Icons.confirmation_number, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),

                      // City Field
                      TextField(
                        controller: cityController,
                        decoration: InputDecoration(
                          labelText: "City",
                          prefixIcon: Icon(Icons.location_city, color: Colors.indigo),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide(color: Colors.indigo, width: 2),
                          ),
                        ),
                      ),
                      SizedBox(height: 30),

                      // Submit Button
                      Container(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : () => addTukTuk(context),
                          child: _isSubmitting
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text(
                            "ADD TUK-TUK",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.amber[600],
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                    ],
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