import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_maps/buisness_logic/maps/maps_cubit.dart';
import 'package:flutter_maps/buisness_logic/phone_auth/phone_auth_cubit.dart';
import 'package:flutter_maps/constants/my_colors.dart';
import 'package:flutter_maps/constants/strings.dart';
import 'package:flutter_maps/data/models/placeSuggestation.dart';
import 'package:flutter_maps/helpers/location_helper.dart';
import 'package:flutter_maps/presentation/widgets/my_drawer.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:uuid/uuid.dart';

import '../widgets/place_item.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({Key? key}) : super(key: key);

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  initState(){
    super.initState();
    getMyCurrentLocation();
  }

  PhoneAuthCubit phoneAuthCubit = PhoneAuthCubit();
 List<PlaceSuggestion> places = [];

  FloatingSearchBarController controller = FloatingSearchBarController();
  static Position? position;
  Completer <GoogleMapController> _mapController = Completer();
  static final CameraPosition _myCurrentLocationCameraPosition = CameraPosition(
      target: LatLng(position!.latitude,position!.longitude),
    bearing: 0.0,
    tilt:0.0,
    zoom: 17
  );

  Future<void> getMyCurrentLocation() async {
    await LocationHelper.getCurrentLocation();

    position = await Geolocator.getLastKnownPosition()
    .whenComplete(() {
      setState(() {

      });
    });
  }

  Widget buildMap(){
    return GoogleMap(
      mapType: MapType.normal,
      myLocationEnabled: true,
      zoomControlsEnabled: false,
      myLocationButtonEnabled: false,
      initialCameraPosition: _myCurrentLocationCameraPosition,
      onMapCreated: (GoogleMapController controller){
        _mapController.complete(controller);
      },
    );
  }

Future<void> _goToMyCurrentLocation() async {
    final GoogleMapController controller =
    await _mapController.future;
    controller.animateCamera(CameraUpdate
        .newCameraPosition(_myCurrentLocationCameraPosition));
}
  Widget buildFloatingSearchBar() {
    final isPortrait = MediaQuery.of(context).orientation
        == Orientation.portrait;
    return FloatingSearchBar(
      controller: controller,
      elevation: 6,
        hintStyle: TextStyle(fontSize: 18),
      queryStyle: TextStyle(fontSize: 18),
      hint: 'Find a plce',
      border: BorderSide(
        style: BorderStyle.none
      ),
      margins: EdgeInsets.fromLTRB(20, 70, 20, 0),
      padding: EdgeInsets.fromLTRB(2,0,2,0),
      height: 52,
      iconColor: MyColors.blue,
      scrollPadding: const EdgeInsets.only(top: 16
          , bottom:56 ),
      transitionDuration: const Duration(milliseconds: 600),
      physics: const BouncingScrollPhysics(),
      axisAlignment: isPortrait? 0.0 : -1.0,
      openAxisAlignment: 0.0,
      width: isPortrait ? 600 : 500,
      debounceDelay: const Duration (milliseconds: 500),
      onQueryChanged: (query){
        getPlacesSuggestions(query);
        },
      onFocusChanged: (_){

    },
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction(
          showIfOpened: false,
          child: CircularButton(
            icon: const Icon(Icons.place,
              color: Colors.black,),
            onPressed: () {},
          ),
        ),
        // FloatingSearchBarAction.searchToClear(
        //   showIfClosed: false,
        // ),
      ],
      builder: (context,transition){
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              buildSuggestionsBloc(),
            ],
          ),
        );
      },

    );
  }

  void getPlacesSuggestions(String query){
    final sessionToken = Uuid().v4();
    BlocProvider.of<MapsCubit>(context)
        .emitPlaceSuggestion(query, sessionToken);
  }

  Widget buildSuggestionsBloc(){
    return BlocBuilder<MapsCubit,MapsState>(
      builder: (context,state){
        if (state is PlacesLoaded){
          places = (state).places;
          if(places.length != 0){
            return buildPlacesList();
          }else {
            return Container ();
          }

        } else {
          return Container();
        }
      },
    );
  }
  Widget buildPlacesList(){
    return ListView.builder(
     itemBuilder: (ctx,index){
    return InkWell(
      onTap: (){
        controller.close();
      },
      child: PlaceItem(
        suggestion: places[index],
      ),
    );
    },
      itemCount: places.length,
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),

    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: MyDrawer(),
      body: Stack(
        fit: StackFit.expand,
        children: [
          position != null ? buildMap() : Center(
            child: Container(
              child: CircularProgressIndicator(
                color: MyColors.blue,
              ),
            ),

          ),
          buildFloatingSearchBar(),
        ],
      ),
      floatingActionButton: Container(
        margin: EdgeInsets.fromLTRB(0, 0, 8, 3),
        child: FloatingActionButton(
          backgroundColor: MyColors.blue,
          onPressed: _goToMyCurrentLocation,
          child: Icon(Icons.place , color: Colors.white,),
        ),
      ),

    );
  }
}
