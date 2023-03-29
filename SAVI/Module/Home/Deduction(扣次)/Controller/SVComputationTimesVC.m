//
//  SVComputationTimesVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/6.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVComputationTimesVC.h"
#import "SVDetailSecondaryRecordVC.h"
#import "SVServiceItemsVC.h"
#import "SVSelectTwoDatesView.h"

@interface SVComputationTimesVC ()
@property (nonatomic,strong) SVDetailSecondaryRecordVC *detailSecondaryRecordVC;

@property (nonatomic,strong) SVServiceItemsVC *serviceItemsVC;
//选择会员按钮
@property (nonatomic,strong) UIButton *button;

//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;

//遮盖view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
@end

@implementation SVComputationTimesVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // self.title = @"次卡管理";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    NSArray *arr = [NSArray array];
 
        arr = [[NSArray alloc]initWithObjects:@"服务项目",@"充次记录", nil];
        self.view.backgroundColor = [UIColor whiteColor];

    
    //初始化UISegmentedControl
    //在没有设置[segment setApportionsSegmentWidthsByContent:YES]时，每个的宽度按segment的宽度平分
    UISegmentedControl *segment = [[UISegmentedControl alloc]initWithItems:arr];
    segment.selectedSegmentIndex = 0;
    [self segmentClick:segment];
    
    //设置frame
    segment.frame = CGRectMake(0, 0, 150, 30);
    
    [segment addTarget:self action:@selector(segmentClick:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = segment;
    
    self.serviceItemsVC = [[SVServiceItemsVC alloc] init];
    //  self.obtainedSecondaryCardVC.selectCount = self.selectCount;
    self.serviceItemsVC.member_id = self.member_id;
    self.serviceItemsVC.model = self.model;
    [self addChildViewController:self.serviceItemsVC];
    self.serviceItemsVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight);
    // [self.lbxScanVC reStartDevice];
    [self.view addSubview:self.serviceItemsVC.view];
    
   
//     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天充次" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
//
//    self.navigationItem.rightBarButtonItem.customView.hidden = YES;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 60)];
    view.backgroundColor = [UIColor clearColor];
    
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(10, 10, 100, 25)];
    //        self.button = [UIButton buttonWithType:UIButtonTypeCustom];
    //        self.button = [[UIButton alloc] init];
    [view addSubview:self.button];
    //        [self.button mas_makeConstraints:^(MASConstraintMaker *make) {
    //            make.right.mas_offset(view.mas_right);
    //            make.centerY.mas_equalTo(view.mas_centerY);
    //            make.width.mas_equalTo(50);
    //            make.height.mas_equalTo(25);
    //        }];
    // [self.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
    [self.button setTitle:@"今天充次" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize:15];
//    self.button.layer.borderColor = [UIColor whiteColor].CGColor;
//    self.button.layer.borderWidth = 1;
//    self.button.layer.cornerRadius = 10;
//    self.button.layer.masksToBounds = YES;
    [self.button setTitleColor:GlobalFontColor forState:UIControlStateNormal];
    
    [self.button addTarget:self action:@selector(rightbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:view];
    
    self.button.hidden = YES;
    //
//    [self.cleanBnt addTarget:self action:@selector(cleanMemberButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    // 创建两个控制器
    self.detailSecondaryRecordVC = [[SVDetailSecondaryRecordVC alloc] init];
    self.detailSecondaryRecordVC.model = self.model;
    self.detailSecondaryRecordVC.member_id = self.member_id;
    [self addChildViewController:self.detailSecondaryRecordVC];
    
    
    
   
}

- (void)rightbuttonResponseEvent{
    //移除第一响应者
   // [self.searchBar resignFirstResponder];
    
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天充次" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor = GlobalFontColor;
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天充次" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor = GlobalFontColor;
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本周充次" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = GlobalFontColor;
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他充次" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = GlobalFontColor;
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
//    YCXMenuItem *storedItem = [YCXMenuItem menuItem:@"    储值卡" image:[UIImage imageNamed:@"YCXM_stored"] target:self action:@selector(logout)];
//    storedItem.foreColor = GlobalFontColor;
//    storedItem.alignment = NSTextAlignmentLeft;
//    storedItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[cashTitle,menuTitle,logoutItem,bankItem];
    //    NSArray *items = @[[YCXMenuItem menuItem:@"现金" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"微信" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"支付宝" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
    //                       [YCXMenuItem menuItem:@"银行卡" image:nil tag:4 userInfo:@{@"title":@"Menu"}],
    //                       ];
    
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:GreyFontColor];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        switch (index) {
            case 0:
            {
               // self.payName = @"现金";
               // [self selectYCXMenuPayName];
                dic[@"day"] = @"1";
                dic[@"dt1"] = @"";
                dic[@"dt2"] = @"";
                [self posttongzhiDay:dic];
                 [self.button setTitle:@"今天充次" forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
              //  self.payName = @"微信支付";
               // [self selectYCXMenuPayName];
                dic[@"day"] = @"2";
                dic[@"dt1"] = @"";
                dic[@"dt2"] = @"";
                 [self posttongzhiDay:dic];
                 [self.button setTitle:@"昨天充次" forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
               // self.payName = @"支付宝";
               // [self selectYCXMenuPayName];
                dic[@"day"] = @"3";
                dic[@"dt1"] = @"";
                dic[@"dt2"] = @"";
                 [self posttongzhiDay:dic];
                 [self.button setTitle:@"本周充次" forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
              //  self.payName = @"银行卡";
              //  [self selectYCXMenuPayName];
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
                [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
                
                [UIView animateWithDuration:.3 animations:^{
                    self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
                }];
              
            }
                break;
         
            default:
                break;
        }
    }];
}



- (void)posttongzhiDay:(NSMutableDictionary *)dict{
   [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyName2" object:dict];
}

- (void)logout{
    
}

- (void)segmentClick:(UISegmentedControl *)segment{
    // 切换视图
    if (segment.selectedSegmentIndex == 0) {
        self.serviceItemsVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight-TopHeight);
        // [self.lbxScanVC reStartDevice];
        [self.view addSubview:self.serviceItemsVC.view];
        self.button.hidden = YES;
        
    } else if (segment.selectedSegmentIndex == 1) {
        //  [self.lbxScanVC removeFromParentViewController];
        self.detailSecondaryRecordVC.view.frame = CGRectMake(0, 0, ScreenW, ScreenH - BottomHeight -TopHeight);
        [self.view addSubview:self.detailSecondaryRecordVC.view];
         self.button.hidden = NO;
    }
}

#pragma mark - 懒加载

-(SVSelectTwoDatesView *)DateView {
    
    if (!_DateView) {
        _DateView = [[[NSBundle mainBundle] loadNibNamed:@"SVSelectTwoDatesView" owner:nil options:nil] lastObject];
        _DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
        
        [_DateView.cancelButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_DateView.determineButton addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        NSDate *minDate = [NSDate date];
        //设置显示模式
        [_DateView.oneDatePicker setDatePickerMode:UIDatePickerModeDate];
                //UIDatePicker时间范围限制
              _DateView.oneDatePicker.maximumDate = maxDate;
                _DateView.oneDatePicker.maximumDate = minDate;
        
        //设置显示模式
        [_DateView.twoDatePicker setDatePickerMode:UIDatePickerModeDate];
               //UIDatePicker时间范围限制
               _DateView.twoDatePicker.maximumDate = maxDate;
               _DateView.twoDatePicker.maximumDate = minDate;
        
    }
    
    return _DateView;
}


- (void)twoCancelResponseEvent{
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    //    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    //    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSString *oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    NSString *twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        self.oneDate = oneDate;
        self.twoDate = twoDate;
//        parame[@"sv_dis_startdate"] = [NSString stringWithFormat:@"%@ 00:00:00",self.oneDate];
//        parame[@"sv_dis_enddate"] = [NSString stringWithFormat:@"%@ 23:59:59",self.twoDate];
        dic[@"day"] = @"4";
        dic[@"dt1"] = [NSString stringWithFormat:@"%@ 00:00:00",self.oneDate];
        dic[@"dt2"] = [NSString stringWithFormat:@"%@ 23:59:59",self.twoDate];
        [self.button setTitle:@"其他充次" forState:UIControlStateNormal];
        [self posttongzhiDay:dic];
        
        //        self.time.text = [NSString stringWithFormat:@"%@ 至 %@",self.oneDate,self.twoDate];
        //        self.time.textColor = GlobalFontColor;
        
    }
}


//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskView addGestureRecognizer:tap];
        
        [_maskView addSubview:_DateView];
    }
    return _maskView;
}

- (void)oneCancelResponseEvent{
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
}

@end
