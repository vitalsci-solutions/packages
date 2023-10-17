// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut: 'lib/src/messages.g.dart',
  objcOptions: ObjcOptions(prefix: 'FSI'),
  objcHeaderOut: 'ios/Classes/messages.g.h',
  objcSourceOut: 'ios/Classes/messages.g.m',
  copyrightHeader: 'pigeons/copyright.txt',
))

/// Pigeon version of SignInInitParams.
///
/// See SignInInitParams for details.
class InitParams {
  /// The parameters to use when initializing the sign in process.
  const InitParams({
    this.scopes = const <String>[],
    this.hostedDomain,
    this.clientId,
    this.serverClientId,
  });

  // TODO(stuartmorgan): Make the generic type non-nullable once supported.
  // https://github.com/flutter/flutter/issues/97848
  // The Obj-C code treats the values as non-nullable.
  final List<String?> scopes;
  final String? hostedDomain;
  final String? clientId;
  final String? serverClientId;
}

/// Pigeon version of GoogleSignInUserData.
///
/// See GoogleSignInUserData for details.
class UserData {
  UserData({
    required this.email,
    required this.userId,
    this.displayName,
    this.photoUrl,
    this.serverAuthCode,
  });

  final String? displayName;
  final String email;
  final String userId;
  final String? photoUrl;
  final String? serverAuthCode;
}

/// Pigeon version of GoogleSignInTokenData.
///
/// See GoogleSignInTokenData for details.
class TokenData {
  TokenData({
    this.idToken,
    this.accessToken,
  });

  final String? idToken;
  final String? accessToken;
}

@HostApi()
abstract class GoogleSignInApi {
  /// Initializes a sign in request with the given parameters.
  @ObjCSelector('initializeSignInWithParameters:')
  void init(InitParams params);

  /// Starts a silent sign in.
  @async
  UserData signInSilently();

  /// Starts a sign in with user interaction.
  @async
  UserData signIn();

  /// Requests the access token for the current sign in.
  @async
  TokenData getAccessToken();

  /// Signs out the current user.
  void signOut();

  /// Revokes scope grants to the application.
  @async
  void disconnect();

  /// Returns whether the user is currently signed in.
  bool isSignedIn();

  /// Requests access to the given scopes.
  @async
  @ObjCSelector('requestScopes:')
  bool requestScopes(List<String> scopes);
}
