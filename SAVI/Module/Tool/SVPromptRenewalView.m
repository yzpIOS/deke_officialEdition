//
//  SVPromptRenewalView.m
//  SAVI
//
//  Created by F on 2020/8/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVPromptRenewalView.h"

@interface SVPromptRenewalView()

@end

@implementation SVPromptRenewalView

- (void)awakeFromNib{
    [super awakeFromNib];
    self.renewBtn.layer.cornerRadius = 22;
    self.renewBtn.layer.masksToBounds = YES;
}

@end
