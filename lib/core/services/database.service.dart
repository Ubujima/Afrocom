import 'dart:io';
import 'package:afrocom/app/constants/appwrite.credentials.dart';
import 'package:afrocom/app/constants/database.credentials.dart';
import 'package:afrocom/core/models/fetch_posts.dart';
import 'package:afrocom/core/models/post.model.dart';
import 'package:afrocom/core/models/signeduser.model.dart';
import 'package:afrocom/core/services/storage.service.dart';
import 'package:afrocom/meta/utilities/snackbar.utility.dart';
import 'package:afrocom/meta/views/authentication/login/login.exports.dart';
import 'package:afrocom/meta/views/home/add_post/components/add_post_components.dart';
import 'package:afrocom/meta/views/home/feed/components/feed.widgets.dart';
import 'package:appwrite/appwrite.dart';
import 'package:logger/logger.dart';

class DatabaseService {
  final _logger = Logger();
  static DatabaseService? _instance;
  late Client _client;
  late Database _database;

  DatabaseService._initialize() {
    _client = Client(endPoint: AppwriteCredentials.AppwriteLocalEndpoint)
        .setProject(AppwriteCredentials.AppwriteLocalProjectID)
        .setSelfSigned();
    _database = Database(_client);
  }
  static DatabaseService get createInstance {
    if (_instance == null) {
      _instance = DatabaseService._initialize();
    }
    return _instance!;
  }

  Future<bool> checkIfExists(
      {required String dataKey,
      required String identifier,
      required String collectionId}) async {
    var userdata;
    await _database.listDocuments(collectionId: collectionId).then((heapDocs) {
      final _listOfDocuments = heapDocs.data['documents'] as List;
      var _userdata =
          _listOfDocuments.where((blux) => blux[dataKey] == identifier);
      userdata = _userdata;
    });
    if (userdata.length >= 1) {
      return true;
    } else {
      return false;
    }
  }

//! <--------------------------------------------------SUBMIT USER DATA------------------------------------------------------------>
  Future submitUserData(
      {required BuildContext context, required SignedUser signedUser}) async {
    var userDocumentId;
    try {
      var response = await _database.createDocument(
          collectionId: "610d7c664edbe",
          data: signedUser.toJson(),
          read: ["*"],
          write: ["*"]);
      var _userDocumentId = response.data['\$id'];
      var resStatusCode = response.statusCode;
      print("Database status : $resStatusCode");
      if (resStatusCode == 201) {
        userDocumentId = _userDocumentId;
        SnackbarUtility.showSnackbar(
            context: context, message: "Account data added!");
        Navigator.of(context).pushNamed(ShareRoute);
      }
      return userDocumentId;
    } on SocketException catch (error) {
      _logger.i(error.message);
    } on AppwriteException catch (error) {
      _logger.i(error.response);
      _logger.i(error.code);
      _logger.i(error.message);
      var errorCode = error.code;
      switch (errorCode) {
        case 429: //! Too many requests
          SnackbarUtility.showSnackbar(
              context: context, message: "Server error, Try again!");
          break;
        case 400: //! Bad structure. Invalid document structure: Unknown properties are not allowed.
          SnackbarUtility.showSnackbar(
              context: context, message: "Something went wrong, Try again");
      }
    } catch (error) {
      _logger.i(error);
      SnackbarUtility.showSnackbar(
          context: context, message: "Something went wrong, Try again");
    }
  }

//! <--------------------------------------------------UPDATE DATA------------------------------------------------------------>
  Future updateData(
      {required String collectionId,
      required String documentId,
      required Map<String, dynamic> data,
      required BuildContext context}) async {
    try {
      var updatedData = await _database.updateDocument(
          collectionId: collectionId,
          documentId: documentId,
          data: data,
          read: ["*"],
          write: ["*"]);

      var statusCode = updatedData.statusCode;
      switch (statusCode) {
        case 200:
          {
            SnackbarUtility.showSnackbar(
                context: context, message: "Information added in database");
          }
      }
    } on AppwriteException catch (exception) {
      var exceptionMessage = exception.message;
      SnackbarUtility.showSnackbar(
          context: context, message: exceptionMessage!);
    } catch (e) {
      print("🔦 = $e");
    }
  }

//! <--------------------------------------------------UPLOAD POSTS------------------------------------------------------------>
  Future uploadPost({required Post post, required BuildContext context}) async {
    try {
      var _response = await _database.createDocument(
          write: ['*'],
          read: ['*'],
          collectionId: DatabaseCredentials.PostCollectionID,
          data: post.toJson());
      var _resStatusCode = _response.statusCode;
      switch (_resStatusCode) {
        case 201:
          {
            AddPostComponents.showProgressIndicator(context: context);
            Future.delayed(Duration(seconds: 12)).whenComplete(() {
              Navigator.of(context).pushNamed(FeedRoute);
            });
          }
      }
    } on AppwriteException catch (exception) {
      var exceptionMessage = exception.message;
      SnackbarUtility.showSnackbar(
          context: context, message: exceptionMessage!);
    } catch (e) {
      SnackbarUtility.showSnackbar(context: context, message: e.toString());
    }
  }

//! <--------------------------------------------------FETCH POSTS------------------------------------------------------------>
  fetchPosts({required BuildContext context}) async {
    try {
      var response = await _database.listDocuments(
          collectionId: DatabaseCredentials.PostCollectionID);
      if (response.data != null) {
        var responseData = response.data;
        return responseData;
      }
    } on AppwriteException catch (exception) {
      var exceptionMessage = exception.message;
      SnackbarUtility.showSnackbar(
          context: context, message: exceptionMessage!);
    } catch (e) {
      SnackbarUtility.showSnackbar(context: context, message: e.toString());
    }
  }

  //! <------------------------------------------DELETE POSTS--------------------------------------------------->
  deletePost(
      {required dynamic imageId,
      required BuildContext context,
      required dynamic postId}) async {
    try {
      var response = await _database.deleteDocument(
          collectionId: DatabaseCredentials.PostCollectionID,
          documentId: postId);
      var resStatusCode = response.statusCode;
      if (resStatusCode == 204) {
        await StorageService.createInstance
            .deletePostImage(postId: imageId, context: context);
        FeedWidgets.deletePostLoader(context: context);
        Future.delayed(Duration(seconds: 6)).whenComplete(() {
          Navigator.of(context).pushNamed(FeedRoute);
        });
      }
    } on AppwriteException catch (exception) {
      var exceptionMessage = exception.message;
      SnackbarUtility.showSnackbar(
          context: context, message: exceptionMessage!);
    } catch (e) {}
  }
}
