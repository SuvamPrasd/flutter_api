class Album {
  final int id;
  final String title;
  final int userId;

  Album({this.id, this.title, this.userId});

  factory Album.fromJson(Map<String, dynamic> json) {
    return Album(
      id: json['id'],
      title: json['title'],
      userId: json['userId'],
    );
  }
}
