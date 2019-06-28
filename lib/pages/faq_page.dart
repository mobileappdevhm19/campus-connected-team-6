import 'package:flutter/material.dart';
import 'package:flutter_campus_connected/FAQ/data.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_campus_connected/utils/screen_aware_size.dart';

class FAQPage extends StatefulWidget {
  @override
  FAQPageState createState() => new FAQPageState();
}

class FAQPageState extends State<FAQPage> {
  List<Container> _buildListItemsFromFlowers() {
    int index = 0;
    return faq.map((faq) {
      var container = Container(
        decoration: index % 2 == 0
            ? new BoxDecoration(color: const Color(0xFFEF9A9A))
            : new BoxDecoration(color: const Color(0xFFEF5350)),
        child: new Row(
          children: <Widget>[
            new Container(
                margin: new EdgeInsets.all(10.0),
                child: new Image(
                  image: AssetImage(faq.imageURL),
                  width: 90.0,
                  height: 90.0,
                  fit: BoxFit.cover,
                )),
            Expanded(
              child: new Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                      height: MediaQuery.of(context).size.height / 10,
                      width: MediaQuery.of(context).size.width,
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height / 20),
                      child: new Text(faq.question,
                          style: new TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 12.0,
                              color: Colors.white))),
                  new Container(
                    height: MediaQuery.of(context).size.height / 10,
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height / 80
                    ),
                    child: new Text(
                      faq.answer,
                      style: new TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
      index = index + 1;
      return container;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(context),
        body: SafeArea(
          bottom: true,
          left: true,
          right: true,
          top: true,
          child: ListView(
            children: _buildListItemsFromFlowers(),
          ),
        ));
  }

  AppBar appBar(BuildContext context) {
    return AppBar(
      title: Text("FAQ"),
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
