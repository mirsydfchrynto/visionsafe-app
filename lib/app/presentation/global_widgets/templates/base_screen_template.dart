import 'package:flutter/material.dart';
import 'package:visionsafe/app/core/values/app_design.dart';
import 'package:visionsafe/app/presentation/global_widgets/molecules/v_immersive_background.dart';

/// BaseScreenTemplate: World-Class template for all VisionSafe screens.
/// Features AAA immersive layered background, strict SafeArea, and elastic physics.
class BaseScreenTemplate extends StatelessWidget {
  final Widget child;
  final PreferredSizeWidget? appBar;
  final Widget? bottomNavigationBar;
  final Widget? floatingActionButton;
  final bool usePadding;
  final bool extendBodyBehindAppBar;
  final ScrollPhysics? physics;
  final List<Widget>? stackLayers;
  final double bottomPadding;

  const BaseScreenTemplate({
    super.key,
    required this.child,
    this.appBar,
    this.bottomNavigationBar,
    this.floatingActionButton,
    this.usePadding = true,
    this.extendBodyBehindAppBar = false, // Changed to false for stability
    this.physics = const BouncingScrollPhysics(),
    this.stackLayers,
    this.bottomPadding = 180.0,
  });

  @override
  Widget build(BuildContext context) {
    return VImmersiveBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: appBar,
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        extendBody: true,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: physics,
              clipBehavior: Clip.none,
              child: SafeArea(
                top: appBar == null, // Safe area only if no app bar
                bottom: false,
                child: Padding(
                  padding: (usePadding ? AppDesign.screenPadding : EdgeInsets.zero).copyWith(
                    top: appBar != null ? AppDesign.space16 : AppDesign.spaceM,
                    bottom: bottomPadding,
                  ),
                  child: child,
                ),
              ),
            ),
            if (stackLayers != null) ...stackLayers!,
          ],
        ),
        bottomNavigationBar: bottomNavigationBar,
        floatingActionButton: floatingActionButton,
      ),
    );
  }
}
