class Nasa {
  final String title;
  final String content;
  final String imageUrl;

  Nasa({this.title, this.content, this.imageUrl});

  Nasa fetchNasa(Map<String, dynamic> json) {
    return Nasa(
      title: json['title'],
      content: json['explanation'],
      imageUrl: json['hdurl'],
    );
  }
}
