// Copyright 2022 mastermakrela@VS-Apps. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'page.dart';

class GroundOverlayPage extends GoogleMapExampleAppPage {
  const GroundOverlayPage({Key? key})
      : super(const Icon(Icons.image), 'Ground overlay', key: key);

  @override
  Widget build(BuildContext context) {
    return const GroundOverlayBody();
  }
}

class GroundOverlayBody extends StatefulWidget {
  const GroundOverlayBody({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GroundOverlayBodyState();
}

class GroundOverlayBodyState extends State<GroundOverlayBody> {
  GroundOverlayBodyState();

  GoogleMapController? controller;
  Map<GroundOverlayId, GroundOverlay> groundOverlays =
      <GroundOverlayId, GroundOverlay>{};
  GroundOverlayId? selectedGroundOverlay;

  GroundOverlay? get _currentGroundOverlay => selectedGroundOverlay == null
      ? null
      : groundOverlays[selectedGroundOverlay!];

  // ignore: use_setters_to_change_properties
  void _onMapCreated(GoogleMapController controller) {
    this.controller = controller;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _onGroundOverlayTapped(GroundOverlayId groundOverlayId) {
    setState(() {
      selectedGroundOverlay = groundOverlayId;
    });
  }

  void _remove() {
    if (selectedGroundOverlay == null) {
      return;
    }

    setState(() {
      if (groundOverlays.containsKey(selectedGroundOverlay)) {
        groundOverlays.remove(selectedGroundOverlay);
      }
      selectedGroundOverlay = null;
    });
  }

  Future<void> _add() async {
    final int overlayCount = groundOverlays.length;

    if (overlayCount == 1) {
      return;
    }

    final BitmapDescriptor icon = await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(devicePixelRatio: 2.5),
      'assets/newark_nj_1922.jpeg',
    );
    final LatLngBounds bounds = LatLngBounds(
      southwest: const LatLng(40.712216, -74.22655),
      northeast: const LatLng(40.773941, -74.12544),
    );

    final String overlayIdVal = 'overlay_id_$overlayCount';
    final GroundOverlayId overlayId = GroundOverlayId(overlayIdVal);

    final GroundOverlay overlay = GroundOverlay(
      groundOverlayId: overlayId,
      bounds: bounds,
      icon: icon,
      tappable: true,
      onTap: () {
        _onGroundOverlayTapped(overlayId);
      },
    );

    setState(() {
      groundOverlays[overlayId] = overlay;
    });
  }

  void _changeOpacity(double opacity) {
    if (selectedGroundOverlay == null) {
      return;
    }

    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay!]!;

    setState(() {
      groundOverlays[selectedGroundOverlay!] = groundOverlay.copyWith(
        opacityParam: opacity,
      );
    });
  }

  void _changeBearings(double bearing) {
    if (selectedGroundOverlay == null) {
      return;
    }

    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay!]!;

    setState(() {
      groundOverlays[selectedGroundOverlay!] = groundOverlay.copyWith(
        bearingParam: bearing,
      );
    });
  }

  void _changeVisible(bool? visible) {
    if (selectedGroundOverlay == null) {
      return;
    }

    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay!]!;

    setState(() {
      groundOverlays[selectedGroundOverlay!] = groundOverlay.copyWith(
        visibleParam: visible,
      );
    });
  }

  void _changeZIndex(double zIndex) {
    if (selectedGroundOverlay == null) {
      return;
    }

    final GroundOverlay groundOverlay = groundOverlays[selectedGroundOverlay!]!;

    setState(() {
      groundOverlays[selectedGroundOverlay!] = groundOverlay.copyWith(
        zIndexParam: zIndex.toInt(),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Center(
          child: SizedBox(
            width: 350.0,
            height: 400.0,
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: LatLng(40.712216, -74.22655),
                zoom: 11.0,
              ),
              onMapCreated: _onMapCreated,
              groundOverlays: Set<GroundOverlay>.of(groundOverlays.values),
            ),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    TextButton(
                      onPressed: _add,
                      child: const Text('Add'),
                    ),
                    TextButton(
                      onPressed: selectedGroundOverlay == null ? null : _remove,
                      child: const Text('Remove'),
                    ),
                  ],
                ),
                const Text('Opacity:'),
                Slider(
                  value: _currentGroundOverlay?.opacity ?? 0.5,
                  onChanged: _changeOpacity,
                ),
                const Text('Bearing:'),
                Slider(
                  value: _currentGroundOverlay?.bearing ?? 0.0,
                  onChanged: _changeBearings,
                  max: 360.0,
                ),
                const Text('Visible:'),
                Checkbox(
                  value: _currentGroundOverlay?.visible ?? true,
                  onChanged: _changeVisible,
                ),
                const Text('ZIndex:'),
                Slider(
                  value: _currentGroundOverlay?.zIndex?.toDouble() ?? 0.0,
                  onChanged: _changeZIndex,
                  divisions: 10,
                  max: 10.0,
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
