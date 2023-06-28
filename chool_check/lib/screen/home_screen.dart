import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  GoogleMapController? mapController;

  bool cholCheckDone = false;
  // latitude - 위도 / logitude - 경도
  static final LatLng companyLatLng = LatLng(
    37.5233273,
    126.921252,
  );
  static final CameraPosition initialPosition = CameraPosition(
    target: companyLatLng,
    zoom: 15,
  );
  static final double okDistance = 100;
  static final Circle withinDistnaceCircle = Circle(
    circleId: CircleId('withinDistnaceCircle'),
    center: companyLatLng,
    fillColor: Colors.blue.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.blue,
    strokeWidth: 1,
  );
  static final Circle notWithinDistnaceCircle = Circle(
    circleId: CircleId('notWithinDistnaceCircle'),
    center: companyLatLng,
    fillColor: Colors.red.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.red,
    strokeWidth: 1,
  );
  static final Circle checkDoneCircle = Circle(
    circleId: CircleId('checkDoneCircle'),
    center: companyLatLng,
    fillColor: Colors.green.withOpacity(0.5),
    radius: okDistance,
    strokeColor: Colors.green,
    strokeWidth: 1,
  );
  static final Marker marker =
      Marker(markerId: MarkerId('marker'), position: companyLatLng);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: randerAppbar(),
      body: FutureBuilder(
        future: checkPermission(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.data.toString() == '위치 권한이 허가 되었습니다') {
            return StreamBuilder<Position>(
                stream: Geolocator.getPositionStream(),
                builder: (context, snapshot) {
                  bool isWithinRange = false;
                  if (snapshot.hasData) {
                    final start = snapshot.data!; // 현재 위치
                    final end = companyLatLng; // 회사의 위치
                    final distanc = Geolocator.distanceBetween(
                      start.latitude,
                      start.longitude,
                      end.latitude,
                      end.longitude,
                    );
                    if (distanc < okDistance) {
                      isWithinRange = true;
                    }
                  }
                  return Column(
                    children: [
                      _CustomGoogleMap(
                        initialPosition: initialPosition,
                        circle: cholCheckDone
                            ? checkDoneCircle
                            : isWithinRange
                                ? withinDistnaceCircle
                                : notWithinDistnaceCircle,
                        marker: marker,
                        onMapCreated: onMapCreated,
                      ),
                      _ChoolCheckButton(
                        isWithinRange: isWithinRange,
                        cholCheckDone: cholCheckDone,
                        onPressed: onCholCheckPressed,
                      ),
                    ],
                  );
                });
          }

          return Center(
            child: Text(
              snapshot.data.toString(),
            ),
          );
        },
      ),
    );
  }

  void onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  void onCholCheckPressed() async {
    final result = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('출근하기'),
          content: Text('출근을 하시겠습니까?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('취소'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('출근하기'),
            )
          ],
        );
      },
    );
    if (result) {
      setState(() {
        cholCheckDone = true;
      });
    }
  }

  Future<String> checkPermission() async {
    final inLocationEnable = await Geolocator.isLocationServiceEnabled();
    if (!inLocationEnable) {
      return '위치 서비스를 활성화 해주세요.';
    }

    LocationPermission checkedPermission = await Geolocator.checkPermission();
    if (checkedPermission == LocationPermission.denied) {
      checkedPermission = await Geolocator.requestPermission();
      if (checkedPermission == LocationPermission.denied) {
        return '위치 권한을 허가해 해주세요.';
      }
    }
    if (checkedPermission == LocationPermission.deniedForever) {
      return '앱의 위치권한을 세팅에서 허가해 주세요';
    }

    return '위치 권한이 허가 되었습니다';
  }

  AppBar randerAppbar() {
    return AppBar(
      centerTitle: true,
      title: Text(
        '오늘도 출근',
        style: TextStyle(
          color: Colors.blue,
          fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.white,
      actions: [
        IconButton(
          color: Colors.blue,
          onPressed: () async {
            if (mapController == null) {
              return;
            }
            final location = await Geolocator.getCurrentPosition();
            mapController!.animateCamera(
              CameraUpdate.newLatLng(
                LatLng(location.latitude, location.longitude),
              ),
            );
          },
          icon: Icon(
            Icons.my_location,
          ),
        )
      ],
    );
  }
}

class _CustomGoogleMap extends StatelessWidget {
  final CameraPosition initialPosition;
  final MapCreatedCallback onMapCreated;
  final Circle circle;
  final Marker marker;
  const _CustomGoogleMap(
      {required this.initialPosition,
      required this.circle,
      required this.marker,
      required this.onMapCreated,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 2,
      child: GoogleMap(
        mapType: MapType.normal,
        initialCameraPosition: initialPosition,
        myLocationEnabled: true,
        myLocationButtonEnabled: false,
        circles: Set.from([circle]),
        markers: Set.from([marker]),
        onMapCreated: onMapCreated,
      ),
    );
  }
}

class _ChoolCheckButton extends StatelessWidget {
  final bool cholCheckDone;
  final bool isWithinRange;
  final VoidCallback onPressed;
  const _ChoolCheckButton(
      {required this.isWithinRange,
      required this.onPressed,
      required this.cholCheckDone,
      Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.timelapse_outlined,
            size: 50.0,
            color: cholCheckDone
                ? Colors.green
                : isWithinRange
                    ? Colors.blue
                    : Colors.red,
          ),
          SizedBox(
            height: 20.0,
          ),
          if (!cholCheckDone && isWithinRange)
            TextButton(
              onPressed: onPressed,
              child: Text('출근하기'),
            )
        ],
      ),
    );
  }
}
