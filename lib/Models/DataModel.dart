
class DataModel{
  int? id;
  final int subActId;
  final String dataType;
  final String dateCreated;
   int? defValue;
   String? unit;

  DataModel({this.id, required this.subActId, required this.dataType,  this.defValue,  this.unit,required this.dateCreated, });
  factory DataModel.fromMap(Map<String,dynamic> json)=>DataModel(
      id:json['id'] ,
      subActId: json['subActId'],
      dataType: json['dataType'],
      defValue: json['defValue'],
      unit: json['unit'],
      dateCreated:json['dateCreated']
  );
  Map<String,dynamic> toMap()=>{
    "id":id,
    "subActId":subActId,
    "dataType":dataType,
    "defValue":defValue,
    "unit":unit,
    "dateCreated":dateCreated
  };
}