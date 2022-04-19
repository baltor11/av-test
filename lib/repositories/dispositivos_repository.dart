import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';



class DispositivosRepository {
  final _firebaseFirestore;


  DispositivosRepository({
    FirebaseFirestore? firebaseFirestore,
  }) : _firebaseFirestore = firebaseFirestore ?? FirebaseFirestore.instance;


  @override
  Stream<QuerySnapshot> getAllDevices() {
    return _firebaseFirestore
        .collection('dispositivos')
        .snapshots();

  }

}