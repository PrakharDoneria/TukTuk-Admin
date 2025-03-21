import 'package:flutter/material.dart';
import 'admin_services.dart';

class AddTukTukPage extends StatelessWidget {
  final AdminFirestoreService _adminService = AdminFirestoreService();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController plateController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  void addTukTuk(BuildContext context) {
    _adminService.addTukTuk(
      nameController.text.trim(),
      plateController.text.trim(),
      cityController.text.trim(),
    );
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Tuk-Tuk")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: nameController, decoration: InputDecoration(labelText: "Driver Name")),
            TextField(controller: plateController, decoration: InputDecoration(labelText: "Auto Number Plate")),
            TextField(controller: cityController, decoration: InputDecoration(labelText: "City")),
            SizedBox(height: 20),
            ElevatedButton(onPressed: () => addTukTuk(context), child: Text("Add")),
          ],
        ),
      ),
    );
  }
}
