import 'package:flutter/material.dart';
import 'package:log_that/Providers/SubActivityProvider.dart';
import 'package:provider/provider.dart';

class SubActivity extends StatefulWidget {
  final int actId;
  const SubActivity({Key? key, required this.actId, }) : super(key: key);

  @override
  _SubActivityState createState() => _SubActivityState();
}

class _SubActivityState extends State<SubActivity> {
  int selectedIndex=-1;
  @override
  void initState() {
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      Provider.of<SubActivityProvider>(context,listen: false).getSubActivities();
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    var width=MediaQuery.of(context).size.width;
    return Container(
      width: width*0.35,
      child: Consumer<SubActivityProvider>(
        builder: (context, value, child) {
          print('from sub activity ${Provider.of<SubActivityProvider>(context, listen: false).activityId}');
          // List<Widget> widgetList=  value.items.map((e) => ActivityCard(key: ObjectKey(e.id), model: e,index: e.id!,
          //
          // , update:()=> callbackFunction(clickedCardId), amIClicked: null,)).toList();

          return ListView.builder(
            itemCount: value.items.length,

            itemBuilder: (BuildContext context, int index) {
              print("items id =${value.items[index].toMap()}");
              return Card(
                elevation: 8,

                color: selectedIndex==index?Colors.blue.shade200:Colors.grey.shade100,
                margin: EdgeInsets.only(left: 5,top: 10,bottom: 10),
                child: ListTile(
                  onLongPress: (){
                    //showCategoriesSheet(context,value.items[index]);
                  },
                  onTap: (){
                    setState(() {
                      selectedIndex=index;
                    });

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
                      onTap:()=>Provider.of<SubActivityProvider>(context,listen: false).deleteSubActivity(value.items[index].id!) ,
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
