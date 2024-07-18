import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../utils/exports/navigation.dart';

class PlacePickerMap extends StatefulWidget {
  const PlacePickerMap({super.key, required this.getPlaceInfo});

  final Function(String info, double lat, double long) getPlaceInfo;

  @override
  State<PlacePickerMap> createState() => _PlacePickerMapState();
}

class _PlacePickerMapState extends State<PlacePickerMap> {
  /// MAP CONFIGURATIONS
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> myMarkers = {};

  void addLocationMarker(double lat, double long) {
    myMarkers.add(
      Marker(
        markerId: MarkerId(UniqueKey().toString()),
        position: LatLng(lat, long),
        icon: BitmapDescriptor.defaultMarker,
      ),
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 60,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
      ),
      clipBehavior: Clip.hardEdge,
      child: GoogleMap(
        onMapCreated: _onMapCreated,
        initialCameraPosition: const CameraPosition(
          target: LatLng(41.3187367, 69.2517909),
          zoom: 12,
        ),
        markers: {...myMarkers},
        onTap: (argument) async {
          var placeMarks = await placemarkFromCoordinates(
              argument.latitude, argument.longitude);
          if (myMarkers.length < 2) {
            addLocationMarker(argument.latitude, argument.longitude);
            widget.getPlaceInfo(
              "Street: ${placeMarks[0].street}. "
              "Sublocality: ${placeMarks[0].subLocality}. "
              "Locality: ${placeMarks[0].locality}. "
              "Administrative area: ${placeMarks[0].administrativeArea}. "
              "Country: ${placeMarks[0].country}. "
              "ISO code: ${placeMarks[0].isoCountryCode}.",
              argument.latitude,
              argument.longitude,
            );
            Future.delayed(
              const Duration(seconds: 1),
              () => navigationService.goBack(),
            );
          }
        },
      ),
    );
  }
}
