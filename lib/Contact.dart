class Contact {
  int? age;
  String? dateAdded;
  String? filename;
  String? gender;
  String? imageUrl;
  String? lastServed;
  String? source;

  Contact({
    this.age,
    this.dateAdded,
    this.filename,
    this.gender,
    this.imageUrl,
    this.lastServed,
    this.source,
  });

  Contact.fromJson(Map<String, dynamic> json) {
    age = json['age'];
    dateAdded = json['date_added'];
    filename = json['filename'];
    gender = json['gender'];
    imageUrl = json['image_url'];
    lastServed = json['last_served'];
    source = json['source'];
  }
}
