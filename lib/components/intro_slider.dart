import 'package:flutter/material.dart';
import 'package:intro_slider/intro_slider.dart';
import 'package:intro_slider/slide_object.dart';

class HelpSlider extends StatefulWidget {
  @override
  _HelpSliderState createState() => _HelpSliderState();
}

class _HelpSliderState extends State<HelpSlider> {
  List<Slide> slides = [];

  @override
  void initState() {
    super.initState();
    slides.add(Slide(
        title: "Welcome to Sous Chef",
        backgroundColor: Colors.orange,
        centerWidget: Image.asset(
          "assets/chef-hat.png",
          height: 200,
        ),
        description:
            "I'm here to make sure all of your dishes finish at the same time"));
    slides.add(Slide(
        title: "Recipes",
        backgroundColor: Colors.blue,
        centerWidget: Image.asset(
          "assets/recipe.png",
          height: 200,
        ),
        description:
            "Each recipe can contain multiple ingredients. Add an ingredient for each dish, such as potatoes or chicken. "
            "Timers for each ingredient will run simulatiously and finish at the same time"));
    slides.add(Slide(
        title: "Ingredients",
        backgroundColor: Colors.red,
        centerWidget: Image.asset(
          "assets/fish.png",
          height: 200,
        ),
        description: "Ingredients are made up of phases. "
            "Add multiple phases if you need to do various steps for an ingredient, such as marinade for 20 minutes then bake for 40 minutes"));
    slides.add(Slide(
        title: "Start The Timer",
        backgroundColor: Colors.green,
        centerWidget: Image.asset(
          "assets/stopwatch.png",
          height: 200,
        ),
        description: "Once you have your timer ready, press play. "
            "You will get notifications once an ingredient timer is about to start, and each time a phase finishes"));
    slides.add(Slide(
        title: "Schedule Timers",
        backgroundColor: Colors.orange,
        centerWidget: Image.asset(
          "assets/scheduledstopwatch.png",
          height: 200,
        ),
        description: "Schedule a timer to finish at a specific time. "
            "Sous Chef will let you know when its time to put in your first dish"));
  }

  void goHome(BuildContext context) {
    Navigator.of(context).pushNamed('/');
  }

  @override
  Widget build(BuildContext context) {
    return new IntroSlider(
      slides: this.slides,
      onDonePress: () => this.goHome(context),
      onSkipPress: () => this.goHome(context),
    );
  }
}
