//
//  SVGifViewController.m
//  SAVI
//
//  Created by 杨忠平 on 2022/11/14.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVGifViewController.h"

@interface SVGifViewController ()
@property (nonatomic, strong) UIImageView *btnEnter;
@end

@implementation SVGifViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.btnEnter = [[UIImageView alloc]init];
    self.btnEnter.frame = CGRectMake(0, 0, ScreenW, ScreenH);
    //[self.btnEnter setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];;
    self.btnEnter.image = [UIImage imageNamed:@"yindaoye.jpg"];
    self.btnEnter.userInteractionEnabled = YES;

    [self.view addSubview:self.btnEnter];
}

@end
