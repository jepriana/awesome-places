import 'package:awesome_places/providers/places.dart';
import 'package:awesome_places/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlaceDetailScreen extends StatelessWidget {
  static const routName = '/place-detail';
  const PlaceDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final id = ModalRoute.of(context)!.settings.arguments as String;
    final selectedPlace =
        Provider.of<Places>(context, listen: false).findById(id);
    return Scaffold(
      appBar: AppBar(
        title:
            Text(selectedPlace != null ? selectedPlace.title : 'Place Detail'),
      ),
      body: selectedPlace != null
          ? Column(
              children: [
                Container(
                  height: 250,
                  width: double.infinity,
                  child: Image.file(
                    selectedPlace.image,
                    fit: BoxFit.cover,
                    width: double.infinity,
                  ),
                ),
                SizedBox(
                  height: 8,
                ),
                Text(
                  selectedPlace.location != null
                      ? selectedPlace.location!.address.toString()
                      : '',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.grey,
                  ),
                ),
                SizedBox(height: 8),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        fullscreenDialog: true,
                        builder: (ctx) => MapScreen(
                          initialLocation: selectedPlace.location!,
                        ),
                      ),
                    );
                  },
                  child: Text('View on Map'),
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                      Theme.of(context).primaryColor,
                    ),
                  ),
                )
              ],
            )
          : Center(
              child: Text('No data'),
            ),
    );
  }
}
