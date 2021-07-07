import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:log_that/Providers/DataProvider.dart';
import 'package:log_that/contants.dart';
import 'package:provider/provider.dart';

class DataModelActivity extends StatefulWidget {
  const DataModelActivity({Key? key}) : super(key: key);

  @override
  _DataModelActivityState createState() => _DataModelActivityState();
}

class _DataModelActivityState extends State<DataModelActivity> {
  @override
  void initState() {
 
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      if(Provider.of<DataProvider>(context,listen: false).dataModelItems.isEmpty){
        int length=Provider.of<DataProvider>(context,listen: false).dataModelItems.length;
        Provider.of<DataProvider>(context,listen: false).addDataWidget(DataForm(index: length,));
      }

    });
  }
  @override
  void dispose() {
    Provider.of<DataProvider>(context).dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Colors.white
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Add data model'),
            Consumer<DataProvider>(
                builder: (context, value, child) {
                  print('value ${value.dataModelItems.length}');
                  return  ListView.builder(
                    shrinkWrap: true,
                    itemCount:value.dataModelItems.length ,
                    itemBuilder: (context, index) {
                        return value.dataModelItems[index];
                    },

                  );
                },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                IconButton(
                    iconSize: 30,
                    onPressed: (){
                      int length=Provider.of<DataProvider>(context,listen: false).dataModelItems.length;
                      Provider.of<DataProvider>(context,listen: false).addDataWidget(DataForm(index: length,));
                    },
                    icon: Icon(Icons.add)),
                IconButton(
                    iconSize: 30,
                    onPressed: (){},
                    icon: Icon(Icons.remove)
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
class DataForm extends StatefulWidget {
  final int index;
  const DataForm({Key? key, required this.index}) : super(key: key);

  @override
  _DataFormState createState() => _DataFormState();
}

class _DataFormState extends State<DataForm> {
  var _formKey = GlobalKey<FormState>();
  TextEditingController _tittleController=TextEditingController();
  TextEditingController _dataTypeController=TextEditingController();
  TextEditingController _unitController=TextEditingController();
  TextEditingController _defValueController=TextEditingController();
  List<String> dataTypes=["Number","Text","Boolean","Time","Gps position"];
  String _selectedDataType="Number";
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                    child: TextFormField(

                      controller: _tittleController,
                      validator: (value){
                        if(value!.isEmpty){
                          return "Please enter data name!";
                        }
                      },
                      decoration: InputDecoration(
                        labelText: "Data",
                        hintText: "Enter data Name",
                        // If  you are using latest version of flutter then lable text and hint text shown like this
                        // if you r using flutter less then 1.20.* then maybe this is not working properly
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        border:outlineInputBorder(),

                        suffixIcon: Icon(Icons.run_circle_outlined),
                      ),
                    ),
                  ),
                ),
               Expanded(
                 child: Padding(
                   padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                   child: DropdownButtonFormField<String>(
                      items: dataTypes.map((e) => DropdownMenuItem(value: e ,child: Text(e))).toList(),
                      value: _selectedDataType,
                      onChanged: ( value){
                        _selectedDataType=value!;
                        if(value=="Number"){
                          Provider.of<DataProvider>(context,listen: false).setNumberMethod(true);
                        }else{
                          Provider.of<DataProvider>(context,listen: false).setNumberMethod(false);
                        }
                      },
                    decoration: InputDecoration(
                      labelText: "Data type",
                      hintText: 'Select data type',
                      border: outlineInputBorder()
                    ),
                ),
                 ),)
              ],

            ),
            Consumer<DataProvider>(
                builder: (context, value, child) {
                  print('index ${widget.index} length:${Provider.of<DataProvider>(context,listen: false).dataModelItems.length}');
                  int length=Provider.of<DataProvider>(context,listen: false).dataModelItems.length;
                  if(value.isNumberMethod==true && widget.index==length-1){
                    return Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: _defValueController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Please enter default value!";
                                    }
                                  },

                                  decoration: InputDecoration(

                                    labelText: "Default value",
                                    hintText: "Enter default value",
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    border:outlineInputBorder(),

                                    // suffixIcon: Icon(Icons.run_circle_outlined),
                                  ),
                                ),
                              ),
                            ),

                            Expanded(

                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                                child: TextFormField(
                                  controller: _defValueController,
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Please enter unit name!";
                                    }
                                  },
                                  decoration: InputDecoration(
                                    labelText: "unit name",
                                    hintText: "Enter unit name",
                                    // If  you are using latest version of flutter then lable text and hint text shown like this
                                    // if you r using flutter less then 1.20.* then maybe this is not working properly
                                    floatingLabelBehavior: FloatingLabelBehavior.auto,
                                    border:outlineInputBorder(),

                                    // suffixIcon: Icon(Icons.run_circle_outlined),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],

                    );
                  }else{
                    return widget.index!=length-1? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.done,color: Colors.green,),
                        SizedBox(height: 4,),
                        Text('Saved')
                      ],
                    ):Container();
                  }
                },
            ),

          ],
        ),
      ),
    );
  }
}
