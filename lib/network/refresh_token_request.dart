import 'dart:convert';

RefreshTokenRequest refreshTokenRequestFromJson(String str) =>
    RefreshTokenRequest.fromJson(json.decode(str));

String refreshTokenRequestToJson(RefreshTokenRequest data) =>
    json.encode(data.toJson());

class RefreshTokenRequest {
  RefreshTokenRequest({
    this.refreshToken,
  });

  String? refreshToken;

  factory RefreshTokenRequest.fromJson(Map<String, dynamic> json) =>
      RefreshTokenRequest(
        refreshToken: json["refresh_token"],
      );

  Map<String, dynamic> toJson() => {
    "refresh_token": refreshToken,
  };
}
