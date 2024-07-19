import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:tadbiro/utils/exports/navigation.dart';
import 'package:tadbiro/utils/extensions/sizedbox_extension.dart';

import '../../../../data/models/event.dart';
import '../../../../data/models/user.dart';

class EventDetailsScreen extends StatefulWidget {
  const EventDetailsScreen({super.key});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  late GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  Set<Marker> markers = {};

  @override
  Widget build(BuildContext context) {
    final arguments =
        ModalRoute.of(context)!.settings.arguments as List<dynamic>;
    final Event event = arguments[0];
    final User user = arguments[1];
    markers.add(Marker(
      markerId: MarkerId(UniqueKey().toString()),
      icon: BitmapDescriptor.defaultMarkerWithHue(
        BitmapDescriptor.hueBlue,
      ),
      position: LatLng(event.longitude, event.longitude),
    ));
    return Scaffold(
      //appBar: AppBar(title: Text(event.title)),
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: 300,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            clipBehavior: Clip.hardEdge,
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: event.bannerImageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.left_chevron),
                    ),
                  ),
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.favorite_border_rounded,
                        color: Colors.redAccent,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(18.0),
            child: Text(
              event.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.calendar_month_rounded),
            title: Text(DateFormat('d MMMM yyyy').format(event.date)),
            subtitle: Text(DateFormat('EEEE HH:mm').format(event.date)),
          ),
          ListTile(
            leading: const Icon(Icons.place_outlined),
            title: Text(event.placeInfo.split('. ')[0]),
            subtitle: Text(event.placeInfo.split('. ')[2]),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
              "Tadbir haqida",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18.0),
            child: Text(
              event.description,
              style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w400),
            ),
          ),
          6.height,
          const Padding(
            padding: EdgeInsets.only(left: 18.0),
            child: Text(
              "Manzil",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
          ),
          Container(
            height: 400,
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            clipBehavior: Clip.hardEdge,
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              initialCameraPosition: CameraPosition(
                target: LatLng(event.latitude, event.longitude),
                zoom: 15,
              ),
              markers: markers,
            ),
          ),
          Visibility(
            visible: event.organizerId != user.id,
            child: Padding(
              padding: const EdgeInsets.all(18.0),
              child: FilledButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Expanded(
                            child: Center(
                              child: Text("PAYMENT PROCESS"),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(18.0),
                            child: FilledButton(
                              onPressed: () {
                                navigationService.goBack();
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) {
                                    return Column(
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        const Expanded(
                                          child: Center(
                                            child: Text("CONGRATULATIONS"),
                                          ),
                                        ),
                                        FilledButton(
                                          onPressed: () {},
                                          child: const Text("Eslatma Belgilash"),
                                        ),
                                        FilledButton(
                                          onPressed: () {
                                            navigationService.goBack();
                                            navigationService.goBack();
                                          },
                                          child: const Text("Bosh Sahifa"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              child: const Text("Keyingi"),
                            ),
                          )
                        ],
                      );
                    },
                  );
                },
                child: const Text("Ro'yxatdan o'tish"),
              ),
            ),
          ),
          20.height
        ],
      ),
    );
  }
}
