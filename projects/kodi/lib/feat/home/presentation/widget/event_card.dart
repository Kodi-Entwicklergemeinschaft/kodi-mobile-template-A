import 'package:common_components/common_components.dart';
import 'package:flutter/material.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:theme/theme.dart';
// import 'package:locale/app_localization.dart'; // Unused import

class EventCard extends StatelessWidget {
  const EventCard({
    super.key,
    required this.imageUrl,
    this.onTapOnFavourite,
    this.onTap,
    required this.dateRange,
    required this.title,
    required this.location,
    required this.isFavourite,
  });

  final String imageUrl;
  final VoidCallback? onTapOnFavourite;
  final VoidCallback? onTap;
  final String dateRange;
  final String title;
  final String location;
  final bool isFavourite;

  @override
  Widget build(BuildContext context) {
    // Use Card or a Material widget for elevation and clipping
    return Card(
      margin: EdgeInsets.only(right: 12.iX),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.iY),
      ),
      color: AppColors.eventCategoryBackground,
      clipBehavior: Clip.antiAlias, // Ensures content respects the border radius
      child: InkWell(
        onTap: onTap,
        child: SizedBox(
          width: 160.iX,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize.min is important if the card is in a row that might stretch it
            mainAxisSize: MainAxisSize.min,
            children: [
              _EventImage(
                imageUrl: imageUrl,
                isFavourite: isFavourite,
                onTapOnFavourite: onTapOnFavourite,
              ),
              _EventDetails(
                dateRange: dateRange,
                title: title,
                location: location,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Private widget for the image section
class _EventImage extends StatelessWidget {
  const _EventImage({
    required this.imageUrl,
    required this.isFavourite,
    this.onTapOnFavourite,
  });

  final String imageUrl;
  final bool isFavourite;
  final VoidCallback? onTapOnFavourite;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100.iY,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          CommonImage(
            imagePath: imageUrl,
            fit: BoxFit.cover,
            // The borderRadius is now handled by the parent Card's clipBehavior
            cacheHeight: (90 * MediaQuery.of(context).devicePixelRatio).round(),
            cacheWidth: (160 * MediaQuery.of(context).devicePixelRatio).round(),
          ),
          if (onTapOnFavourite != null)
            Positioned(
              top: 4.iY,
              right: 4.iX,
              child: _FavoriteButton(
                isFavourite: isFavourite,
                onTap: onTapOnFavourite!,
              ),
            ),
        ],
      ),
    );
  }
}

// Private widget for the favorite button to improve semantics and hit area
class _FavoriteButton extends StatelessWidget {
  const _FavoriteButton({required this.isFavourite, required this.onTap});

  final bool isFavourite;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: IconButton(
        onPressed: onTap,
        icon: Icon(
          isFavourite ? Icons.favorite : Icons.favorite_border,
          color: isFavourite ? Colors.red : Colors.white,
        ),
        iconSize: 24.iY,
        splashRadius: 20.iY,
        // Visual feedback for the tap
        constraints: const BoxConstraints(), // Removes extra padding
        tooltip: isFavourite ? 'Remove from favorites' : 'Add to favorites',
      ),
    );
  }
}


// Private widget for the text details section
class _EventDetails extends StatelessWidget {
  const _EventDetails({
    required this.dateRange,
    required this.title,
    required this.location,
  });

  final String dateRange;
  final String title;
  final String location;

  @override
  Widget build(BuildContext context) {
    // Assuming you have text styles defined in your theme
    final textTheme = Theme.of(context).textTheme;
    final primaryColor = AppColors.white; // Or get from theme

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.iX, vertical: 8.iY),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CommonText(
            titleText: dateRange,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            // Prefer using theme styles for consistency
            textStyle: textTheme.bodySmall?.copyWith(fontSize: 12.iY, color: primaryColor),
          ),
          SizedBox(height: 4.iY),
          SizedBox(
            height: 38.iY,
            child: CommonText(
              titleText: title,
              maxLines: 2,
              textAlign: TextAlign.start,
              overflow: TextOverflow.ellipsis,
              textStyle: textTheme.titleMedium?.copyWith(
                  fontSize: 14.iY,
                  fontWeight: FontWeight.bold,
                  color: primaryColor),
            ),
          ),
          SizedBox(height: 6.iY),
          // Row(
          //   children: [
          //     CommonIcon(
          //       icon: Icons.location_on,
          //       size: 12.iY,
          //       color: primaryColor,
          //     ),
          //     SizedBox(width: 4.iX),
          //     Expanded(
          //       child: CommonText(
          //         titleText: location,
          //         maxLines: 1,
          //         overflow: TextOverflow.ellipsis,
          //         textStyle: textTheme.bodySmall?.copyWith(fontSize: 12.iY, color: primaryColor),
          //       ),
          //     ),
          //   ],
          // ),
        ],
      ),
    );
  }
}
