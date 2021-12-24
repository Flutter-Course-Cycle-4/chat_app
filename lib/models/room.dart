class RoomData {
  String name, category, description;
  List<dynamic> users;

  RoomData(this.name, this.category, this.description, this.users);

  RoomData.fromJson(Map<String, Object?> json)
      : this(json['name']! as String, json['category']! as String,
            json['description']! as String, json['users']! as List<dynamic>);
}

class Room {
  String id;
  RoomData data;

  Room(this.id, this.data);

  Room.fromJson(Map<String, Object?> json)
      : this(
          json['id']! as String,
          RoomData.fromJson(json),
        );

  Map<String, Object?> toJson() {
    return {
      'id': id,
      'name': data.name,
      'description': data.description,
      'category': data.category,
      'users': data.users,
    };
  }
}
