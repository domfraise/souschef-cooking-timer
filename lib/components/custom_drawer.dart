import 'package:flutter/material.dart';
import 'package:souschef/components/intro_slider.dart';
import 'package:souschef/pages/privacy_policy.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Center(
            child: UserAccountsDrawerHeader(
              accountName: Text("User"),
              accountEmail: Text("Email"),
              currentAccountPicture: CircleAvatar(
                child: Icon(Icons.person),
              ),
            ),
          ),
          ListTile(
              title: Text("Timer"),
              leading: Icon(Icons.timer),
              onTap: () {
                Navigator.pushNamed(context, '/');
              }),
          ListTile(
            leading: Icon(Icons.receipt),
            title: Text("Recipes"),
            onTap: () {
              Navigator.pushNamed(context, 'recipes');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.help),
            title: Text("Help"),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => HelpSlider())),
          ),
          Spacer(
            flex: 4,
          ),
          Divider(),
          ListTile(
            title: Center(child: Text("Privacy Policy",
                style: Theme.of(context).textTheme.caption),),
            onTap: () => Navigator.push(
                context, MaterialPageRoute(builder: (context) => PrivacyPolicy())),
          )
        ],
      ),
    );
  }
}
