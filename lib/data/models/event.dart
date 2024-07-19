class Event {
  final String id;
  final String organizerId;
  final String participantId;
  String title;
  String description;
  String placeInfo;
  DateTime date;
  double latitude;
  double longitude;
  String bannerImageUrl;
  bool isLiked;

  Event({
    required this.id,
    required this.organizerId,
    this.participantId = '',
    required this.title,
    required this.description,
    required this.placeInfo,
    required this.date,
    required this.latitude,
    required this.longitude,
    required this.bannerImageUrl,
    required this.isLiked,
  });

  @override
  String toString() {
    return 'Event{id: $id, organizerId:$organizerId, participantId: $participantId, title: $title, description: $description, placeInfo: $placeInfo, date: $date, latitude: $latitude, longitude: $longitude, bannerImageUrl: $bannerImageUrl, isLiked: $isLiked}';
  }
}
