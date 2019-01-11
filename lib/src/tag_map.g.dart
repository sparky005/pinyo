// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_map.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<TagMap> _$tagMapSerializer = new _$TagMapSerializer();

class _$TagMapSerializer implements StructuredSerializer<TagMap> {
  @override
  final Iterable<Type> types = const [TagMap, _$TagMap];
  @override
  final String wireName = 'TagMap';

  @override
  Iterable serialize(Serializers serializers, TagMap object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'tags',
      serializers.serialize(object.tags,
          specifiedType: const FullType(
              Map, const [const FullType(String), const FullType(String)])),
    ];

    return result;
  }

  @override
  TagMap deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new TagMapBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'tags':
          result.tags = serializers.deserialize(value,
              specifiedType: const FullType(Map, const [
                const FullType(String),
                const FullType(String)
              ])) as Map<String, String>;
          break;
      }
    }

    return result.build();
  }
}

class _$TagMap extends TagMap {
  @override
  final Map<String, String> tags;

  factory _$TagMap([void updates(TagMapBuilder b)]) =>
      (new TagMapBuilder()..update(updates)).build();

  _$TagMap._({this.tags}) : super._() {
    if (tags == null) {
      throw new BuiltValueNullFieldError('TagMap', 'tags');
    }
  }

  @override
  TagMap rebuild(void updates(TagMapBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  TagMapBuilder toBuilder() => new TagMapBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TagMap && tags == other.tags;
  }

  @override
  int get hashCode {
    return $jf($jc(0, tags.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('TagMap')..add('tags', tags))
        .toString();
  }
}

class TagMapBuilder implements Builder<TagMap, TagMapBuilder> {
  _$TagMap _$v;

  Map<String, String> _tags;
  Map<String, String> get tags => _$this._tags;
  set tags(Map<String, String> tags) => _$this._tags = tags;

  TagMapBuilder();

  TagMapBuilder get _$this {
    if (_$v != null) {
      _tags = _$v.tags;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(TagMap other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$TagMap;
  }

  @override
  void update(void updates(TagMapBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$TagMap build() {
    final _$result = _$v ?? new _$TagMap._(tags: tags);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
