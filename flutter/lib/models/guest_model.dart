class Guest {
  int id;
  String name;
  String region;
  int image;
  String attendTime;

  Guest({
    this.id,
    this.name,
    this.region,
    this.image,
    this.attendTime
  });

 Guest.fromJson(Map<String, dynamic> json) {
    id = int.parse(json['id']);
    name = json['name'];
    region = json['region'];
    image = int.parse(json['img']);
    attendTime = json['attend_time'];
  }
}
