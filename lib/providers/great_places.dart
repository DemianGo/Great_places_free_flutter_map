import 'package:flutter/foundation.dart';
import 'dart:io';

import '../models/place.dart';
import '../helpers/db_helper.dart';
import '../helpers/location_helper.dart';


class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place findById(String id){
    return _items.firstWhere((place) => place.id == id);
  }


  // salva na lista(memoria) e também no db
  Future<void> addPlaces(String pickedTitle, File pickedImage, PlaceLocation pickedLocation) async{
    // pega a rua
    final address = await LocationHelper.getPlaceAddress(pickedLocation.latitude!, pickedLocation.longitude!);
    final updatedLocation = PlaceLocation(latitude: pickedLocation.latitude, longitude: pickedLocation.longitude, address: address);

    final newPlace = Place(
      id: DateTime.now().toString(),
      title: pickedTitle,
      location: updatedLocation,
      image: pickedImage,
    );
    _items.add(newPlace);
    notifyListeners();
    // insere no sqlite
    DBHelper.insert('user_places', {
      'id': newPlace.id as Object,
      'title': newPlace.title as Object,
      'image': newPlace.image!.path,
      'loc_lat':newPlace.location!.latitude as double,
      'loc_lng':newPlace.location!.longitude as double,
      'address':newPlace.location!.address as String,
    });
  }

  // busca db, e seta em memoria(_items)
  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item['title'],
            location: PlaceLocation(latitude:item['loc_lat'] , longitude:item['loc_lng'] , address: item['address']),
            image: File(
              item['image'],
            ),
          ),
        )
        .toList();
    // avisa todos os ouvintes sobre os novos dados carregados
    notifyListeners();
  }
}
