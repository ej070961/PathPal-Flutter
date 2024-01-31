import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/place.dart';
import 'package:pathpal/screens/dp/select_place.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/models/car_state.dart';

class WalkSearch extends StatefulWidget {
  const WalkSearch({super.key});

  @override
  State<WalkSearch> createState() => _WalkSearchState();
}

class _WalkSearchState extends State<WalkSearch> {

  late TextEditingController departureController;
  final MapService mapService = MapService();

  List<Place> searchResults = [];

  @override
  void initState() {
    super.initState();
    departureController =
        TextEditingController(text: CarServiceState().departureAddress);
  }

  // Parse the JSON response and return a list of places
  List<Map<String, dynamic>> parseResponse(String responseBody) {
    try {
      final Map<String, dynamic> jsonData = json.decode(responseBody);

      // Assuming the places are stored in a 'places' key in the JSON response
      final List<dynamic> placesData = jsonData['places'];

      // Map each place data to a Map<String, dynamic>
      return placesData.map((place) => place as Map<String, dynamic>).toList();
    } catch (e) {
      print('Error parsing JSON response: $e');
      return [];
    }
  }

  void searchPlace(placeText) async {
    String responseBody = await mapService.getPlace(placeText);
    print(responseBody);
    // Parse the response and extract the relevant information
    List<Map<String, dynamic>> places = parseResponse(responseBody);

    // Create a list of Place objects
    searchResults = places
        .map((place) => Place(
              formattedAddress: place['formattedAddress'],
              displayName: place['displayName']['text'],
              latitude: place['location']['latitude'],
              longitude: place['location']['longitude'],
              // postalCode: place['addressComponents'].firstWhere(
              //     (component) => component['types'].contains('postal_code'),
              //     orElse: () => null)?['shortText'],
            ))
        .toList();
    print(searchResults);

    // Update the UI
    setState(() {});
  }

  void _goToSelectPlace(place) {
    print("출발지 선택 화면 이동 ");
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                Container(child: SelectPlace(item: place, label: '출발지', category: 'walk',))));

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.arrow_back)),
          centerTitle: true,
          title: Text(
            '도보서비스',
            style: Theme.of(context).textTheme.titleLarge,
          ),
        ),
        body: Column(
          children: [
            SizedBox(
              child: Padding(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset('assets/images/circle-icon.png'),
                        SizedBox(width: 10),
                        Expanded(
                          // 수정: InputDecorator를 Expanded로 감싸서 폭을 제한
                          child: TextField(
                            controller: departureController,
                            decoration: InputDecoration(hintText: '출발지'),
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            searchPlace(departureController.text);
                          },
                          icon: Icon(
                            Icons.search,
                            color: gray400,
                          ),
                        ),
                      ],
                    ),                    
                    SizedBox(height: 5),
                  ],
                ),
              ),
            ),
            Container(
              color: background,
              height: 10,
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              itemCount: searchResults.length,
              itemBuilder: (BuildContext context, int index) {
                // 현재 인덱스에 해당하는 Place 객체 가져오기
                Place place = searchResults[index];

                return Column(
                  children: [
                    ListTile(
                      title: Text(place.displayName),
                      subtitle: Text(place.formattedAddress),
                      onTap: () {
                        _goToSelectPlace(place);
                      },
                    ),
                    Divider(
                      color: gray200,
                      thickness: 1,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      );
  }
}