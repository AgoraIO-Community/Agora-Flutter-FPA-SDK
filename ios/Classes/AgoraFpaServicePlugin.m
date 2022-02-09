#import "AgoraFpaServicePlugin.h"
#if __has_include(<agora_fpa_service/agora_fpa_service-Swift.h>)
#import <agora_fpa_service/agora_fpa_service-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "agora_fpa_service-Swift.h"
#endif

@implementation AgoraFpaServicePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAgoraFpaServicePlugin registerWithRegistrar:registrar];
}
@end
