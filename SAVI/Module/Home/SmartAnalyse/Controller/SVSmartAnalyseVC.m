//
//  SVSmartAnalyseVC.m
//  SAVI
//
//  Created by Sorgle on 2017/7/21.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSmartAnalyseVC.h"
//跳转到查询销售
#import "SVQuerySalesVC.h"


//四套View
#import "SVTodyAnalysisVC.h"
#import "SVYesterdayAnalysisVC.h"
#import "SVMonthAnalysisVC.h"
#import "SVDateAnalysisVC.h"

//Xib
#import "SVDateSelectionXib.h"
//日期Xib
#import "SVDatePickerView.h"
#import "UISegmentedControl+SVSegmentedCategory.h"


@interface SVSmartAnalyseVC ()<UIScrollViewDelegate>
{
    SVTodyAnalysisVC *_oneVC;
    SVYesterdayAnalysisVC *_twoVC;
    SVMonthAnalysisVC *_threeVC;
    SVDateAnalysisVC *_fourVC;
}
////分段控件
@property (nonatomic,strong) UISegmentedControl *segment;

//日期选择的Xib
@property (nonatomic,strong) SVDateSelectionXib *dateView;
@property (nonatomic,strong) UIView *backView;

//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;
@property (nonatomic, strong) SVDatePickerView *twoDatePicker;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) UIView *maskTwoView;

@property (nonatomic,strong) NSString *oneDate;

@property (nonatomic,strong) NSString *twoDate;


@end

@implementation SVSmartAnalyseVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"经营概况";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"经营概况";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //隐藏TabBar
    self.hidesBottomBarWhenPushed=YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
    //navigation右边按钮
    [SVUserManager loadUserInfo];
    if ([[NSString stringWithFormat:@"%@",[SVUserManager shareInstance].isStore] isEqualToString:@"0"]) {
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"分店概况" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }
    
    __weak typeof(self) weakSelf = self;
    //创建控制器的对象
    _oneVC = [[SVTodyAnalysisVC alloc] init];
    _twoVC = [[SVYesterdayAnalysisVC alloc] init];
    _threeVC = [[SVMonthAnalysisVC alloc] init];
    _fourVC = [[SVDateAnalysisVC alloc] init];
    
    _fourVC.infoInquirySaleBlock = ^(NSString *oneDate, NSString *twoDate) {
        weakSelf.oneDate = oneDate;
        weakSelf.twoDate = twoDate;
        NSLog(@"oneDate = %@,twoDate = %@",oneDate,twoDate);
        
    };
    
    [self.view addSubview:_oneVC.view];
    
    [_oneVC.button addTarget:self action:@selector(handlePan1) forControlEvents:UIControlEventTouchUpInside];
    
    //默认第一个segment被选中
    self.segment.selectedSegmentIndex = 0;
    self.segment.frame = CGRectMake(ScreenW/10, 2, ScreenW/10*8, 28);
    self.segment.tintColor = RGBA(243, 255, 249, 1);
    self.segment.backgroundColor = navigationBackgroundColor;
    //设置圆角
    self.segment.layer.masksToBounds = YES;
    self.segment.layer.cornerRadius = 12;
    self.segment.layer.borderWidth = 1;
    self.segment.layer.borderColor = RGBA(243, 255, 249, 1).CGColor;
    //添加到view上
    [self.view addSubview:self.segment];
    //监听事件,当控件值改变时调用
    [self.segment addTarget:self action:@selector(changesegment:) forControlEvents:UIControlEventValueChanged];
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    self.dateView.oneDaylbl.text = DateTime;
    self.dateView.twoDaylbl.text = DateTime;
    
    //    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToggleMasterVisible:) name:@"InfoInquirySale" object:nil];
    
}


//- (void)onToggleMasterVisible:(NSNotification *)noti{
//    NSDictionary *dicM =noti.object;
//    NSLog(@"dicM = %@",dicM);
//
//    //    //数据请求
//    //    self.payName = @"";
//    //    [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@""];
//}
//
//- (void)dealloc{
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InfoInquirySale" object:nil];
//}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    titleLabel.textColor = [UIColor whiteColor];;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text=self.title;
    
    self.navigationItem.titleView = titleLabel;
    
      [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
     [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
}
    
    //- (void)onToggleMasterVisible:(NSNotification *)noti{
    //    NSDictionary *dicM =noti.object;
    //    NSLog(@"dicM = %@",dicM);
    //
    //    //    //数据请求
    //    //    self.payName = @"";
    //    //    [self getThreeSourcesWithPage:1 top:20 day:self.buttonNum payname:@"" keys:@"" date:@"" date2:@""];
    //}
    //
    //- (void)dealloc{
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"InfoInquirySale" object:nil];
    //}
    
-(void)rightbuttonResponseEvent {
    self.hidesBottomBarWhenPushed = YES;
    [SVUserManager loadUserInfo];
    SVWebViewVC *webViewVC = [[SVWebViewVC alloc]init];
    webViewVC.turn = YES;
    webViewVC.url = [NSString stringWithFormat:@"http://www.decerp.cc/ShopInfo/Generastore_N3?key=%@",[SVUserManager shareInstance].access_token];
    
    [self.navigationController pushViewController:webViewVC animated:YES];
    
}

#pragma mark -Action Click
-(void)changesegment:(UISegmentedControl *)segment{
    int Index = (int)_segment.selectedSegmentIndex;
    switch (Index) {
            case 0://选中快捷收银界面
            
            //第一个界面
            [self.view addSubview:_oneVC.view];
            [_twoVC.view removeFromSuperview];
            [_threeVC.view removeFromSuperview];
            [_fourVC.view removeFromSuperview];
            [self.view addSubview:self.segment];
            
            break;
            case 1:
            
            [self.view addSubview:_twoVC.view];
            [_oneVC.view removeFromSuperview];
            [_threeVC.view removeFromSuperview];
            [_fourVC.view removeFromSuperview];
            [self.view addSubview:self.segment];
            //
            [_twoVC.button addTarget:self action:@selector(handlePan2) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            case 2:
            
            [self.view addSubview:_threeVC.view];
            [_oneVC.view removeFromSuperview];
            [_twoVC.view removeFromSuperview];
            [_fourVC.view removeFromSuperview];
            [self.view addSubview:self.segment];
            
            [_threeVC.button addTarget:self action:@selector(handlePan3) forControlEvents:UIControlEventTouchUpInside];
            
            break;
            case 3:
            
            //            [SVProgressHUD showImage:nil status:@"请选择日期查询"];
            
            [self.view addSubview:_fourVC.view];
            //            [self.view addSubview:self.backView];
            [_oneVC.view removeFromSuperview];
            [_twoVC.view removeFromSuperview];
            [_threeVC.view removeFromSuperview];
            [self.view addSubview:self.segment];
            
            [_fourVC.button addTarget:self action:@selector(handlePan4) forControlEvents:UIControlEventTouchUpInside];
            
            break;
        default:
            break;
            
    }
    
}

// 1是今天，-1是昨天，2是本周，3是其他
// 今天
- (void)handlePan1{
 
    
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 6) {
//            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//            tableVC.indexNum = 1;
//            //    //跳转界面有导航栏的
//            [self.navigationController pushViewController:tableVC animated:YES];
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(6,1)];
//            if ([num isEqualToString:@"0"]) {
//                [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
//            }else{
//                SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//                tableVC.indexNum = 1;
//                //    //跳转界面有导航栏的
//                [self.navigationController pushViewController:tableVC animated:YES];
//            }
//        }
//    }else{
//        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//        tableVC.indexNum = 1;
//        //    //跳转界面有导航栏的
//        [self.navigationController pushViewController:tableVC animated:YES];
//    }
    
    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
               tableVC.indexNum = 1;
               //    //跳转界面有导航栏的
               [self.navigationController pushViewController:tableVC animated:YES];
}
// 昨天
- (void)handlePan2{
    
    //    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
    //        NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+6,1)];
    //        if ([num isEqualToString:@"0"]) {
    //            [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
    //        }else{
    //            //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            //            tableVC.indexNum = 1;
    //            //            //    //跳转界面有导航栏的
    //            //            [self.navigationController pushViewController:tableVC animated:YES];
    //
    //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            tableVC.indexNum = -1;
    //            //    //跳转界面有导航栏的
    //            [self.navigationController pushViewController:tableVC animated:YES];
    //        }
    //    }else{
    //        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //        tableVC.indexNum = -1;
    //        //    //跳转界面有导航栏的
    //        [self.navigationController pushViewController:tableVC animated:YES];
    //    }
    
    
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 6) {
//            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//            tableVC.indexNum = -1;
//            //    //跳转界面有导航栏的
//            [self.navigationController pushViewController:tableVC animated:YES];
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(6,1)];
//            if ([num isEqualToString:@"0"]) {
//                [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
//            }else{
//                SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//                tableVC.indexNum = -1;
//                //    //跳转界面有导航栏的
//                [self.navigationController pushViewController:tableVC animated:YES];
//            }
//        }
//    }else{
//        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//        tableVC.indexNum = -1;
//        //    //跳转界面有导航栏的
//        [self.navigationController pushViewController:tableVC animated:YES];
//    }
    
    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
               tableVC.indexNum = -1;
               //    //跳转界面有导航栏的
               [self.navigationController pushViewController:tableVC animated:YES];
    
}
// 本周
- (void)handlePan3{
    
    //    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
    //        NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+6,1)];
    //        if ([num isEqualToString:@"0"]) {
    //            [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
    //        }else{
    //            //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            //            tableVC.indexNum = 1;
    //            //            //    //跳转界面有导航栏的
    //            //            [self.navigationController pushViewController:tableVC animated:YES];
    //
    //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            tableVC.indexNum = 2;
    //            //    //跳转界面有导航栏的
    //            [self.navigationController pushViewController:tableVC animated:YES];
    //        }
    //    }else{
    //        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //        tableVC.indexNum = 2;
    //        //    //跳转界面有导航栏的
    //        [self.navigationController pushViewController:tableVC animated:YES];
    //    }
    
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 6) {
//            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//            tableVC.indexNum = 2;
//            //    //跳转界面有导航栏的
//            [self.navigationController pushViewController:tableVC animated:YES];
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(6,1)];
//            if ([num isEqualToString:@"0"]) {
//                [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
//            }else{
//                SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//                tableVC.indexNum = 2;
//                //    //跳转界面有导航栏的
//                [self.navigationController pushViewController:tableVC animated:YES];
//            }
//        }
//    }else{
//        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//        tableVC.indexNum = 2;
//        //    //跳转界面有导航栏的
//        [self.navigationController pushViewController:tableVC animated:YES];
//    }
    
    
    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
         tableVC.indexNum = 2;
         //    //跳转界面有导航栏的
         [self.navigationController pushViewController:tableVC animated:YES];
}
// 其他
- (void)handlePan4{
    
    //    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
    //        NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+6,1)];
    //        if ([num isEqualToString:@"0"]) {
    //            [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
    //        }else{
    //            //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            //            tableVC.indexNum = 1;
    //            //            //    //跳转界面有导航栏的
    //            //            [self.navigationController pushViewController:tableVC animated:YES];
    //
    //            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //            tableVC.indexNum = 3;
    //            tableVC.oneDateStr = self.oneDate;
    //            tableVC.twoDateStr = self.twoDate;
    //
    //            //    //跳转界面有导航栏的
    //            [self.navigationController pushViewController:tableVC animated:YES];
    //        }
    //    }else{
    //        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
    //        tableVC.indexNum = 3;
    //        tableVC.oneDateStr = self.oneDate;
    //        tableVC.twoDateStr = self.twoDate;
    //
    //        //    //跳转界面有导航栏的
    //        [self.navigationController pushViewController:tableVC animated:YES];
    //    }
    
    
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 6) {
//            SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//            tableVC.indexNum = 3;
//            tableVC.oneDateStr = self.oneDate;
//            tableVC.twoDateStr = self.twoDate;
//
//            //    //跳转界面有导航栏的
//            [self.navigationController pushViewController:tableVC animated:YES];
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(6,1)];
//            if ([num isEqualToString:@"0"]) {
//                [SVTool TextButtonAction:self.view withSing:@"亲，你还没有该权限"];
//            }else{
//                SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//                tableVC.indexNum = 3;
//                tableVC.oneDateStr = self.oneDate;
//                tableVC.twoDateStr = self.twoDate;
//
//                //    //跳转界面有导航栏的
//                [self.navigationController pushViewController:tableVC animated:YES];
//            }
//        }
//    }else{
//        SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//        tableVC.indexNum = 3;
//        tableVC.oneDateStr = self.oneDate;
//        tableVC.twoDateStr = self.twoDate;
//
//        //    //跳转界面有导航栏的
//        [self.navigationController pushViewController:tableVC animated:YES];
//    }
    
    
    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
              tableVC.indexNum = 3;
              tableVC.oneDateStr = self.oneDate;
              tableVC.twoDateStr = self.twoDate;
              
              //    //跳转界面有导航栏的
              [self.navigationController pushViewController:tableVC animated:YES];
    
}

//-(void)handlePan{
//
//    SVQuerySalesVC *tableVC = [[SVQuerySalesVC alloc]init];
//    //跳转界面有导航栏的
//    [self.navigationController pushViewController:tableVC animated:YES];
//
//}

-(void)setUIWithView{
    
    NSInteger temp = [SVDateTool cTimestampFromString:self.dateView.oneDaylbl.text format:@"yyyy-MM-dd"];
    NSInteger tempi = [SVDateTool cTimestampFromString:self.dateView.twoDaylbl.text format:@"yyyy-MM-dd"];
    
    if (temp > tempi) {
        //        [SVProgressHUD showErrorWithStatus:@"输入时间有误"];
        //        //用延迟来移除提示框
        //        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //            [SVProgressHUD dismiss];
        //        });
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        
    } else {
        
        //
        //        [_oneVC.view removeFromSuperview];
        //        [_twoVC.view removeFromSuperview];
        //        [_threeVC.view removeFromSuperview];
        //        [self.view addSubview:self.segment];
        //        [self.view addSubview:self.backView];
        
        
    }
    
    
}

-(void)oneResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
    
}

-(void)twoResponseEvent{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.twoDatePicker];
    
}

#pragma mark - 懒加载
/**
 分段按钮
 */
-(UISegmentedControl *)segment{
    if (!_segment) {
        _segment = [[UISegmentedControl alloc] initWithItems:@[@"今天",@"昨天",@"本周",@"其它"]];
        [_segment ensureiOS12Style];
    }
    return _segment;
}

-(SVDateSelectionXib *)dateView{
    if (!_dateView) {
        _dateView = [[NSBundle mainBundle] loadNibNamed:@"SVDateSelectionXib" owner:nil options:nil].lastObject;
        _dateView.frame = CGRectMake(1, 1, ScreenW/8*6-2, 26);
        
        _dateView.layer.cornerRadius = 8;
        
        //创建手势
        UITapGestureRecognizer *oneGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneResponseEvent)];
        UITapGestureRecognizer *twoGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoResponseEvent)];
        //添加事件
        [_dateView.oneViewButton addGestureRecognizer:oneGestureRecognizer];
        [_dateView.twoViewButton addGestureRecognizer:twoGestureRecognizer];
        [_dateView.button addTarget:self action:@selector(setUIWithView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _dateView;
}

-(UIView *)backView{
    if (!_backView) {
        
        _backView = [[UIView alloc]initWithFrame:CGRectMake(ScreenW/8, 95, ScreenW/8*6, 28)];
        _backView.backgroundColor = [UIColor whiteColor];
        _backView.layer.cornerRadius = 8;
        
        [_backView addSubview:self.dateView];
    }
    return _backView;
}



#pragma mark -- 第一个日期
/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        CGFloat a = 320;
        CGFloat b = 230;
        
        CGFloat x = (ScreenW - a) / 2;
        CGFloat y = (ScreenH - b) / 2;
        
        _myDatePicker.frame = CGRectMake(x, y, a, b);
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _myDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _myDatePicker.datePickerView.maximumDate = minDate;
        //
        [_myDatePicker.dateCancel addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(oneDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _myDatePicker;
}

/**
 遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//点击手势的点击事件
- (void)oneDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateView.oneDaylbl.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskOneView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    
}


#pragma mark -- 第二个日期
/**
 日期选择
 */
-(SVDatePickerView *)twoDatePicker{
    if (!_twoDatePicker) {
        _twoDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        CGFloat a = 320;
        CGFloat b = 230;
        
        CGFloat x = (ScreenW - a) / 2;
        CGFloat y = (ScreenH - b) / 2;
        
        _twoDatePicker.frame = CGRectMake(x, y, a, b);
        _twoDatePicker.backgroundColor = [UIColor whiteColor];
        //设置显示模式
        [_twoDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _twoDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _twoDatePicker.datePickerView.maximumDate = minDate;
        //
        [_twoDatePicker.dateCancel addTarget:self action:@selector(twoCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_twoDatePicker.dateDetermine addTarget:self action:@selector(twoDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _twoDatePicker;
}

/**
 遮盖View
 */
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twoCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)twoDetermineResponseEvent{
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    self.dateView.twoDaylbl.text = [dateFormatter stringFromDate:self.twoDatePicker.datePickerView.date];
}

//点击手势的点击事件
- (void)twoCancelResponseEvent{
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    
}


@end
