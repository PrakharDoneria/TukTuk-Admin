import 'package:flutter/material.dart';
import 'admin_services.dart';
import 'add_tuk_tuk.dart';
import 'manage_bookings.dart';

class AdminDashboard extends StatelessWidget {
  final AdminFirestoreService _adminService = AdminFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(""),
        backgroundColor: Colors.indigo[700],
        elevation: 0,
      ),
      body: Column(
        children: [
          // Welcome header with background image
          Container(
            height: 180,
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
                Text(
                  "Welcome Admin",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  "Manage your fleet of Tuk Tuks",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 20),
                // Prominent add button positioned centrally
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => AddTukTukPage()));
                  },
                  icon: Icon(Icons.add_circle, size: 28),
                  label: Text("ADD NEW TUK TUK", style: TextStyle(fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.amber[600],
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  ),
                ),
              ],
            ),
          ),

          // Title for the list
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Icon(Icons.directions_car, color: Colors.indigo[700]),
                SizedBox(width: 10),
                Text(
                  "Your Tuk Tuk Fleet",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.indigo[700],
                  ),
                ),
              ],
            ),
          ),

          // Tuk Tuk list
          Expanded(
            child: StreamBuilder(
              stream: _adminService.getAllTukTuks(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                final tukTuks = snapshot.data.docs;

                if (tukTuks.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/empty_fleet.png', // Add this image to your assets
                        //   height: 150,
                        // ),
                        // SizedBox(height: 20),
                        Text(
                          "No tuk tuks added yet!",
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "Add your first tuk tuk using the button above",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: tukTuks.length,
                  itemBuilder: (context, index) {
                    var tukTuk = tukTuks[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      elevation: 2,
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.indigo[100],
                          child: Icon(Icons.directions_car, color: Colors.indigo[700]),
                        ),
                        title: Text(
                          tukTuk['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text("Auto No: ${tukTuk['plate']} | City: ${tukTuk['city']}"),
                        trailing: IconButton(
                          icon: Icon(Icons.arrow_forward_ios, color: Colors.indigo[700]),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ManageBookingsPage()),
                            );
                          },
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