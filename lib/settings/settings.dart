import 'package:flutter/material.dart';

import 'package:flutter_campus_connected/settings/color_box.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:meta/meta.dart';

typedef ClockColorCallback(Color color);

class SettingPage extends StatefulWidget {

  SettingPage

      ({
    Key key,
    @required this.activeColor,

  })
      :
        assert(activeColor == null),
        super (key:key);


  final Color activeColor;

  @override
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage> {

  bool _value = false;


  void _onChanged(bool value) {
    setState(() {
      _value = value;
    });
  }

  bool _value2 = false;

  void _onChanged2(bool value2) {
    setState(() {
      _value2 = value2;
    });
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    return new Scaffold(
        appBar: appBar(context),

        body: Container(
          padding: EdgeInsets.all(5.0),
          child: Column(
            children: <Widget>[
              SwitchListTile(value: _value,
                  title: Text("Dark"),
                  activeColor: Colors.red,
                  secondary: Icon(Icons.color_lens),
                  subtitle: Text("You can switch your app in dark"),

                  onChanged: (bool value) {
                    _onChanged(value);
                  }),
              SwitchListTile(value: _value2,
                  title: Text("Light"),
                  activeColor: Colors.red,
                  secondary: Icon(Icons.color_lens),
                  onChanged: (bool value2) {
                    _onChanged2(value2);
                  }),

              ListTile(
                title: new ColorBoxGroup(
                    width: 25.0,
                    height: 25.0,
                    spacing: 10.0,
                    colors: [
                      themeData.textTheme.display1.color,
                      Colors.red,
                      Colors.orange,
                      Colors.green,
                      Colors.purple,
                      Colors.blue,
                      Colors.yellow,
                    ],
                    groupValue: widget.activeColor,
                    onTap: (color) {

                    }

                ),
              )
            ],
          ),


        )
    );
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("Settings"),
      leading: new IconButton(
          icon: new Icon(
            Icons.arrow_back_ios,
          ),
          color: Colors.white,
          onPressed: () {
            Navigator.pop(context);
          }),
    );
  }

  Container appColor(BuildContext context) {
    return Container(
        color: Colors.redAccent,
        height: screenAwareSize(150, context),
        child: Center());
  }
}
