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
  final _extendedSubject = BehaviorSubject<String>(seedValue: "");

  Stream<String> get tags => _tagsSubject.stream;
  final _tagsSubject = BehaviorSubject<String>(seedValue: "");

  Stream<bool> get isLoading => _isLoadingSubject.stream;
  final _isLoadingSubject = BehaviorSubject<bool>(seedValue: false);

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
    _isLoadingSubject.close();
  }

  Future<int> submit() async {
    _isLoadingSubject.add(true);
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
    final rc = await PinboardAPI.api.addPost(token, post);
    _isLoadingSubject.add(false);
    return rc;
  }
}
