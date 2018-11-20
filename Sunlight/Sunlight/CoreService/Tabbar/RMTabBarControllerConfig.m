//
//  RMTabBarControllerConfig.m
//  Money
//
//  Created by 宣佚 on 2017/10/22.
//  Copyright © 2017年 Xuanyi Liu. All rights reserved.
//

#import "RMTabBarControllerConfig.h"
#import "RMMineVC.h"
#import "RMHomeViewController.h"
#import "RMBaseNavigationController.h"

@interface RMTabBarControllerConfig ()<UITabBarControllerDelegate>

@property (nonatomic, readwrite, strong) CYLTabBarController *tabBarController;

@end

@implementation RMTabBarControllerConfig

/**
 *  lazy load tabBarController
 *
 *  @return CYLTabBarController
 */
- (CYLTabBarController *)tabBarController {
    if (_tabBarController == nil) {
        /**
         * 以下两行代码目的在于手动设置让TabBarItem只显示图标，不显示文字，并让图标垂直居中。
         * 等效于在 `-tabBarItemsAttributesForController` 方法中不传 `CYLTabBarItemTitle` 字段。
         * 更推荐后一种做法。
         */
        UIEdgeInsets imageInsets = UIEdgeInsetsZero;//UIEdgeInsetsMake(4.5, 0, -4.5, 0);
        UIOffset titlePositionAdjustment = UIOffsetZero;//UIOffsetMake(0, MAXFLOAT);
        
        CYLTabBarController *tabBarController = [CYLTabBarController tabBarControllerWithViewControllers:self.viewControllers
                                                                                   tabBarItemsAttributes:self.tabBarItemsAttributesForController
                                                                                             imageInsets:imageInsets
                                                                                 titlePositionAdjustment:titlePositionAdjustment];

        [self customizeTabBarAppearance:tabBarController];
        _tabBarController = tabBarController;
    }
    return _tabBarController;
}

- (NSArray *)viewControllers {

    RMHomeViewController *homeVC = [[RMHomeViewController alloc] init];
    UIViewController *homeNav = [[RMBaseNavigationController alloc]
                                                   initWithRootViewController:homeVC];
    
    
    
    RMMineVC *mineVC = [[RMMineVC alloc] init];
    UIViewController *mineNav = [[RMBaseNavigationController alloc]
                                                    initWithRootViewController:mineVC];
    
    NSArray * viewControllers = @[
                        homeNav,
                        mineNav
                        ];
    
    return viewControllers;
}

- (NSArray *)tabBarItemsAttributesForController {
    
    NSDictionary *shopTabBarItemsAttributes = @{
                                                CYLTabBarItemTitle : @"商城",
                                                CYLTabBarItemImage : @"home_normal",  /* NSString and UIImage are supported*/
                                                CYLTabBarItemSelectedImage : @"home_highlight", /* NSString and UIImage are supported*/
                                                };
    NSDictionary *homeTabBarItemsAttributes = @{
                                                 CYLTabBarItemTitle : @"首页",
                                                 CYLTabBarItemImage : @"home_normal",
                                                 CYLTabBarItemSelectedImage : @"home_highlight", 
                                                 };

    NSDictionary *mineTabBarItemsAttributes = @{
                                                  CYLTabBarItemTitle : @"我的",
                                                  CYLTabBarItemImage : @"account_normal",
                                                  CYLTabBarItemSelectedImage : @"account_highlight"
                                                  };

    NSArray *tabBarItemsAttributes = nil;
    if (self.type == 0){
        
        tabBarItemsAttributes = @[
                                  homeTabBarItemsAttributes,
                                  mineTabBarItemsAttributes
                                  ];
        
    }else{
        
        tabBarItemsAttributes = @[
                                  homeTabBarItemsAttributes,
                                  shopTabBarItemsAttributes,
                                  mineTabBarItemsAttributes
                                  ];
    }
    
    return tabBarItemsAttributes;
}

/**
 *  更多TabBar自定义设置：比如：tabBarItem 的选中和不选中文字和背景图片属性、tabbar 背景图片属性等等
 */
- (void)customizeTabBarAppearance:(CYLTabBarController *)tabBarController {
    // Customize UITabBar height
    // 自定义 TabBar 高度
    //     tabBarController.tabBarHeight = CYLTabBarControllerHeight;
    
    // set the text color for unselected state
    // 普通状态下的文字属性
    NSMutableDictionary *normalAttrs = [NSMutableDictionary dictionary];
    normalAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text color for selected state
    // 选中状态下的文字属性
    NSMutableDictionary *selectedAttrs = [NSMutableDictionary dictionary];
    selectedAttrs[NSForegroundColorAttributeName] = [UIColor blackColor];
    
    // set the text Attributes
    // 设置文字属性
    UITabBarItem *tabBar = [UITabBarItem appearance];
    [tabBar setTitleTextAttributes:normalAttrs forState:UIControlStateNormal];
    [tabBar setTitleTextAttributes:selectedAttrs forState:UIControlStateSelected];
    
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc] init]];
    [[UITabBar appearance] setBackgroundColor:[UIColor whiteColor]];
    [[UITabBar appearance] setShadowImage:[UIImage imageNamed:@"tapbar_top_line"]];
//    [[UITabBar appearance] setShadowImage:[[UIImage alloc] init]];
}

@end
