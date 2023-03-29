//
//  SVModifyVipVC.h
//  SAVI
//
//  Created by Sorgle on 2017/6/7.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVModifyVipVC : UIViewController

//全局属性接收
//图片路径
@property (nonatomic,copy) NSString *imgURL;
//卡号
@property (nonatomic,copy) NSString *cardNumber;
//会员名
@property (nonatomic,copy) NSString *name;
//会员ID
@property (nonatomic,copy) NSString *memberID;
//会员级别ID
@property (nonatomic,assign) NSUInteger number;

//等级
@property (nonatomic,copy) NSString *vipLevel;
//电话
@property (nonatomic,copy) NSString *phone;

@property (nonatomic,strong) NSString * telNumber;
//性别 称谓
@property (nonatomic,copy) NSString *gender;
//生日
@property (nonatomic,copy) NSString *birthday;
//地址
@property (nonatomic,copy) NSString *address;


//qq
@property (nonatomic,copy) NSString *qq;
//微信
@property (nonatomic,copy) NSString *weChat;
//邮箱
@property (nonatomic,copy) NSString *email;
//备注
@property (nonatomic,copy) NSString *note;
@property (nonatomic,strong) NSMutableArray *customArray;
/**
 车牌号码
 */
@property (nonatomic,strong) NSString * sv_mr_platenumber;


//修改成功回调
@property (nonatomic,copy) void (^ModifyVipBlock)();


@end
