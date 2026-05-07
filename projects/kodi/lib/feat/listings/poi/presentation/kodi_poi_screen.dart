import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:kodi/feat/listings/data/model/category_model.dart';
import 'package:kodi/feat/listings/data/model/listing_model.dart';
import 'package:kodi/feat/listings/poi/controller/poi_controller.dart';
import 'package:kodi/feat/listings/poi/controller/poi_state.dart';
import 'package:kodi/utils/app_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/go_router.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/theme.dart';

import 'widget/poi_bottom_sheet.dart';

/// A generic map screen that shows [category] listings as POI markers on an
/// OpenStreetMap base layer, with a draggable bottom sheet listing panel.
///
/// Designed to be reusable: pass any [CategoryModel] and optional [screenTitle]
/// to drive the content. The [themeColor] tints markers and UI accents.
class KodiPOIScreen extends ConsumerStatefulWidget {
  const KodiPOIScreen({
    super.key,
    required this.category,
    this.screenTitle,
  });

  final CategoryModel category;

  final String? screenTitle;

  @override
  ConsumerState<KodiPOIScreen> createState() => _KodiPOIScreenState();
}

class _KodiPOIScreenState extends ConsumerState<KodiPOIScreen> {
  final _mapController = MapController();
  final _sheetController = DraggableScrollableController();

  // Kodi city centre as the default map focus.
  static const LatLng _kodiCenter = LatLng(54.3233, 10.1228);
  static const double _defaultZoom = 10.5;

  Color get _themeColor =>
      widget.category.headerBackgroundColor?.hexToColor ?? AppColors.pink;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(poiControllerProvider.notifier).setCategory(widget.category);
    });
  }

  @override
  void dispose() {
    _mapController.dispose();
    _sheetController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(poiControllerProvider);
    final markers = _buildMarkers(state);

    return Scaffold(
      appBar: CommonAppBar(
        showBackButton: true,
        showTitleLogo: false,
        toolbarHeight: 100.iY,
        onBackPressed: () => context.pop(),
        title: Expanded(
          child: CommonText(
            titleText:
                widget.screenTitle ?? state.categoryModel?.name ?? widget.category.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            textStyle: TextStyle(
              fontSize: 18.iY,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _initialCenter(state),
              initialZoom: _defaultZoom,
              onTap: (_, __) {
                if (state.selectedMarker != null) {
                  ref
                      .read(poiControllerProvider.notifier)
                      .clearSelectedMarker();
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.kodi.app',
                maxZoom: 19,
              ),
              if (markers.isNotEmpty) MarkerLayer(markers: markers),
            ],
          ),
          SizedBox(height: 30.iY),
          DraggableScrollableSheet(
            controller: _sheetController,
            initialChildSize: 0.40,
            minChildSize: 0.40,
            maxChildSize: 0.85,
            snap: true,
            snapSizes: const [0.40, 0.85],
            builder: (context, scrollController) {
              return POIBottomSheet(
                scrollController: scrollController,
                sheetController: _sheetController,
                themeColor: _themeColor,
              );
            },
          ),
        ],
      ),
    );
  }

  List<Marker> _buildMarkers(POIState poiState) {
    return poiState.listings
        .where((l) => l.geoLat != null && l.geoLng != null)
        .map((l) => _markerFor(l, poiState.selectedMarker))
        .toList();
  }

  Marker _markerFor(ListingModel listing, ListingModel? selected) {
    final isSelected = selected?.id == listing.id;
    final color = isSelected ? AppColors.pink : _themeColor;
    final size = isSelected ? 48.0 : 36.0;

    return Marker(
      point: LatLng(listing.geoLat!, listing.geoLng!),
      width: size,
      height: size,
      child: GestureDetector(
        onTap: () => _onMarkerTap(listing),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(60),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.location_on,
            color: Colors.white,
            size: isSelected ? 26 : 20,
          ),
        ),
      ),
    );
  }

  void _onMarkerTap(ListingModel listing) {
    ref.read(poiControllerProvider.notifier).selectMarker(listing);

    // _mapController.move(
    //   LatLng(listing.geoLat!, listing.geoLng!),
    //   15.0,
    // );
    if (_sheetController.isAttached) {
      _sheetController.animateTo(
        0.40,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  LatLng _initialCenter(POIState poiState) {
    final first = poiState.listings.cast<ListingModel?>().firstWhere(
          (l) => l?.geoLat != null && l?.geoLng != null,
          orElse: () => null,
        );
    if (first != null) return LatLng(first.geoLat!, first.geoLng!);
    return _kodiCenter;
  }
}