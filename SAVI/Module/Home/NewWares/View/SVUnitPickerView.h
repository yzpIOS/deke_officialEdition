//
//  SVUnitPickerView.h
//  SAVI
//
//  Created by Sorgle on 17/5/23.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVUnitPickerView : UIView
@property (weak, nonatomic) IBOutlet UIPickerView *unitPicker;
@property (weak, nonatomic) IBOutlet UIButton *unitCancel;
@property (weak, nonatomic) IBOutlet UIButton *unitDetermine;

@end
