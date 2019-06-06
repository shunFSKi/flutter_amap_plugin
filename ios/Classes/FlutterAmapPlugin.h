#import <Flutter/Flutter.h>

@interface FlutterAmapPlugin : NSObject<FlutterPlugin>

+ (NSObject<FlutterPluginRegistrar> *) registar;
+ (FlutterMethodChannel *)locationChannel;
@end
