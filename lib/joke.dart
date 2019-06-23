class Joke {
  final String id;
  final String body;
  final int status;

  Joke({this.id, this.body, this.status});

  factory Joke.fromJson(Map<String, dynamic> json) {
    return Joke(
      id: json['id'],
      body: json['joke'],
      status: json['status'],
    );
  }
}
