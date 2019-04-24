#import "FlutterAmapPlugin.h"
#import <flutter_amap_plugin/flutter_amap_plugin-Swift.h>
#import <AMapFoundationKit/AMapFoundationKit.h>

static NSString *AMAP_BASE_CHANNEL = @"plugin/base/init";
static NSString *AMAP_MAP_CHANNEL = @"plugin/amap/map";
static NSString *AMAP_NAV_CHANNEL = @"plugin/amap/nav";
@implementation FlutterAmapPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFlutterAmapPlugin registerWithRegistrar:registrar];
    
    [AMapServices sharedServices].enableHTTPS = YES;
    [FlutterAmapPlugin setChannel:registrar];
    
    FlutterAMapViewFactory *mapFactory = [[FlutterAMapViewFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:mapFactory withId:AMAP_MAP_CHANNEL];
    
    FlutterAMapNavFactory *navFactory = [[FlutterAMapNavFactory alloc]initWithMessenger:[registrar messenger]];
    [registrar registerViewFactory:navFactory withId:AMAP_NAV_CHANNEL];
    
}

+ (void)setChannel:(NSObject<FlutterPluginRegistrar>*)registar {
    //设置AMap Key
    FlutterMethodChannel *setKeyChannel = [FlutterMethodChannel methodChannelWithName:AMAP_BASE_CHANNEL binaryMessenger:[registar messenger]];
    [setKeyChannel setMethodCallHandler:^(FlutterMethodCall * _Nonnull call, FlutterResult  _Nonnull result) {
        if ([call.method isEqualToString:@"initKey"]) {
            
            NSString *key = call.arguments[@"iosKey"];
            [AMapServices sharedServices].apiKey = key;
            
            result(@"AMap_Key set success");
        } else {
            result(FlutterMethodNotImplemented);
        }
    }];
}
@end
