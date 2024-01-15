package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.GoogleMap;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import io.flutter.plugin.common.MethodChannel;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class GroundOverlaysController {

  private final Map<String, GroundOverlayController> groundOverlayIdToController;
  private final Map<String, String> googleMapsGroundOverlayIdToDartGroundOverlayId;
  private final MethodChannel methodChannel;
  private GoogleMap googleMap;

  GroundOverlaysController(MethodChannel methodChannel) {
    this.groundOverlayIdToController = new HashMap<>();
    this.googleMapsGroundOverlayIdToDartGroundOverlayId = new HashMap<>();
    this.methodChannel = methodChannel;
  }

  void setGoogleMap(GoogleMap googleMap) {
    this.googleMap = googleMap;
  }

  void addGroundOverlays(List<Object> groundOverlaysToAdd) {
    if (groundOverlaysToAdd != null) {
      for (Object groundOverlayToAdd : groundOverlaysToAdd) {
        addGroundOverlay(groundOverlayToAdd);
      }
    }
  }

  void changeGroundOverlays(List<Object> groundOverlaysToChange) {
    if (groundOverlaysToChange != null) {
      for (Object groundOverlayToChange : groundOverlaysToChange) {
        changeGroundOverlay(groundOverlayToChange);
      }
    }
  }

  void removeGroundOverlays(List<Object> groundOverlayIdsToRemove) {
    if (groundOverlayIdsToRemove == null) {
      return;
    }
    for (Object rawGroundOverlayId : groundOverlayIdsToRemove) {
      if (rawGroundOverlayId == null) {
        continue;
      }
      String groundOverlayId = (String) rawGroundOverlayId;
      final GroundOverlayController groundOverlayController =
          groundOverlayIdToController.remove(groundOverlayId);
      if (groundOverlayController != null) {
        groundOverlayController.remove();
        googleMapsGroundOverlayIdToDartGroundOverlayId.remove(
            groundOverlayController.getGoogleMapsGroundOverlayId());
      }
    }
  }

  boolean onGroundOverlayTap(String googleGroundOverlayId) {
    String groundOverlayId =
        googleMapsGroundOverlayIdToDartGroundOverlayId.get(googleGroundOverlayId);
    if (groundOverlayId == null) {
      return false;
    }
    methodChannel.invokeMethod("groundOverlay#onTap", Convert.groundOverlayToJson(groundOverlayId));
    GroundOverlayController groundOverlayController =
        groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController != null) {
      return groundOverlayController.consumeTapEvents();
    }
    return false;
  }

  private void addGroundOverlay(Object groundOverlay) {
    if (groundOverlay == null) {
      return;
    }
    GroundOverlayBuilder groundOverlayBuilder = new GroundOverlayBuilder();
    String groundOverlayId =
        Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayBuilder);
    GroundOverlayOptions options = groundOverlayBuilder.build();
    addGroundOverlay(groundOverlayId, options, groundOverlayBuilder.consumeTapEvents());
  }

  private void addGroundOverlay(
      String groundOverlayId, GroundOverlayOptions options, boolean consumeTapEvents) {
    final GroundOverlay groundOverlay = googleMap.addGroundOverlay(options);
    GroundOverlayController groundOverlayController =
        new GroundOverlayController(groundOverlay, consumeTapEvents);
    this.groundOverlayIdToController.put(groundOverlayId, groundOverlayController);
    this.googleMapsGroundOverlayIdToDartGroundOverlayId.put(groundOverlay.getId(), groundOverlayId);
  }

  private void changeGroundOverlay(Object groundOverlay) {
    if (groundOverlay == null) {
      return;
    }

    String groundOverlayId = getGroundOverlayId(groundOverlay);
    GroundOverlayController groundOverlayController =
        this.groundOverlayIdToController.get(groundOverlayId);
    if (groundOverlayController != null) {
      Convert.interpretGroundOverlayOptions(groundOverlay, groundOverlayController);
    }
  }

  @SuppressWarnings("unchecked")
  private static String getGroundOverlayId(Object groundOverlay) {
    Map<String, Object> groundOverlayMap = (Map<String, Object>) groundOverlay;
    return (String) groundOverlayMap.get("groundOverlayId");
  }
}
