//
//  SVHomeVC.h
//  SAVI
//
//  Created by Sorgle on 17/4/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVBaseVC.h"

@interface SVHomeVC : SVBaseVC
//保存手机属性
@property (nonatomic,copy) NSString *phoneNum;
//保存输入的密码
@property (nonatomic,copy) NSString *password;

@end
