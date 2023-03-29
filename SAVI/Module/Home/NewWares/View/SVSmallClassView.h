//
//  SVSmallClassView.h
//  SAVI
//
//  Created by Sorgle on 17/5/11.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSmallClassView : UIView
//大分类
@property (weak, nonatomic) IBOutlet UILabel *bigClassName;
//小分类
@property (weak, nonatomic) IBOutlet UITextField *smallClassName;


/**
 取消按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;

/**
 确定按钮
 */
@property (weak, nonatomic) IBOutlet UIButton *determineButton;

@end
