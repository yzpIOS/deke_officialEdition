//
//  SVCashierVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/14.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVCashierVC.h"
//选择商品
#import "SVSelectWaresVC.h"
//选择会员
#import "SVVipSelectVC.h"

@interface SVCashierVC (){
    SVSelectWaresVC *_oneVC;
    UIViewController *_twoVC;
}
//分段控件
@property (nonatomic,strong) UISegmentedControl *segment;

//会员名
@property (nonatomic,copy) NSString *name;
//会员折扣
@property (nonatomic,copy) NSString *discount;

@property (nonatomic,strong) UIButton *button;


@end

@implementation SVCashierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //在navigation里添加UISegmentedControl按钮
    self.segment = [[UISegmentedControl alloc]initWithItems:@[@"选择商品",@"扫码收银"]];
    //默认第一个segment被选中
    self.segment.selectedSegmentIndex = 0;
    self.segment.frame = CGRectMake(20, 20, 200.0, 30.0);
    self.segment.tintColor = [UIColor whiteColor];
    //添加到navigation上
    self.navigationItem.titleView = self.segment;
    //监听事件,当控件值改变时调用
    [self.segment addTarget:self action:@selector(changesegment:) forControlEvents:UIControlEventValueChanged];
    
    
    //创建控制器的对象
    _oneVC = [[SVSelectWaresVC alloc] init];
    _twoVC = [[UIViewController alloc] init];
    _twoVC.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_oneVC.view];
    
    //添加选择会员的按钮
//    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_vip"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
//    self.navigationItem.rightBarButtonItem = rightButon;
    
    //正确创建方式，这样显示的图片就没有问题了
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 22)];
    [self.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
    [self.button addTarget:self action:@selector(rightbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.button];
    
    
}

#pragma mark -Action Click
-(void)changesegment:(UISegmentedControl *)segment{
    int Index = (int)_segment.selectedSegmentIndex;
    switch (Index) {
        case 0://选中快捷收银界面
            
            //第一个界面
            [self.view addSubview:_oneVC.view];
            [_twoVC.view removeFromSuperview];
            
            break;
        case 1:
            
            [self.view addSubview:_twoVC.view];
            [_oneVC.view removeFromSuperview];
//            [SVProgressHUD showImage:nil status:@"敬请期待"];
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
            [SVTool TextButtonAction:self.view withSing:@"敬请期待"];
            
            break;
        default:
            break;
    }
}

//进来默认选中第一行
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //默认选中第一行
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [_oneVC.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//}



//会员选择按钮
-(void)rightbuttonResponseEvent{
    self.hidesBottomBarWhenPushed = YES;
    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
    __weak typeof(self) weakSelf = self;
    
//    VC.vipBlock = ^(NSString *name,NSString *phone,NSString *level,NSString *discount,NSString *member_id,NSString *storedValue,NSString *headimg,NSString *sv_mr_cardno,NSString *sv_mw_availablepoint){
//
//
//
//
//
//    };
    
    VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
          weakSelf.name = name;
              
              [weakSelf.button setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
              [weakSelf.button setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    };
    
    
    [self.navigationController pushViewController:VC animated:YES];
}


#pragma mark - 懒加载
/**
 分段按钮
 */
-(UISegmentedControl *)segment{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] init];
    }
    return _segment;
}

@end
