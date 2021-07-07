
class SubActivityModel{
  int? id;
  final int activityId;
  final String title;
  final String dateCreated;
  final int clicked;

  SubActivityModel({this.id,required this.activityId, required this.title, required this.dateCreated, required this.clicked});

  factory SubActivityModel.fromMap(Map<String,dynamic> json)=>SubActivityModel(
      id: json['id'],
      activityId: json['activityId'],
      title: json['title'],
      dateCreated: json['dateCreated'],
      clicked: json['clicked']
  );
  Map<String,dynamic> toMap()=>{
    'id':id,
    'activityId':activityId,
    'title':title,
    'dateCreated':dateCreated,
    'clicked':clicked
  };

}