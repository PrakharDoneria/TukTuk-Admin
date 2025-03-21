import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AdminFirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Add a new tuk-tuk driver
  Future<void> addTukTuk(String name, String plate, String city) async {
    try {
      User? admin = _auth.currentUser;
      if (admin == null) {
        print("Admin not logged in!");
        return;
      }

      await _db.collection('drivers').add({
        'adminId': admin.uid,
        'name': name,
        'plate': plate,
        'city': city,
        'isBooked': false,
      });

      print("Tuk-tuk added successfully!");
    } catch (e) {
      print("Error adding tuk-tuk: $e");
    }
  }

  // Get all tuk-tuks added by the logged-in admin
  Stream<QuerySnapshot> getAllTukTuks() {
    User? admin = _auth.currentUser;
    if (admin == null) {
      return Stream.empty();
    }
    return _db.collection('drivers').where('adminId', isEqualTo: admin.uid).snapshots();
  }

  // Get ride bookings for the logged-in admin (Updated to fetch only related bookings)
  Stream<QuerySnapshot> getBookingsForAdmin() async* {
    User? admin = _auth.currentUser;
    if (admin == null) {
      yield* Stream.empty();
      return;
    }

    // Fetch all drivers added by the logged-in admin
    QuerySnapshot driverSnapshot = await _db
        .collection('drivers')
        .where('adminId', isEqualTo: admin.uid)
        .get();

    if (driverSnapshot.docs.isEmpty) {
      yield* Stream.empty();
      return;
    }

    List<String> driverIds = driverSnapshot.docs.map((doc) => doc.id).toList();

    // Fetch bookings that are associated with these drivers
    yield* _db
        .collection('bookings')
        .where('driverId', whereIn: driverIds)
        .snapshots();
  }

  // Update booking status (Accept/Reject)
  Future<void> updateBookingStatus(String bookingId, String status) async {
    try {
      await _db.collection('bookings').doc(bookingId).update({'status': status});
      print("Booking status updated to $status");
    } catch (e) {
      print("Error updating booking status: $e");
    }
  }
}
