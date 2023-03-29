//
//  SVvipPickerView.h
//  SAVI
//
//  Created by Sorgle on 17/5/23.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVvipPickerView : UIView
//pickerView
@property (weak, nonatomic) IBOutlet UIPickerView *vipPicker;
//取消
@property (weak, nonatomic) IBOutlet UIButton *vipCancel;
//确定
@property (weak, nonatomic) IBOutlet UIButton *vipDetermine;

@property (weak, nonatomic) IBOutlet UIPickerView *twoVipPicker;
@property (weak, nonatomic) IBOutlet UIButton *twovipCancel;
@property (weak, nonatomic) IBOutlet UIButton *twovipDetermine;

@end
