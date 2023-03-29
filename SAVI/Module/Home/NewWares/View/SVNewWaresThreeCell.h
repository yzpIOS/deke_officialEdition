//
//  SVNewWaresThreeCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVNewWaresThreeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *inventory;
@property (weak, nonatomic) IBOutlet UITextField *specifications;

//@property (weak, nonatomic) IBOutlet UITextField *unit;
@property (weak, nonatomic) IBOutlet UILabel *unit;
@property (weak, nonatomic) IBOutlet UIView *unitView;
@property (weak, nonatomic) IBOutlet UISwitch *switch_isOn;
@property (weak, nonatomic) IBOutlet UITextField *sv_guaranteeperiod;

@end
