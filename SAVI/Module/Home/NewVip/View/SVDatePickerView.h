//
//  SVDatePickerView.h
//  SAVI
//
//  Created by Sorgle on 17/5/23.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVDatePickerView : UIView
@property (weak, nonatomic) IBOutlet UIDatePicker *datePickerView;
@property (weak, nonatomic) IBOutlet UIButton *dateCancel;
@property (weak, nonatomic) IBOutlet UIButton *dateDetermine;

@end
