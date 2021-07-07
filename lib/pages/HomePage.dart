import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:log_that/Models/CategoriesModel.dart';
import 'package:log_that/Models/SubActivityModel.dart';
import 'package:log_that/Providers/Homepageprovider.dart';
import 'package:log_that/Providers/SubActivityProvider.dart';

import 'package:log_that/contants.dart';
import 'package:log_that/pages/Components/Activity.dart';
import 'package:log_that/pages/Components/DataModelActivity.dart';
import 'package:log_that/pages/Components/SubActivity.dart';
import 'package:log_that/sqlflite/CategoriesDb.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:provider/provider.dart';
import 'package:progress_state_button/progress_button.dart';


import '../size_config.dart';

GlobalKey<_CustomAppBarState> appBarKey = GlobalKey();
class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //late CategoriesDb db;
  final _categoriesAdd=TextEditingController();
  final _subCategoriesAdd=TextEditingController();
  List<CategoriesModel> datas = [];
  ButtonState _buttonState=ButtonState.idle;
  var _formKey = GlobalKey<FormState>();
  var _formSubKey = GlobalKey<FormState>();
   CategoriesModel? _selectedItem;
  String dateNow=DateFormat().format(DateTime.now());
  bool _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }else{
      return true;
    }

  }


  @override
  void dispose() {
    print('widget disposed');
    _categoriesAdd.dispose();
    Provider.of<HomePageProvider>(context).dispose();
    super.dispose();
  }
  void showActivityAddSheet(BuildContext context){
    showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,

        context: context,
        builder: (context){
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Container(
              height: 300,
              child: Stack(

                children: [
                  Positioned(
                      top: 75,
                      right: 20,
                      child: InkWell(
                          onTap: ()=>Navigator.pop(context),
                          child: Icon(Icons.close))),
                  Form(
                    key: _formKey,
                    child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            decoration:BoxDecoration(
                                color: Colors.blue,
                                borderRadius: BorderRadius.circular(15.0),
                               ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "Add Activity",
                                style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                              ),
                            ),
                          ),
                          Container(
                            decoration:BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: InkWell(
                              onTap: (){
                                Navigator.pop(context);
                                showSubActivityAddSheet(context);
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Add Sub Activity",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration:BoxDecoration(
                              color: Colors.deepOrangeAccent,
                              borderRadius: BorderRadius.circular(15.0),
                            ),
                            child: InkWell(
                              onTap:()=> Navigator.push(context, MaterialPageRoute(builder: (context)=>DataModelActivity())),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Add Data",
                                  style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Text('Add Activity',style: TextStyle(fontSize: 25,color: Colors.black),),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextFormField(
                          controller: _categoriesAdd,
                          validator: (value){
                            if(value!.isEmpty){
                              return "Please enter activity name!";
                            }
                          },
                          decoration: InputDecoration(
                            labelText: "Activity",
                            hintText: "Enter Activity Name",
                            // If  you are using latest version of flutter then lable text and hint text shown like this
                            // if you r using flutter less then 1.20.* then maybe this is not working properly
                            floatingLabelBehavior: FloatingLabelBehavior.auto,
                            border:outlineInputBorder(),

                            suffixIcon: Icon(Icons.run_circle_outlined),
                          ),
                        ),
                      ),
                Consumer<HomePageProvider>(
                    builder:(context, value, child) => ProgressButton.icon(iconedButtons: {
                      ButtonState.idle: IconedButton(
                          text: "Add Activity",
                          icon: Icon(Icons.add, color: Colors.white),
                          color: Colors.deepOrangeAccent),
                      ButtonState.loading:
                      IconedButton(text: "Loading", color: Colors.deepPurple.shade700),
                      ButtonState.fail: IconedButton(
                          text: "Failed",
                          icon: Icon(Icons.cancel, color: Colors.white),
                          color: Colors.red.shade300),
                      ButtonState.success: IconedButton(
                          text: "",
                          icon: Icon(
                            Icons.check_circle,
                            color: Colors.white,
                          ),
                          color: Colors.green.shade400)
                    }, onPressed: (){
                      if(_submit()){
                        CategoriesModel model=CategoriesModel(title: _categoriesAdd.text, dateCreated: dateNow,clicked: Provider.of<HomePageProvider>(context,listen: false).lastCount);
                        Provider.of<HomePageProvider>(context,listen: false).addData( model, context);
                      }

                    },
                        state: Provider.of<HomePageProvider>(context).buttonState
                    ),
                )

                    ],
                ),
                  )],
              ),
            ),
          );
        }
    );
  }
  void showSubActivityAddSheet(BuildContext context){
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        isScrollControlled: true,

        context: context,
        builder: (context){
          return Provider.of<HomePageProvider>(context).items.isEmpty?Container(
              height: 400,
              child: Center(child: Text('Please add Activity first')),) :Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Container(
                height: 400,
                child: Stack(

                  children: [
                    Positioned(
                        top: 75,
                        right: 20,
                        child: InkWell(
                            onTap: ()=>Navigator.pop(context),
                            child: Icon(Icons.close))),
                    Form(
                      key: _formSubKey,
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Row(
                            mainAxisAlignment:MainAxisAlignment.spaceEvenly,
                            children: [
                              Container(
                                decoration:BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add Activity",
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:BoxDecoration(
                                  color: Colors.blue,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add Sub Activity",
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                  ),
                                ),
                              ),
                              Container(
                                decoration:BoxDecoration(
                                  color: Colors.deepOrangeAccent,
                                  borderRadius: BorderRadius.circular(15.0),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Add Data",
                                    style: TextStyle(fontSize: 18,fontWeight: FontWeight.w900,color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('Add Sub Activity',style: TextStyle(fontSize: 25,color: Colors.black),),
                    Padding( padding:const EdgeInsets.all(8),
                    child: DropdownButtonFormField(

                                decoration: InputDecoration(
                                    border: OutlineInputBorder(
                                      borderRadius: const BorderRadius.all(
                                        const Radius.circular(15.0),
                                      ),
                                      borderSide: BorderSide(color: kTextColor)
                                    ),
                                  labelText: "Activity",
                                  hintText: "Select Activity Name",
                                ),

                                value: _selectedItem==null?_selectedItem= Provider.of<HomePageProvider>(context).items.first:_selectedItem,
                                onChanged: ( item){
                                  setState(() {
                                    _selectedItem=item! as CategoriesModel?;
                                  });
                                },
                                items: Provider.of<HomePageProvider>(context).items.map((e) => DropdownMenuItem<CategoriesModel>
                                  (child: Text(e.title),value: e,)).toList(),

                            )),


                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(
                              controller: _subCategoriesAdd,
                              validator: (value){
                                if(value!.isEmpty){
                                  return "Please enter sub activity name!";
                                }
                              },
                              decoration: InputDecoration(
                                labelText: "Sub Activity",
                                hintText: "Enter Sub Activity Name",
                                // If  you are using latest version of flutter then lable text and hint text shown like this
                                // if you r using flutter less then 1.20.* then maybe this is not working properly
                                floatingLabelBehavior: FloatingLabelBehavior.auto,
                                border:outlineInputBorder(),

                                suffixIcon: Icon(Icons.run_circle_outlined),
                              ),
                            ),
                          ),

                          InkWell(
                            onTap:()=> Provider.of<SubActivityProvider>(context,listen: false).addData(SubActivityModel(activityId: _selectedItem!.id!, title: _subCategoriesAdd.text, dateCreated:dateNow, clicked: 5), context),
                            child: Container(
                              width: 150,
                              height: 50,
                            )
                      ,
                          )
                        ],
                      ),
                    )],
                ),
              ),

          );
        }
    );
  }
  @override
  void initState() {

    super.initState();


  }
  @override
  Widget build(BuildContext context) {

    SizeConfig().init(context);
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Scaffold(
        extendBody: true,
        bottomNavigationBar:  BottomAppBar(
          elevation: 0.3,
          notchMargin: 5,

          clipBehavior: Clip.antiAlias,
          color: Colors.white,
          shape: CircularNotchedRectangle(),
          child: Container(height: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
                gradient: LinearGradient(colors: [Color(int.parse("0xff2193b0")),Color(int.parse("0xff6dd5ed"))])
            ),
          )
      ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
          onPressed:()=> showActivityAddSheet(context),
          child: Icon(Icons.add),
        ),
      body:Container(
        child: Stack(
          children: [
            CustomAppBar(key: appBarKey,),
            NotificationListener<DraggableScrollableNotification>(
              onNotification:  (notification) {
                if(notification.extent>0.85){
                  appBarKey.currentState!.goToTop();
                }else if(notification.extent<0.85){
                  appBarKey.currentState!._startController.forward();
                }

                return true;
              },
              child: DraggableScrollableSheet(
                  initialChildSize: 0.79,
                  minChildSize: 0.79,
                  maxChildSize: 0.9,
                  builder: (BuildContext context,ScrollController scrollController){
                      return SingleChildScrollView(
                        controller: scrollController,
                        child: Container(
                          width: width,
                          height: height,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15)
                          ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Activity(controller: scrollController,),
                            SubActivity(actId: Provider.of<SubActivityProvider>(context,listen: false).activityId,) ,


                          ],
                        ),
                        ),
                      );
                  }
              ),
            )
          ],
        )
      )
    );
  }
}
class CustomAppBar extends StatefulWidget {
  const CustomAppBar({Key? key}) : super(key: key);

  @override
  _CustomAppBarState createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> with SingleTickerProviderStateMixin{
  late AnimationController _startController;
  late Animation<double> _startAnimation;

  bool _startAnim=false;
  String dateFormat=DateFormat("dd-MM-yyyy").format(DateTime.now());
  void startAnimation(){

    _startAnimation=Tween<double>(begin: 0,end: 1) .animate(CurvedAnimation(parent: _startController, curve: Curves.easeIn));
    _startController.forward();
  }

  void goToTop(){
    _startController.reverse();
  }
  @override
  void initState() {
    _startController=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _startController.addStatusListener((status) {
      if(status==AnimationStatus.reverse){
        setState(() {
          _startAnim=true;
        });
      }

    });
    startAnimation();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    print(height*0.3);
    return Container(
      width: width,
      height: height*0.23,
      decoration: BoxDecoration(
          gradient: LinearGradient(colors: [Color(int.parse("0xff2193b0")),Color(int.parse("0xff6dd5ed"))]),
        //  borderRadius: BorderRadius.circular(10)
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedBuilder(
              animation: _startController,
              builder: (BuildContext context,Widget? child){
                print(_startAnim);
                return  Opacity(
                    opacity:!_startAnim? _startAnimation.value:1 ,
                    child: Padding(
                      padding: EdgeInsets.only(top: _startAnimation.value*40),
                      child: child,
                    )
                );
              },
              child: Text(appName,style: TextStyle(color: Colors.white,fontSize: 25),)
          ),
          // TweenAnimationBuilder(
          //
          //     duration: Duration(milliseconds: 800),
          //     tween: Tween<double>(begin: 0,end: 1),
          //     curve: Curves.easeIn,
          //     builder: (BuildContext context, double value, Widget? child) {
          //       return Opacity(
          //           opacity: value,
          //           child: Padding(
          //             padding: EdgeInsets.only(top: value*40),
          //             child: child,
          //           ),
          //       );
          //
          //     },
          //     child: Text(appName,style: TextStyle(color: Colors.white,fontSize: 25),)),
          SizedBox(height: 20,),
          TweenAnimationBuilder(
            builder: (BuildContext context, double value, Widget? child) {
              return Opacity(
                opacity: value,
                child: child,);
            },
            duration: Duration(milliseconds: 800),
            tween: Tween<double>(begin: 0,end: 1),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                    onTap:(){
                      _startController.reverse();
                    },
                    child: Icon(Icons.arrow_left_outlined,size: 35,color: Colors.white,)),
                Text(dateFormat,style: TextStyle(fontSize: 40,color: Colors.white),),
                Icon(Icons.arrow_right_outlined,size: 35,color: Colors.white,),

              ],
            ),
          )
        ],
      ),
    );
  }
}


