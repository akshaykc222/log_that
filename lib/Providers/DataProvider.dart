import 'package:flutter/material.dart';
import 'package:log_that/Models/DataModel.dart';
import 'package:log_that/Models/SubActivityModel.dart';
import 'package:log_that/sqlflite/CategoriesDb.dart';
import 'package:progress_state_button/progress_button.dart';

class DataProvider with ChangeNotifier{
  int currentActId=0;
  int get activityId=>currentActId;
  bool isNumber=true;
  bool get isNumberMethod=>isNumber;
  List<Widget> dataModelItems=[];
  void addDataWidget(Widget item){
    dataModelItems.add(item);
    notifyListeners();
  }

  void setNumberMethod(bool value){
    this.isNumber=value;
    notifyListeners();
  }
  void activityIdGet(int id){
    this.currentActId=id;
    getSubActivities();
    notifyListeners();
  }
  List<SubActivityModel> _activityItems=[];
  int _lastCount=0;
  ButtonState _buttonState=ButtonState.idle;
  int get lastCount=>_activityItems.isNotEmpty?_lastCount=_activityItems.last.clicked+1:_lastCount;

  ButtonState get buttonState=>_buttonState;
  List<SubActivityModel> get items=>_activityItems;
  Future<void> addData(DataModel model,BuildContext context) async {
    await DatabaseHelper.db.insertDataModel(model);
    notifyListeners();
  }
  void getSubActivities() async {
    _activityItems=await DatabaseHelper.db.getSubActivity(currentActId);
    print("items size ${_activityItems.length}");

    notifyListeners();
  }
  void updateSubActivity(int id){

  }
  Future<bool> deleteSubActivity(int id) async {
    int deleted=await DatabaseHelper.db.deleteSubActivity(id);
    print('deleted $deleted');
    if(deleted==1){
      getSubActivities();
      return true;
    }else{
      return false;
    }
  }

}