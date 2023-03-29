//
//  SVDatePickerView.m
//  SAVI
//
//  Created by Sorgle on 17/5/23.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVDatePickerView.h"

@implementation SVDatePickerView

- (void)awakeFromNib {
    [super awakeFromNib];
    if (@available(iOS 13.4, *)) {
              self.datePickerView.preferredDatePickerStyle = UIDatePickerStyleWheels;
          } else {
              // Fallback on earlier versions
          }
}

@end
