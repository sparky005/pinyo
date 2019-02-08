import 'package:pinyo/src/models/post.dart';
import 'package:pinyo/src/utils/apiprovider.dart';
import 'package:rxdart/rxdart.dart';

class EditBloc {
  final token = "sparky_005:3E0DC4EC2FF41897ED27";

  Stream<String> get url => _urlSubject.stream;
  final _urlSubject = BehaviorSubject<String>();

  Stream<String> get description => _descriptionSubject.stream;
  final _descriptionSubject = BehaviorSubject<String>();

  Stream<String> get extended => _extendedSubject.stream;
  final _extendedSubject = BehaviorSubject<String>();

  Stream<String> get tags => _tagsSubject.stream;
  final _tagsSubject = BehaviorSubject<String>(seedValue: "");

  Stream<bool> get submitValid =>
      Observable.combineLatest4(url, description, extended, tags, (url, description, extended, tags) => true);

  // sink getters
  Function(String) get changeUrl => _urlSubject.sink.add;
  Function(String) get changeDescription => _descriptionSubject.sink.add;
  Function(String) get changeExtended => _extendedSubject.sink.add;
  Function(String) get changeTags => _tagsSubject.sink.add;

  dispose() {
    _urlSubject.close();
    _descriptionSubject.close();
    _extendedSubject.close();
    _tagsSubject.close();
  }

  submit() {
    final url = _urlSubject.value;
    final description = _descriptionSubject.value;
    final extended = _extendedSubject.value;
    final tags = _tagsSubject.value;
    Post post = new Post((i) => i
      ..href = url
      ..description = description
      ..extended = extended
      ..tags = tags
    );
    print("URL: $url");
    print("Description: $description");
    print("Extended: $extended");
    print("Tags: $tags");
    print(post.toString());
    //PinboardAPI.api.addPost(token, post);
  }
}
