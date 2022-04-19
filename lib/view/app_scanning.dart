import 'package:asistentevisualapp/controller/requirement_state_controller.dart';
import 'package:asistentevisualapp/repositories/devices_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_beacon/flutter_beacon.dart';
import 'package:get/get.dart';

class TabScanning extends StatefulWidget {
  @override
  _TabScanningState createState() => _TabScanningState();
}

class _TabScanningState extends State<TabScanning> {
  StreamSubscription<RangingResult>? _streamRanging;
  final _regionBeacons = <Region, List<Beacon>>{};
  final _beacons = <Beacon>[];
  final controller = Get.find<RequirementStateController>();
  late String id;
  late String identifier;
  late String mensaje;
  late Stream dataList;
  String sitioMasCercano = 'Sin Resultados';
  List<Map<String, dynamic>> listaDynDispositivos = [];

  @override
  void initState() {
    super.initState();
    getAllDevices();
    controller.startStream.listen((flag) {
      if (flag == true) {
        initScanBeacon();
      }
    });

    controller.pauseStream.listen((flag) {
      if (flag == true) {
        pauseScanBeacon();
      }
    });
  }

  getAllDevices() async {
    await FirebaseFirestore.instance.collection("dispositivos").get().then((
        querySnapshot) async {
      querySnapshot.docs.forEach((result) async {
        await FirebaseFirestore.instance
            .collection("dispositivos")
            .get()
            .then((querySnapshot) {
          querySnapshot.docs.forEach((result) {
            DevicesList devicesList = DevicesList.fromDocument(result);
            final allData = querySnapshot.docs.map((doc) => doc.data()).toList();
            print("--------------------- Books ---------------------\n"

                "id: ${devicesList.id}\n"
                "identificador: ${devicesList.identifier}\n"
                "mensaje: ${devicesList.mensaje}");
            print(allData);

            setState(() {
              listaDynDispositivos = allData;
              id = devicesList.id;
              identifier = devicesList.identifier;
              mensaje = devicesList.mensaje;
            });

          });
        });
      });
    });
  }

  initScanBeacon() async {
    await flutterBeacon.initializeScanning;
    if (!controller.authorizationStatusOk ||
        !controller.locationServiceEnabled ||
        !controller.bluetoothEnabled) {
      print(
          'RETURNED, authorizationStatusOk=${controller.authorizationStatusOk}, '
          'locationServiceEnabled=${controller.locationServiceEnabled}, '
          'bluetoothEnabled=${controller.bluetoothEnabled}');
      return;
    }
    final regions = <Region>[
      Region(
        identifier: 'Cubeacon',
        //proximityUUID: listaDynDispositivos[0]['id'],
        proximityUUID: listaDynDispositivos[0]['id'].toString(),
      ),
      Region(
        identifier: 'Cubeacon2',
        proximityUUID: listaDynDispositivos[1]['id'].toString(),
      ),

      Region(
        identifier: 'Cubeacon3',
        proximityUUID: listaDynDispositivos[2]['id'].toString(),
      ),
    ];

    if (_streamRanging != null) {
      if (_streamRanging!.isPaused) {
        _streamRanging?.resume();
        return;
      }
    }

    _streamRanging =
        flutterBeacon.ranging(regions).listen((RangingResult result) {
      print(result);
      if (mounted) {
        setState(() {
          _regionBeacons[result.region] = result.beacons;
          _beacons.clear();
          _regionBeacons.values.forEach((list) {
            _beacons.addAll(list);
          });
          _beacons.sort(_compareParameters);
        });
      }
    });
  }

  pauseScanBeacon() async {
    _streamRanging?.pause();
    if (_beacons.isNotEmpty) {
      setState(() {
        _beacons.clear();
      });
    }
  }

  int _compareParameters(Beacon a, Beacon b) {
    int compare = a.proximityUUID.compareTo(b.proximityUUID);

    if (compare == 0) {
      compare = a.major.compareTo(b.major);
    }

    if (compare == 0) {
      compare = a.minor.compareTo(b.minor);
    }

    return compare;
  }

  @override
  void dispose() {
    _streamRanging?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff0f131e),
      body: ListView.builder(
          itemCount: listaDynDispositivos.length,
          itemBuilder:(context,i) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Card(
                color: Color(0xff252f49),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                child: ListTile(
                  leading: const Icon(Icons.maps_ugc),
                  title: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(listaDynDispositivos[i]['mensaje'].toString()),
                  ),
                ),
              ),
            );
          }
      ),

      /*
      _beacons.isEmpty
          ? const Center(child: Card(
              child: Text('Refrescando...'),
      ))
          : ListView(
              children: ListTile.divideTiles(
                context: context,
                tiles: _beacons.map(
                  (beacon) {
                    return ListTile(
                      title: Text(
                        beacon.proximity.toString(),
                        style: TextStyle(fontSize: 15.0),
                      ),
                      subtitle: new Row(
                        mainAxisSize: MainAxisSize.max,
                        children: <Widget>[
                          Flexible(
                            child: Text(
                              'Major: ${beacon.major}\nMinor: ${beacon.minor}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 1,
                            fit: FlexFit.tight,
                          ),
                          Flexible(
                            child: Text(
                              'Accuracy: ${beacon.accuracy}m\nRSSI: ${beacon.rssi}',
                              style: TextStyle(fontSize: 13.0),
                            ),
                            flex: 2,
                            fit: FlexFit.tight,
                          )
                        ],
                      ),
                    );
                  },
                ),
              ).toList(),
            ),
      */

    );
  }
}
