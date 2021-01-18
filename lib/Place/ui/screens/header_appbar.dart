import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/User/bloc/bloc_user.dart';
import 'package:platzy/User/model/user.dart';
import '../../../widgets/gradient_back.dart';
import '../widgets/card_image_list.dart';

class HeaderAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    UserBloc userBloc;
    userBloc = BlocProvider.of(context);
    return StreamBuilder(
        stream: userBloc.authStatus,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return CircularProgressIndicator();
            case ConnectionState.none:
              return CircularProgressIndicator();
            case ConnectionState.active:
              return showPlacesData(snapshot);
            case ConnectionState.done:
              return showPlacesData(snapshot);

            default:
          }
        });
  }

  Widget showPlacesData(AsyncSnapshot snapshot) {
    if (!snapshot.hasData || snapshot.hasError) {
      return Stack(
        children: [
          GradientBack(
            heigth: 250.0,
          ),
          Text("Usuario no logueado")
        ],
      );
    } else {
      User user = User(
          uid: snapshot.data.uid,
          name: snapshot.data.displayName,
          email: snapshot.data.email,
          photo: snapshot.data.photoUrl);
      return Stack(
        children: [GradientBack(heigth: 250.0), CardImageList()],
      );
    }
  }
}
