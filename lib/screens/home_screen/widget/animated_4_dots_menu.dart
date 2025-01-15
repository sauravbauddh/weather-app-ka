// import 'dart:io';
//
// import 'package:consumer_flutter_app/network/shared_prefs.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// import '../../../styles.dart';
// import '../../../themes.dart';
//
// enum DotLocation { topLeft, bottomLeft, bottomRight, topRight }
//
// class Animated4DotsMenu extends StatefulWidget {
//   const Animated4DotsMenu({
//     this.initalActiveLocation,
//     this.onTabChange,
//     Key? key,
//   }) : super(key: key);
//   final DotLocation? initalActiveLocation;
//   final void Function(int)? onTabChange;
//
//   @override
//   State<Animated4DotsMenu> createState() => _Animated4DotsMenuState();
// }
//
// class _Animated4DotsMenuState extends State<Animated4DotsMenu>
//     with SingleTickerProviderStateMixin {
//   bool expanded = true;
//   DotLocation? activeLocation;
//
//   @override
//   void initState() {
//     activeLocation = widget.initalActiveLocation;
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: MediaQuery.of(context).size.width,
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           SizedBox(
//             width: double.infinity,
//             height: 60,
//             child: LayoutBuilder(builder: (context, constraints) {
//               final height = constraints.maxHeight;
//               final width = constraints.maxWidth;
//               const smallPadding = 0.75;
//               const smallRadius = 8.0;
//
//               final bigPadding = Insets.xs - 1;
//               const bigRadius = 21.0;
//
//               return GestureDetector(
//                 onTap: () => setState(() => expanded = !expanded),
//                 behavior: HitTestBehavior.translucent,
//                 child: Stack(
//                   children: <Widget>[
//                     dot(
//                       key: const Key('green'),
//                       location: DotLocation.topLeft,
//                       smallDotRadius: smallRadius,
//                       smallDotPadding: smallPadding,
//                       bigDotRadius: bigRadius,
//                       bigDotPadding: bigPadding,
//                       imageColor: activeLocation == DotLocation.topLeft
//                           ? AppTheme.containerWhite
//                           : AppTheme.moneyGreen,
//                       borderColor: AppTheme.moneyGreen,
//                       backgroundColor: activeLocation == DotLocation.topLeft
//                           ? AppTheme.moneyGreen
//                           : AppTheme.containerWhite,
//                       imagePath: "assets/images/money.svg",
//                       menuHeight: height,
//                       menuWidth: width,
//                     ),
//                     dot(
//                       key: const Key('red'),
//                       location: DotLocation.topRight,
//                       smallDotRadius: smallRadius,
//                       smallDotPadding: smallPadding,
//                       bigDotRadius: bigRadius,
//                       bigDotPadding: bigPadding,
//                       imageColor: activeLocation == DotLocation.topRight
//                           ? AppTheme.containerWhite
//                           : AppTheme.redPersonal,
//                       borderColor: AppTheme.redPersonal,
//                       backgroundColor: activeLocation == DotLocation.topRight
//                           ? AppTheme.redPersonal
//                           : AppTheme.containerWhite,
//                       imagePath: "assets/images/personal.svg",
//                       menuHeight: height,
//                       menuWidth: width,
//                     ),
//                     dot(
//                       key: const Key('brown'),
//                       location: DotLocation.bottomRight,
//                       smallDotRadius: smallRadius,
//                       smallDotPadding: smallPadding,
//                       bigDotRadius: bigRadius,
//                       bigDotPadding: bigPadding,
//                       imageColor: activeLocation == DotLocation.bottomRight
//                           ? AppTheme.containerWhite
//                           : AppTheme.everythingElseBrown,
//                       borderColor: AppTheme.everythingElseBrown,
//                       backgroundColor: activeLocation == DotLocation.bottomRight
//                           ? AppTheme.everythingElseBrown
//                           : AppTheme.containerWhite,
//                       imagePath: "assets/images/everything_else.svg",
//                       menuHeight: height,
//                       menuWidth: width,
//                     ),
//                     dot(
//                       key: const Key('blue'),
//                       location: DotLocation.bottomLeft,
//                       smallDotRadius: smallRadius,
//                       smallDotPadding: smallPadding,
//                       bigDotRadius: bigRadius,
//                       bigDotPadding: bigPadding,
//                       imageColor: activeLocation == DotLocation.bottomLeft
//                           ? AppTheme.containerWhite
//                           : AppTheme.blueHelp,
//                       borderColor: AppTheme.blueHelp,
//                       backgroundColor: activeLocation == DotLocation.bottomLeft
//                           ? AppTheme.blueHelp
//                           : AppTheme.containerWhite,
//                       imagePath: "assets/images/help_support.svg",
//                       menuHeight: height,
//                       menuWidth: width,
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//         ],
//       ),
//     );
//   }
//
//   Widget dot({
//     required Key key,
//     required DotLocation location,
//     required double smallDotRadius,
//     required double bigDotRadius,
//     required double menuHeight,
//     required double smallDotPadding,
//     required double bigDotPadding,
//     required double menuWidth,
//     required String imagePath,
//     required Color backgroundColor,
//     required Color imageColor,
//     required Color borderColor,
//     void Function()? callBack,
//     Duration animationDuration = const Duration(milliseconds: 200),
//   }) {
//     final bigPaddedRadius = bigDotRadius + bigDotPadding;
//     final smallPaddedRadius = smallDotRadius + smallDotPadding;
//     late final double smallY;
//     late final double smallX;
//     late final double bigY;
//     late final double bigX;
//
//     switch (location) {
//       case DotLocation.topLeft:
//         bigY = menuHeight / 2 - bigPaddedRadius;
//         smallY = menuHeight / 2 - smallPaddedRadius;
//         bigX = menuWidth / 2 - 4 * bigPaddedRadius;
//         smallX = menuWidth / 2 - 2 * smallPaddedRadius;
//         break;
//       case DotLocation.topRight:
//         bigY = menuHeight / 2 - bigPaddedRadius;
//         smallY = menuHeight / 2 - smallPaddedRadius;
//         bigX = menuWidth / 2 + 2 * bigPaddedRadius;
//         smallX = menuWidth / 2 + smallDotPadding;
//         break;
//       case DotLocation.bottomRight:
//         bigY = menuHeight / 2 - bigPaddedRadius;
//         smallY = menuHeight / 2 + smallPaddedRadius;
//         bigX = menuWidth / 2;
//         smallX = menuWidth / 2 + smallDotPadding;
//         break;
//       case DotLocation.bottomLeft:
//         bigY = menuHeight / 2 - bigPaddedRadius;
//         smallY = menuHeight / 2 + smallPaddedRadius;
//         bigX = menuWidth / 2 - 2 * bigPaddedRadius;
//         smallX = menuWidth / 2 - 2 * smallPaddedRadius;
//         break;
//     }
//
//     return AnimatedPositioned(
//       key: key,
//       width: expanded ? bigDotRadius * 2 : smallDotRadius * 2,
//       height: expanded ? bigDotRadius * 2 : smallDotRadius * 2,
//       top: expanded ? bigY : smallY,
//       left: expanded ? bigX : smallX,
//       duration: animationDuration,
//       curve: Curves.fastOutSlowIn,
//       child: GestureDetector(
//         onTap: () {
//           setState(() => expanded = !expanded);
//           if (!expanded) {
//             activeLocation = location;
//             if (widget.onTabChange != null) widget.onTabChange!(location.index);
//             if(location.index == 1){
//               _launchWhatsapp(context);
//             }else{
//               callBack?.call();
//             }
//           }
//         },
//         child: Container(
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.all(Radius.circular(bigDotRadius)),
//             border: Border.all(
//               width: bigDotPadding * 0.5,
//               color: borderColor,
//               style: BorderStyle.solid,
//             ),
//             color: backgroundColor,
//           ),
//           child: AnimatedOpacity(
//             duration: animationDuration,
//             opacity: expanded ? 1 : 0,
//             child: Transform.scale(
//               scale: 0.65,
//               child: SvgPicture.asset(
//                 imagePath,
//                 color: imageColor,
//                 fit: BoxFit.scaleDown,
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   _launchWhatsapp(BuildContext context) async {
//     // var whatsappUri =
//     // Uri.parse("whatsapp://send?phone=+91$whatsappNumber&text=Hello");
//     String numberToCall = (await SharedPref.getHelpNumber())!;
//     var whatsappUri =
//     Uri.parse("whatsapp://send?phone=+91$numberToCall&text=Hello");
//
//     var whatsAppUrlIos = Uri.parse(
//         "https://wa.me/+91$numberToCall?text=${Uri.parse("Hello")}");
//     if (Platform.isIOS) {
//       // for iOS phone only
//       try {
//         await launchUrl(whatsAppUrlIos);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Whatsapp not installed")));
//       }
//     } else {
//       try {
//         await launchUrl(whatsappUri);
//       } catch (e) {
//         ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("Whatsapp not installed")));
//       }
//     }
//   }
// }
