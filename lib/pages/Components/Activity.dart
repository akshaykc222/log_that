

import 'package:flutter/material.dart';
import 'package:log_that/Models/CategoriesModel.dart';
import 'package:log_that/Providers/SubActivityProvider.dart';
import 'package:log_that/Providers/Homepageprovider.dart';
import 'package:progress_state_button/iconed_button.dart';
import 'package:progress_state_button/progress_button.dart';
import 'package:provider/provider.dart';

import '../../contants.dart';
int selectedIndex=-1;
class Activity extends StatefulWidget {
  final ScrollController controller;
  const Activity({Key? key, required this.controller}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> with SingleTickerProviderStateMixin{
  late AnimationController _activityController;
  late Animation<double> _sizeAnimation;
  late Animation _colourAnimation;
  final _categoriesAdd=TextEditingController();
  final GlobalKey<AnimatedListState> _listKey=GlobalKey<AnimatedListState>();
  Tween<Offset> _offset=Tween<Offset>(begin: Offset(1,0),end: Offset(0,0));
  var _formKey = GlobalKey<FormState>();
  void setPro(int id,BuildContext context){

    Provider.of<SubActivityProvider>(context,listen: false).activityIdGet(id);
    print('provider  ${Provider.of<SubActivityProvider>(context, listen: false).activityId}');
  }
  void onTapAnimation(){

    _activityController=AnimationController(vsync: this,duration: Duration(milliseconds: 500));
    _sizeAnimation=TweenSequence(
        <TweenSequenceItem<double>>[
          TweenSequenceItem(tween: Tween(begin: 20,end: 30), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 30,end: 22), weight: 50)
        ]
    ).animate(_activityController);
    _colourAnimation=ColorTween(begin: Colors.grey.shade100,end: Colors.blue.shade200).animate(_activityController) ;
  }
  bool _submit() {
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      return false;
    }else{
      _formKey.currentState!.save();
      return true;
    }

  }
  void showCategoriesSheet(BuildContext context,CategoriesModel model){
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
                      top: 25,
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

                        Text('Update Activity',style: TextStyle(fontSize: 25,color: Colors.black),),
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
                                text: "Update Activity",
                                icon: Icon(Icons.update, color: Colors.white),
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
                              CategoriesModel modelUpdate=CategoriesModel(id: model.id,title: _categoriesAdd.text, dateCreated: model.dateCreated,clicked: Provider.of<HomePageProvider>(context,listen: false).lastCount);
                              Provider.of<HomePageProvider>(context,listen: false).updateActivity( modelUpdate, context);
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
  @override
  void dispose() {
    _categoriesAdd.dispose();
    super.dispose();
  }

  @override
  void initState() {

    onTapAnimation();
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<HomePageProvider>(context,listen: false).getActivities();
    });

  }
  @override
  Widget build(BuildContext buildContext) {
    print('widget reloaded');
    var width=MediaQuery.of(context).size.width;
    var height=MediaQuery.of(context).size.height;
    return Container(

      width: width*0.35,

      child: Consumer<HomePageProvider>(
        builder: (context, value, child) {
        // List<Widget> widgetList=  value.items.map((e) => ActivityCard(key: ObjectKey(e.id), model: e,index: e.id!,
        //
        // , update:()=> callbackFunction(clickedCardId), amIClicked: null,)).toList();

          return ListView.builder(
            itemCount: value.items.length,
            controller: widget.controller,
            itemBuilder: (BuildContext context, int index) {
              print("items id =${value.items[index].toMap()}");
              return Card(
                elevation: 8,

                color: selectedIndex==index?Colors.blue.shade200:Colors.grey.shade100,
                margin: EdgeInsets.only(left: 5,top: 10,bottom: 10),
                child: ListTile(
                  onLongPress: (){
                    showCategoriesSheet(context,value.items[index]);
                  },
                  onTap: (){
                    setState(() {
                      selectedIndex=index;

                    });
setPro(value.items[index].id!,buildContext);
                    // print("selectedIndex $selectedIndex index${index}");
                    // callbackFunction(index);
                    // if(amIclicked) {
                    //   _activityController.forward();
                    // }else{
                    //   _activityController.reverse();
                    // }
                  },
                  leading:Container(width: 70, child: Text(value.items[index].title,style: TextStyle(color: Colors.black,fontSize:  selectedIndex==index?22:20,fontWeight:FontWeight.w300,letterSpacing: 0.5, ),maxLines: 2,)) ,
                  trailing: InkWell(
                      onTap:()=>Provider.of<HomePageProvider>(context,listen: false).deleteActivity(value.items[index].id!) ,
                      child: Icon(Icons.delete_outlined,size: 20,)),
                ),
              );
            },

          );
        },
      ),
    );
  }
}
class ActivityCard extends StatefulWidget {
  final CategoriesModel model;
  final int index;

   ActivityCard({Key? key, required this.model, required this.index }) : super(key: key);

  @override
  _ActivityCardState createState() => _ActivityCardState();
}

class _ActivityCardState extends State<ActivityCard> with SingleTickerProviderStateMixin{

  @override
  void initState() {
    print("key: ${widget.key}");

    super.initState();
  }
  @override
  void dispose() {
    print('disposed');
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    return Container(
        child:Container(

          child: Card(
            elevation: 8,

            color:selectedIndex== widget.index?Colors.blue.shade200:Colors.grey.shade100,
            margin: EdgeInsets.only(left: 5,top: 10,bottom: 10),
            child: ListTile(

              onTap: (){
                    setState(() {
                      selectedIndex=widget.index;
                    });

                // print("selectedIndex $selectedIndex index${widget.id}");
                // widget.update(widget.id);
                // if(widget.amIClicked) {
                //   _activityController.forward();
                // }else{
                //   _activityController.reverse();
                // }
              },
              leading:Text(widget.model.title,style: TextStyle(color: Colors.black,fontSize:selectedIndex== widget.index?18:20 ,fontWeight:FontWeight.w300,letterSpacing: 1 )) ,
              trailing: Icon(Icons.delete_outlined,size: 20,),
            ),
          ),
        )
    );
  }
}
