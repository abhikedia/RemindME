class Tasks {
  int id;
  String description;
  String title;
  double lat;
  double long;
  int location;
  int done;

  Tasks(this.id, this.description, this.title, this.lat,this.long, this.location, this.done);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ID': id,
      'DESCRIPTION': description,
      'TITLE': title,
      'LAT': lat,
      'LONG':long,
      'LOCATION': location,
      'DONE': done
    };
    return map;
  }

  Tasks.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    description = map['DESCRIPTION'];
    title = map['TITLE'];
    lat=map['LAT'];
    long=map['LONG'];
    location = map['LOCATION'];
    done = map['DONE'];
    //print(id);
  }
}
