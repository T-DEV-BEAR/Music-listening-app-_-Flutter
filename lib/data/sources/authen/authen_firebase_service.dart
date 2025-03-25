import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spotify/core/configs/constants/app_urls.dart';
import 'package:spotify/data/models/authen/create_user_req.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify/data/models/authen/signin_user_req.dart';
import 'package:spotify/data/models/authen/user.dart';
import 'package:spotify/domain/entities/authen/user.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

abstract class AuthenFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinReq);
  Future<Either> getUser();
  Future<Either> signupGoogle(CreateUserReq createUserReq);
  Future<Either> signupFacebook(CreateUserReq createUserReq);
}

class AuthenFirebaseServiceImpl extends AuthenFirebaseService {

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    try {
        var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: createUserReq.email,
        password:createUserReq.password
      );      

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid)
      .set(
        {
          'name' : createUserReq.fullName,
          'email' : data.user?.email,
        }
      );

      return const Right('Signup was Successful');
    }on FirebaseAuthException catch(e) {
      String message = '';
      if(e.code == 'weak-password') {
        message = 'The password provided is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email.';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signin(SigninUserReq signinReq) async {
    try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: signinReq.email,
        password:signinReq.password
      );      
      return const Right('SignIn was Successful');
    }on FirebaseAuthException catch(e) {
      String message = '';
      if(e.code == 'invalid-email') {
        message = "Can't found the email address for this account";
      } else if (e.code == 'invalid-credential') {
        message = 'Wrong password for this account';
      }
      return Left(message);
    }
  }

  @override
  Future <Either> getUser() async {
    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

      var user = await firebaseFirestore.collection('Users').doc(
        firebaseAuth.currentUser?.uid
      ).get();

      UserModel userModel = UserModel.fromJson(user.data() !);
      userModel.imageURL = firebaseAuth.currentUser?.photoURL ?? AppURLs.defaultImage;
      UserEntity userEntity = userModel.toEntity();
      return Right(userEntity);
    } catch (e) {
      return const Left('An error occurred');
    }
  }
  
  @override
  Future<Either> signupGoogle(CreateUserReq createUserReq) async {
    try {
      // Initialize GoogleSignIn instance
      final GoogleSignIn googleSignIn = GoogleSignIn();

      // Start the sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser == null) {
        return const  Left('Google Sign-In was canceled');
      }

      // Authenticate with Google
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create Firebase credential using the Google token
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase using the Google credential
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

      // If the user does not already exist in Firestore, create a new user document
      final User? user = userCredential.user;
      if (user != null) {
        final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

        final userDoc = await userRef.get();
        if (!userDoc.exists) {
          // Save user information in Firestore
          await userRef.set({
            'name': createUserReq.fullName, // Name from Google profile or passed in `CreateUserReq`
            'email': user.email,
          });
        }

        return const Right('Signup with Google was Successful');
      } else {
        return const Left('Failed to sign up with Google');
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'account-exists-with-different-credential') {
        message = 'An account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        message = 'The provided Google credential is invalid.';
      }
      return Left(message);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }
  
  @override
  Future<Either> signupFacebook(CreateUserReq createUserReq) async {
    try {
      // Trigger the Facebook sign-in process
      final LoginResult loginResult = await FacebookAuth.instance.login();

      // Check if the sign-in was successful
      if (loginResult.status == LoginStatus.success) {
        // Get the Facebook access token
        final AccessToken? accessToken = loginResult.accessToken;

        if (accessToken == null) {
          return const Left('Failed to retrieve Facebook access token');
        }

        // Create an OAuth credential using the Facebook access token
        final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(accessToken.tokenString);

        // Sign in to Firebase using the Facebook credential
        final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);

        // Retrieve the signed-in user
        final User? user = userCredential.user;
        if (user != null) {
          // Reference to Firestore
          final userRef = FirebaseFirestore.instance.collection('Users').doc(user.uid);

          // Check if the user already exists in Firestore
          final userDoc = await userRef.get();
          if (!userDoc.exists) {
            // Save user information in Firestore
            await userRef.set({
              'name': createUserReq.fullName, // Name from Facebook profile or passed in `CreateUserReq`
              'email': user.email,
            });
          }

          return const Right('Signup with Facebook was Successful');
        } else {
          return const Left('Failed to sign up with Facebook');
        }
      } else if (loginResult.status == LoginStatus.cancelled) {
        return const Left('Facebook Sign-In was canceled');
      } else {
        return Left('Facebook Sign-In failed: ${loginResult.message}');
      }
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'account-exists-with-different-credential') {
        message = 'An account already exists with a different credential.';
      } else if (e.code == 'invalid-credential') {
        message = 'The provided Facebook credential is invalid.';
      }
      return Left(message);
    } catch (e) {
      return Left('An error occurred: $e');
    }
  }
}


