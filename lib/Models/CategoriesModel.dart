
class CategoriesModel{
   int? id;
   String title;
   String dateCreated;
   int clicked;
   CategoriesModel({this.id, required this.title, required this.dateCreated, required this.clicked});
   factory CategoriesModel.fromMap(Map<String,dynamic> json)=>CategoriesModel(
            id: json["id"],
            title: json["title"],
            dateCreated: json["dateCreated"],
            clicked: json['clicked']
    );
   Map<String,dynamic> toMap()=>{
        "id":id,
        "title":title,
        "dateCreated":dateCreated,
        "clicked":clicked
      };
}