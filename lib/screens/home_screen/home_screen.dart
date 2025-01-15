// import 'dart:async';
//
// import 'package:consumer_flutter_app/analytics.dart';
// import 'package:consumer_flutter_app/network/shared_prefs.dart';
// import 'package:consumer_flutter_app/repo/profile_repo.dart';
// import 'package:consumer_flutter_app/screens/cart_summary_section_screen/controller/cart_summary_controller.dart';
// import 'package:consumer_flutter_app/screens/deep_link_event.dart';
// import 'package:consumer_flutter_app/screens/home_screen/widget/build_home_screen_body.dart';
// import 'package:consumer_flutter_app/screens/map_screen/model/current_address_model.dart';
// import 'package:consumer_flutter_app/screens/notification_screen/controller/notification_controller.dart';
// import 'package:consumer_flutter_app/screens/order_list/controller/order_list_controller.dart';
// import 'package:consumer_flutter_app/screens/society_selection/controller/select_society_controller.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:synchronized/synchronized.dart';
// import 'package:uni_links/uni_links.dart';
//
// import '../../logger.dart';
// import '../../routes/app_routes.dart';
// import '../../strings.dart';
// import '../../styles.dart';
// import '../../themes.dart';
// import '../../utils/common.dart';
// import '../../utils/deep_link_utils.dart';
// import '../../widgets/show_alert_dialog.dart';
// import '../cart_screen/controllers/free_product_controller.dart';
// import '../cart_summary_section_screen/models/location.dart';
// import '../catalog_screen/controller/inventory_controller.dart';
// import '../catalog_screen/widgets/society_issue_dialog.dart';
// import '../notification_screen/model/in_app_message_model.dart';
// import '../notification_screen/widget/in_app_message_dialog.dart';
// import '../cart_screen/screens/cart_screen.dart';
// import '../product_detail_screen/widgets/enter_phone_number_dialog.dart';
// import '../cart_screen/screens/pdp_cart_widget.dart';
// import '../product_detail_screen/widgets/wallet_dialog.dart';
// import '../sign_in_screen/model/login_model.dart';
// import '../splash_screen/controller/config_controller.dart';
// import '../store_details/store_details_controller.dart';
// import '../support/controller/support_controller.dart';
// import '../track_screen/controller/track_order_controller.dart';
// import '../wallet_screen/screen/wallet_controller.dart';
//
// // EventBus eventBus = EventBus();
//
// class HomeScreen extends StatefulWidget {
//   const HomeScreen(
//       {Key? key, this.centerScreenSkuId = 0, this.initialCatalogZoom = 1.0})
//       : super(key: key);
//   final int centerScreenSkuId;
//   final double initialCatalogZoom;
//
//   @override
//   State<HomeScreen> createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   OrderListController orderListController = Get.put(OrderListController());
//   CartSummaryController cartSummaryController = Get.find();
//   TrackOrderController trackOrderController = Get.put(TrackOrderController());
//   InventoryController inventoryController = Get.find();
//   SelectSocietyController selectSocietyController = Get.find();
//   final StoresController storesController = Get.find<StoresController>();
//   SupportController supportController = Get.put(SupportController());
//   ConfigController configController = Get.find();
//   NotificationController notificationController = Get.find();
//   FreeProductController freeProductController = Get.find();
//   WalletController walletController = Get.put(WalletController());
//   User? user;
//   late StreamSubscription _linkSubscription;
//   StreamSubscription? _targetStreamSub;
//   var lock = Lock();
//   var currentTime = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     _initUser();
//     Analytics().trackEvent(TrackingEvent.homeLaunched, {});
//     // orderListController.getCurrentOrderList();
//     loadBalance();
//     getStores();
//     checkSocietyDialog();
//     checkNotificationPermissionEvent();
//     FirebaseMessaging messaging = FirebaseMessaging.instance;
//     ProfileRepo profileRepo = ProfileRepo();
//     () async {
//       String? fcmtoken = await messaging.getToken(
//         vapidKey: Strings.validKey,
//       );
//       await profileRepo.updateFCM(fcmtoken!);
//     }();
//     // initDeepLinkWithPush();
//     initDeepLink();
//   }
//
//   _initUser() async {
//     user = await SharedPref.getCurrentUser();
//
//     if (mounted) {
//       setState(() {});
//     }
//   }
//
//   Future<void> initDeepLink() async {
//     var link = await getInitialLink();
//     if (link != null) {
//       DeepLinkUtils.navigateToPage(link, user);
//     }
//     _linkSubscription = linkStream.listen((url) async {
//       if (url != null) {
//         DeepLinkUtils.navigateToPage(url, user);
//       }
//     }, onError: (Object err) {
//       logger.d("Error while opening the app from external link");
//     });
//
//     String? targetUrl = await SharedPref.getStringWithKey(SharedPref.DEEP_LINK);
//     if (targetUrl != null &&
//         DateTime.now().millisecondsSinceEpoch > currentTime + 1000) {
//       currentTime = DateTime.now().millisecondsSinceEpoch;
//       DeepLinkUtils.navigateToPage(targetUrl, user);
//       SharedPref.removeWithKey(SharedPref.DEEP_LINK);
//     }
//
//     _targetStreamSub = eventBus.on<DeepLinkEvent>().listen((event) {
//       lock.synchronized(() {
//         setState(() {
//           if (DateTime.now().millisecondsSinceEpoch > currentTime + 1000) {
//             currentTime = DateTime.now().millisecondsSinceEpoch;
//             DeepLinkUtils.navigateToPage(event.targetUrl, user);
//             SharedPref.removeWithKey(SharedPref.DEEP_LINK);
//           }
//         });
//       });
//     });
//   }
//
//   loadBalance() async {
//     var user = await SharedPref.getCurrentUser();
//     if (user!.phoneNumber != null) {
//       await walletController.fetchUserWalletAmount();
//       // await Future.delayed(const Duration(milliseconds: 400));
//       await walletController.fetchWalletHistory();
//       // await walletController.fetchWalletHistoryData();
//     }
//   }
//
//   checkSocietyDialog() async {
//     final user = await SharedPref.getCurrentUser();
//     if (user != null && user.phoneNumber != null) {
//       WidgetsBinding.instance.addPostFrameCallback((_) async {
//         if (inventoryController.showSocietyDialog.value) {
//           ShowAlertDialog.showAlertDialog(context, const SocietyIssueDialog());
//         }
//       });
//     }
//   }
//
//   getNotificationList() async {
//     await notificationController.getAllNotifications();
//   }
//
//   getInAppMessages() {
//     notificationController.getInAppMessages().then((value) {
//       if (value != null) {
//         Analytics().trackEvent(TrackingEvent.showInAppMessageDialog, {});
//         ShowAlertDialog.showAlertDialog(
//           context,
//           InAppMessageDialog(
//             inAppMessageModel: value,
//           ),
//         );
//     }
//     });
//   }
//
//   getStores() async {
//     // CurrentAddressModel? currentAddressModel =
//     // await SharedPref.getCurrentAddress();
//     // String? err = await storesController.getStoreDetailList(
//     //   latitude: currentAddressModel?.latitude.toString() ?? '',
//     //   longitude: currentAddressModel?.longitude.toString() ?? '',
//     // );
//     // if (err != null && context.mounted) {
//     //   ///
//     // } else {
//
//     loadInventory();
//     await orderListController.getCurrentOrderList();
//     getInAppMessages();
//     getNotificationList();
//     selectSocietyController.getSocietyData();
//     inventoryController.getSlotsList();
//     await supportController.getSupportCategoriesList();
//
//     // }
//   }
//
//   loadInventory() async {
//     await inventoryController.getYourPickList();
//     await inventoryController.getInventory();
//     await freeProductController.getFreeProductDetails();
//     setOrder();
//   }
//
//   checkNotificationPermissionEvent() async {
//     int? isAccepted =
//         await SharedPref.getIntWithKey(SharedPref.IS_NOTIFICATION_ACCEPTED);
//     final user = await SharedPref.getCurrentUser();
//     if (user != null &&
//         user.phoneNumber != null &&
//         isAccepted != null &&
//         isAccepted != 2) {
//       await SharedPref.setIntWithKey(SharedPref.IS_NOTIFICATION_ACCEPTED, 2);
//       Analytics().trackEvent(TrackingEvent.notificationPermissionRequest, {
//         "is_accepted": isAccepted == 1 ? true : false,
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     trackOrderController.timer?.cancel();
//     _linkSubscription.cancel();
//     _targetStreamSub?.cancel();
//     super.dispose();
//   }
//
//   late CurrentAddressModel? currentAddressModel;
//
//   setOrder() async {
//     // await orderListController.getCurrentOrderList();
//     // await SharedPref.setCurrentOrderId(
//     //     orderListController.currentOrderList.first.id!);
//     currentAddressModel = await SharedPref.getCurrentAddress();
//     // try {
//     await cartSummaryController.getCartSummary(
//         Location(
//             lat: currentAddressModel?.latitude.toString(),
//             long: currentAddressModel?.longitude.toString()),
//         true,
//         context);
//     // } catch (e) {}
//     // setState(() {});
//   }
//
//   void getUserData() async {
//     // await orderListController.getCurrentOrderList();
//     // await trackOrderController
//     //     .getOrderTrack(orderListController.currentOrderList.first.id!);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     // getUserData();
//     setStatusBarColor();
//     // final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
//     return WillPopScope(
//       onWillPop: () async {
//         if (inventoryController.isExpanded.value) {
//           inventoryController.toggleBottomSheet();
//           setStatusBarColor();
//           return false;
//         }
//         SystemChrome.setSystemUIOverlayStyle(
//           SystemUiOverlayStyle(
//             statusBarColor: AppTheme.white,
//             statusBarIconBrightness: Brightness.dark,
//           ),
//         );
//         AppRoutes.back();
//         return true;
//       },
//       child: Obx(
//         () => Scaffold(
//           appBar: inventoryController.isShowAppBarHomeCart.value
//               ? AppBar(
//                   backgroundColor: AppTheme.darkYellow,
//                   elevation: 0,
//                   // forceMaterialTransparency: true,
//                   leading: GestureDetector(
//                     onTap: () {
//                       Analytics()
//                           .trackEvent(TrackingEvent.cartCloseButtonClick, {});
//                       if (inventoryController.isExpanded.value) {
//                         inventoryController.toggleBottomSheet();
//                       }
//                       SystemChrome.setSystemUIOverlayStyle(
//                         const SystemUiOverlayStyle(
//                           statusBarColor: AppTheme.white,
//                           statusBarIconBrightness: Brightness.dark,
//                         ),
//                       );
//                     },
//                     child: Padding(
//                       padding: const EdgeInsets.all(14.0),
//                       child: SvgPicture.asset(
//                         'assets/images/ic_back.svg',
//                         color: AppTheme.white,
//                         height: 20,
//                         width: 20,
//                       ),
//                     ),
//                   ),
//
//                   actions: [
//                     if (user?.phoneNumber != null)
//                       Padding(
//                         padding: EdgeInsets.only(right: Insets.med),
//                         child: GestureDetector(
//                           onTap: () async {
//                             var user = await SharedPref.getCurrentUser();
//                             if (user!.phoneNumber != null) {
//                               ShowAlertDialog.showAlertDialog(
//                                   context, const WalletDialog());
//                             } else {
//                               ShowAlertDialog.showAlertDialog(
//                                   context, const EnterPhoneNumberDialog(),
//                                   onThen: (value) {
//                                 if (mounted) {
//                                   setState(() {});
//                                 }
//                               });
//                             }
//                             Analytics().trackEvent(
//                                 TrackingEvent.homeWalletButtonClick, {});
//                           },
//                           child: Obx(
//                             () => Stack(
//                               children: [
//                                 Container(
//                                   // height: 28,
//                                   // width: 25,
//                                   padding: EdgeInsets.all(Insets.sm),
//                                   child: Center(
//                                     child: SvgPicture.asset(
//                                       "assets/images/ic_wallet_without_bg.svg",
//                                       // height: Insets.xl,
//                                       height: 26,
//                                       width: 26,
//                                     ),
//                                   ),
//                                 ),
//                                 if (walletController.walletAmount.value <
//                                     (cartSummaryController.cartResponse.value
//                                             .data?.finalBillAmount ??
//                                         0))
//                                   Positioned(
//                                     bottom: 13,
//                                     right: 8,
//                                     child: SizedBox(
//                                       width: 26,
//                                       height: 26,
//                                       child: Lottie.asset(
//                                         "assets/lottie/wallet_error.json",
//                                         repeat: true,
//                                         width: 16,
//                                         height: 16,
//                                       ),
//                                     ),
//                                   ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                   ],
//                 )
//               : PreferredSize(
//                   preferredSize: const Size.fromHeight(5.0),
//                   child: AppBar(
//                     backgroundColor: Colors.white,
//                     elevation: 0,
//                     toolbarHeight: 1,
//                   ),
//                 ),
//           // key: scaffoldKey,
//           // drawer: const LeftDrawerWidget(),
//           //endDrawer: const RightSideDrawerWidget(),
//
//           // body: Container(
//           //   padding: Platform.isIOS
//           //       ? const EdgeInsets.symmetric(vertical: 20)
//           //       : EdgeInsets.zero,
//           //   child: BuildHomeScreenBody(
//           //       centerScreenSkuId: widget.centerScreenSkuId,
//           //       initialCatalogZoom: widget.initialCatalogZoom),
//           // ),
//
//           body: SafeArea(
//             child: SizedBox(
//               child: BuildHomeScreenBody(
//                   centerScreenSkuId: widget.centerScreenSkuId,
//                   initialCatalogZoom: widget.initialCatalogZoom),
//             ),
//           ),
//           bottomSheet: Obx(
//             () => GestureDetector(
//               onVerticalDragUpdate: (details) {
//                 if (details.delta.dy > 0) {
//                   // Dragging downwards
//                   if (inventoryController.isExpanded.value) {
//                     inventoryController.toggleBottomSheet();
//                     Analytics()
//                         .trackEvent(TrackingEvent.homeCartSlideDownToClose, {});
//                     SystemChrome.setSystemUIOverlayStyle(
//                       const SystemUiOverlayStyle(
//                         statusBarColor: AppTheme.white,
//                         statusBarIconBrightness: Brightness.dark,
//                       ),
//                     );
//                   }
//                 } else if (details.delta.dy < 0) {
//                   // Dragging upwards
//
//                   if (!inventoryController.isExpanded.value) {
//                     inventoryController.toggleBottomSheet();
//                     Analytics()
//                         .trackEvent(TrackingEvent.homeCartSlideUpToOpen, {});
//                     SystemChrome.setSystemUIOverlayStyle(
//                       const SystemUiOverlayStyle(
//                         statusBarColor: AppTheme.darkYellow,
//                         statusBarIconBrightness: Brightness.dark,
//                       ),
//                     );
//                   }
//                 }
//               },
//               child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 400),
//                   height: inventoryController.isExpanded.value
//                       ? MediaQuery.of(context).size.height
//                       : 110,
//                   color: AppTheme.white,
//                   child: inventoryController.isExpanded.value
//                       ? _buildExpandedBottomSheet()
//                       : !inventoryController.isHideBottomCart.value
//                           ? _buildExpandedBottomSheet()
//                           : _buildSmallBottomSheet()),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildExpandedBottomSheet() {
//     return Container(
//       height: MediaQuery.of(context).size.height,
//       decoration: const BoxDecoration(
//         color: Colors.transparent,
//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(10),
//           topRight: Radius.circular(10),
//         ),
//       ),
//       child: CartScreen(
//         onCartTap: () {
//           Analytics().trackEvent(TrackingEvent.cartCloseButtonClick, {});
//           if (inventoryController.isExpanded.value) {
//             SystemChrome.setSystemUIOverlayStyle(
//               const SystemUiOverlayStyle(
//                 statusBarColor: AppTheme.white,
//                 statusBarIconBrightness: Brightness.dark,
//               ),
//             );
//           }
//           inventoryController.toggleBottomSheet();
//         },
//         onItemTap: (skuCode) {
//           inventoryController.toggleBottomSheet();
//           // goToSelectedItem(skuCode);
//         },
//       ),
//     );
//   }
//
//   Widget _buildSmallBottomSheet() {
//     return Container(
//         height: 110,
//         decoration: const BoxDecoration(
//           color: Colors.transparent,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(10),
//             topRight: Radius.circular(10),
//           ),
//         ),
//         child: PDPCartWidget(
//           isFromHome: true,
//           onCartTap: () {
//             Analytics().trackEvent(TrackingEvent.homeCartButtonClick, {});
//             if (!inventoryController.isExpanded.value) {
//               SystemChrome.setSystemUIOverlayStyle(
//                 const SystemUiOverlayStyle(
//                   statusBarColor: AppTheme.darkYellow,
//                   statusBarIconBrightness: Brightness.dark,
//                 ),
//               );
//             }
//             inventoryController.toggleBottomSheet();
//           },
//           onItemTap: (skuCode) {
//             // goToSelectedItem(skuCode);
//           },
//         ));
//   }
// }
