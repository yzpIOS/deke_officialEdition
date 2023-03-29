//
//  SVQuickCashierVC.h
//  SAVI
//
//  Created by Sorgle on 17/5/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVQuickCashierVC : UIViewController

@property(retain,nonatomic) UIButton *button;
@property(retain,nonatomic) NSMutableString *string;  //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(retain,nonatomic) NSMutableString *stringNumber;
@property(assign,nonatomic) double num1,num2;
@property(assign,nonatomic) NSString *str;



@end
