//
//  SVDateAnalysisVC.h
//  SAVI
//
//  Created by Sorgle on 2017/8/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVDateAnalysisVC : UIViewController

//些属性为了在别的地方设置响应事件
@property (nonatomic, strong) UIButton *button;

@property (nonatomic,copy) void(^dateBlock)(NSString *oneDate,NSString *twoDate);

@property (nonatomic, strong) NSString *oneDate;
@property (nonatomic, strong) NSString *twoDate;

@property (nonatomic,copy) void(^infoInquirySaleBlock)(NSString *oneDate,NSString *twoDate);

@end
