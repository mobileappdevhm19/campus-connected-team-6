import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:flutter_campus_connected/settings/color_box.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';
import 'package:flutter_campus_connected/utils/text_aware_size.dart';
import 'package:meta/meta.dart';

typedef ClockColorCallback(Color color);

class SettingPage extends StatefulWidget {
  SettingPage({
    Key key,
    @required this.activeColor,
  })  : assert(activeColor == null),
        super(key: key);

  final Color activeColor;

  @override
  SettingPageState createState() => new SettingPageState();
}

class SettingPageState extends State<SettingPage> {
  bool _value = false;

  void _onChanged(bool value) async {
    setState(() {
      _value = value;
    });
    await DynamicTheme.of(context)
        .setBrightness(Theme.of(context).brightness == Brightness.dark
            ? Brightness.light
            : Brightness.dark)
        .then((data) => SystemChrome.setSystemUIOverlayStyle(
            SystemUiOverlayStyle(
                statusBarColor: DynamicTheme.of(context)
                    .data
                    .primaryColor, // status bar color
                statusBarBrightness: Brightness.light)));
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
              SwitchListTile(
                  value: _value,
                  title: Text(
                    "Dark / Light",
                  ),
                  activeColor: Colors.red,
                  secondary: Icon(Icons.color_lens),
                  subtitle: Text(
                    "You can switch your app in Dark or in Light mode",
                  ),
                  onChanged: (bool value) {
                    _onChanged(value);
                  }),
              ListTile(
                title: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new ColorBoxGroup(
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
                          DynamicTheme.of(context).setThemeData(
                            new ThemeData(primaryColor: getColor(color)),
                          );
                          SystemChrome.setSystemUIOverlayStyle(
                              SystemUiOverlayStyle(
                            statusBarColor: DynamicTheme.of(context)
                                .data
                                .primaryColor, // status bar color
                          ));
                        }),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        "Select Theme Color...",
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }

  getColor(Color color) {
    if (color == Colors.red) {
      return Colors.red;
    } else if (color == Colors.orange) {
      return Colors.orange;
    } else if (color == Colors.green) {
      return Colors.green;
    } else if (color == Colors.purple) {
      return Colors.purple;
    } else if (color == Colors.blue) {
      return Colors.blue;
    } else if (color == Colors.yellow) {
      return Colors.yellow;
    } else {
      return Colors.black;
    }
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
