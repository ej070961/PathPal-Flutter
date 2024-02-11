import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:pathpal/colors.dart';
import 'package:pathpal/models/place.dart';
import 'package:pathpal/screens/dp/select_place.dart';
import 'package:pathpal/service/map_service.dart';
import 'package:pathpal/models/car_state.dart';
import 'package:pathpal/utils/app_images.dart';
import 'package:pathpal/widgets/build_image.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  bool isDepartureSelected = false; // 출발지가 선택되었는지를 추적하는 변수
  bool isDestinationSelected = false; // 목적지가 선택되었는지를 추적하는 변수

  final  _departureController = TextEditingController(text: CarServiceState().departureAddress);
  final _destinationController = TextEditingController(text: CarServiceState().destinationAddress);
  final MapService mapService = MapService();
   List<Place> searchResults = [];

  @override
  void initState() {
    super.initState();
    _departureController.addListener(() { });
    _destinationController.addListener(() { });
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
    if (isDepartureSelected) {
      print("출발지 선택 화면 이동 ");
      setState(() {
        _departureController.text = place.formattedAddress;
      });
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Container(
                child: SelectPlace(item: place, label: '출발지', category: 'car')
          )
          )
      );
    }else if (isDestinationSelected){
      print("목적지 선택 화면 이동 ");
      setState(() {
        _destinationController.text = place.formattedAddress;
      });
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => Container(
              child: SelectPlace(item: place, label: '목적지', category: 'car')
          )
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
       backgroundColor: Colors.white,
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(kToolbarHeight), // 기본 AppBar 높이
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: gray200,
                  width: 0.5,
                ),
              ),
            ),
            child: AppBar(
              leading: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(Icons.arrow_back),
              ),
              centerTitle: true,
              title: Text(
                '차량서비스',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
          ),
        ),
        body: Column(
        children: [
          SizedBox(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                      BuildImage.buildImage(AppImages.circleIconImagePath),
                      SizedBox(width: 10),
                      Expanded(
                        // 수정: InputDecorator를 Expanded로 감싸서 폭을 제한
                        child: TextField(
                          controller: _departureController,
                          decoration: InputDecoration(hintText: '출발지'),
                           onEditingComplete: () {
                            FocusScope.of(context).unfocus(); // 키보드를 닫습니다.
                            setState(() {
                              isDepartureSelected = true;
                              isDestinationSelected = false;
                            });
                            searchPlace(_departureController.text);
                          },
                        ),
                      ),
                     IconButton(
                        onPressed: () {
                          FocusScope.of(context).unfocus(); // 키보드를 닫습니다.
                          setState(() {
                            isDepartureSelected = true;
                            isDestinationSelected = false;
                          });
                          searchPlace(_departureController.text);
                        },
                        icon: Icon(
                          Icons.search,
                          color: gray400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(width: 10),
                        BuildImage.buildImage(AppImages.redCircleIconImagePath),
                      SizedBox(width: 10),
                      Expanded(
                        // 수정: InputDecorator를 Expanded로 감싸서 폭을 제한
                        child: TextField(
                          controller: _destinationController,
                          decoration: InputDecoration(hintText: '목적지'),
                          onEditingComplete: () {
                            FocusScope.of(context).unfocus(); // 키보드를 닫습니다.
                            setState(() {
                              isDepartureSelected = false;
                              isDestinationSelected = true;
                            });
                            searchPlace(_destinationController.text);
                          },
                          
                        ),
                      ),
                      IconButton(
                        onPressed: () {
                           FocusScope.of(context).unfocus(); // 키보드를 닫습니다.
                           setState(() {
                            isDepartureSelected = false;
                            isDestinationSelected = true;
                          });
                          searchPlace(_destinationController.text);
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
          Container(color: background, height: 10,),
          Expanded(
           child: ListView.builder(
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
          )
        ],
      ),
          
      );
  }
}