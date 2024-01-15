// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of google_maps_flutter_web;

/// This class manages a set of [GroundOverlayController]s associated to a [GoogleMapController].
class GroundOverlaysController extends GeometryController {
  /// Initialize the cache. The [StreamController] comes from the [GoogleMapController], and is shared with other controllers.
  GroundOverlaysController({
    required StreamController<MapEvent<Object?>> stream,
  })  : _streamController = stream,
        _groundOverlayIdToController =
            <GroundOverlayId, GroundOverlayController>{};

  // A cache of [GroundOverlayController]s indexed by their [GroundOverlayId].
  final Map<GroundOverlayId, GroundOverlayController>
      _groundOverlayIdToController;

  // The stream over which groundOverlays broadcast their events
  final StreamController<MapEvent<Object?>> _streamController;

  /// Returns the cache of [GroundOverlayController]s. Test only.
  @visibleForTesting
  Map<GroundOverlayId, GroundOverlayController> get groundOverlays =>
      _groundOverlayIdToController;

  /// Adds a set of [GroundOverlay] objects to the cache.
  ///
  /// Wraps each [GroundOverlay] into its corresponding [GroundOverlayController].
  void addGroundOverlays(Set<GroundOverlay> groundOverlaysToAdd) {
    groundOverlaysToAdd.forEach(_addGroundOverlay);
  }

  void _addGroundOverlay(GroundOverlay groundOverlay) {
    final gmaps.OverlayView gmGroundOverlay = gmaps.OverlayView()
      ..map = googleMap;

    final GroundOverlayController controller = GroundOverlayController(
      groundOverlay: gmGroundOverlay,
      url: _urlFromBitmapDescriptor(groundOverlay.icon),
      bounds: _latLngBoundsFromLatLngBounds(groundOverlay.bounds),
      opacity: groundOverlay.opacity,
      rotation: groundOverlay.bearing,
    );

    _groundOverlayIdToController[groundOverlay.groundOverlayId] = controller;
  }

  /// Updates a set of [GroundOverlay] objects with new options.
  void changeGroundOverlays(Set<GroundOverlay> groundOverlaysToChange) {
    debugPrint('groundOverlaysToChange: $groundOverlaysToChange');
    groundOverlaysToChange.forEach(_changeGroundOverlay);
  }

  void _changeGroundOverlay(GroundOverlay groundOverlay) {
    final GroundOverlayController? groundOverlayController =
        _groundOverlayIdToController[groundOverlay.groundOverlayId];

    if (groundOverlayController != null) {
      groundOverlayController.url =
          _urlFromBitmapDescriptor(groundOverlay.icon);
      groundOverlayController.bounds =
          _latLngBoundsFromLatLngBounds(groundOverlay.bounds);
      groundOverlayController.rotation = groundOverlay.bearing;
      groundOverlayController.opacity = groundOverlay.opacity;

      // the best way to force a redraw that I could find ¯\_(ツ)_/¯
      groundOverlayController.groundOverlay?.map = googleMap;
    }
  }

  /// Removes a set of [GroundOverlayId]s from the cache.
  void removeGroundOverlays(Set<GroundOverlayId> groundOverlayIdsToRemove) {
    groundOverlayIdsToRemove.forEach(_removeGroundOverlay);
  }

  void _removeGroundOverlay(GroundOverlayId groundOverlayId) {
    final GroundOverlayController? groundOverlayController =
        _groundOverlayIdToController[groundOverlayId];
    groundOverlayController?.remove();
    _groundOverlayIdToController.remove(groundOverlayId);
  }
}
