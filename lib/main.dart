import 'package:flutter/material.dart';
import 'package:listy/src/sample_feature/sample_item.dart';
import 'package:realm/realm.dart';

import 'src/app.dart';
import 'src/settings/settings_controller.dart';
import 'src/settings/settings_service.dart';

void main() async {
  // final realm = Realm(Configuration.local([SampleItem.schema]));
  final app = App(AppConfiguration("listy-app-kcikr"));
  final user = app.currentUser ?? await app.logIn(Credentials.anonymous());
  final realm = Realm(Configuration.flexibleSync(user, [SampleItem.schema]));
  realm.subscriptions.update((mutableSubscriptions) {
    mutableSubscriptions.add(realm.all<SampleItem>());
  });
  final allItems = realm.all<
      SampleItem>(); // returns only a pointer to the data in the DB, not the actual data

  final settingsController = SettingsController(SettingsService());
  await settingsController.loadSettings();
  runApp(MyApp(
    settingsController: settingsController,
    allItems: allItems,
  ));
}
