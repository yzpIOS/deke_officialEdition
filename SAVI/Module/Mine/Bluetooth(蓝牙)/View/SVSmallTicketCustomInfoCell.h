//
//  SVSmallTicketCustomInfoCell.h
//  SAVI
//
//  Created by houming Wang on 2019/6/24.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SVSmallTicketCustomInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextView *textView_text;


@property (weak, nonatomic) IBOutlet UISwitch *textView_switch;

@end

NS_ASSUME_NONNULL_END
