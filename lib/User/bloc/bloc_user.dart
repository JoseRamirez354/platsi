import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/Place/model/place.dart';
import 'package:platzy/Place/repository/firebase_storage_repository.dart';
import 'package:platzy/Place/ui/widgets/card_image.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/User/repository/auth_repository.dart';
import 'package:platzy/User/repository/cloud_firestore_api.dart';
import 'package:platzy/User/repository/cloud_firestore_repository.dart';
import 'package:platzy/User/repository/firebase_storage_api.dart';
import 'package:platzy/User/ui/widgets/profile_place.dart';
import '';

class UserBloc implements Bloc {
  final _auth_repository = AuthRepository();
  //flujo de datos -Streams
  // Stream -Firebase tiene su propios metodos
  //caso contrario se manejan con StreamController
  Stream<FirebaseUser> streamFirebase =
      FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => streamFirebase;
  Future<FirebaseUser> get currentUser => FirebaseAuth.instance.currentUser();

  // casos de usos de la aplicacion :
  // 1 signIn con google

  Future<FirebaseUser> signIn() => _auth_repository.signInFirebase();

  //2 Registrar usuario
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreRepository.updatePlaceData(place);

  Stream<QuerySnapshot> placesListStream =
      Firestore.instance.collection(CloudFirestoreAPI().PLACES).snapshots();
  Stream<QuerySnapshot> get placesStream => placesListStream;
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildMyPlaces(placesListSnapshot);

  List<CardImageWithFabIcon> buildPlaces(
          List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreRepository.buildPlaces(placesListSnapshot);

  Stream<QuerySnapshot> myPlacesListStream(String uid) => Firestore.instance
      .collection(CloudFirestoreAPI().PLACES)
      .where("userOwner",
          isEqualTo: Firestore.instance
              .document("${CloudFirestoreAPI().USERS}/${uid}"))
      .snapshots();

  final _firebaseStorageRepository = FirebaseStorageRepository();
  Future<StorageUploadTask> uploadFile(String path, File image) =>
      _firebaseStorageRepository.uploadFile(path, image);

  //

  signOut() {
    _auth_repository.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
