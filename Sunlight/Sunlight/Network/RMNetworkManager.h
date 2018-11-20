//
//  RMNetworkManager.h
//  Money
//
//  Created by 宣佚 on 2017/10/22.
//  Copyright © 2017年 Xuanyi Liu. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * const RMHttpRSAPublicKey;

@interface RMNetworkManager : NSObject

+ (BOOL)checkNetIsReachable;

@property (nonatomic, readonly) BOOL isReachable;
//wifi , wwan
@property (nonatomic, readonly, nonnull) NSString *networkStatus;

+ (nonnull instancetype)sharedManager;

+ (BOOL)checkAppNetworkIsReachable;

- (void)cancelAllNetWork;

@end
