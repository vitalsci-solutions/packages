package io.flutter.plugins.googlemaps;

import com.google.android.gms.maps.model.BitmapDescriptor;
import com.google.android.gms.maps.model.LatLng;
import com.google.android.gms.maps.model.LatLngBounds;

interface GroundOverlayOptionsSink {

  void setConsumeTapEvents(boolean consumeTapEvents);

  void setBearing(float bearing);

  void setClickable(boolean clickable);

  void setOpacity(float opacity);

  void setTitle(Object title);

  void setIcon(BitmapDescriptor imageDescriptor);

  void setPosition(LatLng latLng);

  void positionFromBounds(LatLngBounds width);

  void setPositionFromBounds(LatLngBounds width);

  void setTransparency(float transparency);

  void setVisible(boolean visible);

  void setZIndex(float zindex);
}
