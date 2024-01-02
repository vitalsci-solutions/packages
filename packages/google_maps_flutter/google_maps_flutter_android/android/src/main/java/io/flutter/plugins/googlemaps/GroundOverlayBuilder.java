package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.GroundOverlayOptions;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

public class GroundOverlayBuilder implements GroundOverlayOptionsSink {

  private final GroundOverlayOptions groundOverlayOptions;
  private boolean consumeTapEvents;

  public GroundOverlayBuilder() {
    this.groundOverlayOptions = new GroundOverlayOptions();
  }

  public GroundOverlayOptions build() {
    return groundOverlayOptions;
  }

  boolean consumeTapEvents() {
    return consumeTapEvents;
  }

  @Override
  public void setConsumeTapEvents(boolean consumeTapEvents) {
    this.consumeTapEvents = consumeTapEvents;
    groundOverlayOptions.clickable(consumeTapEvents);
  }

  @Override
  public void setBearing(float bearing) {
    groundOverlayOptions.bearing(bearing);
  }

  @Override
  public void setClickable(boolean clickable) {
    groundOverlayOptions.clickable(clickable);
  }

  @Override
  public void setOpacity(float opacity) {
    groundOverlayOptions.transparency(1 - opacity);
  }

  @Override
  public void setTitle(Object title) {}

  @Override
  public void setIcon(BitmapDescriptor imageDescriptor) {
    groundOverlayOptions.image(imageDescriptor);
  }

  @Override
  public void setPosition(LatLng latLng) {
    groundOverlayOptions.position(latLng, groundOverlayOptions.getWidth());
  }

  @Override
  public void positionFromBounds(LatLngBounds width) {
    groundOverlayOptions.positionFromBounds(width);
  }

  @Override
  public void setPositionFromBounds(LatLngBounds width) {
    groundOverlayOptions.positionFromBounds(width);
  }

  @Override
  public void setTransparency(float transparency) {
    groundOverlayOptions.transparency(transparency);
  }

  @Override
  public void setVisible(boolean visible) {
    groundOverlayOptions.visible(visible);
  }

  @Override
  public void setZIndex(float zindex) {
    groundOverlayOptions.zIndex(zindex);
  }
}
