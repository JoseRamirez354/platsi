import 'package:firebase_auth/firebase_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:platzy/User/model/user.dart';
import 'package:platzy/User/repository/auth_repository.dart';
import 'package:platzy/User/repository/cloud_firestore_repository.dart';
import '';

class UserBloc implements Bloc {
  final _auth_repository = AuthRepository();
  //flujo de datos -Streams
  // Stream -Firebase tiene su propios metodos
  //caso contrario se manejan con StreamController
  Stream<FirebaseUser> streamFirebase =
      FirebaseAuth.instance.onAuthStateChanged;
  Stream<FirebaseUser> get authStatus => streamFirebase;

  // casos de usos de la aplicacion :
  // 1 signIn con google

  Future<FirebaseUser> signIn() {
    return _auth_repository.signInFirebase();
  }

  //2 Registrar usuario
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(User user) =>
      _cloudFirestoreRepository.updateUserDataFirestore(user);

  signOut() {
    _auth_repository.signOut();
  }

  @override
  void dispose() {
    // TODO: implement dispose
  }
}
