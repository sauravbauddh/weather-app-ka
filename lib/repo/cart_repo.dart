class CartRepo {


  // static Future<CartResponse?> upDateToCart(
  //     UpdateCartRequest updateCartRequest) async {
  //   try {
  //     Response response = await ApiClient.putRequest(
  //         endpoint: ApiEndPoints.cartSummaryV2,
  //         param: updateCartRequest.toJson());
  //
  //     if (response.statusCode == 200) {
  //       logger.d("upDateToCart : ${response.data}");
  //       var json = jsonEncode(response.data);
  //       return cartResponseFromJson(json);
  //     } else {
  //       logger.d("upDateToCart Response is null : ${response.data}");
  //     }
  //   } on ServiceException catch (e) {
  //     throw RepoServiceException(message: e.message);
  //   }
  // }

}
