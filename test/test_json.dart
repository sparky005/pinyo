import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pinyo/src/post.dart';

import 'package:pinyo/main.dart';
import 'package:pinyo/src/tag_map.dart';

void main() {
  test("test parsing a single post", () {
    final post = """{
      "href": "https://nbviewer.jupyter.org/github/brandomr/document_cluster/blob/master/cluster_analysis_web.ipynb",
      "description": "Document clustering python",
      "extended": "",
      "meta": "af2f78c7535af107955f698c8de423f1",
      "hash": "4dfa01632a13761d468b093bb6a77a3d",
      "time": "2017-02-19T04:26:14Z",
      "shared": "yes",
      "toread": "no",
      "tags": "python text_classification"
    }""";
    expect(parsePost(post).hash, "4dfa01632a13761d468b093bb6a77a3d");
  });

  test("parse another post, just to be safe", () {
    final post = """{
    "href": "https://blog.jetbrains.com/pycharm/2017/04/webinar-recording-visual-debugging/",
    "description": "Webinar Recording: Visual Debugging | PyCharm Blog",
    "extended": "",
    "meta": "7fed03d23d3f05823176bc87f5fa8e2d",
    "hash": "dcbbbb0fd691f66e669f746d0a1cf587",
    "time": "2017-04-26T22:34:14Z",
    "shared": "yes",
    "toread": "yes",
    "tags": ""
  }""";
    expect(parsePost(post).hash, "dcbbbb0fd691f66e669f746d0a1cf587");
  });

  test("parse a list of posts", () {
    final jsonListOfPosts = """[
      {
        "href": "http://streamhacker.com/2010/05/10/text-classification-sentiment-analysis-naive-bayes-classifier/",
        "description": "Text Classification for Sentiment Analysis – Naive Bayes Classifier | StreamHacker",
        "extended": "This is somewhat near human accuracy, as apparently people agree on sentiment only around 80% of the time.",
        "meta": "807d32aafed5b6d2796b8f85f6b2e0b4",
        "hash": "e0f273cb0dc650390b2d931509504956",
        "time": "2017-03-06T13:06:51Z",
        "shared": "yes",
        "toread": "no",
        "tags": "python naive_bayes text_classification programming"
      },
      {
        "href": "http://billchambers.me/tutorials/2015/01/14/python-nlp-cheatsheet-nltk-scikit-learn.html",
        "description": "Python NLP - NLTK and scikit-learn",
        "extended": "",
        "meta": "0d04d33ede8bc5784a5c22c86b412c66",
        "hash": "ad4f6fb62b68d37a74df4f0d41056fa1",
        "time": "2017-03-04T17:00:32Z",
        "shared": "yes",
        "toread": "no",
        "tags": "text_classification"
      },
      {
        "href": "https://arxiv.org/pdf/1410.5329.pdf",
        "description": "Naive Bayes and Text Classification I",
        "extended": "",
        "meta": "e6939f3dcf9664e376157aa08af29614",
        "hash": "2b8a6728c6e357d5072c41b8085e6f41",
        "time": "2017-02-26T17:46:52Z",
        "shared": "yes",
        "toread": "no",
        "tags": "papers naive_bayes via:chrisalbon text_classification"
      },
      {
        "href": "https://nbviewer.jupyter.org/github/brandomr/document_cluster/blob/master/cluster_analysis_web.ipynb",
        "description": "Document clustering python",
        "extended": "",
        "meta": "af2f78c7535af107955f698c8de423f1",
        "hash": "4dfa01632a13761d468b093bb6a77a3d",
        "time": "2017-02-19T04:26:14Z",
        "shared": "yes",
        "toread": "no",
        "tags": "python text_classification"
      },
      {
        "href": "http://blog.alejandronolla.com/2013/05/20/n-gram-based-text-categorization-categorizing-text-with-python/",
        "description": "N-Gram-Based Text Categorization: Categorizing text with python - Alejandro Nolla - z0mbiehunt3r",
        "extended": "",
        "meta": "888c72389af257ec02c2a62f7d91e472",
        "hash": "c3b35ef62b941869c80560e4ebc9c400",
        "time": "2017-02-19T04:24:51Z",
        "shared": "no",
        "toread": "no",
        "tags": "python text_classification"
      }
    ]""";
    expect(parseAllPosts(jsonListOfPosts).first.hash, "e0f273cb0dc650390b2d931509504956");
  });

  test("parse tags", () {
    final tags = """{
  "2018": "6",
  "academia": "1",
  "ai": "1",
  "android": "9",
  "anime": "8",
  "ansible": "6",
  "apartment": "2",
  "api": "2",
  "article": "1",
  "ash": "2",
  "aws": "1",
  "awx": "1",
  "backtesting": "1",
  "bags": "2",
  "bash": "1",
  "bitcoin": "1",
  "blog": "1",
  "books": "12",
  "bootstrap": "1",
  "bs4": "1",
  "c": "1",
  "cli": "1",
  "code_style": "2",
  "compton": "1",
  "conda": "1",
  "dart": "1",
  "datascience": "1",
  "dataset": "6",
  "datasets": "1",
  "data_source": "1",
  "dating": "3",
  "deep_learning": "3",
  "devops": "6",
  "docker": "2",
  "education": "1",
  "facebook": "1",
  "film": "1",
  "finance": "4",
  "fitness": "5",
  "flask": "2",
  "flutter": "7",
  "folium": "1",
  "functionalprogramming": "1",
  "games": "6",
  "gcloud": "2",
  "geo": "1",
  "git": "1",
  "go": "2",
  "go-lang": "2",
  "go-language": "1",
  "golang": "2",
  "google_cloud_engine": "1",
  "graph": "3",
  "haskell": "1",
  "ifttt": "2",
  "image-classification": "4",
  "inspiration": "1",
  "javascript": "2",
  "journaling": "2",
  "jupyter": "1",
  "keras": "9",
  "lda": "4",
  "lifehacker": "1",
  "linux": "3",
  "list": "11",
  "lists": "13",
  "machine-learning": "17",
  "machinelearning": "6",
  "mapping": "2",
  "math": "1",
  "ml": "17",
  "mongodb": "2",
  "movies": "19",
  "music": "10",
  "naive_bayes": "2",
  "navbar": "1",
  "neuralnetworks": "2",
  "neural_networks": "5",
  "nlp": "1",
  "optimization": "1",
  "packer": "1",
  "pandas": "1",
  "papers": "2",
  "performance": "3",
  "phone": "2",
  "powershell": "1",
  "production": "1",
  "productivity": "5",
  "profiling": "1",
  "programming": "34",
  "project_management": "3",
  "python": "41",
  "quant": "5",
  "reference": "1",
  "scala": "1",
  "sci-fi": "5",
  "scifi": "5",
  "scraping": "1",
  "sentimentanalysis": "1",
  "statarb": "8",
  "tensorflow": "7",
  "terminal": "1",
  "test-kitchen": "1",
  "Text_Classification": "8",
  "text_classification": "9",
  "tips": "2",
  "tmux": "1",
  "tools": "1",
  "trading": "8",
  "travel": "3",
  "trello": "1",
  "tutorial": "6",
  "tv": "3",
  "twitter": "11",
  "unity": "1",
  "vagrant": "1",
  "via:chrisalbon": "1",
  "vim": "5",
  "web_development": "3",
  "windows": "1",
  "wireframe": "2",
  "word2vec": "1",
  "wtb": "29",
  "zipline": "1"
}""";
    final parsedTags = parseTags(tags);
    expect(parsedTags.tags.keys.first, "2018");
    expect(parsedTags.tags.keys.last, "zipline");
  });
}
