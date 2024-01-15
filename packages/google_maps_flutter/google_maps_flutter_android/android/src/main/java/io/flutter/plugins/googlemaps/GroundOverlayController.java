package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlay;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

class GroundOverlayController implements GroundOverlayOptionsSink {

  private final GroundOverlay groundOverlay;

  private final String googleMapsGroundOverlayId;

  private boolean consumeTapEvents;

  GroundOverlayController(GroundOverlay groundOverlay, boolean consumeTapEvents) {
    this.groundOverlay = groundOverlay;
    this.consumeTapEvents = consumeTapEvents;
    this.googleMapsGroundOverlayId = groundOverlay.getId();
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    groundOverlay.setClickable(consumeTapEvents);
  }

  public void remove() {
    groundOverlay.remove();
  }

  @Override
  public void setBearing(float bearing) {
    groundOverlay.setBearing(bearing);
  }

  @Override
  public void setClickable(boolean clickable) {
    groundOverlay.setClickable(clickable);
  }

  @Override
  public void setOpacity(float opacity) {
    groundOverlay.setTransparency(1 - opacity);
  }

  @Override
  public void setTitle(Object title) {
    groundOverlay.setTag(title);
  }

  @Override
  public void setIcon(BitmapDescriptor imageDescriptor) {
    groundOverlay.setImage(imageDescriptor);
  }

  @Override
  public void setPosition(LatLng latLng) {
    groundOverlay.setPosition(latLng);
  }

  @Override
  public void positionFromBounds(LatLngBounds width) {
    groundOverlay.setPositionFromBounds(width);
  }

  @Override
  public void setPositionFromBounds(LatLngBounds width) {
    groundOverlay.setPositionFromBounds(width);
  }

  @Override
  public void setTransparency(float transparency) {
    groundOverlay.setTransparency(transparency);
  }

  @Override
  public void setVisible(boolean visible) {
    groundOverlay.setVisible(visible);
  }

  @Override
  public void setZIndex(float zindex) {
    groundOverlay.setZIndex(zindex);
  }

  String getGoogleMapsGroundOverlayId() {
    return googleMapsGroundOverlayId;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }
}
