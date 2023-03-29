//
//  SVSmallTicketCustomInfoCell.m
//  SAVI
//
//  Created by houming Wang on 2019/6/24.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVSmallTicketCustomInfoCell.h"


@interface SVSmallTicketCustomInfoCell()
//@property (weak, nonatomic) IBOutlet UITextView *textView;

@end
@implementation SVSmallTicketCustomInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.textView_text.layer.cornerRadius = 5;
    self.textView_text.layer.masksToBounds = YES;
    self.textView_text.layer.borderWidth = 1;
    self.textView_text.layer.borderColor = BackgroundColor.CGColor;

    self.textView_text.inputAccessoryView = [[UIView alloc] init];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
