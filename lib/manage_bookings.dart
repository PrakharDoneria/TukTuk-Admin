import 'package:flutter/material.dart';
import 'admin_services.dart';

class ManageBookingsPage extends StatelessWidget {
  final AdminFirestoreService _adminService = AdminFirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Manage Bookings")),
      body: StreamBuilder(
        stream: _adminService.getBookingsForAdmin(),
        builder: (context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final bookings = snapshot.data.docs;

          return ListView.builder(
            itemCount: bookings.length,
            itemBuilder: (context, index) {
              var booking = bookings[index];
              return ListTile(
                title: Text("Customer: ${booking['customerName']}"),
                subtitle: Text("Pickup: ${booking['pickupLocation']} → Drop: ${booking['dropLocation']}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: Icon(Icons.check, color: Colors.green),
                      onPressed: () => _adminService.updateBookingStatus(booking.id, "Accepted"),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.red),
                      onPressed: () => _adminService.updateBookingStatus(booking.id, "Rejected"),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
