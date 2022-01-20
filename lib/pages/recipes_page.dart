import 'package:flutter/material.dart';
import 'package:souschef_cooking_timer/components/custom_drawer.dart';
import 'package:souschef_cooking_timer/components/recipe_view.dart';
import 'package:souschef_cooking_timer/model/recipe.dart';
import 'package:souschef_cooking_timer/model/timer_model.dart';

class RecipesPage extends StatefulWidget {
  final Future<TimerModel> currentTimerFuture;
  final Function saveRecipeCallback;
  final Function deleteRecipeCallback;
  final Function renameRecipeCallback;
  final Stream<List<Recipe>> recipesFuture;
  final Function createEmptyRecipe;

  RecipesPage(this.currentTimerFuture,
      this.saveRecipeCallback,
      this.deleteRecipeCallback,
      this.renameRecipeCallback,
      this.recipesFuture,
      this.createEmptyRecipe);

//TODO stateless?
  @override
  _RecipesPageState createState() => _RecipesPageState();
}

class _RecipesPageState extends State<RecipesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Recipes"),
      ),
      drawer: CustomDrawer(),
      body: SafeArea(
          child: Container(
            child: StreamBuilder(
                stream: widget.recipesFuture,
                builder: (context, recipesStream) {
                  if (recipesStream.hasData) {
                    return Column(
                      children: <Widget>[
                        FutureBuilder(
                            future: widget.currentTimerFuture,
                            builder: (BuildContext context,
                                AsyncSnapshot<TimerModel> snapshot) {
                              if (snapshot.hasData &&
                                  snapshot.data!.isRunning()) {

                                return buildCurrentTimerView(snapshot.data!);
                              } else {
                                return Container();
                              }
                            }),
                        Expanded(
                          child: ListView.separated(
                              itemCount: (recipesStream.data as List<Recipe>).length,
                              separatorBuilder: (context, i) =>
                                  Divider(
                                    color: Theme
                                        .of(context)
                                        .dividerColor,
                                  ),
                              itemBuilder: (context, i) =>
                                  RecipeView(
                                      (recipesStream.data as List<Recipe>)[i],
                                      widget.deleteRecipeCallback,
                                      widget.renameRecipeCallback,
                                      widget.saveRecipeCallback,
                                      showDialogueIfTimerRunning)),
                        ),
                      ],
                    );
                  } else {
                    return ListView();
                  }
                }),
          )),
      floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add), onPressed: () async{
        var pushNewRecipe = () {
          widget
              .createEmptyRecipe()
              .then((recipe) =>
              Navigator.of(context).pushNamed(recipe.documentId));
        };
        showDialogueIfTimerRunning(pushNewRecipe);
      }),
    );
  }

  Widget buildCurrentTimerView(TimerModel timer) =>
      Card(
        elevation: 10,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text("Running Timer",
                  // style: Theme
                  //     .of(context)
                  //     .textTheme
                  //     .subhead
              ),
              padding: EdgeInsets.all(10),
            ),
            Divider(
              color: Theme
                  .of(context)
                  .dividerColor,
            ),
            RecipeView(
              timer.recipe,
              widget.deleteRecipeCallback,
              widget.renameRecipeCallback,
              widget.saveRecipeCallback,
              (onContinue) => onContinue(),
              routeToPush: '',
            )
          ],
        ),
      );

  void showDialogueIfTimerRunning(Function onContinue) async {
    var timer = await widget.currentTimerFuture;

    if (timer.isRunning()) {
      showWarningDialogue(context, onContinue);
    } else {
      onContinue();
    }
  }

  void showWarningDialogue(context, onContinue) {
    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text("You Have a Timer Running"),
            content: Text("Current timer will be stopped"),
            actions: <Widget>[
              FlatButton(
                onPressed: () {
                  onContinue();
                },
                child: Text("Continue"),
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text("Cancel"),
              )
            ],
          ),
    );
  }
}
