#import "FlutterAmapPlugin.h"
#import <flutter_amap_plugin/flutter_amap_plugin-Swift.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

static NSObject <FlutterPluginRegistrar> *_registar;
static FlutterMethodChannel *_locChannel;

static NSString *AMAP_BASE_CHANNEL = @"plugin/base/init";
static NSString *AMAP_MAP_CHANNEL = @"plugin/amap/map";
static NSString *AMAP_NAV_CHANNEL = @"plugin/amap/nav";
static NSString *AMAP_LOCATION_CHANNEL = @"plugin/amap/location";
static NSString *AMAP_SEARCH_ROUTE_CHANNEL = @"plugin/amap/search/route";

@implementation FlutterAmapPlugin
+ (void)registerWithRegistrar:(NSObject <FlutterPluginRegistrar> *)registrar {
    [SwiftFlutterAmapPlugin registerWithRegistrar:registrar];
    _registar = registrar;

    [AMapServices sharedServices].enableHTTPS = YES;
    [FlutterAmapPlugin setChannel:registrar];

    FlutterAMapViewFactory *mapFactory = [[FlutterAMapViewFactory alloc] initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:mapFactory withId:AMAP_MAP_CHANNEL];

    FlutterAMapNavFactory *navFactory = [[FlutterAMapNavFactory alloc] initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:navFactory withId:AMAP_NAV_CHANNEL];
}

+ (void)setChannel:(NSObject <FlutterPluginRegistrar> *)registar {
    //设置AMap Key
    FlutterMethodChannel *setKeyChannel = [FlutterMethodChannel methodChannelWithName:AMAP_BASE_CHANNEL binaryMessenger:[registar messenger]];
    [setKeyChannel setMethodCallHandler:^(FlutterMethodCall *_Nonnull call, FlutterResult _Nonnull result) {
        if ([call.method isEqualToString:@"initKey"]) {
            NSString *key = call.arguments[@"iosKey"];
            [AMapServices sharedServices].apiKey = key;
            result(@"AMap_Key set success");
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

    //定位
    FlutterMethodChannel *locationChannel = [FlutterMethodChannel methodChannelWithName:AMAP_LOCATION_CHANNEL binaryMessenger:[registar messenger]];
    _locChannel = locationChannel;
    [locationChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([call.method isEqualToString:@"startSingleLocation"]) {
            FlutterAMapStartLocation *startLocation = [[FlutterAMapStartLocation alloc] init];
            [startLocation onMethodWithCall:call result:result];
        } else if ([call.method isEqualToString:@"stopLocation"]) {
            FlutterAMapStopLocation *stopLocation = [[FlutterAMapStopLocation alloc] init];
            [stopLocation onMethodWithCall:call result:result];
        } else if ([call.method isEqualToString:@"initLocation"]) {
            [[FlutterAMapLocation alloc] init];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

    //路线规划
    FlutterMethodChannel *routeChannel = [FlutterMethodChannel methodChannelWithName:AMAP_SEARCH_ROUTE_CHANNEL binaryMessenger:[registar messenger]];
    [routeChannel setMethodCallHandler:^(FlutterMethodCall *call, FlutterResult result) {
        if ([call.method isEqualToString:@"startRoutePlanning"]) {
            FlutterAMapRoutePlan *routePlan = [[FlutterAMapRoutePlan alloc] init];
            [routePlan onMethodWithCall:call result:result];
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];

}

+ (NSObject <FlutterPluginRegistrar> *)registar {
    return _registar;
}

+ (FlutterMethodChannel *)locationChannel {
    return _locChannel;
}
@end
