import 'package:example/src/widgets/two_button_card.dart';
import 'package:flutter/material.dart';

class PhotoGrabbingCard extends TwoActionCard {

  PhotoGrabbingCard({
    super.title = "Get an Image",
    super.subtitle = "User camera or pick an existing image",
    String takePhotoButtonText = "Take Picture",
    String pickImageFromGalleryButtonText = "Pick Existing",
    VoidCallback? onCameraPressed,
    VoidCallback? onGalleryPressed,
    super.key
  }) : super(
      action1ButtonText: takePhotoButtonText,
      action2ButtonText: pickImageFromGalleryButtonText,
      onAction1ButtonPressed: onCameraPressed,
      onAction2ButtonPressed: onGalleryPressed,
      action1Icon: Icons.camera_alt_outlined,
      action2Icon: Icons.image_outlined
  )
  {
    if(onCameraPressed == null && onGalleryPressed == null) {
      throw ArgumentError("Either onCameraPressed or onGalleryPressed (or both) need to be specified", "onCameraPressed");
    }
  }
}