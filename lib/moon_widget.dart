import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'moon_painter.dart';

class MoonWidget extends StatefulWidget {
  ///DateTime to show.
  ///Even hour, minutes, and seconds are calculated for MoonWidget
  final DateTime date;

  ///Decide the container size for the MoonWidget
  final int size;

  ///Resolution will be the moon radius.
  ///Large resolution needs more math operation makes widget heavy.
  ///Enter a small number if it is sufficient to mark it small,
  ///such as an icon or marker.
  //final double resolution;

  ///Color of light side of moon
  final Color surfaceColor;

  ///Moon image asset path
  final String assetImagePath;

  ///Color of dark side of moon
  final Color shadowColor;

  final ui.Image? moonImage;

  const MoonWidget({
    Key? key,
    required this.date,
    this.size = 36,
    //this.resolution = 96,
    this.surfaceColor = Colors.amber,
    this.shadowColor = Colors.black87,
    this.assetImagePath = "",
    this.moonImage,
  }) : super(key: key);

  @override
  State<MoonWidget> createState() => _MoonWidgetState();
}

class _MoonWidgetState extends State<MoonWidget> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    if (widget.moonImage != null) {
      setState(() {
        image = widget.moonImage;
      });
    } else if (widget.assetImagePath.isNotEmpty) {
      _asyncInit();
    }
  }

  Future<void> _asyncInit() async {
    ui.Image image2 =
        await getUiImage(context, widget.assetImagePath, widget.size.round());
    if (mounted) {
      setState(() {
        image = image2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.size.toDouble(),
        height: widget.size.toDouble(),
        child: CustomPaint(
          painter: MoonPainter(moonWidget: widget, moonImage: image),
        ),
      ),
    );
  }

  Future<ui.Image> getUiImage(
      BuildContext context, String imageAssetPath, int size) async {
    final ByteData assetImageByteData =
        await DefaultAssetBundle.of(context).load(imageAssetPath);
    final codec = await ui.instantiateImageCodec(
      assetImageByteData.buffer.asUint8List(),
      targetHeight: size,
      targetWidth: size,
    );
    return (await codec.getNextFrame()).image;
  }
}
