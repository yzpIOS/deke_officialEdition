//
//  SVNewWarestwoCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVNewWarestwoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *price;
@property (weak, nonatomic) IBOutlet UITextField *sv_p_originalprice;
@property (weak, nonatomic) IBOutlet UITextField *sv_p_memberprice;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoCell_height;
@property (weak, nonatomic) IBOutlet UIView *jinjiaView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lineView_height;

@property (weak, nonatomic) IBOutlet UITextField *sv_p_artno;
@property (weak, nonatomic) IBOutlet UITextField *sv_mnemonic_code;

@end
