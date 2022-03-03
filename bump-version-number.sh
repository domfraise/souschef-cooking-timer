previous=$(cat ./android/app/build.gradle | grep "flutterVersionCode = '" | cut -d "'" -f2)
new=$((previous +1))
searchFor="flutterVersionCode = '$previous'"
replace="flutterVersionCode = '$new'"
sed -i "" "s/$searchFor/$replace/g" ./android/app/build.gradle
echo "New version code: $new"
