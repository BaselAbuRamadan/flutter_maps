import 'package:dio/dio.dart';
import 'package:flutter_maps/data/models/placeSuggestation.dart';
import 'package:flutter_maps/data/webservices/placesWebServices.dart';

import '../../constants/strings.dart';

class MapsRepository {
  final PlacesWebServices placesWebServices;
  MapsRepository(this.placesWebServices);

  Future<List<PlaceSuggestion>> fetchSuggestion(
      String place, String sessionToken)async{
     final suggestions =
     await placesWebServices.fetchSuggestion(
         place, sessionToken
     );
     return suggestions.map((suggestions) =>
     PlaceSuggestion.fromJson(suggestions)).toList();
  }}