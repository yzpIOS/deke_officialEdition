//
//  SVExpandBtn.m
//  SAVI
//
//  Created by houming Wang on 2019/5/16.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVExpandBtn.h"

@implementation SVExpandBtn

-(BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bounds = self.bounds;
    //扩大原热区直径至40，可以暴露个接口，用来设置需要扩大的半径。
    CGFloat widthDelta = MAX(40, 0);
    CGFloat heightDelta = MAX(40, 0);
    bounds = CGRectInset(bounds, -0.5 * widthDelta, -0.5 * heightDelta);
    return CGRectContainsPoint(bounds, point);
}

@end
