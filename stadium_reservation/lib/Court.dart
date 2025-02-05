class Court {
  final String courtId;
  final String courtName;
  final String description;
  final String location;
  final bool availability;
  final String orgID;
  final BookingStatus bookingStatus;
  final double hourlyRate;
  final String imageUrl;

  Court({
    required this.courtId,
    required this.courtName,
    required this.description,
    required this.location,
    required this.availability,
    required this.orgID,
    required this.bookingStatus,
    required this.hourlyRate,
    required this.imageUrl
  });
}

enum BookingStatus {
  BOOKED,
  AVAILABLE,
}
