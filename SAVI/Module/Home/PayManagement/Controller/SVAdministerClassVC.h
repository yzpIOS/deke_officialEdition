//
//  SVAdministerClassVC.h
//  SAVI
//
//  Created by Sorgle on 2017/10/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVAdministerClassVC : UIViewController

@property (nonatomic,copy) NSString *className;
@property (nonatomic,copy) NSString *number;

//blcok
@property (nonatomic,copy) void(^administerBlock)();

@end
