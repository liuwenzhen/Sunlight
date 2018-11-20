//
//  AppDelegate+RMService.m
//  Money
//
//  Created by 宣佚 on 2017/10/22.
//  Copyright © 2017年 Xuanyi Liu. All rights reserved.
//

#import "AppDelegate+RMService.h"
#import "RMTabBarControllerConfig.h"
#import "RMNetworkManager.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import "ZCBusinessService.h"
#import "ZCRequestModel.h"
#import "UIDevice+RMDevice.h"
#import "RMBaseNavigationController.h"
#import "IQKeyboardManager.h"

@interface AppDelegate () <UITabBarControllerDelegate, CYLTabBarControllerDelegate>

@end

@implementation AppDelegate (RMService)

#pragma mark ————— 初始化window —————
-(void)initWindow {
    self.window = [[UIWindow alloc]init];
    self.window.frame = [UIScreen mainScreen].bounds;
    [self.window makeKeyAndVisible];
}

#pragma mark 初始化Tabbar

- (void)toShowRootVC {
    
    [self initTabbarControllerWithType:[CURRENT_USER.userType integerValue]];
}

- (void)initTabbarControllerWithType:(NSInteger )type{
    
    RMTabBarControllerConfig *tabBarControllerConfig = [[RMTabBarControllerConfig alloc] init];
    tabBarControllerConfig.type = type;
    CYLTabBarController *tabBarController = tabBarControllerConfig.tabBarController;
    [self.window setRootViewController:tabBarController];
    tabBarController.delegate = self;
}






-(void)startUpShare {

    [ShareSDK registerActivePlatforms:@[
                                        @(SSDKPlatformTypeWechat)
                                        ]
                             onImport:^(SSDKPlatformType platformType)
     {
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [ShareSDKConnector connectWeChat:[WXApi class]];
                 break;
             default:
                 break;
         }
     }
                      onConfiguration:^(SSDKPlatformType platformType, NSMutableDictionary *appInfo)
     {
         
         switch (platformType)
         {
             case SSDKPlatformTypeWechat:
                 [appInfo SSDKSetupWeChatByAppId:@"wxcf4394ad2e6260dc"
                                       appSecret:@"7a308c506ff93cecd43ea68cb6d46dde"];
                 break;
             default:
                 break;
         }
     }];
}

// 0 手势密码错误 100 别的设备登录
- (void)kickLoginOutWithReason:(NSInteger )reason{
    
    switch (reason) {
        case 0:
            [RMProgressManager showInfoMessage:@"手势密码错误次数过多"];
            break;
        case 100:
            [RMProgressManager showInfoMessage:@"您已在另一台设备上登录"];
            break;
            
        default:
            break;
    }
    
    [self performSelector:@selector(logoutToHome) withObject:nil afterDelay:2];
    
}

- (void)logoutToHome{
    
    [RMUserInfoModel loginOut];
    [self toShowRootVC];
}

#pragma mark - delegate

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController {
    
    return YES;
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{

}

- (void)setIQkeyboard{
    
    [[[IQKeyboardManager sharedManager]disabledDistanceHandlingClasses] addObject:[RMShopHomeVC class]];
}

@end
