import 'dart:io';

import 'package:flutter/material.dart';
import 'package:udemy_great_placess_app/providers/great_places.dart';
import 'package:udemy_great_placess_app/screens/add_place_screen.dart';
import 'package:provider/provider.dart';
import '../screens/place_detail_screen.dart';
import 'add_place_screen.dart';

class PlacesListScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your places'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(AddPlaceScreen.routeName);
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        // constroi a lista _items na memoria buscando no db e notifica mudanças
        future: Provider.of<GreatPlaces>(context, listen: false)
            .fetchAndSetPlaces(),
        builder: (ctx, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            // quando terminar a construção, aplica as mudanças
            : Consumer<GreatPlaces>(
                child: Center(
                  child: const Text('No new places'),
                ),
                builder: (ctx, greatPlaces, ch) => greatPlaces.items.length <= 0
                    ? ch!
                    : ListView.builder(
                        itemCount: greatPlaces.items.length,
                        itemBuilder: (ctx, i) => ListTile(
                          leading: CircleAvatar(
                            backgroundImage:
                                FileImage(greatPlaces.items[i].image!),
                          ),
                          title: Text(greatPlaces.items[i].title!),
                          subtitle: Text((greatPlaces.items[i].location!.address).toString()),
                          onTap: () {
                            // ... go to detail page
                            Navigator.of(context).pushNamed(PlaceDetailScreen.routeName, arguments: greatPlaces.items[i].id);
                          },
                        ),
                      ),
              ),
      ),
    );
  }
}
