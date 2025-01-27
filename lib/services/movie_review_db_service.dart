import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:movie_app/models/movie_review_model.dart';


class MovieDBService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _movieReviewCollection = 'movie_reviews';
  final String _userReviews ='userReviews';

  Future<void> updateRating(int movieId, String userId,String userName, double rating) async {
    try {
      _firestore
          .collection(_movieReviewCollection)
          .doc(movieId.toString()).set({'movieId': movieId},SetOptions(merge: true));
      final userReviewRef = _firestore
          .collection(_movieReviewCollection)
          .doc(movieId.toString())
          .collection(_userReviews)
          .doc(userId);

      await userReviewRef.set({'rating': rating,'userName':userName, 'timestamp': DateTime.now().toIso8601String()}, SetOptions(merge: true));

    } catch (e) {
      throw Exception('Failed to update rating: $e');
    }
  }

  Future<void> updateReview(int movieId, String userId,String userName, String review) async {
    try {
      _firestore
          .collection(_movieReviewCollection)
          .doc(movieId.toString()).set({'movieId': movieId},SetOptions(merge: true));
      final userReviewRef = _firestore
          .collection(_movieReviewCollection)
          .doc(movieId.toString())
          .collection(_userReviews)
          .doc(userId);

      await userReviewRef.set({'review': review,'userName':userName, 'timestamp': DateTime.now().toIso8601String()}, SetOptions(merge: true));

    } catch (e) {
      throw Exception('Failed to update review: $e');
    }
  }




  Stream<QuerySnapshot<Map<String, dynamic>>> getAllReviews(int movieId) {
    try {
      final userReviewsSnapshot = _firestore
          .collection(_movieReviewCollection)
          .doc(movieId.toString())
          .collection(_userReviews)
          .snapshots();

      return userReviewsSnapshot;
    } catch (e) {
      throw Exception('Failed to fetch reviews: $e');
    }
  }

  Future<Review?> getReviewByUser(int movieId,String userId) async{
    try{
      final snap=await _firestore.collection(_movieReviewCollection).doc(movieId.toString()).collection(_userReviews).doc(userId).get();
      if(snap.exists){
        return Review.fromJson(snap.data()!);
      }
    }catch(e){
      throw Exception(e);
    }
    return null;
}


  Future<List<Map<String, dynamic>>> getAllUserReviews(String userId) async {
    List<Map<String,dynamic>> userReviews = [];

    try {
      final QuerySnapshot<Map<String, dynamic>> movieReviewedDocs=await _firestore.collection(_movieReviewCollection).get();
      for (var movie in movieReviewedDocs.docs) {
        print(movie.id);
        DocumentSnapshot reviewSnapshot = await movie.reference
            .collection(_userReviews)
            .doc(userId)
            .get();
        userReviews.add({'movieId':movie.id,'review':Review.fromJson(reviewSnapshot.data() as Map<String,dynamic>)});
      }
    } catch (e) {
      print('Error fetching reviews: $e');
    }

    return userReviews;
  }
}