import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Theme.of(context).primaryColor,
        child: Column(
          children: <Widget>[
            Image(
              image: AssetImage("assets/chef-hat.png"),
              color: Theme.of(context).colorScheme.onPrimary,
            ),
            Text(
              "Sous Chef",
              style: TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold)

            ),
            CircularProgressIndicator()
          ],
        ),
      ),
    );
  }
}
