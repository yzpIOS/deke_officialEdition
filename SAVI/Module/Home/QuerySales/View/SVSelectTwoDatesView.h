//
//  SVSelectTwoDatesView.h
//  SAVI
//
//  Created by Sorgle on 2018/4/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSelectTwoDatesView : UIView
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *determineButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *oneDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *twoDatePicker;

@end
