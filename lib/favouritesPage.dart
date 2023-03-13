import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class Favourites extends StatefulWidget {
  const Favourites(BuildContext context, {Key? key}) : super(key: key);

  @override
  State<Favourites> createState() => _FavouritesState();
}

class _FavouritesState extends State<Favourites> {


  @override
  Widget build(BuildContext context) {

    var appState = context.watch<MyAppState>();


    if (appState.favorites.isEmpty) {
      return Center(
        child: Text('No favorites yet.'),
      );
    }


    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.all(20),
          child: Text('You have '
              '${appState.favorites.length} favorites:'),
        ),
        for (var pair in appState.favorites)
          ListTile(
            leading: Icon(Icons.favorite),
            title: Text(pair.asLowerCase),
            trailing: IconButton(
                onPressed: () {
                  //Code Behaviour
                  setState(() {
                    appState.favorites.remove(pair);
                  });
                },
                icon: Icon(Icons.delete_forever)),
          ),
      ],
    );
  }

}
