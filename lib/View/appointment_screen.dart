import "package:flutter/material.dart";
import 'package:flutter/material.dart';

//https://www.uplabs.com/search?q=barber
//https://github.com/JoanNabusoba/flutter-salon-app/blob/master/lib/pages/book.dart
//TODO
//Firebase request get servicios
//VGrid horas disponibles, widget hora
class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    final screen_size_width = MediaQuery.of(context).size.width;
    final screen_size_height = MediaQuery.of(context).size.height;
    //buttonTime
    Widget buttonTime(timeText, btnBg, timeBtnColor) {
      return Container(
        height: 42,
        padding: EdgeInsets.symmetric(horizontal: 8),
        child: TextButton(
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  side: BorderSide(
                      color: Colors.grey, width: 1, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            onPressed: () {},
            child: Text(timeText,
                style: TextStyle(
                    color: timeBtnColor,
                    fontWeight: FontWeight.w600,
                    fontSize: 15))),
      );
    }

    return Scaffold(
      backgroundColor: Colors.green,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.chevron_left, color: Colors.white),
            onPressed: () => Navigator.pop(context)),
        title: Text("Book Appointment"),
      ),
      body: Container(
        width: screen_size_width,
        height: screen_size_height,
        color: Colors.white,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: Colors.blue,
                  width: screen_size_width,
                  child: Column(children: <Widget>[
                    //SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.chevron_left, color: Colors.white),
                            onPressed: () {}),
                        Expanded(
                          child: Text("July, 2020",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                        IconButton(
                            icon:
                                Icon(Icons.chevron_right, color: Colors.white),
                            onPressed: () {}),
                      ],
                    ),
                    SizedBox(height: 10),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DateColumn(
                              weekDay: "Mon",
                              date: "16",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                          DateColumn(
                              weekDay: "Tue",
                              date: "17",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                          DateColumn(
                              weekDay: "Wed",
                              date: "18",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                          DateColumn(
                              weekDay: "Thu",
                              date: "19",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                          DateColumn(
                              weekDay: "Fri",
                              date: "20",
                              dateBg: Colors.white,
                              dateTextColor: Colors.purple),
                          DateColumn(
                              weekDay: "Sat",
                              date: "21",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                          DateColumn(
                              weekDay: "Sun",
                              date: "22",
                              dateBg: Colors.transparent,
                              dateTextColor: Colors.white),
                        ]),
                    SizedBox(height: 15),
                  ])),
              Container(
                  width: screen_size_width,
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(height: 18),
                      Text("Available Slot", style: TextStyle(fontSize: 16)),
                      SizedBox(height: 18),
                      Container(
                        alignment: Alignment.center,
                        child: Wrap(
                          runSpacing: 15,
                          spacing: 2,
                          children: <Widget>[
                            buttonTime("9:30 - 10:30 AM", Colors.white,
                                Colors.black54),
                            buttonTime("10:30 - 11:45 AM", Colors.purple,
                                Colors.white),
                            buttonTime("12:00 - 1:30 PM", Colors.white,
                                Colors.black54),
                            buttonTime(
                                "2:00 - 4:30 PM", Colors.white, Colors.black54),
                            buttonTime(
                                "5:30 - 6:30 PM", Colors.white, Colors.black54),
                            buttonTime(
                                "6:30 - 7:30 PM", Colors.white, Colors.black54),
                          ],
                        ),
                      ),
                      SizedBox(height: 25),
                      Text("Choose Hair Specialists",
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600)),
                      SizedBox(height: 10),
                      Container(
                          height: 140,
                          width: screen_size_width,
                          child: ListView(
                            scrollDirection: Axis.horizontal,
                            children: <Widget>[
                              Row(children: [Text("caca"),Text("caca"),Text("caca")],),
                              Row(children: [Text("caca"),Text("caca"),Text("caca")],),
                              Row(children: [Text("caca"),Text("caca"),Text("caca")],)
                            ],
                          ))
                    ],
                  )),
              SizedBox(height: 10),
              MyButton(btnText: "Book Appointment", onpressed: () {}),
              SizedBox(height: 20)
            ],
          ),
        ),
      ),
    );
  }
}

class DateColumn extends StatelessWidget {
  final String weekDay, date;
  final Color dateBg, dateTextColor;

  const DateColumn(
      {Key key, this.weekDay, this.date, this.dateBg, this.dateTextColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text(weekDay, style: TextStyle(color: Colors.white)),
        SizedBox(height: 15),
        Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: dateBg,
                borderRadius: BorderRadius.all(Radius.circular(10))),
            child: Text(date, style: TextStyle(color: dateTextColor))),
      ],
    );
  }
}

class MyButton extends StatelessWidget {
  final String btnText;
  final VoidCallback onpressed;

  const MyButton({Key key, this.btnText, this.onpressed}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * .5,
      height: 40,
      child: TextButton(
        style: ButtonStyle(),
        onPressed: onpressed,
        child: Text(btnText,
            style: TextStyle(
                color: Colors.white,
                fontSize: 15.5,
                fontWeight: FontWeight.w400)),
      ),
    );
  }
}
