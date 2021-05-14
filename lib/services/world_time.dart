import 'package:http/http.dart';
import 'dart:convert';
import 'package:intl/intl.dart';

class WorldTime {
  String location; //location name for the ui
  String time;  //the time in that location
  String flag;  //url to an asset flag icon
  String url; //location url for api endpoint
  bool isDaytime; // true or false if daytime or not

  WorldTime({ this.location, this.flag, this.url });

  Future<void> getTime() async {

    try {
      var Url = Uri.parse('http://worldtimeapi.org/api/timezone/$url');
      Response response = await get(Url);
      Map data = jsonDecode(response.body);
      //print(data);

      //get properties from data
      String datetime = data["utc_datetime"];
      String offset1 = data["utc_offset"].substring(1,3);
      String offset2 = data["utc_offset"].substring(4,6);
      String offset3 = data["utc_offset"].substring(0,1);
      //print(datetime);
      //print(offset);

      //create DateTime object
      DateTime now  = DateTime.parse(datetime);
      if (offset3 == "+"){
        now = now.add(Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));
      }
      else {
        now = now.subtract(Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));
      }
      //now = now.add(Duration(hours: int.parse(offset1), minutes: int.parse(offset2)));
      //print(now);

      // set the time property
      isDaytime = now.hour > 7 && now.hour < 19 ? true : false;
      time = DateFormat.jm().format(now);
    }
    catch (e) {
      print('caught error: $e');
      time = 'could not get time data';
    }


  }
}