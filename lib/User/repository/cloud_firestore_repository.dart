import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:platzy/Place/model/place.dart';
import 'package:platzy/Place/ui/widgets/card_image.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/User/repository/cloud_firestore_api.dart';
import 'package:platzy/User/ui/widgets/profile_place.dart';

class CloudFirestoreRepository {
  final _cloudFirestoreAPI = CloudFirestoreAPI();
  void updateUserDataFirestore(User user) =>
      _cloudFirestoreAPI.updateUserData(user);
  Future<void> updatePlaceData(Place place) =>
      _cloudFirestoreAPI.updatePlaceData(place);
  List<ProfilePlace> buildMyPlaces(List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreAPI.buildMyPlaces(placesListSnapshot);
  List<CardImageWithFabIcon> buildPlaces(
          List<DocumentSnapshot> placesListSnapshot) =>
      _cloudFirestoreAPI.buildPlaces(placesListSnapshot);
}
