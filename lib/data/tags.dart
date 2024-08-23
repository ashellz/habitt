import 'package:hive/hive.dart';

part 'tags.g.dart';

@HiveType(typeId: 2)
class TagData extends HiveObject {
  TagData({required this.tag});
  @HiveField(0)
  String tag;
}
