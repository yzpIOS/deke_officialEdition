//
//  SVModifyClassView.h
//  SAVI
//
//  Created by Sorgle on 2017/10/11.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVModifyClassView : UIView

//小分类
@property (weak, nonatomic) IBOutlet UITextField *Name;


/**
 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/**
 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
@property (weak, nonatomic) IBOutlet UIButton *determineTwoButton;

@end
