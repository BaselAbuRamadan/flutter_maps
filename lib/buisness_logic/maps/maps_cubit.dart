import 'package:bloc/bloc.dart';
import 'package:flutter_maps/data/models/placeSuggestation.dart';
import 'package:flutter_maps/data/repository/map_repo.dart';
import 'package:meta/meta.dart';

part 'maps_state.dart';

class MapsCubit extends Cubit<MapsState> {
  final MapsRepository mapsRepository;

  MapsCubit(this.mapsRepository) : super(MapsInitial());
  void emitPlaceSuggestion (String place, String sessionToken){
    mapsRepository.fetchSuggestion
      (place, sessionToken).then(
            (suggestions) {
              emit(PlacesLoaded(suggestions));
            });
  }
}
