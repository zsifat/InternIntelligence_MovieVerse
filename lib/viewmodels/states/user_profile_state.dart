import '../../models/user_profile_model.dart';

class UserProfileState {
  final UserProfile? userProfile;
  final bool isLoading;
  final String errorMessage;

  UserProfileState({
    this.userProfile,
    this.isLoading = false,
    this.errorMessage = '',
  });

  UserProfileState copyWith({
    UserProfile? userProfile,
    bool? isLoading,
    String? errorMessage,
  }) {
    return UserProfileState(
      userProfile: userProfile ?? this.userProfile,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}