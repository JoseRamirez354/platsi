import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/Place/ui/widgets/card_image_list.dart';
import 'package:platzy/User/bloc/bloc_user.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/platzi_trips_cupertino.dart';
import 'package:platzy/widgets/button_green.dart';
import 'package:platzy/widgets/gradient_back.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SignInScreen();
  }
}

class _SignInScreen extends State<SignInScreen> {
  UserBloc userBloc;
  double screenWhiht;

  @override
  Widget build(BuildContext context) {
    screenWhiht = MediaQuery.of(context).size.width;
    userBloc = BlocProvider.of(context);
    // TODO: implement build
    return _handleCurrenSession();
  }

  Widget _handleCurrenSession() {
    return StreamBuilder(
      stream: userBloc.authStatus,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData || snapshot.hasError) {
          return signInGoogleUI();
        } else {
          return PlatziTripsCupertino();
        }
      },
    );
  }

  Widget signInGoogleUI() {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          GradientBack(heigth: null),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Container(
                  width: screenWhiht,
                  child: Text(
                    "Bienvenido",
                    style: TextStyle(
                        fontSize: 37.0,
                        fontFamily: "Lato",
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              ButtonGreen(
                text: "login Google",
                onPressed: () {
                  userBloc.signIn().then((FirebaseUser user) => {
                        userBloc.updateUserData(User(
                            uid: user.uid,
                            name: user.displayName,
                            email: user.email,
                            photo: user.photoUrl))
                      });
                },
                width: 300.0,
                height: 50.0,
              )
            ],
          )
        ],
      ),
    );
  }
}
