import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import 'moon_painter.dart';

class MoonWidget extends StatefulWidget {
  final BuildContext context;

  ///DateTime to show.
  ///Even hour, minutes, and seconds are calculated for MoonWidget
  final DateTime date;

  ///Decide the container size for the MoonWidget
  final int size;

  ///Resolution will be the moon radius.
  ///Large resolution needs more math operation makes widget heavy.
  ///Enter a small number if it is sufficient to mark it small,
  ///such as an icon or marker.
  final double resolution;

  ///Color of light side of moon
  final Color surfaceColor;

  ///Moon image asset path
  final String assetImagePath;

  ///Color of dark side of moon
  final Color shadowColor;

  const MoonWidget({
    Key? key,
    required this.context,
    required this.date,
    this.size = 36,
    this.resolution = 96,
    this.surfaceColor = Colors.amber,
    this.shadowColor = Colors.black87,
    this.assetImagePath = "",
  }) : super(key: key);

  @override
  State<MoonWidget> createState() => _MoonWidgetState();
}

class _MoonWidgetState extends State<MoonWidget> {
  ui.Image? image;

  @override
  void initState() {
    super.initState();
    _asyncInit();
  }

  Future<void> _asyncInit() async {
    if (widget.assetImagePath.isNotEmpty) {
      final image2 = await getUiImage(
          context, widget.assetImagePath, widget.resolution.round());
      setState(() {
        image = image2;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Colors.green,
      width: widget.size.toDouble(),
      height: widget.size.toDouble(),
      child: Transform.scale(
        scale: widget.size / (widget.resolution * 2),
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
      targetHeight: size * 2,
      targetWidth: size * 2,
    );
    return (await codec.getNextFrame()).image;
  }
}
