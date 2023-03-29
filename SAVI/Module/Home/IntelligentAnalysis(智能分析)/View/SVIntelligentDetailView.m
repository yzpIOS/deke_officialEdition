//
//  SVIntelligentDetailView.m
//  SAVI
//
//  Created by houming Wang on 2019/9/18.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVIntelligentDetailView.h"


@interface SVIntelligentDetailView()
//@property (weak, nonatomic) IBOutlet UIView *topView;

@end
@implementation SVIntelligentDetailView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.topView.layer.cornerRadius = 10;
    self.topView.layer.masksToBounds = YES;
}



@end
