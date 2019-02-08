// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post.dart';

// **************************************************************************
// BuiltValueGenerator
// **************************************************************************

Serializer<Post> _$postSerializer = new _$PostSerializer();

class _$PostSerializer implements StructuredSerializer<Post> {
  @override
  final Iterable<Type> types = const [Post, _$Post];
  @override
  final String wireName = 'Post';

  @override
  Iterable serialize(Serializers serializers, Post object,
      {FullType specifiedType = FullType.unspecified}) {
    final result = <Object>[
      'href',
      serializers.serialize(object.href, specifiedType: const FullType(String)),
    ];
    if (object.url != null) {
      result
        ..add('url')
        ..add(serializers.serialize(object.url,
            specifiedType: const FullType(String)));
    }
    if (object.id != null) {
      result
        ..add('id')
        ..add(serializers.serialize(object.id,
            specifiedType: const FullType(int)));
    }
    if (object.description != null) {
      result
        ..add('description')
        ..add(serializers.serialize(object.description,
            specifiedType: const FullType(String)));
    }
    if (object.extended != null) {
      result
        ..add('extended')
        ..add(serializers.serialize(object.extended,
            specifiedType: const FullType(String)));
    }
    if (object.meta != null) {
      result
        ..add('meta')
        ..add(serializers.serialize(object.meta,
            specifiedType: const FullType(String)));
    }
    if (object.hash != null) {
      result
        ..add('hash')
        ..add(serializers.serialize(object.hash,
            specifiedType: const FullType(String)));
    }
    if (object.time != null) {
      result
        ..add('time')
        ..add(serializers.serialize(object.time,
            specifiedType: const FullType(String)));
    }
    if (object.shared != null) {
      result
        ..add('shared')
        ..add(serializers.serialize(object.shared,
            specifiedType: const FullType(String)));
    }
    if (object.toread != null) {
      result
        ..add('toread')
        ..add(serializers.serialize(object.toread,
            specifiedType: const FullType(String)));
    }
    if (object.tags != null) {
      result
        ..add('tags')
        ..add(serializers.serialize(object.tags,
            specifiedType: const FullType(String)));
    }

    return result;
  }

  @override
  Post deserialize(Serializers serializers, Iterable serialized,
      {FullType specifiedType = FullType.unspecified}) {
    final result = new PostBuilder();

    final iterator = serialized.iterator;
    while (iterator.moveNext()) {
      final key = iterator.current as String;
      iterator.moveNext();
      final dynamic value = iterator.current;
      switch (key) {
        case 'href':
          result.href = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'url':
          result.url = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'id':
          result.id = serializers.deserialize(value,
              specifiedType: const FullType(int)) as int;
          break;
        case 'description':
          result.description = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'extended':
          result.extended = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'meta':
          result.meta = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'hash':
          result.hash = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'time':
          result.time = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'shared':
          result.shared = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'toread':
          result.toread = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
        case 'tags':
          result.tags = serializers.deserialize(value,
              specifiedType: const FullType(String)) as String;
          break;
      }
    }

    return result.build();
  }
}

class _$Post extends Post {
  @override
  final String href;
  @override
  final String url;
  @override
  final int id;
  @override
  final String description;
  @override
  final String extended;
  @override
  final String meta;
  @override
  final String hash;
  @override
  final String time;
  @override
  final String shared;
  @override
  final String toread;
  @override
  final String tags;

  factory _$Post([void updates(PostBuilder b)]) =>
      (new PostBuilder()..update(updates)).build();

  _$Post._(
      {this.href,
      this.url,
      this.id,
      this.description,
      this.extended,
      this.meta,
      this.hash,
      this.time,
      this.shared,
      this.toread,
      this.tags})
      : super._() {
    if (href == null) {
      throw new BuiltValueNullFieldError('Post', 'href');
    }
  }

  @override
  Post rebuild(void updates(PostBuilder b)) =>
      (toBuilder()..update(updates)).build();

  @override
  PostBuilder toBuilder() => new PostBuilder()..replace(this);

  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Post &&
        href == other.href &&
        url == other.url &&
        id == other.id &&
        description == other.description &&
        extended == other.extended &&
        meta == other.meta &&
        hash == other.hash &&
        time == other.time &&
        shared == other.shared &&
        toread == other.toread &&
        tags == other.tags;
  }

  @override
  int get hashCode {
    return $jf($jc(
        $jc(
            $jc(
                $jc(
                    $jc(
                        $jc(
                            $jc(
                                $jc(
                                    $jc(
                                        $jc($jc(0, href.hashCode),
                                            url.hashCode),
                                        id.hashCode),
                                    description.hashCode),
                                extended.hashCode),
                            meta.hashCode),
                        hash.hashCode),
                    time.hashCode),
                shared.hashCode),
            toread.hashCode),
        tags.hashCode));
  }

  @override
  String toString() {
    return (newBuiltValueToStringHelper('Post')
          ..add('href', href)
          ..add('url', url)
          ..add('id', id)
          ..add('description', description)
          ..add('extended', extended)
          ..add('meta', meta)
          ..add('hash', hash)
          ..add('time', time)
          ..add('shared', shared)
          ..add('toread', toread)
          ..add('tags', tags))
        .toString();
  }
}

class PostBuilder implements Builder<Post, PostBuilder> {
  _$Post _$v;

  String _href;
  String get href => _$this._href;
  set href(String href) => _$this._href = href;

  String _url;
  String get url => _$this._url;
  set url(String url) => _$this._url = url;

  int _id;
  int get id => _$this._id;
  set id(int id) => _$this._id = id;

  String _description;
  String get description => _$this._description;
  set description(String description) => _$this._description = description;

  String _extended;
  String get extended => _$this._extended;
  set extended(String extended) => _$this._extended = extended;

  String _meta;
  String get meta => _$this._meta;
  set meta(String meta) => _$this._meta = meta;

  String _hash;
  String get hash => _$this._hash;
  set hash(String hash) => _$this._hash = hash;

  String _time;
  String get time => _$this._time;
  set time(String time) => _$this._time = time;

  String _shared;
  String get shared => _$this._shared;
  set shared(String shared) => _$this._shared = shared;

  String _toread;
  String get toread => _$this._toread;
  set toread(String toread) => _$this._toread = toread;

  String _tags;
  String get tags => _$this._tags;
  set tags(String tags) => _$this._tags = tags;

  PostBuilder();

  PostBuilder get _$this {
    if (_$v != null) {
      _href = _$v.href;
      _url = _$v.url;
      _id = _$v.id;
      _description = _$v.description;
      _extended = _$v.extended;
      _meta = _$v.meta;
      _hash = _$v.hash;
      _time = _$v.time;
      _shared = _$v.shared;
      _toread = _$v.toread;
      _tags = _$v.tags;
      _$v = null;
    }
    return this;
  }

  @override
  void replace(Post other) {
    if (other == null) {
      throw new ArgumentError.notNull('other');
    }
    _$v = other as _$Post;
  }

  @override
  void update(void updates(PostBuilder b)) {
    if (updates != null) updates(this);
  }

  @override
  _$Post build() {
    final _$result = _$v ??
        new _$Post._(
            href: href,
            url: url,
            id: id,
            description: description,
            extended: extended,
            meta: meta,
            hash: hash,
            time: time,
            shared: shared,
            toread: toread,
            tags: tags);
    replace(_$result);
    return _$result;
  }
}

// ignore_for_file: always_put_control_body_on_new_line,annotate_overrides,avoid_annotating_with_dynamic,avoid_as,avoid_catches_without_on_clauses,avoid_returning_this,lines_longer_than_80_chars,omit_local_variable_types,prefer_expression_function_bodies,sort_constructors_first,test_types_in_equals,unnecessary_const,unnecessary_new
