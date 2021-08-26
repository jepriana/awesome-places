import 'dart:io';
import 'package:collection/collection.dart';
import 'package:awesome_places/helpers/db_helper.dart';
import 'package:awesome_places/helpers/location_helper.dart';
import 'package:flutter/foundation.dart';
import 'package:nanoid/async.dart';
import '../models/place.dart';

class Places with ChangeNotifier {
  List<Place> _items = [];

  List<Place> get items {
    return [..._items];
  }

  Place? findById(String id) {
    return _items.firstWhereOrNull((place) => place.id == id);
  }

  Future<void> addPlaces(
    String pickedTitle,
    File pickedImage,
    PlaceLocation pickedLocation,
  ) async {
    final address = await LocationHelper.getPlaceAddress(
      pickedLocation.latitude,
      pickedLocation.longitude,
    );
    final updatedLocation = PlaceLocation(
      latitude: pickedLocation.latitude,
      longitude: pickedLocation.longitude,
      address: address,
    );
    final newPlace = Place(
      id: await nanoid(),
      title: pickedTitle,
      location: updatedLocation,
      image: pickedImage,
    );
    await DBHelper.insert(
      'places',
      {
        'id': newPlace.id,
        'title': newPlace.title,
        'image': newPlace.image.path,
        'loc_lat': newPlace.location!.latitude,
        'loc_lng': newPlace.location!.longitude,
        'address': newPlace.location!.address.toString(),
      },
    );
    _items.add(newPlace);
    notifyListeners();
  }

  Future<void> fetchAndSetPlaces() async {
    final dataList = await DBHelper.getData('places');
    _items = dataList
        .map(
          (place) => Place(
            id: place['id'],
            title: place['title'],
            image: File(place['image']),
            location: PlaceLocation(
              latitude: place['loc_lat'],
              longitude: place['loc_lng'],
              address: place['address'],
            ),
          ),
        )
        .toList();
    notifyListeners();
  }
}
