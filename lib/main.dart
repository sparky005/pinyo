import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinyo/src/pinyo_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pinyo/src/post.dart';

void main() {
  final pinyo_bloc  = PinyoBloc();
  runApp(MyApp(bloc: pinyo_bloc));
}

class MyApp extends StatelessWidget {
  final PinyoBloc bloc;

  MyApp({
    Key key,
    this.bloc,
  }) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pinyo',
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHomePage(title: 'Pinyo', bloc: bloc),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final PinyoBloc bloc;
  MyHomePage({Key key, this.title, this.bloc}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _currentIndex = 0;

  //static String jsonListOfPosts = """[
  //    {
  //      "href": "http://streamhacker.com/2010/05/10/text-classification-sentiment-analysis-naive-bayes-classifier/",
  //      "description": "Text Classification for Sentiment Analysis – Naive Bayes Classifier | StreamHacker",
  //      "extended": "This is somewhat near human accuracy, as apparently people agree on sentiment only around 80% of the time.",
  //      "meta": "807d32aafed5b6d2796b8f85f6b2e0b4",
  //      "hash": "e0f273cb0dc650390b2d931509504956",
  //      "time": "2017-03-06T13:06:51Z",
  //      "shared": "yes",
  //      "toread": "no",
  //      "tags": "python naive_bayes text_classification programming"
  //    },
  //    {
  //      "href": "http://billchambers.me/tutorials/2015/01/14/python-nlp-cheatsheet-nltk-scikit-learn.html",
  //      "description": "Python NLP - NLTK and scikit-learn",
  //      "extended": "",
  //      "meta": "0d04d33ede8bc5784a5c22c86b412c66",
  //      "hash": "ad4f6fb62b68d37a74df4f0d41056fa1",
  //      "time": "2017-03-04T17:00:32Z",
  //      "shared": "yes",
  //      "toread": "no",
  //      "tags": "text_classification"
  //    },
  //    {
  //      "href": "https://arxiv.org/pdf/1410.5329.pdf",
  //      "description": "Naive Bayes and Text Classification I",
  //      "extended": "",
  //      "meta": "e6939f3dcf9664e376157aa08af29614",
  //      "hash": "2b8a6728c6e357d5072c41b8085e6f41",
  //      "time": "2017-02-26T17:46:52Z",
  //      "shared": "yes",
  //      "toread": "no",
  //      "tags": "papers naive_bayes via:chrisalbon text_classification"
  //    },
  //    {
  //      "href": "https://nbviewer.jupyter.org/github/brandomr/document_cluster/blob/master/cluster_analysis_web.ipynb",
  //      "description": "Document clustering python",
  //      "extended": "",
  //      "meta": "af2f78c7535af107955f698c8de423f1",
  //      "hash": "4dfa01632a13761d468b093bb6a77a3d",
  //      "time": "2017-02-19T04:26:14Z",
  //      "shared": "yes",
  //      "toread": "no",
  //      "tags": "python text_classification"
  //    },
  //    {
  //      "href": "http://blog.alejandronolla.com/2013/05/20/n-gram-based-text-categorization-categorizing-text-with-python/",
  //      "description": "N-Gram-Based Text Categorization: Categorizing text with python - Alejandro Nolla - z0mbiehunt3r",
  //      "extended": "",
  //      "meta": "888c72389af257ec02c2a62f7d91e472",
  //      "hash": "c3b35ef62b941869c80560e4ebc9c400",
  //      "time": "2017-02-19T04:24:51Z",
  //      "shared": "no",
  //      "toread": "no",
  //      "tags": "python text_classification"
  //    }
  //  ]""";


  //final posts = parseAllPosts(jsonListOfPosts);
  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: StreamBuilder<UnmodifiableListView<Post>>(
        stream: widget.bloc.posts,
        initialData: UnmodifiableListView<Post>([]),
        builder: (context, snapshot) => _buildList(context, snapshot),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            title: Text('All'),
            icon: Icon(Icons.announcement),
          ),
          BottomNavigationBarItem(
            title: Text('Python'),
            icon: Icon(Icons.computer),
          ),
        ],
        onTap: (index) {
          if (index == 0) {
            // this "adds" the enum to the stream
            // listener in the bloc handles change
            widget.bloc.postsType.add(PostsType.all);
          } else {
            // same here
            widget.bloc.postsType.add(PostsType.python);
          }
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }

  Widget _buildList(BuildContext context, AsyncSnapshot snapshot) {
    List<Post> posts = snapshot.data;
    return ListView.builder(
      itemCount: posts.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildItem(posts[index]);
      },
    );
  }

  Widget _buildItem(Post post) {
    return Padding(
      key: Key(post.description),
      padding: const EdgeInsets.all(16.0),
      child: ListTile(
        title: Padding(
          padding: const EdgeInsets.only(bottom: 8.0),
          child: Text(post.description ?? '[null]'),
        ),
        subtitle: Text(post.extended),
        onTap: () async {
          // await the future!
          // needed because canLaunch returns a future
          // and "if" statements are syncronous
          if (await canLaunch(post.href)) {
            launch(post.href);
          }
        },
        onLongPress: () {
          Fluttertoast.showToast(
              msg: "Not yet implemented.",
              toastLength: Toast.LENGTH_SHORT,
              gravity: ToastGravity.BOTTOM,
              timeInSecForIos: 1,
          );
          throw UnimplementedError;
        }
      ),
    );
  }
}
