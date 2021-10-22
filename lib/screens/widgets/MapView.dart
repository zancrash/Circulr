import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends StatefulWidget {
  const MapView({Key? key}) : super(key: key);

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  static const _initialCameraPosition = CameraPosition(
    target: LatLng(43.6532, -79.3832),
    zoom: 8.0,
  );

  late GoogleMapController _googleMapController;

  @override
  void dispose() {
    _googleMapController.dispose();
    super.dispose();
  }

  // @override
  // void initState() {
  //   initialize();
  //   super.initState();
  // }

  // initialize() {
  //   Marker firstMarker = Marker
  // }

  final Set<Marker> markers = new Set();

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        //2432 Kingston Road Toronto ON M1N 1V3
        markerId: MarkerId('marker1'),
        position: LatLng(43.709210, -79.249710), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Green and Frugal - Scarborough ',
          snippet: '2432 Kingston Road Toronto ON M1N 1V3',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add second marker
        markerId: MarkerId('marker2'),
        position: LatLng(43.718610, -79.455700), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Green and Frugal - Dufferin ',
          snippet: '3220 Dufferin St Unit 18A North York ON M6A 2T3',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker3'),
        position: LatLng(43.734680, -79.285310), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Eco + Amour ',
          snippet: '30 Bertrand Ave Unit C9 Scarborough ON M1L 2P5',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker4'),
        position: LatLng(43.682260, -80.429340), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'The Elora Mercantile',
          snippet: '58 Geddes St Unit 1 Elora ON N0B 1S0',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker5'),
        position: LatLng(43.656000, -79.402350), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Green and Frugal - Kensington',
          snippet: '283 Augusta Ave Toronto ON M5T 2M1',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker6'),
        position: LatLng(43.87931, -78.94337), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Green and Frugal - Whitby',
          snippet: '100 Byron St S Unit 2 Whitby ON L1N 4P4',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker7'),
        position: LatLng(43.6585405, -79.4875431), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Canary and Fox',
          snippet: '778 Annette St, Toronto, ON',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker8'),
        position: LatLng(43.54683, -80.24999), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'The Flour Barrel',
          snippet: '115 Wyndham St N Guelph ON N1H 4E9',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker9'),
        position: LatLng(43.65022, -79.4357481), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Saponetti',
          snippet: '615c Brock Avenue Toronto ON M6H 3P1',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      markers.add(Marker(
        //add third marker
        markerId: MarkerId('marker10'),
        position: LatLng(43.54469, -80.25235), //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Stone Store Natural Foods',
          snippet: '14 commercial st Guelph ON N1H 2T7',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));

      //add more markers here
    });

    return markers;
  }

  // IN PROGRESS: Getting markers from firestore
  // Map<MarkerId, Marker> fbmarkers = <MarkerId, Marker>{};

  // populateClients() {
  //     FirebaseFirestore.instance
  //       .collection('locations').get()
  //       .then((docs) {
  //     if (docs.docs.isNotEmpty) {
  //       for (int i = 0; i < docs.docs.length; i++) {
  //         initMarker(docs.docs[i].data, docs.docs[i].id);
  //       }
  //     }
  //   });
  // }

  // void initMarker(request, requestId) {
  //   var markerIdVal = requestId;
  //   final MarkerId markerId = MarkerId(markerIdVal);
  //   final Marker marker = Marker(
  //       markerId: markerId,
  //       position: LatLng(
  //           request['location'].latitude, request['location'].longitude),
  //       infoWindow: InfoWindow(title: "Car:", snippet: request['Car'])
  //       );
  //   setState(() { //setState Adds Marker to Google Maps
  //     fbmarkers[markerId] = marker;
  //     // _child = MapView();
  //     print(markerId);
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        myLocationButtonEnabled: false,
        zoomControlsEnabled: false,
        initialCameraPosition: _initialCameraPosition,
        onMapCreated: (controller) => _googleMapController = controller,
        markers: getmarkers(), //markers to show on map
      ),
      floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 100.0),
          child: FloatingActionButton(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            onPressed: () => _googleMapController.animateCamera(
              CameraUpdate.newCameraPosition(_initialCameraPosition),
            ),
            child: const Icon(Icons.center_focus_strong),
          )),
    );
  }
}
