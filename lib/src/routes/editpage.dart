import 'package:flutter/material.dart';
import 'package:pinyo/src/edit_bloc.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = EditBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: urlField(bloc),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: descriptionField(bloc),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: extendedField(bloc),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: tagsField(bloc),
          ),
          submitButton(bloc),
        ],
      ),
    );
  }

  Widget urlField(EditBloc bloc) {
    return StreamBuilder(
      stream: bloc.url,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeUrl,
          keyboardType: TextInputType.url,
          decoration: InputDecoration(
              hintText: 'https://google.com',
              labelText: "URL",
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget descriptionField(EditBloc bloc) {
    return StreamBuilder(
      stream: bloc.description,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeDescription,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'Google dot com',
              labelText: "Bookmark Title",
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget extendedField(EditBloc bloc) {
    return StreamBuilder(
      stream: bloc.extended,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeExtended,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'A super cool search engine',
              labelText: "Bookmark Description",
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget tagsField(EditBloc bloc) {
    return StreamBuilder(
      stream: bloc.tags,
      builder: (context, snapshot) {
        return TextField(
          onChanged: bloc.changeTags,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              hintText: 'search google flutter',
              labelText: "Tags",
              errorText: snapshot.error),
        );
      },
    );
  }

  Widget submitButton(EditBloc bloc) {
    return StreamBuilder(
      stream: bloc.submitValid,
      builder: (context, snapshot) {
        return RaisedButton(
          child: Text('Submit'),
          color: Colors.blue,
          onPressed: snapshot.hasData ? bloc.submit : null,
        );
      },
    );
  }
}
