import 'package:souschef_cooking_timer/model/ingredient_model.dart';
import 'package:souschef_cooking_timer/model/phase.dart';
import 'package:souschef_cooking_timer/model/timeline_item.dart';


class Recipe {
  String name;
  List<IngredientModel> ingredients;
  String documentId;

  Recipe(this.name, this.ingredients, this.documentId);

  Recipe empty() {
    return Recipe("", [], "");
  }

  Duration get initialDuration {
    Duration longestDuration = Duration(seconds: 0);
    ingredients.forEach((ingredient) {
      if (ingredient.initialDuration > longestDuration)
        longestDuration = ingredient.initialDuration;
    });
    return longestDuration;
  }

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "ingredients":
          ingredients.map((ingredient) => ingredient.toJson()).toList()
    };
  }

  Recipe.empty()
      : name = "New Recipe", ingredients = [], documentId = "NO DOC-ID";

  static Recipe fromJson(Map<String, dynamic> json, String documentId, Function alertCallback) {
    var ingredients = json['ingredients'] ?? [];
    return Recipe(
        json['name'] ?? "New Recipe",
        List<IngredientModel>.from(ingredients
            .map((ingredient) =>
                IngredientModel.fromJson(ingredient, alertCallback))
            .toList()),
        documentId
    );
  }

  void reset() {
    ingredients.forEach((IngredientModel ingredient) => ingredient.reset());
  }

  List<TimelineItem> getTimelineList() {
    var allTimelineItems = getAllTimelineItems();
    _sortByTimeUntilStart(allTimelineItems);
    return allTimelineItems;
  }

  void _sortByTimeUntilStart(List<TimelineItem> allTimelineItems) {
    allTimelineItems.sort((a, b) {
      if (a.timeUntilStart > b.timeUntilStart) {
        return 1;
      }
      else if (a.timeUntilStart == b.timeUntilStart) {
        return 0;
      } else {
        return -1;
      }
    });
  }

  void _sortByTimeRemaining(List<TimelineItem> allTimelineItems) {
    allTimelineItems.sort((a, b) {
      return a.timeTillNextAlert.compareTo(b.timeTillNextAlert);
    });
  }

  List<TimelineItem> getAllTimelineItems() {
    var phases = <TimelineItem>[];

    for (int ingIndex = 0; ingIndex < ingredients.length; ingIndex++) {
      var ingredient = ingredients[ingIndex];
      var offset = ingredient.offset;
      for (int phaseIndex = 0;
          phaseIndex < ingredient.phases.length;
          phaseIndex++) {
        var phase = ingredient.phases[phaseIndex];
        phases.add(TimelineItem(
            phase.timeRemaining, offset, phase.name, ingredient.name));
        offset += phase.timeRemaining;
      }
    }
    return phases;
  }

  TimelineItem getNextAlertingPhase() {
    var allTimelineItems = getAllTimelineItems();
    allTimelineItems.retainWhere((item) => item.timeRemaining > Duration.zero);
    _sortByTimeRemaining(allTimelineItems);
    return allTimelineItems.isNotEmpty
        ? allTimelineItems.first
        : TimelineItem(Duration.zero, Duration.zero, "", "");
  }

  Recipe clone() {
    return Recipe(
        name,
        ingredients
            .map((ingredient) => IngredientModel(
                name: ingredient.name,
                alertCallback: ingredient.alertCallback,
                phases: ingredient.phases
                    .map((phase) => Phase(
                        name: phase.name,
                        initialDuration: phase.initialDuration,
                        notes: phase.notes))
                    .toList()))
            .toList(),
        documentId);
  }
}
