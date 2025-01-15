// import 'package:consumer_flutter_app/network/shared_prefs.dart';
// import 'package:consumer_flutter_app/screens/track_screen/controller/track_order_controller.dart';
// import 'package:consumer_flutter_app/strings.dart';
// import 'package:consumer_flutter_app/styles.dart';
// import 'package:consumer_flutter_app/themes.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class HelpScreen extends StatefulWidget {
//   const HelpScreen({Key? key}) : super(key: key);
//
//   @override
//   State<HelpScreen> createState() => _HelpScreenState();
// }
//
// class _HelpScreenState extends State<HelpScreen> {
//   TrackOrderController trackOrderController = Get.find();
//
//   @override
//   String numberToCall = "";
//   void initState() {
//     init();
//   }
//
//   init() async {
//     numberToCall = (await SharedPref.getHelpNumber())!;
//   }
//
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppTheme.containerWhite,
//       body: SafeArea(
//         child: ListView(
//           children: [
//             Padding(
//               padding: EdgeInsets.only(top: Insets.xxl),
//               child: Text(Strings.help.capitalize!,
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                       fontFamily: "JD",
//                       letterSpacing: 2,
//                       fontSize: 32,
//                       color: AppTheme.darkYellow,
//                       fontWeight: FontWeight.w500)),
//             ),
//             Text("#${trackOrderController.trackResponse.value.displayOrderId}",
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                     fontFamily: "Roboto",
//                     letterSpacing: 2,
//                     fontSize: 12,
//                     color: AppTheme.grey,
//                     fontWeight: FontWeight.w500)),
//             Padding(
//               padding: EdgeInsets.all(Insets.lg),
//               child: Text(
//                 Strings.ifYouAreHere,
//                 textAlign: TextAlign.center,
//                 style: TextStyles.title1.copyWith(
//                   fontSize: 16.0,
//                   fontWeight: FontWeight.w500,
//                 ),
//               ),
//             ),
//             Padding(
//               padding: EdgeInsets.symmetric(
//                   horizontal: Insets.lg, vertical: Insets.xl),
//               child: DottedBorder(
//                 dashPattern: const [6, 3],
//                 color: AppTheme.darkYellow,
//                 strokeWidth: 1,
//                 strokeCap: StrokeCap.round,
//                 borderType: BorderType.RRect,
//                 radius: Radius.circular(Insets.med),
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.all(Radius.circular(12)),
//                   child: Container(
//                       height: Insets.offsetMed * 1.3,
//                       padding: EdgeInsets.all(Insets.lg),
//                       child: Center(
//                         child: Column(
//                           children: [
//                             Text(
//                               Strings.doNotWorry,
//                               textAlign: TextAlign.center,
//                               style: TextStyles.title1.copyWith(
//                                   fontSize: 18.0,
//                                   color: AppTheme.elSalva,
//                                   fontWeight: FontWeight.w400,
//                                   letterSpacing: 1),
//                             ),
//                             const Text(
//                               Strings.refundOrReturn,
//                               textAlign: TextAlign.center,
//                               style: TextStyle(
//                                   fontSize: 22.0,
//                                   color: AppTheme.elSalva,
//                                   fontWeight: FontWeight.w800,
//                                   letterSpacing: 1),
//                             ),
//                           ],
//                         ),
//                       )),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: Insets.lg,
//             ),
//             Padding(
//               padding: EdgeInsets.all(Insets.lg),
//               child: Text(
//                 Strings.stillWorried,
//                 textAlign: TextAlign.center,
//                 style: TextStyles.title1.copyWith(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.w500,
//                     letterSpacing: 1),
//               ),
//             ),
//             GestureDetector(
//               behavior: HitTestBehavior.translucent,
//               onTap: () => onPhoneButtonTapped(),
//               child: Center(
//                 child: Container(
//                   width: Insets.xxl * 1.4,
//                   height: Insets.xxl * 1.4,
//                   decoration: BoxDecoration(
//                     border: Border.all(
//                         width: Insets.xs * 0.6, color: AppTheme.buttonColor),
//                     shape: BoxShape.circle,
//                     color: AppTheme.white,
//                   ),
//                   child: Center(
//                     child: SvgPicture.asset(
//                       "assets/images/phone.svg",
//                       height: Insets.xl * 0.8,
//                       color: AppTheme.buttonColor,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: Insets.xxl,
//             )
//           ],
//         ),
//       ),
//     );
//   }
//
//   onPhoneButtonTapped() {
//     try {
//       canLaunchUrl(Uri(scheme: 'tel', path: '123')).then((bool result) async {
//         final Uri launchUri = Uri(
//           scheme: 'tel',
//           path: numberToCall,
//         );
//         await launchUrl(launchUri);
//       });
//     } catch (e) {
//       ScaffoldMessenger.of(context)
//           .showSnackBar(const SnackBar(content: Text("Something went wrong")));
//     }
//   }
// }
