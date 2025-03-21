import 'package:flutter/material.dart';
import 'admin_services.dart';
import 'add_tuk_tuk.dart';
import 'manage_bookings.dart';

class AdminDashboard extends StatelessWidget {
  final AdminFirestoreService _adminService = AdminFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Admin Dashboard")),
      body: StreamBuilder(
        stream: _adminService.getAllTukTuks(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final tukTuks = snapshot.data.docs;

          return ListView.builder(
            itemCount: tukTuks.length,
            itemBuilder: (context, index) {
              var tukTuk = tukTuks[index];
              return ListTile(
                title: Text(tukTuk['name']),
                subtitle: Text("Auto No: ${tukTuk['plate']} | City: ${tukTuk['city']}"),
                trailing: IconButton(
                  icon: Icon(Icons.directions_car),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ManageBookingsPage()),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => AddTukTukPage()));
        },
      ),
    );
  }
}
