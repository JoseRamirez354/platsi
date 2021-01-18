import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/Place/model/place.dart';
import 'package:platzy/Place/ui/widgets/card_image.dart';
import 'package:platzy/Place/ui/widgets/title_input_location.dart';
import 'package:platzy/User/bloc/bloc_user.dart';
import 'package:platzy/widgets/button_purple.dart';
import 'package:platzy/widgets/gradient_back.dart';
import 'package:platzy/widgets/text_input.dart';
import 'package:platzy/widgets/title_header.dart';

class AddPlaceScreen extends StatefulWidget {
  File image;
  AddPlaceScreen({Key key, this.image});
  @override
  State<StatefulWidget> createState() {
    return _AddPlaceScreen();
    // TODO: implement createState
    throw UnimplementedError();
  }
}

class _AddPlaceScreen extends State<AddPlaceScreen> {
  @override
  Widget build(BuildContext context) {
    UserBloc userBloc = BlocProvider.of<UserBloc>(context);
    final _controllerTitlePlace = TextEditingController();
    final _controllerDescriptionPlace = TextEditingController();
    final _controllerLocationsPlace = TextEditingController();
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GradientBack(
            heigth: 300,
          ),
          Row(
            children: [
              Container(
                padding: EdgeInsets.only(top: 25.0, left: 5.0),
                child: SizedBox(
                  width: 45.0,
                  height: 45.0,
                  child: IconButton(
                      icon: Icon(
                        Icons.keyboard_arrow_left,
                        color: Colors.white,
                        size: 45.0,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      }),
                ),
              ),
              Flexible(
                child: Container(
                  padding: EdgeInsets.only(top: 45.0, left: 20.0, right: 10.0),
                  child: TitleHeader(
                    title: "Agregar un lugar",
                  ),
                ),
              )
            ],
          ),
          Container(
            margin: EdgeInsets.only(top: 120.0, bottom: 20.0),
            child: ListView(
              children: [
                Container(
                  alignment: Alignment.center,
                  child: CardImageWithFabIcon(
                    pathImage: widget.image.path,
                    iconData: Icons.camera_alt,
                    width: 300.0,
                    height: 250.0,
                    left: 0,
                  ),
                ), //foto
                Container(
                  margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                  child: TextInput(
                    hintText: "Titulo",
                    inputType: null,
                    maxLines: 1,
                    controller: _controllerTitlePlace,
                  ),
                ),
                TextInput(
                    hintText: "Descripción",
                    inputType: TextInputType.multiline,
                    maxLines: 4,
                    controller: _controllerDescriptionPlace),
                Container(
                  margin: EdgeInsets.only(top: 20.0),
                  child: TextInputLocation(
                    hintText: "Agregue localización",
                    iconData: Icons.location_on,
                    controller: _controllerLocationsPlace,
                  ),
                ),
                Container(
                  width: 70.0,
                  child: ButtonPurple(
                      buttonText: "Add Lugar",
                      onPressed: () {
                        userBloc.currentUser.then((FirebaseUser user) {
                          if (user != null) {
                            String uid = user.uid;
                            String path =
                                "${uid}/${DateTime.now().toString()}.jpg";

                            userBloc
                                .uploadFile(path, widget.image)
                                .then((StorageUploadTask storageUploadTask) {
                              storageUploadTask.onComplete
                                  .then((StorageTaskSnapshot snapshot) {
                                snapshot.ref.getDownloadURL().then((urlImage) {
                                  print("URLImagen: ${urlImage}");

                                  userBloc
                                      .updatePlaceData(Place(
                                          name: _controllerTitlePlace.text,
                                          description:
                                              _controllerDescriptionPlace.text,
                                          likes: 0,
                                          urlImage: urlImage))
                                      .whenComplete(() {
                                    print("termino");
                                    Navigator.pop(context);
                                  });
                                });
                              });
                            });
                          }
                        });
                      }),
                )
              ],
            ),
          ),
        ],
      ),
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}
