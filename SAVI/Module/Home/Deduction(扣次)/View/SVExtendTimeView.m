//
//  SVExtendTimeView.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/7.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVExtendTimeView.h"
#import "SVDatePickerView.h"
#import "SVCardRechargeInfoModel.h"

@interface SVExtendTimeView()
@property (weak, nonatomic) IBOutlet UIButton *oneMonth;
@property (weak, nonatomic) IBOutlet UIButton *threeMonth;
@property (weak, nonatomic) IBOutlet UIButton *HalfYear;
@property (weak, nonatomic) IBOutlet UIButton *oneYear;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (nonatomic,strong) SVDatePickerView *myDatePicker;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
@property (nonatomic , strong) UIButton * currentSelectedBtn;
@end
@implementation SVExtendTimeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.oneMonth.layer.cornerRadius = 10;
    self.oneMonth.layer.masksToBounds = YES;
    self.oneMonth.layer.borderWidth = 1;
    self.oneMonth.layer.borderColor = GreyFontColor.CGColor;
    [self.oneMonth setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.oneMonth setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
    [self.oneMonth setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
   [self.oneMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    [self.oneMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.timeBtn.layer.cornerRadius = 25;
    self.timeBtn.layer.masksToBounds = YES;
    
    self.threeMonth.layer.cornerRadius = 10;
    self.threeMonth.layer.masksToBounds = YES;
    self.threeMonth.layer.borderWidth = 1;
    self.threeMonth.layer.borderColor = GreyFontColor.CGColor;
    
    [self.threeMonth setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.threeMonth setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
    
    [self.threeMonth setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.threeMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
     [self.threeMonth setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    
    self.HalfYear.layer.cornerRadius = 10;
    self.HalfYear.layer.masksToBounds = YES;
    self.HalfYear.layer.borderWidth = 1;
    self.HalfYear.layer.borderColor = GreyFontColor.CGColor;
    
    [self.HalfYear setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.HalfYear setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
    
    [self.HalfYear setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.HalfYear setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
      [self.HalfYear setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    
    self.oneYear.layer.cornerRadius = 10;
    self.oneYear.layer.masksToBounds = YES;
    self.oneYear.layer.borderWidth = 1;
    self.oneYear.layer.borderColor = GreyFontColor.CGColor;
    [self.oneYear setBackgroundImage:[self imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [self.oneYear setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateSelected];
    
    [self.oneYear setTitleColor:[UIColor colorWithHexString:@"646464"] forState:UIControlStateNormal];
    [self.oneYear setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
     [self.oneYear setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
 
//    NSString *time = [model.validity_date substringToIndex:10];
//    self.timeStr = time;
    [SVUserManager loadUserInfo];
    self.timeStr = [SVUserManager shareInstance].timeStr;
    [self.timeBtn setTitle:self.timeStr forState:UIControlStateNormal];
    
}

- (instancetype)init
{
    if (self = [super init]) {
        
        self = [[NSBundle mainBundle]loadNibNamed:@"SVExtendTimeView" owner:nil options:nil].lastObject;
        // _addCustomView.textView.delegate = self;
        self.frame = CGRectMake(10, TopHeight, ScreenW - 20, 390);
        self.layer.cornerRadius = 10;
        self.layer.masksToBounds = YES;
        self.center = CGPointMake(ScreenW / 2, ScreenH / 2);
    }
    
    return self;
}

- (IBAction)cleanClick:(id)sender {
    if (self.cleanBlock) {
        self.cleanBlock();
    }
}
- (IBAction)timeClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
}
- (IBAction)sureClick:(id)sender {
    
    if (self.sureBlock) {
        self.sureBlock(self.timeBtn.titleLabel.text);
    }
}

- (IBAction)yearMonthClick:(UIButton *)button {
    self.sureBtn.userInteractionEnabled = YES;
   [self.sureBtn setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.currentSelectedBtn.selected = NO;
    button.selected = YES;
    self.currentSelectedBtn =button;
    NSString *timeStr = self.timeStr;
   // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString *str1 = [timeStr substringWithRange:NSMakeRange(0,4)];//str2 = "is"
     NSString *str2 = [timeStr substringWithRange:NSMakeRange(5,2)];//str2 = "is"
     NSString *str3 = [timeStr substringWithRange:NSMakeRange(8,2)];//str2 = "is"
    NSLog(@"timeStr = %@",timeStr);
    NSLog(@"str1 = %@",str1);
    NSLog(@"str2 = %@",str2);
    if (button.tag == 0) {
        if ((1 + str2.intValue) <= 12) {
            str2 = [NSString stringWithFormat:@"%d",(1 + str2.intValue)];
        }else{
            str2 = @"1";
            str1 = [NSString stringWithFormat:@"%d",(str1.intValue + 1)];
        }
    }else if (button.tag == 1){
        if ((3 + str2.intValue) <= 12) {
            str2 = [NSString stringWithFormat:@"%d",(3 + str2.intValue)];
        }else{
            str2 = @"3";
            str1 = [NSString stringWithFormat:@"%d",(str1.intValue + 1)];
        }
    }else if (button.tag == 2){
        if ((6 + str2.intValue) <= 12) {
            str2 = [NSString stringWithFormat:@"%d",(6 + str2.intValue)];
        }else{
            str2 = @"6";
            str1 = [NSString stringWithFormat:@"%d",(str1.intValue + 1)];
        }
    }else{
        
           str1 = [NSString stringWithFormat:@"%d",(str1.intValue + 1)];
    }
    
    [self.timeBtn setTitle:[NSString stringWithFormat:@"%@-%@-%@",str1,str2,str3] forState:UIControlStateNormal];
    
}


- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}


/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _myDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _myDatePicker.center = self.center;
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
//        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
//        _myDatePicker.datePickerView.maximumDate = maxDate;
//       // NSDate* minDate = [[NSDate alloc]initWithString:@"1900-01-01 00:00:00 -0500"];
//        NSDate *minDate = [NSDate alloc] init;
//        _myDatePicker.datePickerView.maximumDate = minDate;
        
        [_myDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myDatePicker;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
  // self.timeBtn.text = [dateFormatter stringFromDate:self.myDatePicker.datePickerView.date];
    [self.timeBtn setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
    
    self.sureBtn.userInteractionEnabled = YES;
    [self.sureBtn setBackgroundImage:[self imageWithColor:navigationBackgroundColor] forState:UIControlStateNormal];
    [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
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
@end
