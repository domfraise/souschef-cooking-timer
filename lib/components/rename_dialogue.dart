import 'package:flutter/material.dart';

class RenameDialogue extends StatefulWidget {
  final String title;
  final String initialValue;
  final Function submitCallback;

  RenameDialogue(this.title, this.initialValue, this.submitCallback);

  @override
  _RenameDialogueState createState() => _RenameDialogueState(this.initialValue);
}

class _RenameDialogueState extends State<RenameDialogue> {
  TextEditingController controller;
  String initialValue;

  _RenameDialogueState(this.initialValue) :
    controller = TextEditingController(text: initialValue);

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        textCapitalization: TextCapitalization.sentences,
        controller: controller,
        autofocus: true,
      ),
      actions: <Widget>[
        FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text("Cancel"),
        ),FlatButton(
          onPressed: () {
            widget.submitCallback(controller.text);
            Navigator.of(context).pop();
          },
          child: Text("OK"),
        ),
      ],
    );
  }
}
