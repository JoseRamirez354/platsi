import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/User/bloc/bloc_user.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/User/ui/screens/profile_header.dart';
import '../widgets/profile_places_list.dart';
import '../widgets/profile_background.dart';

class ProfileTrips extends StatelessWidget {
  UserBloc userBloc;
  @override
  Widget build(BuildContext context) {
    userBloc = BlocProvider.of<UserBloc>(context);
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext contex, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.none:
              return CircularProgressIndicator();

            case ConnectionState.active:
              return showProfileData(snapshot);
            case ConnectionState.done:
              return showProfileData(snapshot);

            default:
          }
        });

    /*
    return Stack(
      children: <Widget>[
        ProfileBackground(),
        ListView(
          children: <Widget>[ProfileHeader(), ProfilePlacesList()],
        ),
      ],
    );*/
  }

  Widget showProfileData(AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.hasError) {
      print("no esta logueado");
      return Stack(
        children: [
          ListView(
            children: [Text("usuario no logueado")],
          )
        ],
      );
    } else {
      print("logueado");
      var user = User(
        uid: snapshot.data.uid,
        name: snapshot.data.displayName,
        email: snapshot.data.email,
        photo: snapshot.data.photoUrl,
      );
      return Stack(
        children: <Widget>[
          ProfileBackground(),
          ListView(
            children: <Widget>[ProfileHeader(user), ProfilePlacesList(user)],
          ),
        ],
      );
    }
  }
}
