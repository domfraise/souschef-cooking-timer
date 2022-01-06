import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:souschef_cooking_timer/model/phase.dart';

class EditPhasePage extends StatefulWidget {
  final Phase phase;
  final Function submitCallback;
  final Function deleteCallback;

  EditPhasePage(
      {required this.phase,
      required this.submitCallback,
      required this.deleteCallback});

  EditPhasePage.empty(
      {required this.submitCallback, required this.deleteCallback})
      : phase = Phase(name: "", initialDuration: Duration.zero);

  @override
  _EditPhasePageState createState() => _EditPhasePageState();
}

class _EditPhasePageState extends State<EditPhasePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController notesController = TextEditingController();
  Duration selectedDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    nameController.text = widget.phase.name;
    selectedDuration = widget.phase.timeRemaining;
    notesController.text = widget.phase.notes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Cooking Step"),
        actions: <Widget>[
          FlatButton(
              onPressed: submit,
              child: Icon(
                Icons.done,
                // color: Theme.of(context).buttonTheme.colorScheme.onPrimary,
              )),
          PopupMenuButton(onSelected: (buttonPressed) {
            switch (buttonPressed) {
              case "delete":
                widget.deleteCallback();
                break;
            }
          }, itemBuilder: (popMenuContext) {
            return [
              PopupMenuItem<String>(
                value: "delete",
                child: Text("Delete"),
              ),
            ];
          })
        ],
      ),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Expanded(
              flex: 2,
              child: buildTitleInput(context),
            ),
            Expanded(
              flex: 5,
              child: buildTimePicker(),
            ),
            Expanded(
              flex: 3,
              child: buildOnDoneInput(context),
            )
          ],
        ),
      ),
    );
  }

  Center buildTitleInput(BuildContext context) {
    return Center(
      child: Container(
        padding: EdgeInsets.all(5),
        child: TextField(
          decoration: InputDecoration(hintText: "e.g. Boil..."),
          textCapitalization: TextCapitalization.sentences,
          textAlign: TextAlign.center,
          // style: Theme.of(context).textTheme.headline,
          controller: nameController,
          onChanged: (value) {
            widget.phase.name = value;
          },
        ),
      ),
    );
  }

  Widget buildTimePicker() {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.all(10),
              child: Text(
                "Duration",
                // style: Theme.of(context).textTheme.subhead,
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Container(
              child: CupertinoTimerPicker(
                initialTimerDuration: selectedDuration,
                onTimerDurationChanged: (duration) {
                  selectedDuration = duration;
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  Container buildOnDoneInput(BuildContext context) {
    return Container(
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 2,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Text(
                  "Notes",
                  // style: Theme.of(context).textTheme.subhead,
                ),
              ),
            ),
            Expanded(
              flex: 8,
              child: Center(
                child: Container(
                  padding: EdgeInsets.all(5),
                  child: TextField(
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(hintText: "e.g. 200°c"),
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    textAlign: TextAlign.center,
                    // style: Theme.of(context).textTheme.headline,
                    controller: notesController,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  void submit() {
    widget.submitCallback(Phase(
        name: nameController.text,
        initialDuration: selectedDuration,
        notes: notesController.text));
    Navigator.pop(context);
  }
}
