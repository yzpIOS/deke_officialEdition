//
//  AppDelegate.h
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MiPushSDK.h"

// 友盟统计key
static NSString *const UMAppKey = @"5fc4596f53a0037e285168b7";
static NSString *const UMAppChannel = @"Default";

@interface AppDelegate : UIResponder <UIApplicationDelegate,
UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

/**
 * 是否允许转向
 */
@property(nonatomic,assign)BOOL allowRotation;

@end



///1.fix bug
// a==1
