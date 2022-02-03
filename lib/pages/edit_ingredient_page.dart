import 'package:flutter/material.dart';
import 'package:souschef/components/duration_view.dart';
import 'package:souschef/model/ingredient_model.dart';
import 'package:souschef/model/phase.dart';
import 'package:souschef/model/timer_state.dart';
import 'package:souschef/pages/edit_phase_page.dart';

class EditIngredientPage extends StatefulWidget {
  final IngredientModel ingredient;
  final Function submitCallback;
  final Function alertCallback;

  EditIngredientPage(
      {required this.ingredient,
      required this.submitCallback,
      required this.alertCallback});

  EditIngredientPage.empty(
      {required this.submitCallback, required this.alertCallback})
      : ingredient = IngredientModel(
          alertCallback: alertCallback,
          name: "",
          phases: [],
        );

  @override
  _EditIngredientPageState createState() =>
      _EditIngredientPageState(ingredient);
}

class _EditIngredientPageState extends State<EditIngredientPage> {
  TextEditingController nameController = TextEditingController();

  IngredientModel ingredient;

  _EditIngredientPageState(this.ingredient);

  @override
  void initState() {
    super.initState();
    nameController.text = ingredient.name;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Ingredient"),
        actions: <Widget>[
          FlatButton(
              onPressed: submit,
              child: Icon(
                Icons.done,
                // color: Theme.of(context).buttonTheme.colorScheme.onPrimary,
              ))
        ],
      ),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(5),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                height: 80,
                child: buildNameInput(),
              ),
              Container(
                height: 160,
                child: buildDurationCard(),
              ),
              Expanded(
                child: buildTimeline(context),
              ),
            ],
          ),
        ),
      )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => EditPhasePage.empty(
                      submitCallback: (Phase phase) {
                        setState(() {
                          ingredient.phases.add(phase);
                        });
                      },
                      deleteCallback: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                    ),
              ),
            );
          }),
    );
  }

  Card buildDurationCard() {
    return Card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "Ingredient Cook Time",
                // style:
                    // Theme.of(context).textTheme.subhead.copyWith(fontSize: 20),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: Center(
              child: DurationView(
                duration: ingredient.timeRemaining,
                fontSize: 45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Card buildTimeline(BuildContext context) {
    return Card(
      child: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10),
            child: Title(
              child: Text(
                "Cooking Steps",
                // style:
                    // Theme.of(context).textTheme.subhead.copyWith(fontSize: 20),
              ),
              color: Theme.of(context).primaryColor,
            ),
          ),
          Expanded(
            flex: 5,
            child: ingredient.phases.isNotEmpty
                ? ReorderableListView(
                    children: buildReorderableList(ingredient.phases),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        var selectedPhase =
                            ingredient.phases.removeAt(oldIndex);
                        if (newIndex > ingredient.phases.length)
                          ingredient.phases.add(selectedPhase);
                        else
                          ingredient.phases.insert(newIndex, selectedPhase);
                      });
                    })
                : ListTile(
                    title: Text(
                      "Try Adding a Cooking Step",
                      style: Theme.of(context).textTheme.caption,
                      textAlign: TextAlign.center,
                    ),
                  ),
          )
        ],
      ),
    );
  }

  void submit() {
    ingredient.name = nameController.text;
    widget.submitCallback(ingredient);
    Navigator.pop(context);
  }

  List<Widget> buildReorderableList(List<Phase> phases) {
    List<Widget> listItems = [];
    for (var i = 0; i < phases.length; i++) {
      listItems.add(ListTile(
        key: ObjectKey(i),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => EditPhasePage(
                    phase: phases[i],
                    submitCallback: (Phase phase) {
                      phase.state = TimerState.PENDING;
                      phases[i] = phase;
                    },
                    deleteCallback: () {
                      phases.removeAt(i);
                      Navigator.of(context).pop();
                    },
                  ),
            ),
          );
        },
        title: Text(phases[i].name),
        trailing: DurationView(duration: phases[i].timeRemaining),
        leading: Icon(Icons.drag_handle),
      ));
    }
    return listItems;
  }

  Container buildNameInput() {
    return Container(
      padding: EdgeInsets.all(5),
      child: TextField(
        textCapitalization: TextCapitalization.sentences,
        textAlign: TextAlign.center,
        // style: Theme.of(context).textTheme.headline.copyWith(fontSize: 30),
        controller: nameController,
        onChanged: (value) {},
        decoration: InputDecoration(hintText: "e.g. Potatoes"),
      ),
    );
  }
}
