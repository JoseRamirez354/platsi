import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:platzy/Place/model/place.dart';
import 'package:platzy/Place/ui/widgets/card_image.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/User/ui/widgets/profile_place.dart';

class CloudFirestoreAPI {
  final String USERS = "users";
  final String PLACES = "places";

  final Firestore _db = Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  void updateUserData(User user) async {
    DocumentReference ref = _db.collection(USERS).document(user.uid);
    return ref.setData({
      'uid': user.uid,
      'name': user.name,
      'email': user.email,
      'photo': user.photo,
      'myPlaces': user.myPlaces,
      'myFavoritePlaces': user.myFavoritePlaces
    }, merge: true);
  }

  Future<void> updatePlaceData(Place place) async {
    CollectionReference refPlaces = _db.collection(PLACES);
    await _auth.currentUser().then((FirebaseUser user) {
      refPlaces.add({
        'name': place.name,
        'description': place.description,
        'likes': place.likes,
        'urlImage': place.urlImage,
        'userOwner': _db.document("${USERS}/${user.uid}"),
      }).then((DocumentReference dr) {
        dr.get().then((DocumentSnapshot snapshot) {
          DocumentReference refUsers = _db.collection(USERS).document(user.uid);
          refUsers.updateData({
            'myPlaces': FieldValue.arrayUnion(
                [_db.document("${PLACES}/${snapshot.documentID}")])
          });
        });
      });
    });
  }

  //se procesan los datos de la lista
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) {
    List<ProfilePlace> profilePlaces = List<ProfilePlace>();
    placesListSnapshot.forEach((p) {
      profilePlaces.add(ProfilePlace(Place(
          name: p.data['name'],
          description: p.data['description'],
          urlImage: p.data['urlImage'] ?? null,
          likes: p.data['likes'])));
    });
    return profilePlaces;
  }

  List<CardImageWithFabIcon> buildPlaces(
      List<DocumentSnapshot> placesListSnapshot) {
    List<CardImageWithFabIcon> placesCard = List<CardImageWithFabIcon>();
    double width = 300.0;
    double height = 250.0;
    double left = 20.0;
    IconData iconData = Icons.favorite_border;
    placesListSnapshot.forEach((p) {
      placesCard.add(CardImageWithFabIcon(
          pathImage: p.data['urlImage'],
          width: width,
          height: height,
          onPressedFabIcon: () {
            likePlace(p.documentID);
          },
          iconData: iconData,
          left: left));
    });
    return placesCard;
  }

  Future likePlace(String idPlace) async {
    await _db
        .collection(PLACES)
        .document(idPlace)
        .get()
        .then((DocumentSnapshot ds) {
      int likes = ds.data["likes"];
      _db.collection(PLACES).document(idPlace).updateData({'likes': likes + 1});
    });
  }
}
