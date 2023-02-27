import 'package:realm/realm.dart';
part 'sample_item.g.dart';

/// A placeholder class that represents an entity or model.
@RealmModel()
class _SampleItem {
  @PrimaryKey()
  @MapTo("_id")
  late ObjectId id;
  late int no;
}
