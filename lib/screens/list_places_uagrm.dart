import 'package:flutter/material.dart';

import '../models/place.dart';
import '../services/places_services.dart';

class ListPlacesUagrm extends StatefulWidget {
  ListPlacesUagrm({Key? key}) : super(key: key);

  @override
  State<ListPlacesUagrm> createState() => _ListPlacesUagrmState();
}

class _ListPlacesUagrmState extends State<ListPlacesUagrm> {
  FetchPlaces _placesList = FetchPlaces();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text('Lugares de la UAGRM'),
          actions: [
            IconButton(
              onPressed: () {
                //showSearch(context: context, delegate: SearchPlaces());
              },
              icon: Icon(Icons.search_sharp),
            )
          ],
        ),
        body: Container(
          padding: const EdgeInsets.all(20),
          child: FutureBuilder<List<PlaceList>>(
              future: _placesList.getPlacesList(),
              builder: (context, snapshot) {
                var data = snapshot.data;
                return ListView.builder(
                    itemCount: data?.length,
                    itemBuilder: (context, index) {
                      if (!snapshot.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      return Card(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Row(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.deepPurpleAccent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '${data?[index].idDatosUagrm}',
                                      style: TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                ),
                                SizedBox(width: 20),
                                Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${data?[index].descripcion}',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        '${data?[index].aula}',
                                        style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ])
                              ],
                            ),
                            // trailing: Text('More Info'),
                          ),
                        ),
                      );
                    });
              }),
        ),
      ),
    );
  }
}
