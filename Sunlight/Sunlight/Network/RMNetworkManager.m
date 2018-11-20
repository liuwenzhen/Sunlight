//
//  RMNetworkManager.m
//  Money
//
//  Created by 宣佚 on 2017/10/22.
//  Copyright © 2017年 Xuanyi Liu. All rights reserved.
//

#import "RMNetworkManager.h"
#import <CoreTelephony/CTCellularData.h>
#import <YTKNetwork/YTKNetwork.h>
#import <AFNetworking/AFNetworking.h>

//NSString * const RMHttpRSAPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0qAC9e/DhDy0rBFYA2CbWM3Bu8+KB0Wgp/NW8BUn7T1WsM3vE3tvC26AL4z+XH3t6KTaD8mB+zf0hT62aY/443gOGS9Uf/VSF5ZuCdN70ngBhDF5s1dt/dTPnr/fXnOSrrzJ9TopzNOhVEwSD4wCCpyHT4Sn2zlF/IOntDYd0ywIDAQAB";

NSString * const RMHttpRSAPublicKey = @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC0qAC9e/DhDy0rBFYA2CbWM3Bu8+KB0Wgp/NW8BUn7T1WsM3vE3tvC26AL4z+XH3t6KTaD8mB+zf0hT62aY/443gOGS9Uf/VSF5ZuCdN70ngBhDF5s1dt/dTPnr/fXnOSrrzJ9TopzNOhVEwSD4wCCpyHT4Sn2zlF/IOntDYd0ywIDAQAB";









@interface RMNetworkManager ()

@end

@implementation RMNetworkManager

+ (BOOL)checkNetIsReachable {
    if (![RMNetworkManager sharedManager].isReachable || ![RMNetworkManager checkAppNetworkIsReachable]) {
        return NO;
    }
    return YES;
}

+ (instancetype)sharedManager
{
    static RMNetworkManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[RMNetworkManager alloc] init];
    });
    return manager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        _isReachable = YES;
        _networkStatus = [self localizationForNetworkstatus:AFNetworkReachabilityStatusReachableViaWiFi];
        
        __weak __typeof(self)myself = self;
        AFNetworkReachabilityManager *reachabilityManager = [AFNetworkReachabilityManager sharedManager];
        [reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            [myself networkStatusChanged:status];
        }];
        [reachabilityManager startMonitoring];
    }
    return self;
}

- (void)networkStatusChanged:(AFNetworkReachabilityStatus)status
{
    if (status == AFNetworkReachabilityStatusNotReachable) {
        _isReachable = NO;
    } else {
        _isReachable = YES;
    }
    _networkStatus = [self localizationForNetworkstatus:status];
}

- (NSString *)localizationForNetworkstatus:(AFNetworkReachabilityStatus)status
{
    switch (status) {
        case AFNetworkReachabilityStatusUnknown:
        case AFNetworkReachabilityStatusReachableViaWiFi:
            return @"WIFI";
        case AFNetworkReachabilityStatusReachableViaWWAN:
            return @"WWAN";
        case AFNetworkReachabilityStatusNotReachable:
            return @"NotReachable";
        default:
            break;
    }
}

+ (void)refreshAppNetworkState:(void(^)(BOOL isReachable))block {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    cellularData.cellularDataRestrictionDidUpdateNotifier =  ^(CTCellularDataRestrictedState state){
        switch (state) {
            case kCTCellularDataRestricted:
                block(NO);
                break;
            case kCTCellularDataNotRestricted:
                block(YES);
                break;
            case kCTCellularDataRestrictedStateUnknown:
                block(YES);
                break;
            default:
                block(YES);
                break;
        }
    };
}

- (void)cancelAllNetWork {
    [[YTKNetworkAgent sharedAgent] cancelAllRequests];
}

+ (BOOL)checkAppNetworkIsReachable {
    CTCellularData *cellularData = [[CTCellularData alloc]init];
    CTCellularDataRestrictedState state = cellularData.restrictedState;
    switch (state) {
        case kCTCellularDataRestricted:
            return NO;
            break;
        case kCTCellularDataNotRestricted:
            return YES;
            break;
        case kCTCellularDataRestrictedStateUnknown:
            return YES;
            break;
        default:
            return NO;
            break;
    }
}

@end
