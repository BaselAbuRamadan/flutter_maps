import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_maps/constants/strings.dart';
class PlacesWebServices {
  late Dio dio;

  PlacesWebServices() {
    BaseOptions options = BaseOptions(
      connectTimeout: 20 * 1000,
      receiveTimeout: 20 * 1000,
      receiveDataWhenStatusError: true,
    );
    dio = Dio(options);
  }

Future<List<dynamic>> fetchSuggestion(
String place, String sessionToken)async{
  try{
    Response response = await dio.get(suggestionBaseUrl,queryParameters: {
      'input':place,
      'types':'address',
      'components': 'country:ps',
      'key' : googleAPIKey,
      sessionToken : sessionToken,
          });
    print(response.data['predictions']);
    print(response.statusCode);
    return response.data['predictions'];
  }catch(error){
      print(error.toString());
      return[];
  }

}}