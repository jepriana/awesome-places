import 'package:awesome_places/providers/places.dart';
import 'package:awesome_places/screens/add_place_screen.dart';
import 'package:awesome_places/screens/place_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlacesListScreen extends StatefulWidget {
  PlacesListScreen({Key? key}) : super(key: key);

  @override
  _PlacesListScreenState createState() => _PlacesListScreenState();
}

class _PlacesListScreenState extends State<PlacesListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Places'),
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
        future: Provider.of<Places>(context, listen: false).fetchAndSetPlaces(),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Consumer<Places>(
                    builder: (ctx, places, ch) => places.items.length <= 0
                        ? ch!
                        : ListView.builder(
                            itemBuilder: (ctx, idx) => ListTile(
                              leading: CircleAvatar(
                                backgroundImage: FileImage(
                                  places.items[idx].image,
                                ),
                              ),
                              title: Text(places.items[idx].title),
                              subtitle: Text(
                                places.items[idx].location!.address.toString(),
                              ),
                              onTap: () {
                                Navigator.of(context).pushNamed(
                                  PlaceDetailScreen.routName,
                                  arguments: places.items[idx].id,
                                );
                              },
                            ),
                            itemCount: places.items.length,
                          ),
                    child: Center(
                      child: Text(
                        'Got no places yet, start adding some!',
                      ),
                    ),
                  ),
      ),
    );
  }
}
