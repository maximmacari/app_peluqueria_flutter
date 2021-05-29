import "package:flutter/material.dart";
import 'package:flutter_sms_auth1/shared/colors.dart';
import 'package:flutter_sms_auth1/shared/styles.dart';

class AppointmentScreen extends StatefulWidget {
  @override
  _AppointmentScreenState createState() => _AppointmentScreenState();
}

class _AppointmentScreenState extends State<AppointmentScreen> {
  @override
  Widget build(BuildContext context) {
    final screenSizeWidth = MediaQuery.of(context).size.width;
    final screenSizeHeight = MediaQuery.of(context).size.height;
    final double itemHeight = (screenSizeHeight - kToolbarHeight - 24) / 10;
    final double itemWidth = screenSizeWidth / 1.8;

    return Scaffold(
      backgroundColor: ConstantColors.mainColorApp,
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
        leading: IconButton(
            icon: Icon(Icons.chevron_left,
                color: Theme.of(context).colorScheme.foregroundTxtButtonColor),
            onPressed: () => Navigator.pop(context)),
        title: Text(
          "Reserva una cita",
          style: TextStyle(
              color: Theme.of(context).colorScheme.foregroundPlainTxtColor),
        ),
      ),
      body: Container(
        width: screenSizeWidth,
        height: screenSizeHeight,
        color: ConstantColors.myWhite,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                  color: ConstantColors.myWhite,
                  width: screenSizeWidth,
                  child: Column(children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        IconButton(
                            icon: Icon(Icons.chevron_left,
                                color: Theme.of(context)
                                    .colorScheme
                                    .foregroundPlainTxtColor),
                            onPressed: () {}),
                        Expanded(
                          child: Text("July, 2020", // instance of date
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .foregroundPlainTxtColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600)),
                        ),
                        Container(
                          padding: const EdgeInsets.all(8),
                          color: ConstantColors.mainColorApp,
                          
                          child: IconButton(
                            color: ConstantColors.mainColorApp,
                              icon: Icon(Icons.chevron_right,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .foregroundTxtButtonColor),
                              onPressed: () {}),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          DateColumn(
                            weekDay: "Mon",
                            date: "16",
                          ),
                          DateColumn(
                            weekDay: "Tue",
                            date: "17",
                          ),
                          DateColumn(
                            weekDay: "Wed",
                            date: "18",
                          ),
                          DateColumn(
                            weekDay: "Thu",
                            date: "19",
                          ),
                          DateColumn(weekDay: "Fri", date: "20"),
                          DateColumn(
                            weekDay: "Sat",
                            date: "21",
                          ),
                          DateColumn(
                            weekDay: "Sun",
                            date: "22",
                          )
                        ]),
                    SizedBox(height: 15),
                  ])),
              Container(
                  width: screenSizeWidth,
                  color: ConstantColors.myWhite,
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _header("Madrugada"),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount:
                                (screenSizeWidth / itemWidth).ceil().toInt(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (BuildContext context, int index) {
                          return buttonTime("10:30 - 11:45");
                        },
                      ),
                      _header("Tarde"),
                      GridView.builder(
                        primary: false,
                        shrinkWrap: true,
                        itemCount: 3,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: (itemWidth / itemHeight),
                            crossAxisCount:
                                (screenSizeWidth / itemWidth).ceil().toInt(),
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8),
                        itemBuilder: (BuildContext context, int index) {
                          return buttonTime("18:30 - 19:30");
                        },
                      ),
                    ],
                  )),
              SizedBox(height: 8),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.7,
                child: TextButton(
                  onPressed: () {},
                  child: Text(
                    "Reservar",
                    style: CustomTextStyles().onboardingBtnTextStyle(context),
                  ),
                  style: TextButton.styleFrom(
                      shape: (RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      )),
                      padding: EdgeInsets.fromLTRB(16, 16, 16, 16),
                      backgroundColor: ConstantColors.mainColorApp),
                ),
              ),
              SizedBox(height: 40)
            ],
          ),
        ),
      ),
    );
  }

  //buttonTime
  Widget buttonTime(timeText) {
    return TextButton(
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
            maxLines: 1,
            style: TextStyle(
                color: Theme.of(context).colorScheme.foregroundTxtButtonColor,
                fontSize: 14)));
  }

  Widget _header(String text) {
    return Column(
      children: [
        SizedBox(height: 24),
        Text("$text: ",
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        SizedBox(height: 16)
      ],
    );
    
  }
}

class AvaiableTimeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class DateColumn extends StatelessWidget {
  final String weekDay, date;

  const DateColumn({Key key, this.weekDay, this.date}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          color: ConstantColors.mainColorApp,
          borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Column(
        children: <Widget>[
          Text(weekDay, style: TextStyle(color: ConstantColors.myBlack)),
          Container(
              padding: EdgeInsets.all(8),
              child: Text(date,
                  style: TextStyle(
                      color: Theme.of(context)
                          .colorScheme
                          .foregroundPlainTxtColor))),
        ],
      ),
    );
  }
}
