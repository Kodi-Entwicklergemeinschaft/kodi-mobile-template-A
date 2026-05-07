part of '../common_components.dart';

class ListingCard extends StatelessWidget {
  final String? imageUrl;
  final String? searchedString;
  final String? distance;
  final String? name;
  final String? address;
  final String? todayOpeningStatus;
  final String? hours;
  final VoidCallback? onTap;
  final VoidCallback? onTapFavourite;
  final bool? isFavourite;
  final Color? headerColor;
  final String? imageLabel;
  final int? nameMaxLine;
  final bool? isKodiWeekCard;
  final bool hideImage;

  const ListingCard({
    super.key,
    this.imageUrl,
    this.searchedString,
    this.distance,
    this.name,
    this.address,
    this.todayOpeningStatus,
    this.hours,
    this.onTap,
    this.isFavourite,
    this.onTapFavourite,
    this.headerColor,
    required this.imageLabel,
    this.nameMaxLine,
    this.isKodiWeekCard,
    this.hideImage = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        // height: 120.iY,
        color: Colors.transparent,
        padding: EdgeInsets.symmetric(vertical: 8.iY),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 10.iX,
          children: [
            if (!hideImage) SizedBox(width: 160.iX, child: _buildImage()),
            Expanded(child: _buildDetails(context)),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.iX),
      child: CommonImage(
        imagePath: imageUrl ?? "",
        label: imageLabel ?? "listing_image_label",
        fit: BoxFit.cover,
        height: 120.iY,
      ),
    );
  }

  Widget _buildDetails(BuildContext context) {
    bool isDarkMode = Theme
        .of(context)
        .brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.iY,
      children: [
        // distance badge
        if (distance != null && distance!.isNotEmpty)
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.iX, vertical: 3.iY),
            decoration: BoxDecoration(
              color: (isDarkMode && isKodiWeekCard != null && isKodiWeekCard!)
                  ? Colors.white
                  : headerColor ?? AppColors.shoppingTitleBackground,
              borderRadius: BorderRadius.circular(10.iX),
            ),
            child: CommonText(
              titleText: distance!,
              textStyle: TextStyle(
                  color: (isDarkMode && isKodiWeekCard != null &&
                      isKodiWeekCard!) ? headerColor ??
                      AppColors.shoppingTitleBackground : Colors.white,
                  fontSize: 14.iX),
            ),
          ),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // store name
            if (name != null)
              Expanded(
                child: HighlightText(
                  highlightColor: Theme
                      .of(context)
                      .primaryColor,
                  textAlign: TextAlign.start,
                  maxLines: (nameMaxLine != null) ? nameMaxLine : 1,
                  style: TextStyle(
                    fontSize: 16.iX,
                    fontWeight: FontWeight.w700,
                    color: Theme
                        .of(context)
                        .textTheme
                        .bodySmall
                        ?.color,
                  ),
                  source: name!,
                  query: searchedString,
                ),
              ),
            if (isFavourite != null)
              GestureDetector(
                onTap: onTapFavourite,
                behavior: HitTestBehavior.opaque,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(10.iX, 5.iY, 0, 5.iY),
                  child: CommonIcon(
                    icon: isFavourite! ? Icons.favorite : Icons.favorite_border,
                    size: 24.iY,
                    color: isFavourite! ? Colors.red : null,
                  ),
                ),
              ),
          ],
        ),

        // address row
        if (address != null)
          Row(
            children: [
              CommonIcon(icon: Icons.location_on, size: 15.iX),
              const SizedBox(width: 4),
              Expanded(
                child: CommonText(
                  textAlign: TextAlign.start,
                  titleText: address!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textStyle: TextStyle(
                    fontSize: 13.iX,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

        // status + hours
        if (todayOpeningStatus != null)
          Row(
            children: [
              CommonIcon(icon: Icons.access_time_filled, size: 15.iX),
              SizedBox(width: 4.iX),
              Expanded(
                child: CommonText(
                  overflow: TextOverflow.ellipsis,
                  titleText: "$todayOpeningStatus",
                  textAlign: TextAlign.start,
                  textStyle: TextStyle(
                    fontSize: 13.iX,
                    color: (isKodiWeekCard != null && isKodiWeekCard!)
                        ? (isDarkMode ? Colors.white : headerColor)
                        : headerColor ?? AppColors.pink,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
      ],
    );
  }
}
