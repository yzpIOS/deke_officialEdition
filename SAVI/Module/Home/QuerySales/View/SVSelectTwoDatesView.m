//
//  SVSelectTwoDatesView.m
//  SAVI
//
//  Created by Sorgle on 2018/4/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVSelectTwoDatesView.h"

@implementation SVSelectTwoDatesView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (@available(iOS 13.4, *)) {
        self.oneDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
        self.twoDatePicker.preferredDatePickerStyle = UIDatePickerStyleWheels;
    
        
          } else {
              // Fallback on earlier versions
          }
}

@end
