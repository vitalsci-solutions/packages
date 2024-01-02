// Copyright 2022 mastermakrela@VS-Apps. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show immutable, VoidCallback;

import 'types.dart';

/// Uniquely identifies a [GroundOverlay] among [GoogleMap] ground overlays.
///
/// This does not have to be globally unique, only unique among the list.
@immutable
class GroundOverlayId extends MapsObjectId<GroundOverlay> {
  /// Creates an immutable identifier for a [GroundOverlayId].
  const GroundOverlayId(String value) : super(value);
}

/// Overlays an image over the map at a given location and bearing.
@immutable
class GroundOverlay implements MapsObject<GroundOverlay> {
  /// Creates an immutable object representing a ground overlay on the map.
  const GroundOverlay({
    required this.groundOverlayId,
    required this.icon,
    this.opacity = 1,
    this.bearing = 0,
    required this.bounds,
    this.title,
    this.visible = true,
    this.tappable = false,
    this.zIndex = 0,
    this.onTap,
  }) : assert(!tappable && onTap == null || tappable && onTap != null,
            'If tappable is true, onTap must be provided');

  /// Uniquely identifies a [GroundOverlay].
  final GroundOverlayId groundOverlayId;

  @override
  GroundOverlayId get mapsId => groundOverlayId;

  /// A description of the bitmap used to draw the marker icon.
  final BitmapDescriptor icon;

  /// Sets the opacity of the [icon], between 0.0 (transparent) and 1.0 (opaque).
  final double opacity;

  /// Bearing of this ground overlay, in degrees.
  /// The default value, zero, points this ground overlay up/down along the normal Y axis of the earth.
  final double bearing;

  /// The 2D bounds on the Earth in which [icon] is drawn.
  final LatLngBounds bounds;

  /// Title, a short description of the overlay.
  /// The title is also the default accessibility text.
  final String? title;

  /// True if ground overlay is visible.
  final bool visible;

  /// If this overlay should cause tap notifications.
  final bool tappable;

  /// Sets the zIndex of the ground overlay.
  /// Higher zIndex value overlays will be drawn on top of lower zIndex value tile layers and overlays.
  final int? zIndex;

  /// Callbacks to receive tap events for ground overlay placed on this map.
  final VoidCallback? onTap;

  /// Creates a new [GroundOverlay] object whose values are the same as this instance,
  /// unless overwritten by the specified parameters.
  GroundOverlay copyWith({
    BitmapDescriptor? iconParam,
    double? opacityParam,
    double? bearingParam,
    LatLngBounds? boundsParam,
    String? titleParam,
    bool? visibleParam,
    bool? tappableParam,
    int? zIndexParam,
    VoidCallback? onTapParam,
  }) {
    return GroundOverlay(
      groundOverlayId: groundOverlayId,
      icon: iconParam ?? icon,
      opacity: opacityParam ?? opacity,
      bearing: bearingParam ?? bearing,
      bounds: boundsParam ?? bounds,
      title: titleParam ?? title,
      visible: visibleParam ?? visible,
      tappable: tappableParam ?? tappable,
      zIndex: zIndexParam ?? zIndex,
      onTap: onTapParam ?? onTap,
    );
  }

  /// Creates a new [GroundOverlay] object whose values are the same as this instance.
  @override
  GroundOverlay clone() => copyWith();

  /// Converts this object to something serializable in JSON.
  @override
  Object toJson() {
    final Map<String, Object> json = <String, Object>{};

    void addIfPresent(String fieldName, Object? value) {
      if (value != null) {
        json[fieldName] = value;
      }
    }

    addIfPresent('groundOverlayId', groundOverlayId.value);
    addIfPresent('icon', icon.toJson());
    addIfPresent('opacity', opacity);
    addIfPresent('bearing', bearing);
    addIfPresent('bounds', bounds.toJson());
    addIfPresent('title', title);
    addIfPresent('visible', visible);
    addIfPresent('tappable', tappable);
    addIfPresent('zIndex', zIndex);

    return json;
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    if (other.runtimeType != runtimeType) {
      return false;
    }
    return other is GroundOverlay &&
        groundOverlayId == other.groundOverlayId &&
        icon == other.icon &&
        opacity == other.opacity &&
        bearing == other.bearing &&
        bounds == other.bounds &&
        title == other.title &&
        visible == other.visible &&
        tappable == other.tappable &&
        zIndex == other.zIndex;
  }

  @override
  int get hashCode => groundOverlayId.hashCode;
}
