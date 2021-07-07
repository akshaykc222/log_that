import 'package:flutter/material.dart';
import 'package:log_that/size_config.dart';

class DateChanger extends StatefulWidget {
  const DateChanger({Key? key}) : super(key: key);

  @override
  _DateChangerState createState() => _DateChangerState();
}

class _DateChangerState extends State<DateChanger> {
  @override
  void initState() {
    SizeConfig().init(context);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.arrow_back_ios_rounded),
          SizedBox(width: getProportionateScreenWidth(10),),
          Text('date',style: TextStyle(fontSize: 18),),
          SizedBox(width: getProportionateScreenWidth(10),),
          Icon(Icons.arrow_forward_ios_rounded),
        ],
      ),
    );
  }
}

