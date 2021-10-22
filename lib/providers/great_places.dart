import 'dart:io';
import 'package:flutter/foundation.dart';

import '../models/place.dart';
import 'package:greatplacesapp/helpers/db_helper.dart';

class GreatPlaces with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  void addPlace(String pickedTitle, File pickedImage) {
    final newPlace = Place(
      id: DateTime.now().toIso8601String(),
      title: pickedTitle,
      image: pickedImage,
      location: new PlaceLocation(latitude: 1, longitude: 1, address: ""),
    );
    _items.add(newPlace);
    notifyListeners();
    DBHelper.insert('user_places',
        {"id": newPlace.id, "title": newPlace.title, "image": newPlace.image});
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('user_places');
    _items = dataList
        .map(
          (item) => Place(
            id: item['id'],
            title: item["title"],
            location: new PlaceLocation(latitude: 1, longitude: 1, address: ""),
            image: File(item["image"]),
          ),
        )
        .toList();
    notifyListeners();
  }
}
