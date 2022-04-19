import 'package:cloud_firestore/cloud_firestore.dart';

class DevicesList {
  final String id;
  final String identifier;
  final String mensaje;

  DevicesList({
    required this.id,
    required this.identifier,
    required this.mensaje,
  });

  factory DevicesList.fromDocument(DocumentSnapshot documentSnapshot) {
    return DevicesList(
      id: documentSnapshot['id'],
      identifier: documentSnapshot['identifier'],
      mensaje: documentSnapshot['mensaje'],
    );
  }
}