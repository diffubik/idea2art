import 'dart:ui' as ui;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

import 'package:idea2art/src/models/generate.dart';
import 'package:idea2art/src/services/generate.dart';

class ImageCanvasMaskStroke {
  final List<Offset> points;
  final double r;

  ImageCanvasMaskStroke({
    this.points = const <Offset>[],
    this.r = 10,
  });

  ImageCanvasMaskStroke copyWith({double? r, List<Offset>? points}) {
    return ImageCanvasMaskStroke(
      r: r ?? this.r,
      points: points ?? this.points,
    );
  }
}

class ImageCanvasImage {
  static int keystate = 0;

  ImageCanvasImage({
    key = -1,
    required this.image,
    this.maskstrokes = const <ImageCanvasMaskStroke>[],
  }) {
    this.key = key < 0 ? (keystate++) : key;
  }

  late final int key;
  final ui.Image image;
  final List<ImageCanvasMaskStroke> maskstrokes;

  ImageCanvasImage copyWith({
    ui.Image? image,
    List<ImageCanvasMaskStroke>? maskstrokes,
  }) {
    return ImageCanvasImage(
      key: key,
      image: image ?? this.image,
      maskstrokes: maskstrokes ?? this.maskstrokes,
    );
  }
}

class ImageCanvasImageSet {
  static int keystate = 0;

  late final int key;
  final Rect pos;
  final int total;

  final List<ImageCanvasImage> images;
  final int selectedKey;

  // Can use to re-generate more items
  final GeneratePrompt prompt;
  final GenerateSettings settings;

  // Can use to monitor progress
  final bool inProgress;
  final GenerateResult? result;

  ImageCanvasImageSet({
    key = -1,
    required this.pos,
    required this.total,
    required this.prompt,
    required this.settings,
    this.inProgress = false,
    this.result,
    this.images = const [],
    this.selectedKey = -1,
  }) {
    this.key = key < 0 ? (keystate++) : key;
  }

  ImageCanvasImageSet.fromCenterWH({
    key = -1,
    Offset center = const Offset(0, 0),
    required width,
    required height,
    required total,
    required prompt,
    required settings,
    inProgress = false,
    result,
    images = const <ImageCanvasImage>[],
  }) : this(
          key: key,
          pos: Rect.fromCenter(center: center, width: width, height: height),
          total: total,
          prompt: prompt,
          settings: settings,
          inProgress: inProgress,
          result: result,
          images: images,
        );

  copyWith({
    Rect? pos,
    int? total,
    GeneratePrompt? prompt,
    GenerateSettings? settings,
    bool? inProgress,
    GenerateResult? result,
    List<ImageCanvasImage>? images,
    int? selectedKey,
  }) {
    return ImageCanvasImageSet(
      key: key,
      total: total ?? this.total,
      prompt: prompt ?? this.prompt,
      settings: settings ?? this.settings,
      pos: pos ?? this.pos,
      inProgress: inProgress ?? this.inProgress,
      result: result ?? this.result,
      images: images ?? this.images,
      selectedKey: selectedKey ?? this.selectedKey,
    );
  }

  ImageCanvasImage? selectedImage() {
    if (selectedKey > -1) {
      return images.firstWhereOrNull((image) => image.key == selectedKey);
    } else {
      return images.firstOrNull;
    }
  }
}

class ImageCanvas {
  ImageCanvas({
    this.imagesets = const <ImageCanvasImageSet>[],
    this.selectedKey = -1,
  });

  final List<ImageCanvasImageSet> imagesets;
  final int selectedKey;

  ImageCanvas copyWith({
    List<ImageCanvasImageSet>? imagesets,
    int? selectedKey,
  }) {
    return ImageCanvas(
      imagesets: imagesets ?? this.imagesets,
      selectedKey: selectedKey ?? this.selectedKey,
    );
  }

  ImageCanvasImageSet? selectedImageset() {
    if (selectedKey >= 0) return this[selectedKey];
    return null;
  }

  ImageCanvasImageSet? operator [](int setKey) {
    return imagesets.firstWhereOrNull((imageset) => imageset.key == setKey);
  }
}

class ImageCanvasFrame {
  final Rect pos;

  ImageCanvasFrame({
    this.pos = Rect.zero,
  });

  ImageCanvasFrame copyWith({
    Rect? pos,
  }) {
    return ImageCanvasFrame(
      pos: pos ?? this.pos,
    );
  }
}

enum ImageCanvasMode {
  auto,
  create,
  variants,
  fill,
  mask,
}

class ImageCanvasControls {
  ImageCanvasControls({this.mode = ImageCanvasMode.create});

  final ImageCanvasMode mode;

  ImageCanvasControls copyWith({
    ImageCanvasMode? mode,
  }) {
    return ImageCanvasControls(
      mode: mode ?? this.mode,
    );
  }

  bool isGenerationMode() {
    return mode == ImageCanvasMode.auto ||
        mode == ImageCanvasMode.create ||
        mode == ImageCanvasMode.variants ||
        mode == ImageCanvasMode.fill;
  }
}
