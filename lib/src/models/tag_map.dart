import 'dart:convert' as json;

import 'package:built_value/built_value.dart';
import 'package:built_value/serializer.dart';
import 'package:pinyo/src/utils/serializers.dart';

part 'tag_map.g.dart';

abstract class TagMap implements Built<TagMap, TagMapBuilder> {
  static Serializer<TagMap> get serializer => _$tagMapSerializer;

  Map<String, String> get tags;

  TagMap._();
  factory TagMap([updates(TagMapBuilder b)]) = _$TagMap;
}

TagMap parseTags(String jsonStr) {
  final parsed = json.jsonDecode(jsonStr);
  //TagMap tags = standardSerializers.deserializeWith(TagMap.serializer, parsed);
  // this is just a straight map
  // we don't really need complicated serializers for this
  Map<String, String> map = Map<String, String>.from(parsed);
  TagMap tags = TagMap((i) => i
                  ..tags=map);
  return tags;
}