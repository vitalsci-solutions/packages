// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of google_maps_flutter_web;

/// The `GroundOverlayController` class wraps a [gmaps.OverlayView] and how it handles events.
class GroundOverlayController {
  /// Creates a `GroundOverlayController`, which wraps a [gmaps.OverlayView] object, its `onTap` behavior.
  GroundOverlayController({
    required gmaps.OverlayView groundOverlay,
    required this.url,
    required this.bounds,
    this.opacity = 1,
    this.rotation = 0,
  }) : _groundOverlay = groundOverlay {
    _groundOverlay!.onAdd = _onAdd;
    _groundOverlay!.draw = _draw;
    _groundOverlay!.onRemove = _onRemove;
  }

  DivElement? _div;

  gmaps.OverlayView? _groundOverlay;

  /// The URL of the image to display on the ground overlay.
  String url;

  /// The bounds of the image overlay.
  gmaps.LatLngBounds bounds;

  /// The opacity of the image overlay.
  num opacity;

  /// The rotation angle of the image overlay.
  num rotation;

  /// Returns the [gmaps.OverlayView] associated to this controller.
  gmaps.OverlayView? get groundOverlay => _groundOverlay;

  /// Disposes of the currently wrapped [gmaps.OverlayView].
  void remove() {
    if (_groundOverlay != null) {
      _groundOverlay!.map = null;
      _groundOverlay = null;
    }
  }

  // MARK: [gmap.GroundOverlay] methods

  void _onAdd() {
    final DivElement div = DivElement();
    div.style
      ..borderStyle = 'none'
      ..borderWidth = '0px'
      ..position = 'absolute';

    final ImageElement img = ImageElement(src: url);
    img.style
      ..width = '100%'
      ..height = '100%'
      ..position = 'absolute'
      ..opacity = opacity.toString();

    div.append(img);

    _div = div;

    _groundOverlay?.panes?.overlayLayer?.append(div);
  }

  void _draw() {
    final gmaps.MapCanvasProjection? overlayProjection =
        _groundOverlay?.projection;

    if (overlayProjection == null) {
      return;
    }

    final gmaps.Point? sw =
        overlayProjection.fromLatLngToDivPixel(bounds.southWest);
    final gmaps.Point? ne =
        overlayProjection.fromLatLngToDivPixel(bounds.northEast);

    if (_div == null || sw == null || ne == null) {
      return;
    }

    if (sw.x == null || sw.y == null || ne.x == null || ne.y == null) {
      return;
    }

    _div!.style
      ..left = '${sw.x!}px'
      ..top = '${ne.y!}px'
      ..width = '${ne.x! - sw.x!}px'
      ..height = '${sw.y! - ne.y!}px'
      ..transform = 'rotate(${rotation}deg)';
  }

  void _onRemove() {
    _div?.remove();
    _div = null;
  }
}
