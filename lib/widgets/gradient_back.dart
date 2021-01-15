import 'package:flutter/material.dart';

class GradientBack extends StatelessWidget {
  double heigth = 0.0;

  GradientBack({Key key, this.heigth});

  @override
  Widget build(BuildContext context) {
    double screenHeigth = MediaQuery.of(context).size.height;
    double screenWhiht = MediaQuery.of(context).size.width;

    if (heigth == null) {
      heigth = screenHeigth;
    }
    // TODO: implement build
    return Container(
      width: screenWhiht,
      height: heigth,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: [Color(0xFF4268D3), Color(0xFF584CD1)],
              begin: FractionalOffset(0.2, 0.0),
              end: FractionalOffset(1.0, 0.6),
              stops: [0.0, 0.6],
              tileMode: TileMode.clamp)),
      /* child: Text(
        title,
        style: TextStyle(
            color: Colors.white,
            fontSize: 30.0,
            fontFamily: "Lato",
            fontWeight: FontWeight.bold),
      ),*/
      child: FittedBox(
        fit: BoxFit.none,
        alignment: Alignment(-1.5, -0.8),
        child: Container(
          width: screenHeigth,
          height: screenHeigth,
          decoration: BoxDecoration(
            color: Color.fromRGBO(0, 0, 0, 0.05),
            borderRadius: BorderRadius.circular(screenHeigth / 2),
          ),
        ),
      ),
      //alignment: Alignment(-0.9, -0.6),
    );
  }
}
