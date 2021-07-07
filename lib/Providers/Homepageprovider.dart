import 'package:flutter/material.dart';
import 'package:log_that/Models/CategoriesModel.dart';
import 'package:log_that/sqlflite/CategoriesDb.dart';
import 'package:progress_state_button/progress_button.dart';

class HomePageProvider with ChangeNotifier{
    int _lastCount=0;

    int get lastCount=>_activityItems.isNotEmpty?_lastCount=_activityItems.last.clicked+1:_lastCount;

    List<CategoriesModel> _activityItems=[];

    List<CategoriesModel> get items=>_activityItems;

    ButtonState _buttonState=ButtonState.idle;

    ButtonState get buttonState=>_buttonState;

    Future<void> addData(CategoriesModel model,BuildContext context) async {
        switch(_buttonState){

          case ButtonState.idle:
                _buttonState=ButtonState.loading;
                bool dataAdded=await DatabaseHelper.db.insertActivity(model);
                print('data added $dataAdded');
                dataAdded?_buttonState=ButtonState.success:_buttonState=ButtonState.fail;
                getActivities();
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

    Future<void> updateActivity(CategoriesModel model,BuildContext context) async {
      switch(_buttonState){

        case ButtonState.idle:
          _buttonState=ButtonState.loading;
          int dataAdded=await DatabaseHelper.db.updateActivity(model);
          print('data added $dataAdded');
          dataAdded==1?_buttonState=ButtonState.success:_buttonState=ButtonState.fail;
          getActivities();
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

    void getActivities() async {
      _activityItems=await DatabaseHelper.db.getActivity();
      print("items size ${_activityItems.length}");

      notifyListeners();
    }
    Future<bool> deleteActivity(int id) async{
      int deleted=await DatabaseHelper.db.deleteActivity(id);
      print('deleted $deleted');
      if(deleted==1){
        getActivities();
        return true;
      }else{
        return false;
      }
    }

}