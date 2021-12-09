import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:souschef_cooking_timer/model/recipe.dart';

class FirestoreService {
  static final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();
  bool isNewUser = false;
  String? userDocumentId;


  FirestoreService(){
    // Firebase.initializeApp();

  }

  Future<String> getUserDocument() async {
   var deviceInfo = await deviceInfoPlugin.androidInfo;
   var deviceId = deviceInfo.id;

    QuerySnapshot documentSnapshot = await FirebaseFirestore.instance
        .collection('users')
        .where("deviceId", isEqualTo: deviceId)
        .limit(1)
        .get();
    var userDocumentRefs = documentSnapshot.docs;
    if (userDocumentRefs.length > 0) {
      var userDocumentId = userDocumentRefs[0].id;
      this.userDocumentId = userDocumentId;
      return userDocumentId;
    } else {
      var newUserDocRef = await createUser(deviceId!);
      isNewUser = true;
      var userDocumentId = newUserDocRef.id;
      this.userDocumentId = userDocumentId;
      return userDocumentId;
    }
  }

  Future<Recipe> getFirstRecipe(Function alertCallback) async {
    //todo get from docId
    String userId = await getUserDocument();
    var recipeSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("recipes")
        .doc();
    var documents = recipeSnapshots.snapshots();
    if(documents.length == 0) {
      return createRecipe(Recipe.empty());
    }
    var documentSnapshot = await documents.first;
    if (documentSnapshot.data() == null) {
      return Recipe.empty();
    }
    return Recipe.fromJson(documentSnapshot.data() ?? {}, documentSnapshot.id, alertCallback);

  }
  Future<Recipe> createRecipe(Recipe newRecipe) {
    return addRecipe(newRecipe)
        .then((documentRef) {
      newRecipe.documentId = documentRef.id;
      return newRecipe;
    });
  }

  Future<List<Recipe>> getRecipes(Function alertCallback) async {
    String userId = await getUserDocument();
    var recipeSnapshots = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection("recipes")
        .doc();
    List<Recipe> recipes = [];
    recipeSnapshots.snapshots().forEach((document) {
      recipes.add(

        Recipe.fromJson(document.data() ?? {}, document.id, alertCallback));
    });
    return recipes;
  }

  Stream<List<Recipe>> getRecipesStream(Function alertCallback) {
    if(userDocumentId == null) print ("User Document not found");
    var recipeSnapshots = FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentId)
        .collection("recipes")
        .snapshots();
    return recipeSnapshots.map((snapshot) => snapshot.docs
        .map((document) => Recipe.fromJson(document.data(), document.id, alertCallback)).toList());
  }

  Future<DocumentReference> createUser(String deviceId) async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .add({'deviceId': deviceId});
    return userDoc;
  }

  Future<DocumentReference> addRecipe(Recipe recipe) async {
    var userDocumentId = await getUserDocument();
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentId)
        .collection("recipes")
        .add(recipe.toJson());
  }

  Future saveRecipe(Recipe recipe) async {
    DocumentReference documentReference = await getRecipeRef(recipe.documentId);
    documentReference.set(recipe.toJson());
  }

  Future<DocumentReference> getRecipeRef(String recipeDocumentId) async {
    var userDocumentId = await getUserDocument();
    DocumentReference documentReference = FirebaseFirestore.instance
        .collection('users')
        .doc(userDocumentId)
        .collection("recipes").doc(recipeDocumentId);

    return documentReference;
  }

  Future<void> deleteRecipe(Recipe recipe) async {
    var recipeRef = await getRecipeRef(recipe.documentId);
    recipeRef.delete();
  }
}
