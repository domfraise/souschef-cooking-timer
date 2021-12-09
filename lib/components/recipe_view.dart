import 'package:flutter/material.dart';
import 'package:souschef_cooking_timer/components/phase_chip.dart';
import 'package:souschef_cooking_timer/components/rename_dialogue.dart';
import 'package:souschef_cooking_timer/model/recipe.dart';

class RecipeView extends StatelessWidget {
  final Recipe recipe;
  final Function deleteRecipeCallback;
  final Function renameRecipeCallback;
  final Function saveRecipeCallback;
  final Function showWarningDialogue;
  String? routeToPush;

  RecipeView(this.recipe, this.deleteRecipeCallback, this.renameRecipeCallback,
      this.saveRecipeCallback, this.showWarningDialogue, {routeToPush}){
    this.routeToPush = routeToPush??recipe.documentId;
    this.recipe.ingredients.sort((a,b) => b.initialDuration.compareTo(a.initialDuration));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(5),
      child: ListTile(
        onTap: () {
          showWarningDialogue(() => Navigator.pushNamed(context, '/$routeToPush'));
        },
        title: Container(
          padding: EdgeInsets.symmetric(vertical: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(0),
                ),
              ),
              Expanded(
                flex: 8,
                child: Text(
                  recipe.name,
                  // style: Theme.of(context).textTheme.headline,
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: PopupMenuButton(
                  onSelected: (selected) {
                    switch (selected) {
                      case "rename":
                        showDialog(
                          context: context,
                          builder: (context) =>
                              RenameDialogue(
                                "Rename Recipe",
                                recipe.name,
                                    (String newValue) {
                                  recipe.name = newValue;
                                  saveRecipeCallback(recipe);
                                },
                              ),
                        );
                        break;
                      case "delete":
                        deleteRecipeCallback(recipe);
                        break;
                    }
                  },
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        value: "rename",
                        child: Text("Rename"),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Text("Delete"),
                      )
                    ];
                  },
                ),
              )
            ],
          ),
        ),
        subtitle: Column(
            children: recipe.ingredients
                .map((ingredient) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(5),
                  child: Text(
                    ingredient.name,
                    // style: Theme.of(context).textTheme.subtitle,
                  ),
                ),
                Container(
                  height: 50,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: ingredient.phases
                        .map((phase) => PhaseChip(phase, (phase) {showWarningDialogue(() => Navigator.pushNamed(context, '/$routeToPush'));},
                        recipe.initialDuration))
                        .toList(),
                  ),
                )
              ],
            ))
                .toList()),
      ),
    );
  }

  void renameRecipe(BuildContext context, Recipe recipe) {
    showDialog(
      context: context,
      builder: (context) => RenameDialogue(
            "Rename Recipe",
            recipe.name,
            (String newValue) {
              recipe.name = newValue;
              saveRecipeCallback(recipe);
            },
          ),
    );
  }
}
