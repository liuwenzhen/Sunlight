//
//  RMTabBarControllerConfig.h
//  Money
//
//  Created by 宣佚 on 2017/10/22.
//  Copyright © 2017年 Xuanyi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CYLTabBarController.h"

@interface RMTabBarControllerConfig : NSObject

@property (nonatomic, readonly, strong) CYLTabBarController *tabBarController;


/**
 0是无商城用户 1是全量用户
 */
@property (nonatomic,assign) NSInteger type;

@end
