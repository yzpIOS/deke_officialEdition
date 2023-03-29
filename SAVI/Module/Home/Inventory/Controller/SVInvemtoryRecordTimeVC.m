//
//  SVInvemtoryRecordTimeVC.m
//  SAVI
//
//  Created by houming Wang on 2019/6/18.
//  Copyright © 2019年 Sorgle. All rights reserved.
//

#import "SVInvemtoryRecordTimeVC.h"
//日期XIB
#import "SVDatePickerView.h"
#import "SVShaixuanListVC.h"
@interface SVInvemtoryRecordTimeVC ()
@property (weak, nonatomic) IBOutlet UIButton *startTime;
@property (weak, nonatomic) IBOutlet UIButton *endTime;
@property (weak, nonatomic) IBOutlet UIButton *resetBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;
@property (nonatomic,assign) NSInteger selectNumber;
@property (nonatomic,assign) BOOL ischineseStr;
@property (nonatomic,assign) BOOL ischineseStr_two;
@end

@implementation SVInvemtoryRecordTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"盘点记录";
    self.startTime.layer.cornerRadius = 10;
    self.startTime.layer.masksToBounds = YES;
    
    self.endTime.layer.cornerRadius = 10;
    self.endTime.layer.masksToBounds = YES;
    
    self.resetBtn.layer.cornerRadius = 30;
    self.resetBtn.layer.masksToBounds = YES;
    
    self.sureBtn.layer.cornerRadius = 30;
    self.sureBtn.layer.masksToBounds = YES;
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
}
- (IBAction)startClick:(id)sender {
    self.selectNumber = 0;// 开始时间
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
}

- (IBAction)endclick:(id)sender {
    self.selectNumber = 1;// 结束时间
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
}

#pragma mark - 确定按钮
- (IBAction)sureClick:(id)sender {
    [self checkIsChinese:self.startTime.titleLabel.text];
    [self checkIsChinese_two:self.endTime.titleLabel.text];
    if (self.ischineseStr == YES || self.ischineseStr_two == YES) {
        [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
    }else{
        NSInteger temp = [SVDateTool cTimestampFromString:self.startTime.titleLabel.text format:@"yyyy-MM-dd"];
        NSInteger tempi = [SVDateTool cTimestampFromString:self.endTime.titleLabel.text format:@"yyyy-MM-dd"];
        
        if (tempi > temp || tempi == temp) {
            SVShaixuanListVC *vc = [[SVShaixuanListVC alloc] init];
            //    [self GrossProfitWithType:-2 Date:self.dateView.oneDaylbl.text Date2:[NSString stringWithFormat:@"%@ 23:59:59",self.dateView.twoDaylbl.text]];
            vc.startTime = self.startTime.titleLabel.text;
            vc.endTime = self.endTime.titleLabel.text;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"输入时间有误"];
        }
    }
    //    if ([self.startTime.titleLabel.text isEqualToString:@"开始日期"] || [self.endTime.titleLabel.text isEqualToString:@"结束日期"]) {
    //
    //    }else{
    //
    //    }
    
    
    
}

- (BOOL)checkIsChinese_two:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            self.ischineseStr = YES;
            return YES;
        }
    }
    self.ischineseStr_two = NO;
    return NO;
}

- (BOOL)checkIsChinese:(NSString *)string{
    for (int i=0; i<string.length; i++) {
        unichar ch = [string characterAtIndex:i];
        if (0x4E00 <= ch  && ch <= 0x9FA5) {
            self.ischineseStr = YES;
            return YES;
        }
    }
    self.ischineseStr = NO;
    return NO;
}

#pragma mark - x重置按钮
- (IBAction)chongzhiClick:(id)sender {
    [self.startTime setTitle:@"开始日期" forState:UIControlStateNormal];
    [self.endTime setTitle:@"结束日期" forState:UIControlStateNormal];
}

/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _myDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _myDatePicker.center = self.view.center;
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _myDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _myDatePicker.datePickerView.maximumDate = minDate;
        
        [_myDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    if (self.selectNumber == 0) {
        [self.maskTheView removeFromSuperview];
        [self.myDatePicker removeFromSuperview];
        //创建一个日期格式化器
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        //设置时间样式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self.startTime setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
        
        // NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
        
        //        NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
        //        NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
    }else{
        [self.maskTheView removeFromSuperview];
        [self.myDatePicker removeFromSuperview];
        //创建一个日期格式化器
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
        //设置时间样式
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        [self.endTime setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
    }
    
    
    //    [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:100];
    
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
}

@end
