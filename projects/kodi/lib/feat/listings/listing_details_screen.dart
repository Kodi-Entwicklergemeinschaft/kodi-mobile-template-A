import 'package:common_components/common_components.dart';
import 'package:common_components/extensions/string_extension.dart';
import 'package:flutter/material.dart';
import 'package:kodi/feat/listings/common_methods.dart';
import 'package:kodi/feat/auth/login/controller/login_controller.dart';
import 'package:kodi/feat/listings/favourite/controller/favourite_controller.dart';
import 'package:kodi/utils/common_methods.dart';
import 'package:local_storage/preference_manager_impl.dart';
import 'package:locale/app_localization.dart';
import 'package:scaling_dep/mobile_size_utils.dart';
import 'package:shared_dependencies/add_to_calandar.dart';
import 'package:shared_dependencies/flutter_html.dart';
import 'package:shared_dependencies/intl.dart';
import 'package:shared_dependencies/riverpod.dart';
import 'package:theme/extension/app_container_colors.dart';
import 'package:theme/extension/app_text_colors.dart';
import 'package:theme/theme.dart';
import '../../utils/app_launcher_utils.dart';
import '../../utils/app_pref_keys.dart';
import '../../utils/config/image.dart';
import 'data/model/listing_model.dart';

class ListingDetailsScreen extends ConsumerStatefulWidget {
  final ListingModel event;
  final Color? headerBackgroundColor;
  final bool? isShopping;
  final String? searchedText;
  final bool? isKodiWeekListing;
  final bool hideImage;

  const ListingDetailsScreen({
    super.key,
    required this.event,
    this.headerBackgroundColor,
    this.isShopping = false,
    this.searchedText = '',
    this.isKodiWeekListing,
    this.hideImage = false,
  });

  @override
  ConsumerState<ListingDetailsScreen> createState() =>
      _ListingDetailsScreenState();
}

class _ListingDetailsScreenState extends ConsumerState<ListingDetailsScreen> {
  bool isFavourite = false;

  @override
  void initState() {
    isFavourite = widget.event.isFavorite ?? false;
    super.initState();
  }

  toggleFavourite() async {
    setState(() {
      isFavourite = !isFavourite;
    });
    ref
        .read(favouriteControllerProvider.notifier)
        .updateFavoriteStatus(widget.event.id!, isFavourite);
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final isGuestUser = ref
        .watch(preferenceManagerProvider)
        .getBool(AppPrefsKeys.isGuestUser);
    return Scaffold(
      appBar: AppBar(
        leading: Padding(
          padding: EdgeInsets.only(left: 16.iX),
          child: CommonIcon(
            icon: Icons.arrow_back_ios_rounded,
            label: 'back_button_label'.tr(context),
            onPressed: () => Navigator.pop(context),
          ),
        ),
        elevation: 0,
        title: const CommonText(titleText: ""),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 10.iX, vertical: 10.iY),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 12.iY,
          children: [
            /// IMAGE
            if (!widget.hideImage)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: _ImageSection(
                imageUrls: [
                  if (widget.event.heroImageUrl != null)
                    widget.event.heroImageUrl,
                  if (widget.event.media != null &&
                      widget.event.media!.isNotEmpty)
                    ...widget.event.media!
                        .map((m) => m.url)
                        .whereType<String>(),
                ].whereType<String>().toList(),
              ),
            ),

            // distance badge
            if (widget.event.distance != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.iX),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.iX,
                    vertical: 3.iY,
                  ),
                  decoration: BoxDecoration(
                    color: (isDarkMode &&
                        widget.isKodiWeekListing != null &&
                        widget.isKodiWeekListing!)
                        ? Colors.white : widget.headerBackgroundColor,
                    borderRadius: BorderRadius.circular(10.iX),
                  ),
                  child: CommonText(
                    titleText: "${((widget.event.distance ?? 0) / 1000).toStringAsFixed(2)} km",
                    textStyle: TextStyle(color: (isDarkMode &&
                        widget.isKodiWeekListing != null &&
                        widget.isKodiWeekListing!)
                        ? Colors.black : Colors.white, fontSize: 16.8.iX),
                  ),
                ),
              ),

            /// Title
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: HighlightText(
                      highlightColor: Theme.of(context).primaryColor,
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontSize: 24.iY,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).textTheme.bodySmall?.color,
                      ),
                      source: widget.event.title ?? "",
                      query: widget.searchedText,
                    ),
                  ),
                  GestureDetector(
                    onTap: isGuestUser
                        ? () {
                            CommonMethods.showInfoDialog(
                              context,
                              'login_to_enable_feature'.tr(context),
                              onTapText: 'register'.tr(context),
                              onTap: () {
                                ref.read(loginProvider.notifier).logout();
                              },
                              onCancel: () {},
                            );
                          }
                        : toggleFavourite,
                    behavior: HitTestBehavior.opaque,
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(10.iX, 5.iY, 0, 5.iY),
                      child: CommonIcon(
                        icon: isFavourite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        size: 28.8.iY,
                        color: isFavourite
                            ? Colors.red
                            : Theme.of(context).extension<AppTextColors>()!.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            /// Address
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: InkWell(
                onTap: () {
                  AppLauncherUtils.openMap(
                    widget.event.geoLat!,
                    widget.event.geoLng!,
                  );
                },
                child: Row(
                  children: [
                    CommonIcon(
                      icon: Icons.location_on,
                      label: 'common_icon_label'
                          .tr(context)
                          .replaceAll('{itemName}', "address".tr(context)),
                      size: 21.6.iY,
                    ),
                    SizedBox(width: 4.iX),
                    Expanded(
                      child: CommonText(
                        textAlign: TextAlign.start,
                        titleText:
                            widget.event.address ?? ('no_address').tr(context),
                        textStyle: TextStyle(
                          fontSize: 16.8.iY,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            /// Date and Time
            if (widget.isShopping! == false &&
                widget.event.eventStart.isNotNullAndEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.iX),
                child: InkWell(
                  onTap: () {
                    DateTime? startDate = ListingsMethods.toDateTime(
                      widget.event.eventStart!,
                    );
                    DateTime? endDate = ListingsMethods.toDateTime(
                      widget.event.eventEnd!,
                    );
                    try {
                      if (startDate != null && endDate != null) {
                        AddToCalendar.addEventToCalendar(
                          title: widget.event.title ?? 'app_name'.tr(context),
                          startDate: startDate,
                          endDate: endDate,
                        );
                      } else {
                        AppSnackBar.showError(
                          context,
                          'invalid_date_range'.tr(context),
                        );
                      }
                    } catch (e) {
                      print(e);
                    }
                  },
                  child: Row(
                    children: [
                      CommonIcon(
                        icon: Icons.access_time_filled,
                        label: 'common_icon_label'
                            .tr(context)
                            .replaceAll('{itemName}', "date".tr(context)),
                        size: 21.6.iY,
                      ),
                      SizedBox(width: 8.iX),
                      Expanded(
                        child: CommonText(
                          textAlign: TextAlign.start,
                          titleText:
                              "${ListingsMethods.formatDate(widget.event.eventStart)} - ${ListingsMethods.formatTime(widget.event.eventStart)} ${"to".tr(context)} ${ListingsMethods.formatDate(widget.event.eventEnd)} - ${ListingsMethods.formatTime(widget.event.eventEnd)}",
                          textStyle: TextStyle(
                            fontWeight: FontWeight.bold,
                            color:
                                (isDarkMode &&
                                    widget.isKodiWeekListing != null &&
                                    widget.isKodiWeekListing!)
                                ? Colors.white
                                : widget.headerBackgroundColor ??
                                      AppColors.pink,
                            fontSize: 16.8.iY,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            /// Opening Hours display and popup trigger
            if (widget.event.timeIntervals != null &&
                widget.event.timeIntervals!.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.iX),
                child: InkWell(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0.iY),
                        ),
                        child: OpeningHoursPopup(
                          timeIntervals: widget.event.timeIntervals!,
                        ),
                      ),
                    );
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CommonIcon(
                        icon: Icons.access_time_filled,
                        label: 'common_icon_label'
                            .tr(context)
                            .replaceAll('{itemName}', "time".tr(context)),
                        size: 21.6.iY,
                      ),
                      SizedBox(width: 8.iX),
                      CommonText(
                        textAlign: TextAlign.start,
                        titleText: ListingsMethods.getTodayOpeningHours(
                          context,
                          widget.event.timeIntervals!,
                        ),
                        textStyle: TextStyle(
                          fontWeight: FontWeight.bold,
                          color:
                              (isDarkMode &&
                                  widget.isKodiWeekListing != null &&
                                  widget.isKodiWeekListing!)
                              ? Colors.white
                              : widget.headerBackgroundColor ?? AppColors.pink,
                          fontSize: 16.8.iY,
                        ),
                      ),
                      SizedBox(width: 4.iX),
                      CommonIcon(
                        icon: Icons.arrow_forward_ios_rounded,
                        color: (isDarkMode &&
                                widget.isKodiWeekListing != null &&
                                widget.isKodiWeekListing!)
                            ? Colors.white
                            : widget.headerBackgroundColor ?? AppColors.pink,
                        label: 'common_icon_label'
                            .tr(context)
                            .replaceAll('{itemName}', "show_all".tr(context)),
                        size: 16.8.iY,
                      ),
                    ],
                  ),
                ),
              ),

            /// Tags
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: Wrap(
                spacing: 8.iX,
                runSpacing: 8.iY,
                children:
                    widget.event.tags?.map((tag) {
                      return _ChipLabel(
                        tag.label ?? "",
                        widget.headerBackgroundColor ?? AppColors.pink,
                        widget.isKodiWeekListing ?? false
                      );
                    }).toList() ??
                    [],
              ),
            ),

            /// Description
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: HighlightText(
                highlightColor: Theme.of(context).primaryColor,
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 18.iY,
                  height: 1.5,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).textTheme.bodySmall?.color,
                ),
                source: widget.event.summary ?? ('no_description').tr(context),
                query: widget.searchedText,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: Html(
                onLinkTap: (url, _, __) {
                  if (url != null) {
                    AppLauncherUtils.openWebsite(context, url: url, title: url);
                  }
                },
                data: highlightSearchText(
                  html: widget.event.content ?? ('no_description').tr(context),
                  query: widget.searchedText ?? "", // your search keyword
                ),
                // data: widget.event.content ?? ('no_description').tr(context),
                style: {
                  "body": Style(
                    margin: Margins.zero,
                    padding: HtmlPaddings.zero,
                    fontSize: FontSize(18),
                  ),
                  "mark": Style(
                    backgroundColor: Theme.of(context).primaryColor,
                    color: Theme.of(context).textTheme.bodySmall?.color,
                  ),
                  'a': Style(textDecoration: TextDecoration.none, fontSize: FontSize(24),),
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.iX),
              child: Column(
                children: [
                  if (widget.event.onlineAppointmentUrl != null)
                    AppButton(
                      "book_appointment".tr(context),
                      size: ButtonSize.small,
                      backgroundColor: AppColors.adminstrationTitleBackground,
                      onPressed: () {
                        AppLauncherUtils.openWebsite(
                          context,
                          url: widget.event.onlineAppointmentUrl!,
                          title: widget.event.onlineAppointmentUrl!,
                        );
                      },
                    ),
                  SizedBox(height: 10.iY),
                ],
              ),
            ),

            /// Contact details
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.iX),
              child: Column(
                spacing: 12.iY,
                children: [
                  if (widget.event.website.isNotNullAndEmpty)
                    _ContactItem(
                      icon: Icons.home_rounded,
                      text: widget.event.website!,
                      onTap: () {
                        AppLauncherUtils.openWebsite(
                          context,
                          url: widget.event.website!,
                          title: widget.event.website!,
                        );
                      },
                    ),
                  if (widget.event.contactEmail.isNotNullAndEmpty)
                    _ContactItem(
                      icon: Icons.email,
                      text: widget.event.contactEmail!,
                      onTap: () {
                        AppLauncherUtils.openEmail(widget.event.contactEmail!);
                      },
                    ),
                  if (widget.event.contactPhone.isNotNullAndEmpty)
                    _ContactItem(
                      icon: Icons.phone,
                      text: widget.event.contactPhone!,
                      onTap: () {
                        AppLauncherUtils.openDialer(widget.event.contactPhone!);
                      },
                    ),

                  // _ContactItem(
                  //   icon: Icons.location_on,
                  //   text: "navigation_start".tr(context),
                  //   onTap: () {
                  //     AppLauncherUtils.openMap(event.geoLat!, event.geoLng!);
                  //   },
                  //   isTextBold: true,
                  // ),
                ],
              ),
            ),
            SizedBox(height: 5.iY),
            if (widget.event.geoLng != null && widget.event.geoLat != null)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10.iX),
                child: InkWell(
                  onTap: () {
                    AppLauncherUtils.openMap(
                      widget.event.geoLat!,
                      widget.event.geoLng!,
                    );
                  },
                  child: Row(
                    children: [
                      CommonIcon(
                        icon: Icons.location_on,
                        label: 'common_icon_label'
                            .tr(context)
                            .replaceAll('{itemName}', "location".tr(context)),
                        size: 42.iY,
                      ),
                      SizedBox(width: 4.iX),
                      Expanded(
                        child: CommonText(
                          textAlign: TextAlign.start,
                          titleText: ('navigation_start').tr(context),
                          textStyle: TextStyle(
                            fontSize: 16.8.iY,
                            decoration: TextDecoration.underline,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            SizedBox(height: 10.iY),
          ],
        ),
      ),
    );
  }
}

class _ChipLabel extends StatelessWidget {
  final String text;
  final Color color;
  final bool isKeelWeek;

  const _ChipLabel(this.text, this.color, this.isKeelWeek);

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.iX, vertical: 6.iY),
      decoration: BoxDecoration(
        color: (isDarkMode && isKeelWeek) ? AppColors.white : color,
        borderRadius: BorderRadius.circular(10.iY),
      ),
      child: CommonText(
        textAlign: TextAlign.start,
        titleText: text,
        textStyle: TextStyle(
          color: (isDarkMode && isKeelWeek) ? Colors.black : AppColors.white,
          fontWeight: FontWeight.w600,
          fontSize: 15.6.iY,
        ),
      ),
    );
  }
}

class _ContactItem extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onTap;
  final bool isTextBold;

  const _ContactItem({
    required this.icon,
    required this.text,
    required this.onTap,
    this.isTextBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Row(
        children: [
          CircleAvatar(
            radius: 14.52.iY,
            backgroundColor: Theme.of(
              context,
            ).extension<AppContainerColors>()!.normal,
            child: CommonIcon(
              icon: icon,
              label: 'common_icon_label'
                  .tr(context)
                  .replaceAll('{itemName}', "contact".tr(context)),
              size: 24.2.iY,
            ),
          ),
          SizedBox(width: 8.iX),
          Expanded(
            child: CommonText(
              textAlign: TextAlign.start,
              titleText: text,
              overflow: TextOverflow.ellipsis,
              textStyle: TextStyle(
                fontSize: 18.15.iY,
                decoration: TextDecoration.underline,
                fontWeight: isTextBold ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImageSection extends StatefulWidget {
  final List<String> imageUrls;

  const _ImageSection({required this.imageUrls});

  @override
  State<_ImageSection> createState() => _ImageSectionState();
}

class _ImageSectionState extends State<_ImageSection> {
  final PageController _controller = PageController(viewportFraction: 1);

  @override
  void initState() {
    if (widget.imageUrls.isEmpty) {
      widget.imageUrls.add("");
    }
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        SizedBox(
          height: 240.iY,
          width: double.infinity,
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              final imageUrl = widget.imageUrls[index];
              return ClipRRect(
                borderRadius: BorderRadius.circular(12.iY),
                child: CommonImage(imagePath: imageUrl, fit: BoxFit.cover),
              );
            },
          ),
        ),
        if (widget.imageUrls.length > 1)
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.iX),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    InkWell(
                      onTap: () {
                        _controller.previousPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: CommonImage(imagePath: Images.backwardArrowIcon),
                    ),
                    InkWell(
                      onTap: () {
                        _controller.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      },
                      child: CommonImage(imagePath: Images.forwardArrowIcon),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class OpeningHoursPopup extends StatefulWidget {
  final List<TimeInterval>? timeIntervals;

  const OpeningHoursPopup({super.key, required this.timeIntervals});

  @override
  State<OpeningHoursPopup> createState() => _OpeningHoursPopupState();
}

class _OpeningHoursPopupState extends State<OpeningHoursPopup> {
  DateTime currentWeekStart = _startOfTheWeek(DateTime.now());

  static DateTime _startOfTheWeek(DateTime date) =>
      date.subtract(Duration(days: date.weekday - 1));

  String _formatTime(String? date) {
    if (date == null) return "";
    final dt = DateTime.parse(date).toLocal();
    return DateFormat("HH:mm").format(dt);
  }

  Map<String, String> buildScheduleForWeek(
    BuildContext context,
    DateTime weekStart,
  ) {
    final schedule = {
      "Monday": ('closed').tr(context),
      "Tuesday": ('closed').tr(context),
      "Wednesday": ('closed').tr(context),
      "Thursday": ('closed').tr(context),
      "Friday": ('closed').tr(context),
      "Saturday": ('closed').tr(context),
      "Sunday": ('closed').tr(context),
    };

    final weekEnd = DateTime(
      weekStart.year,
      weekStart.month,
      weekStart.day + 6,
      23,
      59,
      59,
    );

    for (final interval in widget.timeIntervals ?? []) {
      if (interval.start == null || interval.end == null) continue;

      final start = DateTime.parse(interval.start!).toLocal();
      final end = DateTime.parse(interval.end!).toLocal();

      // ----------------------------------------------------
      // 1️⃣ ONE-TIME EVENT (freq = NONE)
      // ----------------------------------------------------
      if (interval.freq == "NONE") {
        if (!start.isBefore(weekStart) && !start.isAfter(weekEnd)) {
          final weekdayStr = DateFormat('EEEE').format(start);

          schedule[weekdayStr] =
              "${DateFormat('HH:mm').format(start)} - ${DateFormat('HH:mm').format(end)}";
        }

        continue;
      }

      // ----------------------------------------------------
      // 2️⃣ WEEKLY RECURRING EVENT
      // ----------------------------------------------------
      if (interval.weekdays == null || interval.weekdays!.isEmpty) continue;

      DateTime? repeatUntil = interval.repeatUntil != null
          ? DateTime.parse(interval.repeatUntil!)
          : null;

      for (final weekday in interval.weekdays!) {
        final weekdayIndex = _weekdayToIndex(weekday);

        final targetDate = weekStart.add(Duration(days: weekdayIndex));

        // Skip if recurrence end reached
        if (repeatUntil != null && targetDate.isAfter(repeatUntil)) continue;

        // Apply time from the original interval
        final startTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          start.hour,
          start.minute,
        );

        final endTime = DateTime(
          targetDate.year,
          targetDate.month,
          targetDate.day,
          end.hour,
          end.minute,
        );

        schedule[weekday] =
            "${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)}";
      }
    }

    return schedule;
  }

  // Convert weekday string → index (Mon=0)
  int _weekdayToIndex(String day) {
    switch (day.toLowerCase()) {
      case "monday":
        return 0;
      case "tuesday":
        return 1;
      case "wednesday":
        return 2;
      case "thursday":
        return 3;
      case "friday":
        return 4;
      case "saturday":
        return 5;
      case "sunday":
        return 6;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final schedule = buildScheduleForWeek(context, currentWeekStart);
    final weekEnd = currentWeekStart.add(const Duration(days: 6));

    return Container(
      padding: EdgeInsets.all(16.iY),
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _circleButton(Icons.arrow_back, () {
                setState(() {
                  currentWeekStart = currentWeekStart.subtract(
                    const Duration(days: 7),
                  );
                });
              }, context),
              Flexible(
                child: CommonText(
                  textAlign: TextAlign.start,
                  titleText:
                      "${DateFormat('dd.MM.yyyy').format(currentWeekStart)} - "
                      "${DateFormat('dd.MM.yyyy').format(weekEnd)}",
                  textStyle: TextStyle(
                    fontSize: 19.2.iY,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              _circleButton(Icons.arrow_forward, () {
                setState(() {
                  currentWeekStart = currentWeekStart.add(
                    const Duration(days: 7),
                  );
                });
              }, context),
            ],
          ),
          SizedBox(height: 20.iY),
          Row(
            children: [
              Expanded(
                child: CommonText(
                  textAlign: TextAlign.start,
                  titleText: ('weekday').tr(context),
                  textStyle: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Expanded(
                child: CommonText(
                  textAlign: TextAlign.start,
                  titleText: ('time').tr(context),
                  textStyle: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          SizedBox(height: 10.iY),
          Flexible(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: schedule.length,
              itemBuilder: (context, index) {
                final dayKey = schedule.keys.toList()[index];
                final translatedDay = (dayKey.toLowerCase()).tr(context);
                final time = schedule[dayKey];

                return Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 12.iY,
                    horizontal: 8.iX,
                  ),
                  color: index % 2 == 0
                      ? Theme.of(
                          context,
                        ).scaffoldBackgroundColor.withValues(alpha: 2)
                      : null,
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonText(
                          textAlign: TextAlign.start,
                          titleText: translatedDay,
                          textStyle: TextStyle(fontSize: 16.8.iY),
                        ),
                      ),
                      Expanded(
                        child: CommonText(
                          textAlign: TextAlign.start,
                          titleText: time ?? ('closed').tr(context),
                          textStyle: TextStyle(
                            fontSize: 16.8.iY,
                            color: time == ('closed').tr(context)
                                ? Colors.red
                                : null,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _circleButton(
  IconData icon,
  VoidCallback onPressed,
  BuildContext context,
) {
  return InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(50.iY),
    child: Container(
      padding: EdgeInsets.all(10.iY),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Theme.of(context).focusColor,
      ),
      child: CommonIcon(
        icon: icon,
        label: 'common_icon_label'
            .tr(context)
            .replaceAll('{itemName}', "navigation".tr(context)),
        size: 26.4.iY,
      ),
    ),
  );
}

String highlightSearchText({required String html, required String query}) {
  if (query.isEmpty) return html;

  final escapedQuery = RegExp.escape(query);

  return html.replaceAllMapped(
    RegExp(escapedQuery, caseSensitive: false),
    (match) => '<mark>${match.group(0)}</mark>',
  );
}
