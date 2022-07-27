import 'dart:io';
import 'package:example/src/dal/selected_picture_dal.dart';
import 'package:example/src/routing/pictures/picture_list_path.dart';
import 'package:example/src/screens/pictures/photo_preview_modal_dialog.dart';
import 'package:example/src/widgets/centered_column.dart';
import 'package:example/src/dal/photo_taker.dart';
import 'package:example/src/widgets/photo_grabbing_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:example/src/utility/file_extensions.dart';

class PictureListScreen extends TabNavScreen { // Subclass NavScreen to enable non-tab navigation

  static final logBookPhotoProvider = PhotoProvider(appDirectory: "pictures");

  const PictureListScreen(super.tabIndex, // Comment super.tabIndex to enable non-tab navigation
          {super.key})
      : super(screenTitle: 'Pictures');

  static const String listItemKeyPrefix = "photos-";

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) =>
    CenteredColumn(children: [
      Expanded(child: AsyncValueAwaiter<List<File>>(
        asyncData: logBookPhotoProvider.watchForPictures(ref),
        waitText: "Loading pictures...",
        builder: (files) => Scrollbar(child:
          ListView(children: [
            for(final File picture in files)
              ListTile(
                leading: ImageFile(picture,
                  waitText: null,
                  waitCursorCentered: false, missingImageIconSize: 40,
                  boxSize: const Size(40, 40),
                ),
                title: Text(parseCreationDate(picture.baseNameOnly)),
                subtitle: const Text("To be done later"),
                key: ValueKey("$listItemKeyPrefix${picture.absolute.path}"),
                onTap: () => SelectedPictureDal.setSelectedPhoto(ref, picture.absolute.path),
              )
          ])
        )
      )),
      _buildNewEntryWidget(context, ref)
    ]);

  static String parseCreationDate(String fileBaseName) =>
    DateTime.tryParse(fileBaseName)?.toString() ?? fileBaseName;

  Widget _buildNewEntryWidget(BuildContext context, WidgetRef ref) =>
      PhotoGrabbingCard(
        onCameraPressed: () => logBookPhotoProvider.takePhoto(ref, source: ImageSource.camera),
        onGalleryPressed: () => logBookPhotoProvider.takePhoto(ref, source: ImageSource.gallery),
        title: "Snap a pic of what's around",
        subtitle: "Photograph whatever inspires you",
        key: const ValueKey("photo-preview"),
      );


  @override
  NavScreen? topScreen(WidgetRef ref) => _showSelectedEntry(ref);

  NavScreen? _showSelectedEntry(WidgetRef ref) {
    final File? pictureFile = SelectedPictureDal.watchForSelectedPhotoFile(ref);

    return pictureFile == null ? null :
          PhotoPreviewChildModalDialog(parentPath: routePath, photoProvider: logBookPhotoProvider);
  }

  @override
  RoutePath get routePath => PictureListPath();
}
