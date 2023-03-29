//
//  UIView+CHView.m
//  CAAnimationTest
//
//  Created by JCH on 16/1/9.
//  Copyright © 2016年 JCH. All rights reserved.
//

#import "UIView+CHView.h"

@implementation UIView (CHView)

- (void)addCornerRadiusWithcorners:(UIRectCorner)corners AndRadii:(CGSize)radii {
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *shapLayer = [[CAShapeLayer alloc]init];
    shapLayer.path = bezierPath.CGPath;
    self.layer.mask = shapLayer;
}

@end
