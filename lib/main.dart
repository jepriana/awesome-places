import 'package:awesome_places/providers/places.dart';
import 'package:awesome_places/screens/add_place_screen.dart';
import 'package:awesome_places/screens/place_detail_screen.dart';
import 'package:awesome_places/screens/places_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: Places(),
      child: MaterialApp(
        title: 'Awesome Places',
        theme: ThemeData(
          primarySwatch: Colors.indigo,
          accentColor: Colors.amberAccent,
        ),
        home: PlacesListScreen(),
        routes: {
          AddPlaceScreen.routeName: (ctx) => AddPlaceScreen(),
          PlaceDetailScreen.routName: (ctx) => PlaceDetailScreen(),
        },
      ),
    );
  }
}
