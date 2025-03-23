import 'package:flutter/material.dart';
import 'admin_services.dart';

class ManageBookingsPage extends StatelessWidget {
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
          // Header section
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.indigo[700]!, Colors.indigo[500]!],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Booking Requests",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "Accept or reject customer ride requests",
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),

          // Bookings List
          Expanded(
            child: StreamBuilder(
              stream: _adminService.getBookingsForAdmin(),
              builder: (context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator(
                    color: Colors.indigo[700],
                  ));
                }

                final bookings = snapshot.data.docs;

                if (bookings.length == 0) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Image.asset(
                        //   'assets/images/no_bookings.png', // Add this image to your assets
                        //   height: 150,
                        // ),
                        SizedBox(height: 20),
                        Text(
                          "No booking requests yet!",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.grey[600],
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          "New booking requests will appear here",
                          style: TextStyle(
                            color: Colors.grey[500],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: EdgeInsets.all(12),
                  itemCount: bookings.length,
                  itemBuilder: (context, index) {
                    var booking = bookings[index];
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        children: [
                          ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.amber[100],
                              child: Icon(Icons.person_outline, color: Colors.amber[800]),
                            ),
                            title: Text(
                              "Customer: ${booking['customerName']}",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            // subtitle: Text(
                            //   "Phone: ${booking['customerPhone'] ?? 'Not provided'}",
                            //   style: TextStyle(fontSize: 12),
                            // ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            child: Column(
                              children: [
                                // Route information
                                Row(
                                  children: [
                                    Icon(Icons.location_on, color: Colors.green, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${booking['pickupLocation']}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 2,
                                        height: 24,
                                        color: Colors.grey[300],
                                      ),
                                    ],
                                  ),
                                ),
                                Row(
                                  children: [
                                    Icon(Icons.flag, color: Colors.red, size: 20),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        "${booking['dropLocation']}",
                                        style: TextStyle(fontSize: 14),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          // Date, time and other details
                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              // children: [
                              //   Icon(Icons.access_time, size: 16, color: Colors.grey[600]),
                              //   SizedBox(width: 4),
                              //   Text(
                              //     "${booking['date'] ?? 'Not specified'} • ${booking['time'] ?? 'Not specified'}",
                              //     style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                              //   ),
                              // ],
                            ),
                          ),
                          // Action buttons
                          Divider(height: 0),
                          Row(
                            children: [
                              Expanded(
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: Icon(Icons.check_circle, color: Colors.green),
                                  label: Text("ACCEPT", style: TextStyle(color: Colors.green)),
                                  onPressed: () => _adminService.updateBookingStatus(booking.id, "Accepted"),
                                ),
                              ),
                              Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey[300],
                              ),
                              Expanded(
                                child: TextButton.icon(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.symmetric(vertical: 12),
                                  ),
                                  icon: Icon(Icons.cancel, color: Colors.red),
                                  label: Text("REJECT", style: TextStyle(color: Colors.red)),
                                  onPressed: () => _adminService.updateBookingStatus(booking.id, "Rejected"),
                                ),
                              ),
                            ],
                          ),
                        ],
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