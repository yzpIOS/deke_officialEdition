//
//  SVOnlineOrderVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/3/17.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVOnlineOrderVC.h"
#import "SVWaitingForPeisong.h"
#import "SVDeliveryOnTimeVC.h"
#import "SVAlreadyCompletedVC.h"
//选择时间
#import "SVSelectTwoDatesView.h"

@interface SVOnlineOrderVC ()
@property (nonatomic,strong) NSArray *titleData;
@property (nonatomic,assign) NSInteger selectNumber;
//支付view
@property (nonatomic,strong) SVSelectTwoDatesView *DateView;
@property (nonatomic,copy) NSString *oneDate;
@property (nonatomic,copy) NSString *twoDate;
//遮盖view
@property (nonatomic,strong) UIView *maskView;
@end

@implementation SVOnlineOrderVC

- (void)viewDidLoad {
    self.selectIndex = 0;
    self.menuViewStyle = WMMenuViewStyleLine;
    //  self.menuItemWidth = ScreenW / 3 *2 / 6;
    self.progressHeight = 1;
    self.titleColorNormal = GlobalFontColor;
    self.titleColorSelected = navigationBackgroundColor;
    
    self.titleFontName = @"PingFangSC-Medium";
    
    self.title = @"线上订单";
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
     self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)selectbuttonResponseEvent{
    
    YCXMenuItem *allTitle = [YCXMenuItem menuItem:@"全部" image:nil target:self action:@selector(logout)];
     allTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
     allTitle.alignment = NSTextAlignmentLeft;
     allTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"今天" image:nil target:self action:@selector(logout)];
    cashTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    cashTitle.alignment = NSTextAlignmentLeft;
    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
    
    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"昨天" image:nil target:self action:@selector(logout)];
    menuTitle.foreColor =  [UIColor colorWithHexString:@"666666"];
    menuTitle.alignment = NSTextAlignmentLeft;
    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"本周" image:nil target:self action:@selector(logout)];
    logoutItem.foreColor = [UIColor colorWithHexString:@"666666"];
    logoutItem.alignment = NSTextAlignmentLeft;
    logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *monthItem = [YCXMenuItem menuItem:@"本月" image:nil target:self action:@selector(logout)];
    monthItem.foreColor = [UIColor colorWithHexString:@"666666"];
    monthItem.alignment = NSTextAlignmentLeft;
    monthItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    YCXMenuItem *bankItem = [YCXMenuItem menuItem:@"其他" image:nil target:self action:@selector(logout)];
    bankItem.foreColor = [UIColor colorWithHexString:@"666666"];
    bankItem.alignment = NSTextAlignmentLeft;
    bankItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
    
    NSArray *items = @[allTitle,cashTitle,menuTitle,logoutItem,monthItem,bankItem];
 
    [YCXMenu setCornerRadius:3.0f];
    [YCXMenu setSeparatorColor:[UIColor colorWithHexString:@"666666"]];
    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
    [YCXMenu setTintColor:[UIColor whiteColor]];
    //name="state">0：查询全部，1：待入库，2：已入库
    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-27, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
                
            case 0:
            {
                // self.payName = @"现金";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"全部" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                // self.selectNumber = 0;
                //                self.selectNum = 0;
                //                [self selectYCXMenuPayName];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"-1";// 今天
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];
                
            }
                break;
                
                
            case 1:
            {
               // self.payName = @"现金";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"今天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
               // self.selectNumber = 0;
//                self.selectNum = 0;
//                [self selectYCXMenuPayName];
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"0";// 今天
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];
                
            }
                break;
            case 2:
            {
              //  self.payName = @"微信支付";
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"昨天" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                // self.selectNumber = 1;
                 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"1";// 昨天
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];
                
            }
                break;
            case 3:
            {
               // self.payName = @"支付宝";
            self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本周" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                // self.selectNumber = 2;
                 NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"2";// 本周
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];
//                 self.selectNum = 2;
//               [self selectYCXMenuPayName];
            }
                break;
                case 4:
            {
                               // self.payName = @"支付宝";
                self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"本月" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                                // self.selectNumber = 2;
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                dic[@"type"] = @"3";// 本周
                [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];
                //                 self.selectNum = 2;
                //               [self selectYCXMenuPayName];
            }
            break;
            case 5:
            {
                  self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"其他" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
                
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
                     [[UIApplication sharedApplication].keyWindow addSubview:self.DateView];
                     
                     [UIView animateWithDuration:.3 animations:^{
                         self.DateView.frame = CGRectMake(0, ScreenH-450, ScreenW, 450);
                     }];
                // self.selectNumber = 3;
                
//                self.selectNum = 3;
//                //self.payName = @"银行卡";
//              [self selectYCXMenuPayName];
            }
                break;
            default:
                break;
        }
    }];
}

- (void)logout {
    
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskView removeFromSuperview];
    
    [UIView animateWithDuration:.5 animations:^{
        self.DateView.frame = CGRectMake(0, ScreenH, ScreenW, 450);
    }];
    
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

- (void)twoCancelResponseEvent {
    [self oneCancelResponseEvent];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.oneDate = [dateFormatter stringFromDate:self.DateView.oneDatePicker.date];
    self.twoDate = [dateFormatter stringFromDate:self.DateView.twoDatePicker.date];
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.oneDate format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.twoDate format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        NSMutableDictionary *dic = [NSMutableDictionary dictionary];
        dic[@"type"] = @"4";
        dic[@"oneDate"] = self.oneDate;
        dic[@"twoDate"] = self.twoDate;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"OnlineOrderPost" object:nil userInfo:dic];

    }
    
    
}

//- (void)selectbuttonResponseEvent{
//
//}



#pragma mark 返回子页面的个数
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    return self.titleData.count;
}



#pragma mark 返回某个index对应的页面
- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    switch (index) {
        case 0:{
//            UIViewController *vc = [[UIViewController alloc] init];
//            vc.view.backgroundColor = [UIColor yellowColor];
            SVWaitingForPeisong *waitVC = [[SVWaitingForPeisong alloc] init];
            return waitVC;
        }
       
            break;
            
        case 1:{
            SVDeliveryOnTimeVC *vc = [[SVDeliveryOnTimeVC alloc] init];
           // vc.view.backgroundColor = [UIColor grayColor];
            return vc;
        }
            
            break;
        default:{
            SVAlreadyCompletedVC *vc = [[SVAlreadyCompletedVC alloc] init];
           // vc.view.backgroundColor = [UIColor greenColor];
            return vc;
        }
            break;
    }
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView
{
    //    if (self.iskaiguan == NO) {
    //        return CGRectMake(0, 0, HomePageScreen / 3 *2, 64);
    //    }else{
    //        return CGRectMake(0, 0, ScreenW /3*2, 64);
    //    }
    return CGRectMake(0, 0, ScreenW, 60);
}


- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView
{
    
    return CGRectMake(0, 60, ScreenW, ScreenH - TopHeight - 60-BottomHeight);
}

#pragma mark 返回index对应的标题
- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    
    return self.titleData[index];
}

#pragma mark 标题数组
- (NSArray *)titleData {
    if (!_titleData) {
        _titleData = @[@"待配送", @"配送中",@"已完成"];
    }
    return _titleData;
}

@end
