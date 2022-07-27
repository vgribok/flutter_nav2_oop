import 'dart:io';
import 'package:example/src/dal/selected_picture_dal.dart';
import 'package:example/src/routing/pictures/photo_preview_path.dart';
import 'package:example/src/dal/photo_taker.dart';
import 'package:example/src/utility/exif_extensions.dart';
import 'package:example/src/widgets/centered_column.dart';
import 'package:example/src/widgets/two_button_card.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_nav2_oop/all.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:native_exif/native_exif.dart';

class PhotoPreviewChildModalDialog extends FullScreenModalDialog {

  final RoutePath parentPath;
  final PhotoProvider photoProvider;

  const PhotoPreviewChildModalDialog({required this.photoProvider, required this.parentPath, super.key})
      : super(screenTitle: "Photo Preview");

  @override
  Widget buildBody(BuildContext context, WidgetRef ref) {
    final File? pictureFile = SelectedPictureDal.watchForSelectedPhotoFile(ref);
    if(pictureFile == null) return Container();

    if(kDebugMode) {
      _printExifData(pictureFile.absolute.path);
    }
    return _buildPreview(context, ref, pictureFile);
  }

  Widget _buildPreview(BuildContext context, WidgetRef ref, File pictureFile) =>
    CenteredColumn(children: [
        Expanded(child: ImageFile(pictureFile, missingImageIconSize: 150)),
        TwoActionCard(title: 'Use this photo?',
            action1ButtonText: "Keep",
            action2ButtonText: "Discard",
            action1Icon: Icons.arrow_back,
            action2Icon: Icons.delete_forever_outlined,
            onAction1ButtonPressed: () => close(context),
            onAction2ButtonPressed: () =>
                _showEntryDeletionConfirmationDialog(context, ref, pictureFile)
        )
    ]);

  static Future<Map<String, Object>> _printExifData(String imageFilePath) async {
    final Exif? exif = await Exif.fromPath(imageFilePath);
    final Map<String, Object>? rawExifData = await exif?.dispose().after(
      exif.getAttributes
    );
    if(kDebugMode) {
      printExifData("when previewing the picture", rawExifData);
    }
    return rawExifData ?? {};
  }

  Future<void> _showEntryDeletionConfirmationDialog(BuildContext context, WidgetRef ref, File pictureFile) =>
            ConfirmationMessageBox(
              children: const [
                Text("Delete this picture?"),
              ],
              continueButtonText: "Delete",
              continueButtonOnPressHandler: (ctx) {
                photoProvider.deletePhoto(pictureFile, ref);
                close(context);
              },
            )
            .show(context);

  @override
  RoutePath get routePath => PhotoPreviewPath();

  @override
  @protected
  @mustCallSuper
  void updateStateOnScreenRemovalFromNavStackTop(WidgetRef ref) {
    SelectedPictureDal.setSelectedPhoto(ref, null);
    super.updateStateOnScreenRemovalFromNavStackTop(ref);
  }
}
