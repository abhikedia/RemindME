class Tasks {
  int id;
  String description;
  String title;
  String location;
  int done;

  Tasks(this.id, this.description, this.title, this.location, this.done);

  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      'ID': id,
      'DESCRIPTION': description,
      'TITLE': title,
      'LOCATION': location,
      'DONE': done
    };
    return map;
  }

  Tasks.fromMap(Map<String, dynamic> map) {
    id = map['ID'];
    description = map['DESCRIPTION'];
    title = map['TITLE'];
    location = map['LOCATION'];
    done = map['DONE'];
    //print(id);
  }
}
