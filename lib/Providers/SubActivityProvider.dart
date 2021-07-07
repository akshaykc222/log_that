
import 'package:flutter/material.dart';
import 'package:log_that/Models/SubActivityModel.dart';
import 'package:log_that/sqlflite/CategoriesDb.dart';
import 'package:progress_state_button/progress_button.dart';

class SubActivityProvider with ChangeNotifier{
  int currentActId=0;
  int get activityId=>currentActId;
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
  Future<void> addData(SubActivityModel model,BuildContext context) async {
    switch(_buttonState){

      case ButtonState.idle:
        _buttonState=ButtonState.loading;
        int dataAdded=await DatabaseHelper.db.insertSubActivity(model);
        print('data added $dataAdded');
        dataAdded==1?_buttonState=ButtonState.success:_buttonState=ButtonState.fail;
        getSubActivities();
        Future.delayed(Duration(seconds: 1),(){
          _buttonState=ButtonState.idle;

          Navigator.pop(context);
        });
        break;
      case ButtonState.loading:

        break;
      case ButtonState.success:
        Navigator.pop(context);
        _buttonState=ButtonState.idle;
        break;
      case ButtonState.fail:

        break;
    }
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