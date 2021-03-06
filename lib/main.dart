import 'dart:async';
import 'dart:ui';

import 'package:audioplayers/audioplayers.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:souschef/components/duration_view.dart';
import 'package:souschef/components/intro_slider.dart';
import 'package:souschef/components/rename_dialogue.dart';
import 'package:souschef/model/notification_model.dart';
import 'package:souschef/model/recipe.dart';
import 'package:souschef/model/timer_model.dart';
import 'package:souschef/pages/recipes_page.dart';
import 'package:souschef/service/firestore.dart';

import './pages/home.dart';
import 'firebase_options.dart';

var flutterLocalNotificationsPlugin;

void main() async {
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  WidgetsFlutterBinding.ensureInitialized();
  initializeService();


  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(SousChefApp());
}
Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      autoStart: false,
      isForegroundMode: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: false,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
}

// to ensure this executed
// run app from xcode, then from xcode menu, select Simulate Background Fetch
void onIosBackground() { //TODO test when testing IOS
  WidgetsFlutterBinding.ensureInitialized();
  print('FLUTTER BACKGROUND FETCH');
}

void onStart() {
  var totalTimeRemaining = 0;
  var timeUntilNextAlert = 0;
  var running = true;
  WidgetsFlutterBinding.ensureInitialized();
  final service = FlutterBackgroundService();


  service.onDataReceived.listen((event) {
    if (event!["action"] == "setAsForeground") {
      service.setForegroundMode(true);
      running = true;
      return;
    }

    if (event["action"] == "setAsBackground") {
      service.setForegroundMode(false);
      running = false;
    }

    if (event["action"] == "stopService") {
      service.stopBackgroundService();
    }

    if (event["action"] == "updateDuration") {
      totalTimeRemaining = event["totalTimeRemaining"];
      timeUntilNextAlert = event["timeUntilNextAlert"];
    }
  });

  // bring to foreground
  service.setForegroundMode(true);
  Timer.periodic(Duration(seconds: 1), (timer) async {
    if (!(await service.isServiceRunning())) timer.cancel();
    service.setNotificationInfo(
      title: "Running Timer",
      content: "Next Alert In: ${DurationView.getDisplayTime(new Duration(seconds: timeUntilNextAlert))}",
    );
    if (running) {
      totalTimeRemaining -= 1;
      timeUntilNextAlert -=1;
    }

    if(timeUntilNextAlert <= 0 ) {
      service.sendData({"action":"phaseCompleted", "totalTimeRemaining": totalTimeRemaining});
    }

    if (totalTimeRemaining <= 0) {
      service.stopBackgroundService();
    }
  });

  service.sendData({"action": "serviceReady"});
}
class SousChefApp extends StatefulWidget {
  @override
  SousChefAppState createState() {
    return new SousChefAppState();
  }
}

class SousChefAppState extends State<SousChefApp> {
  FirestoreService firestore = FirestoreService();
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  List<NotificationModel> notifications = [];
  Recipe currentRecipe = Recipe.empty();
  late Future<TimerModel> timerFuture;
  AudioCache audioCache = new AudioCache();
  AudioPlayer? audioPlayer;
  bool alerting = false;

  @override
  void initState() {
    super.initState();
    _configureNotifications();
    currentRecipe = Recipe.empty();
    setState(() {
      timerFuture = firestore.getUserDocument()
          .then((value) => firestore.getFirstRecipe(notify))
          .then((value) => TimerModel(recipe:value, alertCallback:notify, showProgress:_showProgressNotification));
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      navigatorKey: navigatorKey,
      theme: ThemeData(
          primarySwatch: Colors.purple,
          brightness: Brightness.light,
          accentColor: Colors.purpleAccent),
      initialRoute: '/',
      routes: {
        '/': (context) {
          if (firestore.isNewUser) {
            firestore.isNewUser = false;
            return HelpSlider();
          } else {
            return HomePage(
              notify: notify,
              notifications: notifications,
              removeNotification: removeNotification,
              saveRecipeCallback: saveRecipe,
              timerFuture: timerFuture,
              muteAlarm: muteAlarm,
              alerting: alerting,
            );
          }
        },
        'recipes': (context) => RecipesPage(
            timerFuture,
            saveRecipe,
            deleteRecipe,
            renameRecipe,
            firestore.getRecipesStream(notify),
            createEmptyRecipe),
        'notifications': (context) => HomePage(
              notify: notify,
              saveRecipeCallback: saveRecipe,
              removeNotification: removeNotification,
              notifications: notifications,
              initialTab: 2,
              timerFuture: timerFuture,
              muteAlarm: muteAlarm,
              alerting: alerting,
            )
      },
      onGenerateRoute: (RouteSettings routeSettings) {
        //open recipe by id
        var recipeId = routeSettings.name?.replaceFirst('/', '');
        timerFuture.then((timer) => timer.pause());
        setState(() {
          timerFuture = getRecipe(recipeId!).then(
                  (recipe) => TimerModel(recipe:recipe, alertCallback:notify, showProgress:_showProgressNotification));
        });
        return MaterialPageRoute(
          builder: (context) => HomePage(
            notify: notify,
            notifications: notifications,
            removeNotification: removeNotification,
            saveRecipeCallback: saveRecipe,
            timerFuture: timerFuture,
            muteAlarm: muteAlarm,
            alerting: alerting,
          ),
        );
      },
    );
  }

  Future<Recipe> createEmptyRecipe() {
    var newRecipe = firestore.createRecipe(Recipe.empty());
    return newRecipe;
  }

  Future<Recipe> getRecipe(String recipeReference) async {
    return firestore.getRecipe(recipeReference, notify);
  }

  saveRecipe(Recipe recipe) {
    firestore.saveRecipe(recipe);
  }

  void deleteRecipe(Recipe recipe) {
    firestore.deleteRecipe(recipe);
  }

  void renameRecipe(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => RenameDialogue(
        "Rename Recipe",
        recipe.name,
        (String newValue) {
          recipe.name = newValue;
          saveRecipe(recipe);
        },
      ),
    );
  }

  void notify(String title, String action) {
    timerFuture.then((value) => value.updateDurationInService());
    _showNotification(title, action);
    playNotificationSound();
    setState(() {
      notifications.insert(
          0,
          NotificationModel(
              title: title, action: action, happendAt: DateTime.now()));
    });
  }

  void playNotificationSound() {
    if (audioPlayer == null) {
      audioCache.loop('beeping.mp3', isNotification: true).then((player) {
        if (audioPlayer == null) {
          audioPlayer = player;
        } else {
          //pause extra created player
          player.pause();
        }
      });
    } else {
      audioPlayer!.resume();
    }
    alerting = true;
  }

  _configureNotifications() async {

    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings("@mipmap/launcher_notification");
    final IOSInitializationSettings initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: (x,y,z,j){}); //TODO implement for IOS
    final MacOSInitializationSettings initializationSettingsMacOS = MacOSInitializationSettings();
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: initializationSettingsMacOS);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: onSelectNotification);
  }

  void onSelectNotification(String? payload) async {
    muteAlarm();
    await navigatorKey.currentState?.pushNamed('notifications');
  }

  void muteAlarm() {
    audioPlayer?.pause();
    setState(() {
      alerting = false;
    });
  }

  Future<void> _showProgressNotification() async {
    var groupKey = 'com.phraze.souschef.progress';
    var timer = await timerFuture;
    if (timer.isRunning()) {
      while (timer.isRunning() && timer.totalTimeRemaining.inSeconds > 0) {
        await Future.delayed(Duration(seconds: 1), () async {
          var androidPlatformChannelSpecifics = AndroidNotificationDetails(
              'progress channel',
              'progress channel',
              channelShowBadge: false,
              importance: Importance.high,
              priority: Priority.high,
              ongoing: timer.isRunning(),
              onlyAlertOnce: true,
              showProgress: true,
              groupKey: groupKey,
              maxProgress: timer.recipe.initialDuration.inSeconds,
              progress: timer.recipe.initialDuration.inSeconds -
                  timer.totalTimeRemaining.inSeconds);
          var iOSPlatformChannelSpecifics = IOSNotificationDetails();
          var platformChannelSpecifics = NotificationDetails(
              android:androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics);

          String title;
          String subtitle;
          var nextAlertingPhase = timer.recipe.getNextAlertingPhase();
          if (timer.scheduledTimeRemaining != null &&
              timer.scheduledTimeRemaining > Duration.zero) {
            title = 'Starting in: ' +
                DurationView.getDisplayTime(timer.scheduledTimeRemaining);
            subtitle =
                'First Item: ${nextAlertingPhase.ingredientName} - ${nextAlertingPhase.phaseName}';
          } else {
            title =
                '${nextAlertingPhase.ingredientName} - ${nextAlertingPhase.phaseName}: ' +
                    DurationView.getDisplayTime(
                        nextAlertingPhase.timeTillNextAlert);
            subtitle = "Total: " +
                DurationView.getDisplayTime(timer.totalTimeRemaining);
          }

          await flutterLocalNotificationsPlugin.show(
              0, title, subtitle, platformChannelSpecifics,
              payload: 'item x');
        });
      }
    }
  }

  Future _showNotification(String title, String body) async {
    var groupKey = 'com.phraze.souschef.notifications';
    var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
        title, 'Sous Chef Timer',
        importance: Importance.high,
        priority: Priority.low,
        groupKey: groupKey);
    var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
    var platformChannelSpecifics = new NotificationDetails(
        android:androidPlatformChannelSpecifics, iOS:iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        1, '$title', '$body', platformChannelSpecifics);
  }

  void removeNotification(NotificationModel notification) {
    setState(() {
      notifications.remove(notification);
    });
  }
}


