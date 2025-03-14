class BaseModel {
  final int? id;
  final String? title;
  final String? key;
  bool selected;

  BaseModel({this.id, this.title,this.selected = false,this.key});

  @override
  String toString() {
    return 'BaseModel{id: $id, title: $title, key: ${key?.split('_')[0]}, selected: $selected}';
  }
}
