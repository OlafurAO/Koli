import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:koli/constants/constants.dart';
import 'package:koli/forms/add_card_form.dart';
import 'package:koli/models/badge.dart';
import 'package:koli/models/date.dart';
import 'package:koli/models/user.dart';
import 'package:koli/models/user_profile.dart';
import 'package:koli/services/authService.dart';
import 'package:koli/services/dataService.dart';
import 'package:koli/shared/achievement_get.dart';
import 'package:koli/shared/bottom_navbar.dart';
import 'package:koli/shared/loading.dart';
import 'package:provider/provider.dart';
import 'package:koli/shared/appbar.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();
  var currentDate = DateTime.now();
  var constants = Constants();
  bool checkedForBadges = false;
  bool checkedForNewCardTrans = false;

  Date getCurrentDate() {
    return Date(currentDate);
  }

  void addNewBadge(Badge badge) {
    achievementGet(this.context, badge);
    setState(() {
      checkedForBadges = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    if(!checkedForNewCardTrans) {
      DatabaseService(uid: user.uid).checkForNewCardTransactions();
      checkedForNewCardTrans = true;
    }

    if(!checkedForBadges) {
      DatabaseService(uid: user.uid).awardBadges(this.addNewBadge);
      checkedForBadges = true;
    }

    DatabaseService().getClimateChangeInfo();

    return StreamBuilder<UserProfile>(
      stream: DatabaseService(uid: user.uid).userProfile,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          UserProfile userData = snapshot.data;
          print(userData.carSize);

          return Scaffold(
            backgroundColor: Colors.white,
            appBar: appBar(context),

            body: Container(
              alignment: Alignment.center,
              child: Column(
                children: <Widget> [
                  /*Container(
                    //margin: EdgeInsets.fromLTRB(50, 20, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: Text(
                            '${getCurrentDate().getCurrentDate()}',
                            style: TextStyle(
                              fontSize: 40,
                            ),
                          ),
                        ),

                        Container(
                          child: Text(
                            '${getCurrentDate().getCurrentWeekday()}',
                            style: TextStyle(
                              fontSize: 30,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),



                  SizedBox(height: 40),
                  */


                  StreamBuilder<int>(
                    stream: DatabaseService(uid: user.uid).co2valueForCurrentMonth,
                    builder: (context, snapshot) {
                      int co2 = snapshot.data;

                      return Container(
                        color: Color(0xFF2D2E2E),
                        child: Row(
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                SizedBox(height: 20),
                                Container(
                                  padding: const EdgeInsets.all(40.0),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      width: 5,
                                      color: Colors.blue[200],
                                    ),

                                    shape: BoxShape.circle,
                                  ),

                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        '$co2 kg',
                                        style: TextStyle(
                                          fontSize: 30,
                                          color: Colors.blue
                                        ),
                                      ),

                                      Text('blabla')
                                    ],
                                  ),
                                ),

                                SizedBox(height: 20),

                                Text(
                                  'Þú ert með lægra kolefnisspor\n'
                                  '          en 60% notenda',
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 20),
                              ],
                            ),

                            //SizedBox(width: 40),
                            VerticalDivider(color: Colors.white),

                            Container(
                              transform: Matrix4.translationValues(0.0, -25.0, 0.0),
                              child: Column(
                                children: <Widget>[
                                  Icon(
                                    Icons.face,
                                    size: 125,
                                    color: Colors.grey[600],
                                  ),
                                  Text(
                                    '${userData.firstName}',
                                    style: TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  ),

                  SizedBox(height: 50),

                  RaisedButton(
                    elevation: 0,
                    color: Colors.blue,
                    child: Text(
                      'Tengja kort',
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),

                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AddCardForm();
                        }
                      );
                    },
                  ),
                ],
              ),
            ),

            bottomNavigationBar: BottomBar(),
          );
        } else {
          return Loading();
        }
      }
    );
  }
}
