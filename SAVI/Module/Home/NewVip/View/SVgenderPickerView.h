//
//  SVgenderPickerView.h
//  SAVI
//
//  Created by Sorgle on 17/5/23.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVgenderPickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *genderPicker;
@property (weak, nonatomic) IBOutlet UIButton *genderCancel;
@property (weak, nonatomic) IBOutlet UIButton *genderDetermine;

@end
