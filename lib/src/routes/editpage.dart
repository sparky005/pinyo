import 'package:flutter/material.dart';
import 'package:pinyo/src/edit_bloc.dart';
import 'package:pinyo/src/widgets/progressbar.dart';

class EditPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final bloc = EditBloc();
    return Scaffold(
      appBar: AppBar(
        title: Text("Edit Post"),
        bottom: PreferredSize(
          preferredSize: Size(double.infinity, 1.0),
          child: ProgressBar(bloc.isLoading),
        ),
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
          // TODO: need to validate that the right data is there
          // and show a message on success or fail
          onPressed: () async {
            if (snapshot.hasData) {
              final rc = await bloc.submit();
              var message;
              if (rc == 0) {
                message = 'Success!';
              } else if (rc == 2) {
                message = 'Invalid Url!';
              } else {
                message = 'Error!';
              }
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text(message),
                ),
              );
            } else {
              Scaffold.of(context).showSnackBar(
                SnackBar(
                  content: Text("Error: URL and title required"),
                ),
              );
            }
          },
        );
      },
    );
  }
}
