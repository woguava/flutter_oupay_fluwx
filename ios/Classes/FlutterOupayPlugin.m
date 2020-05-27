#import "FlutterOupayPlugin.h"
#import "OupayAlipay.h"
#import "OupayCMBPay.h"
#import "OupayUnionPay.h"

__weak FlutterOupayPlugin* __FlutterOupayPlugin;

@interface FlutterOupayPlugin()
@property (readwrite,copy,nonatomic) FlutterResult __result;
@property (readwrite,copy,nonatomic) NSString * alipay_urlScheme;
@property (readwrite,copy,nonatomic) NSString * uppay_urlScheme;
@property (readwrite,copy,nonatomic) NSString * cmb_urlScheme;
@end

@implementation FlutterOupayPlugin{
    UIViewController *_viewController;
}

- (instancetype)initWithViewController:(UIViewController *)viewController {
    self = [super init];
    if (self) {
        _viewController = viewController;
        __FlutterOupayPlugin  = self;
    }
    return self;
}

+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"flutter_oupay"
            binaryMessenger:[registrar messenger]];
 UIViewController *viewController =
    [UIApplication sharedApplication].delegate.window.rootViewController;
    FlutterOupayPlugin* instance = [[FlutterOupayPlugin alloc] initWithViewController:viewController];
  [registrar addMethodCallDelegate:instance channel:channel];
}



- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  self.__result = result;

  if ([@"checkInstallApps" isEqualToString:call.method]) {
      NSString * unpayAppid = call.arguments[@"unpayAppid"];
      NSString * alipayAppid = call.arguments[@"alipayAppid"];
      NSString * wechatAppid = call.arguments[@"wechatAppid"];
      NSString * cmbAppid = call.arguments[@"cmbAppid"];

      NSNumber *boolUppay = [NSNumber numberWithBool:[OupayUnionPay checkInstallApp:unpayAppid]];
      NSNumber *boolAlipay = [NSNumber numberWithBool:[OupayAlipay checkInstallApp:alipayAppid]];
      //NSNumber *boolWechat = [NSNumber numberWithBool:[OupayWechat checkInstallApp:wechatAppid]];
      NSNumber *boolCmb = [NSNumber numberWithBool:[OupayCMBPay checkInstallApp:cmbAppid]];
      
      
      NSDictionary * resultDict = @{@"unpayApp":boolUppay,@"alipayApp":boolAlipay,
                                    @"wechatApp":[NSNumber numberWithBool:YES],@"cmbApp":boolCmb};

      result(resultDict);
  } else if ([@"unionPay" isEqualToString:call.method]) {
    NSString * payInfo = call.arguments[@"payInfo"];
    NSNumber * isSandbox = call.arguments[@"isSandbox"];
    NSString * urlScheme = call.arguments[@"urlScheme"];
      
    self.uppay_urlScheme = urlScheme;

    [OupayUnionPay startPay:payInfo isSandbox:[isSandbox boolValue] urlScheme:urlScheme viewCtrl:_viewController result:result ];

  } else if ([@"aliPay" isEqualToString:call.method]) {
    NSString * payInfo = call.arguments[@"payInfo"];
    NSNumber * isSandbox = call.arguments[@"isSandbox"];
    NSString * urlScheme = call.arguments[@"urlScheme"];
    
    self.alipay_urlScheme = urlScheme;

    [OupayAlipay startPay:payInfo urlScheme:urlScheme result:result ];

  }  else if ([@"cmbchinaPay" isEqualToString:call.method]) {
    NSString * payInfo = call.arguments[@"payInfo"];
    NSString *  appId = call.arguments[@"appid"];
    NSNumber * isSandbox = call.arguments[@"isSandbox"];
     NSString * urlScheme = call.arguments[@"urlScheme"];
      
    self.cmb_urlScheme = urlScheme;

    [OupayCMBPay startPay:appId payInfo:payInfo isSandbox:[isSandbox boolValue] viewCtrl:_viewController result:result ];

  } else {
    result(FlutterMethodNotImplemented);
  }

}

+(BOOL)handleOpenURL:(NSURL*)url{
    if(!__FlutterOupayPlugin)return NO;
    return [__FlutterOupayPlugin handleOpenURL:url];
}

//回调通知
- (BOOL)handleOpenURL:(NSURL*)url {
    NSLog(@"reslut = %@",url);
    NSLog(@"url.scheme = %@",url.scheme);
    if( [url.scheme isEqualToString:self.alipay_urlScheme] ){
        return [OupayAlipay handleOpenURL:url result:self.__result];
    }else if( [url.scheme isEqualToString:self.uppay_urlScheme] ){
        return [OupayUnionPay handleOpenURL:url result:self.__result];
    }else if( [url.scheme isEqualToString:self.cmb_urlScheme] ){
        return [OupayCMBPay handleOpenURL:url result:self.__result];
    }
    
    return NO;
}

@end
