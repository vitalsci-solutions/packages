// Copyright 2022 mastermakrela@VS-Apps. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'types.dart';

/// [GroundOverlay] update events to be applied to the [GoogleMap].
///
/// Used in [GoogleMapController] when the map is updated.
// (Do not re-export)
class GroundOverlayUpdates extends MapsObjectUpdates<GroundOverlay> {
  /// Computes [GroundOverlayUpdates] given previous and current [GroundOverlay]s.
  GroundOverlayUpdates.from(
      Set<GroundOverlay> previous, Set<GroundOverlay> current)
      : super.from(previous, current, objectName: 'groundOverlay');

  /// Set of GroundOverlays to be added in this update.
  Set<GroundOverlay> get groundOverlaysToAdd => objectsToAdd;

  /// Set of GroundOverlayIds to be removed in this update.
  Set<GroundOverlayId> get groundOverlayIdsToRemove =>
      objectIdsToRemove.cast<GroundOverlayId>();

  /// Set of GroundOverlays to be changed in this update.
  Set<GroundOverlay> get groundOverlaysToChange => objectsToChange;
}
