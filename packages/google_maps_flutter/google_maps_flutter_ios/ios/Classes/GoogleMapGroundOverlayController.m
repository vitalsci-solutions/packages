// TODO copyright

#import "GoogleMapGroundOverlayController.h"
#import "FLTGoogleMapJSONConversions.h"

@interface FLTGoogleMapGroundOverlayController ()

@property(strong, nonatomic) GMSGroundOverlay *overlay;
@property(weak, nonatomic) GMSMapView *mapView;

@end

@implementation FLTGoogleMapGroundOverlayController

- (instancetype)initGroundOverlayWithIdentifier:(NSString *)identifier
                                        mapView:(GMSMapView *)mapView {
  self = [super init];
  if (self) {
    _mapView = mapView;

    // here we just create an empty overlay
    // it will be configured later in |interpretGroundOvelayOptions|
    _overlay = [[GMSGroundOverlay alloc] init];
    _overlay.userData = @[ identifier ];

    _overlay.map = self.mapView;  // maybe move to setVisibe if we want it
  }
  return self;
}

- (void)removeGroundOverlay {
  self.overlay.map = nil;
}

- (void)setIcon:(UIImage *)icon {
  self.overlay.icon = icon;
}

- (void)setOpacity:(float)opacity {
  self.overlay.opacity = opacity;
}

- (void)setBearing:(float)bearing {
  self.overlay.bearing = bearing;
}

- (void)setBounds:(GMSCoordinateBounds *)bounds {
  self.overlay.bounds = bounds;
}

- (void)setTitle:(NSString *)title {
  self.overlay.title = title;
}

- (void)setVisible:(BOOL)visible {
  self.overlay.map = visible ? self.mapView : nil;
}

- (void)setTappable:(BOOL)tappable {
  self.overlay.tappable = tappable;
}

- (void)setZIndex:(int)zIndex {
  self.overlay.zIndex = zIndex;
}

- (void)interpretGroundOvelayOptions:(NSDictionary *)data
                           registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  NSArray *icon = data[@"icon"];
  if (icon && icon != (id)[NSNull null]) {
    UIImage *image = [self extractIconFromData:icon registrar:registrar];
    [self setIcon:image];
  }
  NSNumber *opacity = data[@"opacity"];
  if (opacity && opacity != (id)[NSNull null]) {
    [self setOpacity:[opacity floatValue]];
  }
  NSNumber *bearing = data[@"bearing"];
  if (bearing && bearing != (id)[NSNull null]) {
    [self setBearing:[bearing doubleValue]];
  }
  NSArray *bounds = data[@"bounds"];
  if (bounds && bounds != (id)[NSNull null]) {
    CLLocationCoordinate2D southWest = [FLTGoogleMapJSONConversions locationFromLatLong:bounds[0]];
    CLLocationCoordinate2D northEast = [FLTGoogleMapJSONConversions locationFromLatLong:bounds[1]];
    GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                              coordinate:northEast];
    [self setBounds:overlayBounds];
  }
  NSString *title = data[@"title"];
  if (title && title != (id)[NSNull null]) {
    [self setTitle:title];
  }
  NSNumber *visible = data[@"visible"];
  if (visible && visible != (id)[NSNull null]) {
    [self setVisible:[visible boolValue]];
  }
  NSNumber *tappable = data[@"tappable"];
  if (tappable && tappable != (id)[NSNull null]) {
    [self setTappable:[tappable boolValue]];
  }
  NSNumber *zIndex = data[@"zIndex"];
  if (zIndex && zIndex != (id)[NSNull null]) {
    [self setZIndex:[zIndex intValue]];
  }
}

- (UIImage *)extractIconFromData:(NSArray *)iconData
                       registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  UIImage *image;
  if ([iconData.firstObject isEqualToString:@"defaultMarker"]) {
    CGFloat hue = (iconData.count == 1) ? 0.0f : [iconData[1] doubleValue];
    image = [GMSMarker markerImageWithColor:[UIColor colorWithHue:hue / 360.0
                                                       saturation:1.0
                                                       brightness:0.7
                                                            alpha:1.0]];
  } else if ([iconData.firstObject isEqualToString:@"fromAsset"]) {
    if (iconData.count == 2) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
    } else {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]
                                                   fromPackage:iconData[2]]];
    }
  } else if ([iconData.firstObject isEqualToString:@"fromAssetImage"]) {
    if (iconData.count == 3) {
      image = [UIImage imageNamed:[registrar lookupKeyForAsset:iconData[1]]];
      id scaleParam = iconData[2];
      image = [self scaleImage:image by:scaleParam];
    } else {
      NSString *error =
          [NSString stringWithFormat:@"'fromAssetImage' should have exactly 3 arguments. Got: %lu",
                                     (unsigned long)iconData.count];
      NSException *exception = [NSException exceptionWithName:@"InvalidBitmapDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  } else if ([iconData[0] isEqualToString:@"fromBytes"]) {
    if (iconData.count == 2) {
      @try {
        FlutterStandardTypedData *byteData = iconData[1];
        CGFloat screenScale = [[UIScreen mainScreen] scale];
        image = [UIImage imageWithData:[byteData data] scale:screenScale];
      } @catch (NSException *exception) {
        @throw [NSException exceptionWithName:@"InvalidByteDescriptor"
                                       reason:@"Unable to interpret bytes as a valid image."
                                     userInfo:nil];
      }
    } else {
      NSString *error = [NSString
          stringWithFormat:@"fromBytes should have exactly one argument, the bytes. Got: %lu",
                           (unsigned long)iconData.count];
      NSException *exception = [NSException exceptionWithName:@"InvalidByteDescriptor"
                                                       reason:error
                                                     userInfo:nil];
      @throw exception;
    }
  }

  return image;
}

- (UIImage *)scaleImage:(UIImage *)image by:(id)scaleParam {
  double scale = 1.0;
  if ([scaleParam isKindOfClass:[NSNumber class]]) {
    scale = [scaleParam doubleValue];
  }
  if (fabs(scale - 1) > 1e-3) {
    return [UIImage imageWithCGImage:[image CGImage]
                               scale:(image.scale * scale)
                         orientation:(image.imageOrientation)];
  }
  return image;
}

@end

@interface FLTGroundOverlaysController ()

@property(strong, nonatomic) NSMutableDictionary *groundOverlayIdentifierToController;
@property(strong, nonatomic) FlutterMethodChannel *methodChannel;
@property(weak, nonatomic) NSObject<FlutterPluginRegistrar> *registrar;
@property(weak, nonatomic) GMSMapView *mapView;

@end
;

@implementation FLTGroundOverlaysController

- (instancetype)init:(FlutterMethodChannel *)methodChannel
             mapView:(GMSMapView *)mapView
           registrar:(NSObject<FlutterPluginRegistrar> *)registrar {
  self = [super init];
  if (self) {
    _methodChannel = methodChannel;
    _mapView = mapView;
    _groundOverlayIdentifierToController = [[NSMutableDictionary alloc] init];
    _registrar = registrar;
  }
  return self;
}

- (void)addGroundOverlays:(NSArray *)groundOverlaysToAdd {
  for (NSDictionary *groundOverlay in groundOverlaysToAdd) {
    NSString *identifier = groundOverlay[@"groundOverlayId"];
    FLTGoogleMapGroundOverlayController *controller =
        [[FLTGoogleMapGroundOverlayController alloc] initGroundOverlayWithIdentifier:identifier
                                                                             mapView:self.mapView];
    [controller interpretGroundOvelayOptions:groundOverlay registrar:self.registrar];
    self.groundOverlayIdentifierToController[identifier] = controller;
  }
}

- (void)changeGroundOverlays:(NSArray *)groundOverlaysToChange {
  for (NSDictionary *groundOverlay in groundOverlaysToChange) {
    NSString *identifier = groundOverlay[@"groundOverlayId"];
    FLTGoogleMapGroundOverlayController *controller =
        self.groundOverlayIdentifierToController[identifier];

    if (!controller) {
      return;
    }

    [controller interpretGroundOvelayOptions:groundOverlay registrar:self.registrar];
  }
}

- (void)removeGroundOverlayWithIdentifiers:(NSArray *)identifiers {
  for (NSString *identifier in identifiers) {
    FLTGoogleMapGroundOverlayController *controller =
        self.groundOverlayIdentifierToController[identifier];

    if (!controller) {
      return;
    }

    [controller removeGroundOverlay];
    [self.groundOverlayIdentifierToController removeObjectForKey:identifier];
  }
}

- (void)didTapGroundOverlayWithIdentifier:(NSString *)identifier {
  if (!identifier) {
    return;
  }
  FLTGoogleMapGroundOverlayController *controller =
      self.groundOverlayIdentifierToController[identifier];
  if (!controller) {
    return;
  }
  [self.methodChannel invokeMethod:@"groundOverlay#onTap"
                         arguments:@{@"groundOverlayId" : identifier}];
}

- (bool)hasGroundOverlayWithIdentifier:(NSString *)identifier {
  if (!identifier) {
    return false;
  }
  return self.groundOverlayIdentifierToController[identifier] != nil;
}

+ (GMSCoordinateBounds *)getBounds:(NSDictionary *)groundOverlay {
  NSArray *bounds = groundOverlay[@"bounds"];
  NSArray *_southWest = bounds[0];
  NSArray *_northEast = bounds[1];

  CLLocationCoordinate2D southWest = [FLTGoogleMapJSONConversions locationFromLatLong:bounds[0]];
  CLLocationCoordinate2D northEast = [FLTGoogleMapJSONConversions locationFromLatLong:bounds[1]];
  GMSCoordinateBounds *overlayBounds = [[GMSCoordinateBounds alloc] initWithCoordinate:southWest
                                                                            coordinate:northEast];

  return overlayBounds;
}

@end
