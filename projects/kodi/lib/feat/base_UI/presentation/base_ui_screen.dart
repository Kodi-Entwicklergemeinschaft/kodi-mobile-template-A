import 'package:flutter/material.dart';
import 'package:kodi/common_widget.dart';
import 'package:kodi/feat/base_UI/controller/base_ui_controller.dart';
import 'package:locale/app_localization.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

class BaseUI extends ConsumerStatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget body;
  final Widget? floatingActionButtonUI;
  final Widget? emptyScreenTile;
  final bool isLoadingText;
  final bool extendBody;
  final bool drawerEnableOpenDragGesture;
  final Widget? drawer;
  final Color? backgroundColor;
  final bool? resizeToAvoidBottomInset;
  final bool isInitialLoading;
  final bool isStackLoading;
  final bool showBottomNavigationBar;
  final bool isSuccess;
  final String? message;
  final EdgeInsetsGeometry bodyPadding;

  const BaseUI({
    super.key,
    this.appBar,
    required this.body,
    this.emptyScreenTile,
    this.floatingActionButtonUI,
    this.isLoadingText = true,
    this.extendBody = false,
    this.drawerEnableOpenDragGesture = true,
    this.drawer,
    this.backgroundColor,
    this.resizeToAvoidBottomInset,
    this.isInitialLoading = false,
    this.isStackLoading = false,
    this.isSuccess = true,
    this.showBottomNavigationBar = false,
    this.message,
    this.bodyPadding = const EdgeInsets.all(8),
  });

  @override
  ConsumerState<BaseUI> createState() => _BaseUIState();
}

class _BaseUIState extends ConsumerState<BaseUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
      drawer: widget.drawer,
      backgroundColor: widget.backgroundColor,
      extendBody: widget.extendBody,
      drawerEnableOpenDragGesture: widget.drawerEnableOpenDragGesture,
      appBar: widget.appBar,
      body: baseUIBody(),
      floatingActionButton: widget.floatingActionButtonUI,
    );
  }

  Widget? baseUIBody() {
    if (widget.isInitialLoading) {
      return CircularProgressIndicator();
    } else if (widget.isStackLoading) {
      return IgnorePointer(
        child: Stack(
          children: [
            Padding(padding: widget.bodyPadding, child: widget.body),
            Center(child: CircularProgressIndicator()),
            Container(
              height: double.infinity,
              width: double.infinity,
              // color: Colors.black.withAlpha((0.3*255).toInt()),
            ),
          ],
        ),
      );
    } else if (widget.isSuccess) {
      return Padding(padding: widget.bodyPadding, child: widget.body);
    } else {
      return Text(
        widget.message ?? 'general_err_message'.tr(context),
        textAlign: TextAlign.center,
      );
    }
  }
}
