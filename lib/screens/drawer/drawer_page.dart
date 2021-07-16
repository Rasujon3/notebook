import 'package:flutter/material.dart';
import 'package:notebook/constants/constants.dart';
import 'package:notebook/database/database_helper.dart';
import 'package:notebook/screens/aboutMe.dart';
import 'package:notebook/screens/home/home_page.dart';
import 'package:notebook/screens/note/note_add_page.dart';
import 'package:notebook/utils/custom_toast.dart';

class DrawerPage extends StatefulWidget {
  @override
  _DrawerPageState createState() => _DrawerPageState();
}

class _DrawerPageState extends State<DrawerPage> {
  DatabaseHelper _db;

  @override
  void initState() {
    super.initState();
    _db = DatabaseHelper();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kColorPrimary,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 35,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        child: Text(
                          'Notebook',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        margin: EdgeInsets.only(left: 20),
                      )),
                  SizedBox(
                    height: 70,
                  ),
                  _drawerItem(
                    title: 'About me',
                    icon: Icons.person,
                    onTap: () {
                      Navigator.of(context).pop();
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AboutMe()));
                    },
                  ),
                  _drawerItem(
                    title: 'Delete account',
                    icon: Icons.account_box_outlined,
                    onTap: () async {
                      int deleted = await _db.deleteTable();
                      if (deleted != null) {
                        CustomToast.toast('Account has been deleted');
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(builder: (context) => HomePage()),
                            (route) => false);
                      }
                    },
                  ),
                  _drawerItem(
                    title: 'Exit',
                    icon: Icons.exit_to_app,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  InkWell _drawerItem({
    @required IconData icon,
    @required String title,
    @required Function onTap,
  }) {
    return InkWell(
      onTap: () {
        onTap();
        //this.onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        height: 58,
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            )
          ],
        ),
      ),
    );
  }
}
