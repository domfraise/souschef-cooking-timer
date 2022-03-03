# souschef_cooking_timer

A smart cooking timer

## Local Set up
Install flutter
`brew install flutter`

Install java
`brew install java@11`

install flutter fire
`brew install flutterfire`
`flutterfire init`

Copy values into key.properties from secure storage

## Release
### Auto
[Optional] update version in pubspec.yaml and version name in app/build.gradle file
* Push to origin main to trigger insider testing release.
* Run Promote build job to push to production


### Manual

* Update version in pubspec,
* Update flutter version code and name in build.gradle
* `flutter build appbundle`
* upload app bundle to google play