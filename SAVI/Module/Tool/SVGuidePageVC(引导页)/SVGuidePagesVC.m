//
//  SVGuidePagesVC.m
//  SAVI
//
//  Created by Sorgle on 2017/11/29.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVGuidePagesVC.h"

#define VERSION_INFO_CURRENT @"currentversion"

@interface SVGuidePagesVC ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIPageControl *pageControl;

@property (nonatomic, strong) UIImageView *btnEnter;

@end

@implementation SVGuidePagesVC

- (void)guidePageControllerWithImages:(NSArray *)images
{
    UIScrollView *gui = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
    gui.delegate = self;
    gui.pagingEnabled = YES;
    // 隐藏滑动条
    gui.showsHorizontalScrollIndicator = NO;
    gui.showsVerticalScrollIndicator = NO;
    // 取消反弹
    gui.bounces = NO;
    for (NSInteger i = 0; i < images.count; i ++) {
        [gui addSubview:({
            self.btnEnter = [[UIImageView alloc]init];
            self.btnEnter.frame = CGRectMake(ScreenW * i, 0, ScreenW, ScreenH);
            //[self.btnEnter setImage:[UIImage imageNamed:images[i]] forState:UIControlStateNormal];;
            self.btnEnter.image = [UIImage imageNamed:images[i]];
            self.btnEnter.userInteractionEnabled = YES;
            self.btnEnter;
        })];
        
        [self.btnEnter addSubview:({
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            if (i == images.count - 1) {
                [btn setTitle:@"点击进入" forState:UIControlStateNormal];
                btn.frame = CGRectMake(0, 0, 80, 50);
                btn.center = CGPointMake(ScreenW / 2, ScreenH - 130 + BottomHeight);
                btn.backgroundColor = RGBA(0, 0, 0, 0.3);
                btn.layer.cornerRadius = 25;
                
//                [btn setTitle:@"点击进入" forState:UIControlStateNormal];
//                btn.frame = CGRectMake(0, 0, 80, 30);
//                btn.center = CGPointMake(ScreenW/2, ScreenH-BottomHeight-PoorHeight-150);
//                btn.backgroundColor = RGBA(0, 0, 0, 0.3);
//                btn.layer.cornerRadius = 15;
            }
//            else {
//                [btn setTitle:@"跳过" forState:UIControlStateNormal];
//                btn.frame = CGRectMake(0, 0, 50, 30);
//                btn.center = CGPointMake(ScreenW - 30, 50);
//                btn.layer.cornerRadius = 15;
//                btn.backgroundColor = RGBA(0, 0, 0, 0.3);
//            }
            [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
            btn.clipsToBounds = YES;
            btn.titleLabel.font = [UIFont systemFontOfSize:13];
            [btn addTarget:self action:@selector(clickEnter) forControlEvents:UIControlEventTouchUpInside];
            btn;
        })];
    }
    gui.contentSize = CGSizeMake(ScreenW * images.count, 0);
    [self.view addSubview:gui];
    
    // pageControl
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 0, ScreenW / 2, 30)];
    self.pageControl.center = CGPointMake(ScreenW / 2, ScreenH - 20);
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = images.count;
}
- (void)clickEnter
{
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(clickEnter)]) {
        [self.delegate clickEnter];
    }
}
+ (BOOL)isShow
{
    // 读取版本信息
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    NSString *localVersion = [user objectForKey:VERSION_INFO_CURRENT];
    NSString *currentVersion =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    if (localVersion == nil || ![currentVersion isEqualToString:localVersion]) {
        [SVGuidePagesVC saveCurrentVersion];
        return YES;
    }else
    {
        return NO;
    }
}
// 保存版本信息
+ (void)saveCurrentVersion
{
    NSString *version =[[NSBundle mainBundle].infoDictionary objectForKey:@"CFBundleShortVersionString"];
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    [user setObject:version forKey:VERSION_INFO_CURRENT];
    [user synchronize];
}
#pragma mark - ScrollerView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    double page = scrollView.contentOffset.x / ScreenW;
    // 四舍五入计算出页码
    self.pageControl.currentPage = (int)(page + 0.5);
    // 1.3四舍五入 1.3 + 0.5 = 1.8 强转为整数(int)1.8= 1
    // 1.5四舍五入 1.5 + 0.5 = 2.0 强转为整数(int)2.0= 2
    // 1.6四舍五入 1.6 + 0.5 = 2.1 强转为整数(int)2.1= 2
    // 0.7四舍五入 0.7 + 0.5 = 1.2 强转为整数(int)1.2= 1
}
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//    double page = scrollView.contentOffset.x / ScreenW;
//    // 四舍五入计算出页码
//    self.pageControl.currentPage = (int)(page + 0.5);
//
//}

@end
