//
//  SVWaresHeaderView.m
//  SAVI
//
//  Created by Sorgle on 2018/1/17.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWaresHeaderView.h"

@implementation SVWaresHeaderView

- (instancetype)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        [self addAllViews];
        self.contentView.backgroundColor = [UIColor blueColor];
    }
    return self;
}


- (void)addAllViews
{
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 29)];
    self.label.textColor = [UIColor redColor];
    [self.contentView addSubview:self.label];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 29, [UIScreen mainScreen].bounds.size.width, 1)];
    view.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:view];
    
}


@end
