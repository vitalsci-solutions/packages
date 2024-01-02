// TODO copyright

#import <Flutter/Flutter.h>
#import <GoogleMaps/GoogleMaps.h>

// Defines ground overlay controllable by Flutter.
@interface FLTGoogleMapGroundOverlayController : NSObject
- (instancetype)initGroundOverlayWithIdentifier:(NSString *)identifier
                                        mapView:(GMSMapView *)mapView;
- (void)removeGroundOverlay;
@end

@interface FLTGroundOverlaysController : NSObject
- (instancetype)init:(FlutterMethodChannel *)methodChannel
             mapView:(GMSMapView *)mapView
           registrar:(NSObject<FlutterPluginRegistrar> *)registrar;
- (void)addGroundOverlays:(NSArray *)groundOverlaysToAdd;
- (void)changeGroundOverlays:(NSArray *)groundOverlaysToChange;
- (void)removeGroundOverlayWithIdentifiers:(NSArray *)identifiers;
- (void)didTapGroundOverlayWithIdentifier:(NSString *)identifier;
- (bool)hasGroundOverlayWithIdentifier:(NSString *)identifier;
@end
