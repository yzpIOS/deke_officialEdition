//
//  SVQuickCashierVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/19.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVQuickCashierVC.h"
//会员选择
#import "SVVipSelectVC.h"
//计算器
#import <QuartzCore/QuartzCore.h>
//显示数字view
#import "SVQuickCashierView.h"
//黑色view
#import "SVVipBlackView.h"
//支付XIB
#import "SVQuickPayView.h"
//结算
//#import "SVQuickCheckoutVC.h"
#import "SVShowCheckoutVC.h"
#import "SVExpandBtn.h"
#import "SVAddCustomView.h"
#import "ZJViewShow.h"
#import "SVQuickpayViewTwo.h"
#import "NSString+Utility.h"
#import "QQLBXScanViewController.h"
#import "Global.h"
#import "StyleDIY.h"
//#define num 315
//#define H   (ScreenH - 64 - 43)
//#define num  H / 2
#define num  ScreenH / 2
//字体颜色
#define GreyFont    [UIColor grayColor]

@interface SVQuickCashierVC ()<UITextViewDelegate>
//支付view
@property (nonatomic,strong) SVQuickPayView *payView;

@property (nonatomic,strong) SVQuickCashierView *twoView;

@property (nonatomic,strong) SVQuickpayViewTwo *payViewTwo;
//遮盖view
@property (nonatomic,strong) UIView * maskTheView;

@property (nonatomic,strong) UIView * maskTheViewTwo;

//会员名
@property (nonatomic,copy) NSString *name;
//会员ID
@property (nonatomic,copy) NSString *member_id;
//折扣
@property (nonatomic,copy) NSString *discount;
//会员卡号
@property (nonatomic,copy) NSString *sv_mr_cardno;
//会员储值
@property (nonatomic,copy) NSString *storedValue;
//显示会员view
@property (nonatomic,strong) SVVipBlackView *oneView;

//选中的支付方式
@property (nonatomic,copy) NSString *payWay;
//扫一扫的授权码
@property (nonatomic,copy) NSString *authcode;

//判断是否开启支付
@property (nonatomic,copy) NSString *sv_enable_alipay;
@property (nonatomic,copy) NSString *sv_enable_wechatpay;
@property (nonatomic,strong) NSString *member_Cumulative;
@property (nonatomic,strong) SVExpandBtn *memberBtn;

@property (nonatomic,strong) UIView *backView;
@property (nonatomic,strong) NSString *sv_mr_pwd;
@property (nonatomic,strong) SVAddCustomView *addCustomView;
@property (nonatomic,strong) ZJViewShow *showView;
@property (nonatomic,assign) BOOL isAggregatePayment;
@property (nonatomic,strong) SVProductResultsData *productResultsData;

@end

@implementation SVQuickCashierVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"收银";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //设置背景色
    self.view.backgroundColor = RGBA(223, 223, 223, 1);;
  
    //隐藏
    self.hidesBottomBarWhenPushed = YES;
    
    self.backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 50)];
    self.backView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.backView];
    
    //隐藏levelbutton
    self.twoView.level.backgroundColor = RGBA(255, 192, 0, 1);
    self.twoView.level.hidden = YES;
    self.twoView.deleteDiscount.hidden = YES;
    self.oneView.hidden = YES;
    
    //添加计算按钮
    [self addQuickButton];
    
    //正确创建方式，这样显示的图片就没有问题了
    self.memberBtn = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
    [self.memberBtn setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
    [self.memberBtn addTarget:self action:@selector(rightbuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.memberBtn];
    
    //为抹零添加方法
    [self.twoView.wipeZero addTarget:self action:@selector(wipeZerobuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.twoView.switch_open addTarget:self action:@selector(switch_openClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [SVUserManager shareInstance].quickOff = @"1";
    [SVUserManager saveUserInfo];
    //调请求
    [self requestMethodOfPayment];
    
    //增加监听，当键盘出现或改变时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    //增加监听，当键退出时收出消息
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
   // [self AggregatePayment];
}

#pragma mark - 验证聚合支付开关
- (void)AggregatePayment{
    [SVUserManager loadUserInfo];

    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL1=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Manage",token];
    [[SVSaviTool sharedSaviTool] GET:dURL1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic9999 == %@",dic);
        NSArray *childInfolist = dic[@"data"][@"childInfolist"];
        if (!kArrayIsEmpty(childInfolist)) {
            for (NSDictionary *dict in childInfolist) {
                NSString *sv_user_config_code = dict[@"sv_user_config_code"];
                if ([sv_user_config_code isEqualToString:@"Refund_Password_Switch"]) {

                    NSArray *childDetailList = dict[@"childDetailList"];
                    if (kArrayIsEmpty(childDetailList)) {

                        self.isAggregatePayment = false;
                    }else{
                        NSDictionary *dict1 = childDetailList[0];
                        NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];

                        if (sv_detail_is_enable.intValue == 1) {
//                            [self oneCancelResponseEvent];
//                            //      [self.singleView.determineButton setEnabled:NO];
//                            [self.addCustomView removeFromSuperview];
//                            self.selectWholeOrder = 0;//0是单品1是整单
//                            [self.addCustomView.textView becomeFirstResponder];// 2
//                            [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//                            [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                            self.isAggregatePayment = true;
                        }else{
                            self.isAggregatePayment = false;
                        }
                    }

                    break;
                }else{
                    self.isAggregatePayment = false;
                }
            }
        }else{
            self.isAggregatePayment = false;
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
//    self.IntegralInputVIew.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
//    NSLog(@"键盘高度是  %d",height);
//    NSLog(@"键盘宽度是  %d",width);
    
    //获取键盘的高度
    
    self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
}

//-(void)viewWillAppear:(BOOL)animated
//{
//    [super viewWillAppear:animated];// 1
//    [self.addCustomView.textFiled becomeFirstResponder];// 2
//
//}


//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
}

- (void)switch_openClick:(UISwitch *)swi{
    if (swi.isOn) { // 开着
        [SVUserManager shareInstance].quickOff = @"1";
        [SVUserManager saveUserInfo];
    }else{
        [SVUserManager shareInstance].quickOff = @"0";
        [SVUserManager saveUserInfo];
    }
}

//此方法可以去掉导航栏的黑线
//- (void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//    UIImage *colorImage = [UIImage imageWithColor:BackgroundColor size:CGSizeMake(ScreenW, 1)];
//    [self.navigationController.navigationBar setShadowImage:colorImage];
//
//    //self.navigationController.navigationBar.subviews[0].subviews[1].hidden = YES;
//
//}



//会员选择按钮
-(void)rightbuttonResponseEvent{
//    self.hidesBottomBarWhenPushed = YES;
    SVVipSelectVC *VC = [[SVVipSelectVC alloc] init];
    
    //回调block
    __weak typeof(self) weakSelf = self;
    
//    VC.vipBlock = ^(NSString *name,NSString *phone,NSString *level,NSString *discount,NSString *member_id,NSString *storedValue,NSString *headimg,NSString *sv_mr_cardno,NSString *sv_mw_availablepoint){
//
//
//
//    };
    
    VC.vipBlock = ^(NSString *name, NSString *phone, NSString *level, NSString *discount, NSString *member_id, NSString *storedValue, NSString *headimg, NSString *sv_mr_cardno, NSString *sv_mw_availablepoint, NSString *sv_mw_sumpoint, NSString *sv_mr_birthday, NSString *sv_mr_pwd, NSString *grade, NSArray *ClassifiedBookArray, NSString *memberlevel_id, NSString *user_id) {
        //接收返来的折扣
        weakSelf.discount = discount;
        //会员ID
        weakSelf.member_id = member_id;
        weakSelf.sv_mr_cardno = sv_mr_cardno;
        //会员储值
        weakSelf.storedValue = storedValue;
        weakSelf.member_Cumulative = sv_mw_availablepoint;
        self.name = name;
        //设置名字
        //        [weakSelf.button setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
        //        [weakSelf.button setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
        [weakSelf.memberBtn setTitle:[name substringToIndex:1] forState:UIControlStateNormal];
        [weakSelf.memberBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        weakSelf.memberBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [weakSelf.memberBtn setBackgroundImage:[UIImage imageNamed:@"ic_vipWhite"] forState:UIControlStateNormal];
        weakSelf.sv_mr_pwd = sv_mr_pwd;
        
        weakSelf.oneView.hidden = NO;
        weakSelf.oneView.name.text = name;
        weakSelf.oneView.storedValue.text = storedValue;
        [weakSelf.oneView.deleteVipButton addTarget:weakSelf action:@selector(deletebuttonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //显示等级按钮
        weakSelf.twoView.level.hidden = NO;
        weakSelf.twoView.level.text = level;
        //        weakSelf.twoView.deleteDiscount.hidden = NO;
        //        [weakSelf.twoView.deleteDiscount addTarget:weakSelf action:@selector(deleteDiscountButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //折扣后的应收，如果折扣为0，就不打折
        if ([weakSelf.discount intValue] == 0) {
            double number = [weakSelf.twoView.moneyLabel.text doubleValue];
            weakSelf.twoView.amount.text = [NSString stringWithFormat:@"%.2f",number];
        } else {
            double number = [weakSelf.twoView.moneyLabel.text doubleValue] * [discount doubleValue] * 0.1;
            weakSelf.twoView.amount.text = [NSString stringWithFormat:@"%.2f",number];
            
        }
        
        //优惠了多少钱
        double num1 = [weakSelf.twoView.moneyLabel.text doubleValue] - [weakSelf.twoView.amount.text doubleValue];
        weakSelf.twoView.preferential.text = [NSString stringWithFormat:@"%.2f",num1];
    };
    
    
    [self.navigationController pushViewController:VC animated:YES];
}

-(void)addQuickButton{
    
//    int num = 315;
    
    //添加1-9数字
    NSArray *array=[NSArray arrayWithObjects:@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9", nil];
    int n=0;
    for (int i=0; i<3; i++)
    {
        for (int j=0; j<3; j++)
        {
            self.button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            self.button.frame=CGRectMake(ScreenW/4*j, num - 64 +(ScreenH-num-BottomHeight)/4*i, (ScreenW-2)/4, (ScreenH-num-2-BottomHeight)/4);
            self.button.backgroundColor = [UIColor whiteColor];
            [self.button setTitle:[array objectAtIndex:n++] forState:UIControlStateNormal];   //注意：[array objectAtIndex:n++]
            [self.button setTitleColor:GreyFont forState:UIControlStateNormal];
            self.button.titleLabel.font = [UIFont systemFontOfSize: 30];
            [self.view addSubview:_button];
            [self.button addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside]; //addTarget:self 的意思是说，这个方法在本类中也可以传入其他类的指针
        }
    }
    
    
    //单独添加0
    UIButton *button0=[UIButton buttonWithType:UIButtonTypeRoundedRect];  //创建一个圆角矩形的按钮
    [button0 setFrame:CGRectMake((ScreenW)/4*1, num-64+(ScreenH-num-BottomHeight)/4*3, (ScreenW-2)/4, (ScreenH-num-2-BottomHeight)/4)];    //设置button在view上的位置
    //也可以这样用：button0.frame:CGRectMake(30, 345, 60, 60);
    [button0 setTitle:@"0" forState:UIControlStateNormal];                //设置button主题
    //    button0.titleLabel.textColor = [UIColor grayColor];       //设置0键的颜色
    [button0 setBackgroundColor:[UIColor whiteColor]];
    [button0 setTitleColor:GreyFont forState:UIControlStateNormal];
    button0.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button0 addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside]; //按下按钮，并且当手指离开离开屏幕的时候触发这个事件
    //触发了这个事件后，执行shuzi方法，action:@selector(shuzi:)
    [self.view addSubview:button0];    //显示控件
    
    //单独添加00
    UIButton *button00 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button00 setFrame:CGRectMake(0, num-64+(ScreenH-num-BottomHeight)/4*3, (ScreenW-2)/4, (ScreenH-num-3-BottomHeight)/4)];
    [button00 setTitle:@"00" forState:UIControlStateNormal];
    [button00 setBackgroundColor:[UIColor whiteColor]];
    [button00 setTitleColor:GreyFont forState:UIControlStateNormal];
    button00.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button00 addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button00];
    
    //添加.
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button1 setFrame:CGRectMake((ScreenW)/4*2, num-64+(ScreenH-num-BottomHeight)/4*3, (ScreenW-2)/4, (ScreenH-num-2-BottomHeight)/4)];
    [button1 setTitle:@"." forState:UIControlStateNormal];
    [button1 setBackgroundColor:[UIColor whiteColor]];
    [button1 setTitleColor:GreyFont forState:UIControlStateNormal];
    button1.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button1 addTarget:self action:@selector(shuzi:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    
    //添加清除键AC
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button2 setFrame:CGRectMake((ScreenW)/4*3, num-64, (ScreenW)/4, (ScreenH-num-2-BottomHeight)/4)];
    [button2 setTitle:@"AC" forState:UIControlStateNormal];
    [button2 setBackgroundColor:[UIColor whiteColor]];
    [button2 setTitleColor:GreyFont forState:UIControlStateNormal];
    button2.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button2 addTarget:self action:@selector(clean:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    //添加+
    UIButton *button3 =[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button3 setFrame:CGRectMake((ScreenW)/4*3, num-64+(ScreenH-num-BottomHeight)/4*1, (ScreenW)/4, (ScreenH-num-2-BottomHeight)/4)];
    [button3 setTitle:@"+" forState:UIControlStateNormal];
    [button3 setBackgroundColor:[UIColor whiteColor]];
    [button3 setTitleColor:GreyFont forState:UIControlStateNormal];
    button3.titleLabel.font = [UIFont systemFontOfSize: 30];
    [button3 addTarget:self action:@selector(go:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button3];
    
    //添加结算
    UIButton *button4=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button4 setFrame:CGRectMake((ScreenW)/4*3, num-64+(ScreenH-num-BottomHeight)/4*2, (ScreenW)/4, (ScreenH-num-BottomHeight)/4*2)];
    [button4 setTitle:@"结算" forState:UIControlStateNormal];
    [button4 setBackgroundColor:RGBA(255, 121, 120, 1)];
    [button4 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button4.titleLabel.font = [UIFont systemFontOfSize: 25];
    [button4 addTarget:self action:@selector(showView:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
    //字符串
    self.str = [NSString string];
    
}


//0-9方法
- (void)shuzi:(id)sender
{
    
    if ([self.stringNumber hasSuffix:@"+"] && [[sender currentTitle] isEqualToString:@"."]) {
        return;
    }
    
    if ((self.stringNumber.length == 0 || [self.stringNumber hasSuffix:@"."]) && [[sender currentTitle] isEqualToString:@"."]) {
        
        return;
    }
    
    if ([self.string containsString:@"."] && [[sender currentTitle] isEqualToString:@"."]) {
        return;
    }
    
    if ([self.string integerValue] > 100000) {
        return;
    }
    
    //数字连续输入
    [self.string appendString:[sender currentTitle]];
    
    //保存输入的数值
    self.num1 = [self.string doubleValue];
    
    [self.stringNumber appendString:[sender currentTitle]];
    self.twoView.numberLabel.text = [NSString stringWithString:_stringNumber];

    
    //显示数值
    self.twoView.moneyLabel.text = [NSString stringWithFormat:@"%.2f", self.num2 + self.num1];
    
    
    
    if ([SVTool isBlankString:self.discount]) {
        
        //没有折扣，就走这里
        self.twoView.amount.text = [NSString stringWithFormat:@"%.2f", self.num2 + self.num1];
        
    } else {
        
        //折扣后的应收，如果折扣为0，就不打折
        if ([self.discount intValue] == 0) {
            double number = [self.twoView.moneyLabel.text doubleValue];
            self.twoView.amount.text = [NSString stringWithFormat:@"%.2f",number];
        } else {
            double number = [self.twoView.moneyLabel.text doubleValue] * [self.discount doubleValue] * 0.1;
            self.twoView.amount.text = [NSString stringWithFormat:@"%.2f",number];
            
        }
        
        //优惠了多少钱
        double num1 = [self.twoView.moneyLabel.text doubleValue] - [self.twoView.amount.text doubleValue];
        self.twoView.preferential.text = [NSString stringWithFormat:@"%.2f",num1];
    }
    
}

//计算方法
-(void)go:(id)sender
{
    
    if ([self.stringNumber hasSuffix:@"."]) {
        return;
    }
    
    if ([self.stringNumber hasSuffix:@"+"] ||
        self.stringNumber.length == 0) {
        
        return;
    }
    
    [self.stringNumber appendString:[sender currentTitle]];
    self.twoView.numberLabel.text = [NSString stringWithString:_stringNumber];
    
    //当str里为空
    if ([self.str isEqualToString:@""])
    {
        self.num2=self.num1;
        //字符串清零
        [self.string setString:@""];
        //保存运算符为了作判断作何种运算
        self.str=[sender currentTitle];
        
        [self.string appendString:self.str];

        //字符串清零
        [self.string setString:@""];
        
    }
    else
    {
        //字符串清零
        [self.string setString:@""];
        //num2是运算符号左边的数值，还是计算结果
        self.num2+=self.num1;
        
    }
    
    self.twoView.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.num2];
    
}


//当按下清除建时，所有数据清零
-(void)clean:(id)sender{
    //NSString *b = [self.stringNumber substringToIndex:[self.stringNumber length]-1];
    [self.stringNumber setString:@""];
    self.twoView.numberLabel.text = @"0";
    
    [self.string setString:@""];//清空字符
    self.num1=0;
    self.num2=0;
    //保证下次输入时清零
    self.twoView.moneyLabel.text = @"0";
    self.twoView.preferential.text =@"0.00";
    self.twoView.amount.text = @"0.00";
    
}


/**
 这个是抹零
 */
-(void)wipeZerobuttonResponseEvent{
    if (![self.twoView.moneyLabel.text isEqualToString:@"0"]) {
        
        //从字符A中分隔成2个元素的数组
        NSArray *array = [self.twoView.amount.text componentsSeparatedByString:@"."];
        

        if ([SVTool isBlankString:self.discount]) {
            
            //没有折扣，就走这里
            //没有折扣的抹零值
            self.twoView.preferential.text = [NSString stringWithFormat:@"0.%@",array[1]];
            
            //计算减去抹零的整数
            double num1 = [self.twoView.moneyLabel.text doubleValue] - [self.twoView.preferential.text doubleValue];
            
            //赋值
            self.twoView.amount.text = [NSString stringWithFormat:@"%.2f",num1];
            
        } else {
            
            double zeroNum = [[NSString stringWithFormat:@"0.%@",array[1]] doubleValue];
            
            //折扣后的应收
            double number = [self.twoView.moneyLabel.text doubleValue] * [self.discount doubleValue] * 0.1 - zeroNum;
            self.twoView.amount.text = [NSString stringWithFormat:@"%.2f",number];
            
            
            //优惠了多少钱
            double num1 = [self.twoView.moneyLabel.text doubleValue] - [self.twoView.amount.text doubleValue];
            self.twoView.preferential.text = [NSString stringWithFormat:@"%.2f",num1];
        }
    }
}


/**
 删除折扣
 */
-(void)deleteDiscountButtonResponseEvent{
    
    //隐藏    removeFromSuperview
    self.twoView.level.hidden = YES;
    self.twoView.deleteDiscount.hidden = YES;
    
    //折扣清零
    self.discount = nil;
    
    //没有折扣，就走这里
    self.twoView.amount.text = [NSString stringWithFormat:@"%.2f", self.num2 + self.num1];
    self.twoView.preferential.text =@"0.00";
    
}


/**
 删除会员
 */
-(void)deletebuttonResponseEvent{
    
    //隐藏    removeFromSuperview
    self.twoView.level.hidden = YES;
    self.twoView.deleteDiscount.hidden = YES;
    
    self.oneView.hidden = YES;
   // self.discount = nil;
    //会员ID
    self.member_id = nil;
    self.sv_mr_cardno = nil;
    //会员储值
    self.storedValue = nil;
   // self.member_id = nil;
    //折扣清零
    self.discount = nil;
    self.name = nil;
    self.member_Cumulative = nil;
    self.sv_mr_pwd = nil;
    
    //没有折扣，就走这里
    self.twoView.amount.text = [NSString stringWithFormat:@"%.2f", self.num2 + self.num1];
    self.twoView.preferential.text =@"0";
    
    //设置名字
   // [self.button setTitle:@"" forState:UIControlStateNormal];
    [self.memberBtn setTitle:@"" forState:UIControlStateNormal];
  //  [self.button setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
     [self.memberBtn setBackgroundImage:[UIImage imageNamed:@"ic_vip"] forState:UIControlStateNormal];
}


#pragma mark - 弹出支付触发事件
-(void)showView:(BOOL)isDown{
    
    [SVUserManager loadUserInfo];
        
        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
        if (self.oneView.hidden == YES) {
          //  self.payViewTwo.fourV.backgroundColor = [UIColor grayColor];
            [self.payViewTwo.fourB setEnabled:NO];
            self.payViewTwo.fourV.hidden = YES;
           
        
        } else {
            self.payViewTwo.fourV.hidden = NO;
            [self.payViewTwo.fourB setEnabled:YES];
            
        }
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.payViewTwo];
        //实现弹出方法
        [UIView animateWithDuration:.5 animations:^{
            self.payViewTwo.frame = CGRectMake(0, num, ScreenW, ScreenH-num);
        }];
        
        
    }else{
        if (self.oneView.hidden == YES) {
            self.payView.sixV.hidden = YES;
        } else {
            self.payView.sixV.hidden = NO;
        }
        

        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.payView];
        //实现弹出方法
        [UIView animateWithDuration:.5 animations:^{
            self.payView.frame = CGRectMake(0, num, ScreenW, ScreenH-num);
        }];
    }
   
}

#pragma mark - 演算接口
- (void)loadSettleCaleIsWholeOrder:(BOOL)isWholeOrder{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Settle/Cale?key=%@",[SVUserManager shareInstance].access_token];

    NSMutableDictionary *parames = [NSMutableDictionary dictionary];
    

        double IntegralAverageDiscount = 1.00;
        NSMutableArray *buySteps = [NSMutableArray array];
     
    
            NSMutableArray *commissions = [NSMutableArray array];
            NSMutableDictionary *buyStepsDict = [NSMutableDictionary dictionary];
            [buyStepsDict setObject:[NSNumber numberWithInteger:1] forKey:@"index"];
            [buyStepsDict setObject:[NSNumber numberWithInteger:1] forKey:@"number"];
            [buyStepsDict setObject:@"0" forKey:@"productId"];
            [buyStepsDict setObject:commissions forKey:@"commissions"];
         
            [buyStepsDict setObject:self.twoView.amount.text forKey:@"productChangePrice"];
        
            [buySteps addObject:buyStepsDict];
      
        

            if (![SVTool isBlankString:self.member_id]) {
                //会员卡号（实给会员ID)
                [parames setObject:self.member_id forKey:@"memberId"];

            }

        [parames setObject:buySteps forKey:@"buySteps"];
   

   
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parames progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        SVHTTPResponse * response = [SVHTTPResponse responseWithObject:responseDict];
        if (response.code == PSResponseStatusSuccessCode) {
            SVProductResultsData *model = [SVProductResultsData mj_objectWithKeyValues:response.data];
            NSArray *productResultslModelList = [SVProductResultslList mj_objectArrayWithKeyValuesArray:model.productResults];
            NSArray *orderPromotionsModelList = [SVOrderPromotions mj_objectArrayWithKeyValuesArray:model.orderPromotions];
           
            model.productResults = productResultslModelList;
            model.orderPromotions = orderPromotionsModelList;
            
            for (SVProductResultslList *productResultslModelList in model.productResults) {
                
                SVOrderPromotions *orderPromotions = [SVOrderPromotions mj_objectWithKeyValues:productResultslModelList.buyStepPromotion];
                SVPromotionDescription *promotionDescription = orderPromotions.promotionDescription;
                orderPromotions.promotionDescription = promotionDescription;
                productResultslModelList.buyStepPromotion = orderPromotions;
                
                if (productResultslModelList.orderPromotions.count > 0) {
                    NSArray *orderPromotionsArray = [SVOrderPromotions mj_objectArrayWithKeyValuesArray:productResultslModelList.orderPromotions];
                    productResultslModelList.orderPromotions = orderPromotionsArray;

                    NSString *preferential = @"";
                    double discountAmount = 0.0;
                    for (int i = 0; i < orderPromotionsArray.count; i++) {
                        SVOrderPromotions *orderPromotions = orderPromotionsArray[i];
                        SVPromotionDescription *promotionDescription = [SVPromotionDescription mj_objectWithKeyValues:orderPromotions.promotionDescription];
                        orderPromotions.promotionDescription = promotionDescription;
                        preferential = [preferential stringByAppendingString:promotionDescription.s];
                        discountAmount += promotionDescription.m;
                       
                    }
                    productResultslModelList.preferential = preferential;
                    productResultslModelList.discountAmount = discountAmount;
                    
                }
               // orderPromotions.promotionDescription = orderPromotions.promotionDescription;
            }
            
            self.productResultsData = model;
             
            
            //不用交互
            [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
            //提示在支付中
            [SVTool IndeterminateButtonAction:self.view withSing:@"等待用户支付中..."];

            NSMutableDictionary *md=[NSMutableDictionary dictionary];
            //订单号   string  order_running_id
            NSString *timeStr = [JWXUtils genTimeStamp];
            [md setObject:timeStr forKey:@"order_running_id"];

            //会员卡号（实给会员ID)    string    user_cardno    没有会员，就给死@“0”
            if ([SVTool isBlankString:self.member_id]) {
                //会员卡号（实给会员ID)
                [md setObject:@"0" forKey:@"user_cardno"];

            } else {
                //会员卡号（实给会员ID)
                [md setObject:self.member_id forKey:@"user_cardno"];

            }

            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
            [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
            NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
            [md setObject:dateString forKey:@"order_datetime"];

            //应收金额    decimal    order_receivable
            [md setObject:self.twoView.amount.text forKey:@"order_receivable"];
           // [guaDanDic setObject:total forKey:@"product_total"];
            // 成交价
          //  [md setObject:self.twoView.amount.text forKey:@"product_total"];
            // 开启积分模式
            [md setObject:@"true" forKey:@"MembershipGradeGroupingIsON"];

            //应收原金额    decimal    order_receivabley
            [md setObject:self.twoView.moneyLabel.text forKey:@"order_receivabley"];

            //付款金额    decimal    order_money
            [md setObject:self.twoView.amount.text forKey:@"order_money"];

            //收款方式    string    order_payment
            [md setObject:self.payWay forKey:@"order_payment"];

            if (!kStringIsEmpty(self.name)) {
                [md setObject:self.name forKey:@"sv_mr_name"];
            }

            if (!kStringIsEmpty(self.sv_mr_cardno)) {
                [md setObject:self.sv_mr_cardno forKey:@"sv_mr_cardno"];
            }

            //会员折扣    decimal    sv_member_discount
            if ([SVTool isBlankString:self.discount]) {
                //散客消费走这里
                [md setObject:[NSNumber numberWithFloat:1.0] forKey:@"sv_member_discount"];
            }else{
                //会员消费走这里
                NSString *vipfold = [NSString stringWithFormat:@"%.2f",[self.discount floatValue]*0.1];
                [md setObject:vipfold forKey:@"sv_member_discount"];
            }
        //    "sv_enable_alipay" = 0;
        //       "sv_enable_wechatpay" = 0;
            //整单折扣    decimal    order_discount
            [md setObject:@"1" forKey:@"order_discount"];

            //收款方式    string    order_payment2    给死@“待付”
            [md setObject:@"待收" forKey:@"order_payment2"];

            //付款金额    decimal    order_money2    给死@“0”
            [md setObject:@"0" forKey:@"order_money2"];

            //找零金额    decimal    order_change    给死@“0”
            [md setObject:@"0" forKey:@"order_change"];
            NSMutableArray *listDicArr = [NSMutableArray array];
            NSMutableDictionary *dic = [NSMutableDictionary dictionary];

            //成交价
            [dic setObject:self.twoView.amount.text forKey:@"product_total"];

            //商品ID
            [dic setObject:@"0" forKey:@"product_id"];
            //商品名
            [dic setObject:@"无码收银" forKey:@"product_name"];
            //数量
            [dic setObject:@"1" forKey:@"product_num"];

            [dic setObject:@"" forKey:@"sv_p_barcode"];
            // 商品规格
            [dic setObject:@"" forKey:@"sv_p_specs"];
            //单价
            [dic setObject:self.twoView.moneyLabel.text forKey:@"product_unitprice"];
            //商品原单价
            [dic setObject:self.twoView.moneyLabel.text forKey:@"product_price"];
            //折扣
            [dic setObject:[NSNumber numberWithFloat:1.0] forKey:@"product_discount"];
            [listDicArr addObject:dic];

            [md setObject:listDicArr forKey:@"prlist"];





            NSMutableDictionary *parames = [NSMutableDictionary dictionary];
            NSMutableDictionary *caleDto = [NSMutableDictionary dictionary];
            NSMutableArray *buySteps = [NSMutableArray array];
            NSMutableArray *payments = [NSMutableArray array];
        //    if (![SVTool isEmpty:self.resultArr]) {
              //  for (NSInteger i = 0; i < self.resultArr.count; i++) {
                   // NSMutableDictionary *dict = self.resultArr[i];

                    NSMutableArray *commissions = [NSMutableArray array];
                    NSMutableDictionary *buyStepsDict = [NSMutableDictionary dictionary];
                    [buyStepsDict setObject:[NSNumber numberWithInteger:1] forKey:@"index"];
                    [buyStepsDict setObject:[NSNumber numberWithInteger:1] forKey:@"number"];
                    [buyStepsDict setObject:[NSNumber numberWithInteger:0] forKey:@"productId"];
                    [buyStepsDict setObject:commissions forKey:@"commissions"];
                    [buyStepsDict setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] forKey:@"productChangePrice"];
                    [buySteps addObject:buyStepsDict];
               // }
        //    }
            [caleDto setObject:buySteps forKey:@"buySteps"];
            [caleDto setObject:[NSNumber numberWithInteger:3] forKey:@"currentStep"];
            //会员卡号（实给会员ID)    string    user_cardno    没有会员，就给死@“0”
            if (![SVTool isBlankString:self.member_id]) {
                //会员卡号（实给会员ID)
                [caleDto setObject:self.member_id forKey:@"memberId"];

            }

                //收款方式    string    order_payment
                NSMutableDictionary *payment1 = [NSMutableDictionary dictionary];
                [payment1 setObject:self.payWay forKey:@"name"];
                //付款金额    decimal    order_money
                [payment1 setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] forKey:@"money"];
               // [payment1 setObject:self.sumMoneyTwo forKey:@"money"];
                [payments addObject:payment1];


            [parames setObject:caleDto forKey:@"caleDto"];
            [parames setObject:[NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney] forKey:@"dealMoney"];
        //    [parames setObject:self.twoView.moneyLabel.text forKey:@"totalMoney"];
            [parames setObject:@"0" forKey:@"exchangeMoney"];
            [parames setObject:[NSNumber numberWithBool:true] forKey:@"isSettle"];
            [parames setObject:payments forKey:@"payments"];
            [parames setObject:[NSNumber numberWithInteger:102] forKey:@"sourceType"];

            NSString *sURL = [[NSString alloc]init];

            NSMutableDictionary *sbmitDict = [NSMutableDictionary dictionary];
            [SVUserManager loadUserInfo];
//            if ([self.payWay isEqualToString:@"扫码支付"]) {
//
//                NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//                if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
//                    //授权码
//                    [md setObject:self.authcode forKey:@"authcode"];
//                    sURL = [URLhead stringByAppendingFormat:@"/api/ConvergePay/Settle/WithoutList?key=%@",[SVUserManager shareInstance].access_token];
//                }else{
//                    //授权码
//                    [md setObject:self.authcode forKey:@"authcode"];
//                    sURL = [URLhead stringByAppendingFormat:@"/api/PayMent?key=%@",[SVUserManager shareInstance].access_token];
//                }
//
//                sbmitDict = md;
//
//            } else {
            
            

                NSString *timeStrT = [SVTool timeAcquireCurrentDateSfm];
                [parames setObject:timeStrT forKey:@"order_datetime"];

                NSInteger timeInteger= [SVDateTool cTimestampFromString:timeStrT format:@"yyyy-MM-dd HH:mm:ss"];

                sURL = [URLhead stringByAppendingFormat:@"/api/Settle/Save?key=%@&Forbid=%ld",[SVUserManager shareInstance].access_token,(long)timeInteger];
                sbmitDict = parames;
          //  }

            [[SVSaviTool sharedSaviTool] POST:sURL parameters:sbmitDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

                [MBProgressHUD hideHUDForView:self.view animated:YES];

                if ([dic[@"code"] integerValue] == 1) {

                    //移除
                    [self handlePan];


                    if (self.authcode.length > 0) {
                        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
                        if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {
                            // 新的聚合支付
                       //  return [SVTool TextButtonAction:self.view withSing:@"暂不支持新的聚合支付"];
                            NSString *code = [NSString stringWithFormat:@"%@",dic[@"code"]];
                            if (code.doubleValue == 1) {
                                //开启交互
                                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                                SVSalesResultData *data = [SVSalesResultData mj_objectWithKeyValues:dic[@"data"]];
                                
                                  [self ConvergePayB2CQueryId:data.queryId md:md];

                                }else{
                                    SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                                md[@"order_payment"] = self.payWay;
                                VC.pay = md[@"order_payment"];
                                      //  VC.pay = self.payWay;
//                                        VC.money = self.twoView.amount.text;
                                        VC.vipName = self.oneView.name.text;
                                        VC.sv_mr_cardno = self.sv_mr_cardno;
                                       VC.storedValue = self.storedValue;
                                       VC.interface = 4;
                                       VC.member_Cumulative = self.member_Cumulative;
                                    
                                    VC.productResultsData = self.productResultsData;
                                    VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
//                                    VC.interface = self.interface;
                                    VC.vipName = self.name;
                                    
                                       VC.md = dic;
                                       VC.md_two = md;
                                    [self.navigationController pushViewController:VC animated:YES];

                                    [self.stringNumber setString:@""];
                                    self.twoView.numberLabel.text = @"0";

                                    [self.string setString:@""];//清空字符
                                    self.num1=0;
                                    self.num2=0;
                                    //保证下次输入时清零
                                    self.twoView.moneyLabel.text = @"0";
                                    self.twoView.preferential.text =@"0.00";
                                    self.twoView.amount.text = @"0.00";
                                }

                           // }
                        }else{
                            SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                        md[@"order_payment"] = self.payWay;
                        VC.pay = md[@"order_payment"];
                              //  VC.pay = self.payWay;
                              //  VC.money = self.twoView.amount.text;
                                VC.vipName = self.oneView.name.text;
                                VC.sv_mr_cardno = self.sv_mr_cardno;
                               VC.storedValue = self.storedValue;
                               VC.interface = 4;
                               VC.member_Cumulative = self.member_Cumulative;
                            VC.productResultsData = self.productResultsData;
                            VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
//                                    VC.interface = self.interface;
                            VC.vipName = self.name;
                               VC.md = dic;
                               VC.md_two = md;
                            [self.navigationController pushViewController:VC animated:YES];

                            [self.stringNumber setString:@""];
                            self.twoView.numberLabel.text = @"0";

                            [self.string setString:@""];//清空字符
                            self.num1=0;
                            self.num2=0;
                            //保证下次输入时清零
                            self.twoView.moneyLabel.text = @"0";
                            self.twoView.preferential.text =@"0.00";
                            self.twoView.amount.text = @"0.00";
                        }
                    }else{
                        SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];
                    md[@"order_payment"] = self.payWay;
                    VC.pay = md[@"order_payment"];
                          //  VC.pay = self.payWay;
                            VC.money = self.twoView.amount.text;
                            VC.vipName = self.oneView.name.text;
                            VC.sv_mr_cardno = self.sv_mr_cardno;
                           VC.storedValue = self.storedValue;
                           VC.interface = 4;
                           VC.member_Cumulative = self.member_Cumulative;
                        VC.productResultsData = self.productResultsData;
                        VC.money = [NSString stringWithFormat:@"%.2f",self.productResultsData.dealMoney];
//                                    VC.interface = self.interface;
                        VC.vipName = self.name;
                           VC.md = dic;
                           VC.md_two = md;
                        [self.navigationController pushViewController:VC animated:YES];

                        [self.stringNumber setString:@""];
                        self.twoView.numberLabel.text = @"0";

                        [self.string setString:@""];//清空字符
                        self.num1=0;
                        self.num2=0;
                        //保证下次输入时清零
                        self.twoView.moneyLabel.text = @"0";
                        self.twoView.preferential.text =@"0.00";
                        self.twoView.amount.text = @"0.00";
                    }



                } else {

                    if ([self.payWay isEqualToString:@"扫码支付"]) {
                        NSString *errmsg = dic[@"errmsg"];
                        [SVTool TextButtonAction:self.view withSing:errmsg];
                    } else {
                        NSString *errmsg = dic[@"values"];
                        [SVTool TextButtonAction:self.view withSing:errmsg];
                    }

                }

        #pragma mark - 这里是聚合支付的返回
  
                //让按钮可点
                [self.payView.oneB setEnabled:YES];
                [self.payView.twoB setEnabled:YES];
                [self.payView.threeB setEnabled:YES];
                [self.payView.fourB setEnabled:YES];
                [self.payView.fiveB setEnabled:YES];
                [self.payView.sixB setEnabled:YES];

                [self.payViewTwo.oneB setEnabled:YES];
                [self.payViewTwo.twoB setEnabled:YES];
                [self.payViewTwo.threeB setEnabled:YES];
                [self.payViewTwo.fourB setEnabled:YES];
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];

            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //        [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];

                //让按钮可点
                [self.payView.oneB setEnabled:YES];
                [self.payView.twoB setEnabled:YES];
                [self.payView.threeB setEnabled:YES];
                [self.payView.fourB setEnabled:YES];
                [self.payView.fiveB setEnabled:YES];
                [self.payView.sixB setEnabled:YES];


                [self.payViewTwo.oneB setEnabled:YES];
                [self.payViewTwo.twoB setEnabled:YES];
                [self.payViewTwo.threeB setEnabled:YES];
                [self.payViewTwo.fourB setEnabled:YES];
            }];
        }else{
            [self.payView.oneB setEnabled:YES];
            [self.payView.twoB setEnabled:YES];
            [self.payView.threeB setEnabled:YES];
            [self.payView.fourB setEnabled:YES];
            [self.payView.fiveB setEnabled:YES];
            [self.payView.sixB setEnabled:YES];
        }
        
//        self.shopViewHeight.constant = 48 + self.productResultsData.productResults.count * rowHeight;
//        [self.tableView reloadData];
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
            
            [self.payView.oneB setEnabled:YES];
            [self.payView.twoB setEnabled:YES];
            [self.payView.threeB setEnabled:YES];
            [self.payView.fourB setEnabled:YES];
            [self.payView.fiveB setEnabled:YES];
            [self.payView.sixB setEnabled:YES];
        }];
}


/**
 结算请求
 */
-(void)requestQuickCashier{
    
    [self.payView.oneB setEnabled:NO];
    [self.payView.twoB setEnabled:NO];
    [self.payView.threeB setEnabled:NO];
    [self.payView.fourB setEnabled:NO];
    [self.payView.fiveB setEnabled:NO];
    [self.payView.sixB setEnabled:NO];

    [self.payViewTwo.oneB setEnabled:NO];
    [self.payViewTwo.twoB setEnabled:NO];
    [self.payViewTwo.threeB setEnabled:NO];
    [self.payViewTwo.fourB setEnabled:NO];
    
    /*
     
     */
    
    [self loadSettleCaleIsWholeOrder:false];


    
}


#pragma mark - B2C支付
- (void)ConvergePayB2CQueryId:(NSString *)queryId md:(NSMutableDictionary *)md{
    [SVUserManager loadUserInfo];
   // NSString *url = [NSString stringWithFormat:@"%@%@",URLhead,@"/api/ConvergePay/B2C?key=%@",NSString *url = [SVUserManager shareInstance].access_token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"authCode"] = self.authcode;
   
//    NSString *order_payment = md[@"order_payment"];
//    NSString *order_payment2 = md[@"order_payment2"];
//    NSString *order_money = md[@"order_money"];
//    NSString *order_money2 = md[@"order_money2"];
//    if ([order_payment isEqualToString:@"扫码支付"]) {
//        parame[@"money"] = [NSString stringWithFormat:@"%.2f",order_money.doubleValue];
//    }else if ([order_payment2 isEqualToString:@"扫码支付"]){
//        parame[@"money"] = [NSString stringWithFormat:@"%.2f",order_money2.doubleValue];
//    }else{
//        parame[@"money"] = [NSString stringWithFormat:@"%.2f",self.sumMoneyTwo.doubleValue];
//    }
    parame[@"money"] = self.twoView.amount.text;
    parame[@"subject"] = [SVUserManager shareInstance].sv_employee_name;
    parame[@"businessType"] = [NSNumber numberWithInteger:3];
    parame[@"queryId"] = queryId;
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ConvergePay/B2C?key=%@",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                   NSLog(@"dic-----B2C支付 = %@",dic);
                   NSLog(@"surlB2C支付 = %@",url);
        if ([dic[@"code"] integerValue] == 1) {
            self.showView = [[ZJViewShow alloc]initWithFrame:self.view.frame];
            //  self.showView.delegate = self;
            self.showView.center = self.view.center;
            [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
            //按钮实现倒计时
            __block int timeout=3000; //倒计时时间
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
            dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
            dispatch_source_set_event_handler(_timer, ^{
                if(timeout<=0){ //倒计时结束，关闭
                    dispatch_source_cancel(_timer);
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [self.showView removeFromSuperview];
                    
                    });
                }else{
                    [self ConvergePayQueryId:queryId _timer:_timer md:md];
                    int seconds = timeout;
                    NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                    NSLog(@"strTime = %@",strTime);
                    
                    timeout--;
                }
            });
            dispatch_resume(_timer);
            
            self.showView.selectCancleBlock = ^{
                dispatch_source_cancel(_timer);
            };
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示
               [MBProgressHUD hideHUDForView:self.view animated:YES];
               //[SVTool requestFailed];
               [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

#pragma mark - 聚合支付轮训
- (void)ConvergePayQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer md:(NSMutableDictionary *)md{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/ConvergePay/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"dic-----聚合支付轮训 = %@",dic);
               NSLog(@"surl聚合支付轮训 = %@",url);
        if ([dic[@"code"] integerValue] == 1) {
            
            //回调清除选择商品数据
//            if (self.selectWaresBlock) {
//                self.selectWaresBlock();
//            }
            
            // 发出通知
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:@"1"];
            
            NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
            NSString *msg = dic[@"msg"];
            if (action.integerValue == -1) {// 停止轮训
                dispatch_source_cancel(_timer);
                [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"支付有误"];
                [self.showView removeFromSuperview];
            }else if(action.integerValue == 1){// 1:Success,取到结果;
                NSString *orderJson = [NSString stringWithFormat:@"%@",dic[@"data"][@"orderJson"]];
                
                NSData *data = [orderJson dataUsingEncoding:NSUTF8StringEncoding];
                if (data != NULL) {
                     NSMutableDictionary *orderJsonDic = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                    [md setValue:orderJsonDic[@"order_integral"] forKey:@"order_integral"];
                    [md setValue:orderJsonDic[@"order_payment"] forKey:@"order_payment"];
                    //NSDictionary *orderJsonDic =[SVTool dictionaryWithJsonString:orderJson];
                    //移除
                    [self handlePan];

                        SVShowCheckoutVC *VC = [[SVShowCheckoutVC alloc]init];

                            VC.pay = self.payWay;
                            VC.money = self.twoView.amount.text;
                            VC.vipName = self.oneView.name.text;
                            VC.sv_mr_cardno = self.sv_mr_cardno;
                            VC.storedValue = self.storedValue;
                            VC.interface = 4;
                           VC.member_Cumulative = self.member_Cumulative;
         
                          // VC.md = dic;
                           VC.md_two = md;
                        [self.navigationController pushViewController:VC animated:YES];
                        
                        [self.stringNumber setString:@""];
                        self.twoView.numberLabel.text = @"0";

                        [self.string setString:@""];//清空字符
                        self.num1=0;
                        self.num2=0;
                        //保证下次输入时清零
                        self.twoView.moneyLabel.text = @"0";
                        self.twoView.preferential.text =@"0.00";
                        self.twoView.amount.text = @"0.00";
                }
   
                dispatch_source_cancel(_timer);
                [self.showView removeFromSuperview];
            }else{// 2:Continue,继续轮询;
                
            }
        }else{
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 请求是否打开支付通道
- (void)requestMethodOfPayment {
    
    [SVTool IndeterminateButtonActionWithSing:nil];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Payment/PaymentUseCheck?key=%@",token];
    
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //隐藏提示
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        if ([dic[@"succeed"] integerValue] == 1) {
            NSDictionary *values = dic[@"values"];
            
            if ([values[@"sv_enable_alipay"] integerValue] == 1) {
                self.sv_enable_alipay = [NSString stringWithFormat:@"%@",values[@"sv_enable_alipay"]];
            } else {
                self.sv_enable_alipay = @"0";
            }
            
            if ([values[@"sv_enable_wechatpay"] integerValue] == 1) {
                self.sv_enable_wechatpay = [NSString stringWithFormat:@"%@",values[@"sv_enable_wechatpay"]];
            } else {
                self.sv_enable_wechatpay = @"0";
            }
            
        } else {
            [SVTool TextButtonActionWithSing:@"扫码支付请求失败"];
            self.sv_enable_alipay = @"0";
            self.sv_enable_wechatpay = @"0";
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
        [SVTool TextButtonActionWithSing:@"扫码支付请求失败"];
        self.sv_enable_alipay = @"0";
        self.sv_enable_wechatpay = @"0";
    }];
    
}


#pragma mark - 懒加载

-(SVVipBlackView *)oneView{
    if (!_oneView) {
        //创建view
//        _oneView = [[SVVipBlackView alloc]initWithFrame:CGRectMake(0, 64, ScreenW, 43)];
        _oneView = [[NSBundle mainBundle] loadNibNamed:@"SVVipBlackView" owner:nil options:nil].lastObject;
        //_oneView.frame = CGRectMake(0, 64, ScreenW, 50);
//        _oneView.backgroundColor = [UIColor blackColor];
        [self.backView addSubview:_oneView];
        
        [_oneView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, 50));
            make.top.mas_equalTo(self.view);
            make.left.mas_equalTo(self.view);
        }];

    }
    return _oneView;
}


-(SVQuickCashierView *)twoView{
    if (!_twoView) {
        _twoView = [[[NSBundle mainBundle]loadNibNamed:@"SVQuickCashierView" owner:nil options:nil] lastObject];
        //_twoView.frame = CGRectMake(0, 114, ScreenW, num-114.5);
        [self.view addSubview:_twoView];
        
        [_twoView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, num-114.5));
            make.top.mas_equalTo(self.view).offset(50);
            make.left.mas_equalTo(self.view);
        }];
    }
    return _twoView;
}

-(SVQuickPayView *)payView{
    if (!_payView) {
        _payView = [[[NSBundle mainBundle]loadNibNamed:@"SVQuickPayView" owner:nil options:nil] lastObject];
        _payView.frame = CGRectMake(0, ScreenH, ScreenW, num);
        _payView.backgroundColor = RGBA(239, 239, 239, 1);
        _payView.fourV.hidden = YES;

        //添加手动拖动
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_payView addGestureRecognizer:panGestureRecognizer];
        }

    [_payView.oneB addTarget:self action:@selector(oneBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    [_payView.twoB addTarget:self action:@selector(twoBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    [_payView.threeB addTarget:self action:@selector(threeBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    [_payView.fourB addTarget:self action:@selector(fourBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    [_payView.fiveB addTarget:self action:@selector(fiveBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    [_payView.sixB addTarget:self action:@selector(sixBrequestQuickCashier) forControlEvents:UIControlEventTouchUpInside];
    
    return _payView;
}

#pragma mark - 新聚合支付的View
-(SVQuickpayViewTwo *)payViewTwo{
    if (!_payViewTwo) {
        _payViewTwo = [[[NSBundle mainBundle]loadNibNamed:@"SVQuickpayViewTwo" owner:nil options:nil] lastObject];
        _payViewTwo.frame = CGRectMake(0, ScreenH, ScreenW, num);
        _payViewTwo.backgroundColor = RGBA(239, 239, 239, 1);
      //  _payView.fourV.hidden = YES;

        //添加手动拖动
        UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_payViewTwo addGestureRecognizer:panGestureRecognizer];
        }

    [_payViewTwo.oneB addTarget:self action:@selector(oneBrequestQuickCashierTwo) forControlEvents:UIControlEventTouchUpInside];
    [_payViewTwo.twoB addTarget:self action:@selector(twoBrequestQuickCashierTwo) forControlEvents:UIControlEventTouchUpInside];
    [_payViewTwo.threeB addTarget:self action:@selector(threeBrequestQuickCashierTwo) forControlEvents:UIControlEventTouchUpInside];
    [_payViewTwo.fourB addTarget:self action:@selector(fourBrequestQuickCashierTwo) forControlEvents:UIControlEventTouchUpInside];
    
    return _payViewTwo;
}





/**
 遮盖
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        
        _maskTheView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheView.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan)];
        [_maskTheView addGestureRecognizer:tap];
        
    }
    
    return _maskTheView;
    
}

/**
 遮盖
 */
-(UIView *)maskTheViewTwo{
    if (!_maskTheViewTwo) {
        
        _maskTheViewTwo = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
        _maskTheViewTwo.backgroundColor = [UIColor colorWithRed:0/255.f green:0/255.f blue:0/255.f alpha:0.3];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitCancelResponseEvent)];
        [_maskTheViewTwo addGestureRecognizer:tap];
        
    }
    
    return _maskTheViewTwo;
    
}

//移除
- (void)handlePan{
    [self.maskTheView removeFromSuperview];
    [UIView animateWithDuration:.5 animations:^{
        self.payView.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
    }];
    
    [UIView animateWithDuration:.5 animations:^{
        self.payViewTwo.frame = CGRectMake(0, ScreenH, ScreenW, ScreenH-num);
    }];
    
}

-(void)oneBrequestQuickCashier{
    
    if ([self.sv_enable_alipay isEqualToString:@"1"]) {
        [self fourBrequestQuickCashier];
    } else {
        self.payWay = @"支付宝记账";
        [self.payView.oneV setBackgroundColor:RGBA(175, 255, 215, 1)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.payView.oneV setBackgroundColor:[UIColor whiteColor]];
        });
        
        [self requestQuickCashier];
    }
    
}

-(void)twoBrequestQuickCashier{
    
    if ([self.sv_enable_wechatpay isEqualToString:@"1"]) {
        [self fourBrequestQuickCashier];
    } else {
        self.payWay = @"微信记账";
        [self.payView.twoV setBackgroundColor:RGBA(175, 255, 215, 1)];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.payView.twoV setBackgroundColor:[UIColor whiteColor]];
        });
        
        [self requestQuickCashier];
    }
    
}

-(void)threeBrequestQuickCashier{
    
    self.payWay = @"现金";
    [self.payView.threeV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.threeV setBackgroundColor:[UIColor whiteColor]];
    });
    
    [self requestQuickCashier];

    
}

/**
 扫一扫
 */
-(void)fourBrequestQuickCashier{
    
    self.payWay = @"扫码支付";
    [self.payView.fourV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.fourV setBackgroundColor:[UIColor whiteColor]];
    });
    
    //移除
    [self handlePan];
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        if ([SVTool deptNumInputShouldNumber:name] == YES) {
//            weakSelf.authcode = name;
//
//            [weakSelf requestQuickCashier];
//        } else {
//            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
//        }
//
//    };
    
    __weak typeof(self) weakSelf = self;

    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        if ([SVTool deptNumInputShouldNumber:resultStr] == YES) {
            weakSelf.authcode = resultStr;

            [weakSelf requestQuickCashier];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
        }
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
       [self.navigationController pushViewController:vc animated:YES];

  
    
}


-(void)fiveBrequestQuickCashier{
    
    self.payWay = @"银行卡";
    [self.payView.fiveV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.fiveV setBackgroundColor:[UIColor whiteColor]];
    });
    
    [self requestQuickCashier];
    
}

-(void)sixBrequestQuickCashier{
    
    self.payWay = @"储值卡";
    [self.payView.sixV setBackgroundColor:RGBA(175, 255, 215, 1)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.sixV setBackgroundColor:[UIColor whiteColor]];
    });
    
    if ([self.storedValue integerValue] < [self.twoView.amount.text integerValue]) {
        [SVTool TextButtonAction:self.view withSing:@"储值余额不足"];
        return;
    }
    
    self.storedValue = [NSString stringWithFormat:@"%.2f",[self.storedValue floatValue] - [self.twoView.amount.text floatValue]];
    
  
        if ( [[SVUserManager shareInstance].sv_uc_isenablepwd isEqualToString:@"0"] || kStringIsEmpty(self.sv_mr_pwd)) {
            [self requestQuickCashier];
        }else{
            
            [self.addCustomView.textView becomeFirstResponder];// 2
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
        }
    
}

#pragma mark - 新聚合支付调用的支付按钮
#pragma mark - 现金
- (void)oneBrequestQuickCashierTwo{
    self.payWay = @"现金";
    [self.payView.threeV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.threeV setBackgroundColor:[UIColor whiteColor]];
    });
    
    [self requestQuickCashier];
}
#pragma mark - 扫码付
-(void)twoBrequestQuickCashierTwo{
    self.payWay = @"扫码支付";
    [self.payView.fourV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.fourV setBackgroundColor:[UIColor whiteColor]];
    });
    
    //移除
    [self handlePan];
    
//    SGQRCodeScanningVC *VC = [[SGQRCodeScanningVC alloc]init];
//
//    __weak typeof(self) weakSelf = self;
//
//    VC.saosao_Block = ^(NSString *name){
//
//        if ([SVTool deptNumInputShouldNumber:name] == YES) {
//            weakSelf.authcode = name;
//
//            [weakSelf requestQuickCashier];
//        } else {
//            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
//        }
//
//    };
//
//    [self.navigationController pushViewController:VC animated:YES];
    
    __weak typeof(self) weakSelf = self;

    QQLBXScanViewController *vc = [QQLBXScanViewController new];
        vc.libraryType = [Global sharedManager].libraryType;
        vc.scanCodeType = [Global sharedManager].scanCodeType;
      //  vc.stockCheckVC = self;
        vc.style = [StyleDIY weixinStyle];
        vc.isStockPurchase = 6;
    vc.addShopScanBlock = ^(NSString *resultStr) {
        if ([SVTool deptNumInputShouldNumber:resultStr] == YES) {
            weakSelf.authcode = resultStr;

            [weakSelf requestQuickCashier];
        } else {
            [SVTool TextButtonAction:self.view withSing:@"结算失败!"];
        }
    };
//        self.hidesBottomBarWhenPushed=YES;
              //跳转界面有导航栏的
       [self.navigationController pushViewController:vc animated:YES];
}

- (void)threeBrequestQuickCashierTwo{
    self.payWay = @"银行卡";
    [self.payView.fiveV setBackgroundColor:RGBA(175, 255, 215, 1)];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.fiveV setBackgroundColor:[UIColor whiteColor]];
    });
    
    [self requestQuickCashier];
}

- (void)fourBrequestQuickCashierTwo{
    self.payWay = @"储值卡";
    [self.payView.sixV setBackgroundColor:RGBA(175, 255, 215, 1)];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.payView.sixV setBackgroundColor:[UIColor whiteColor]];
    });
    
    if ([self.storedValue integerValue] < [self.twoView.amount.text integerValue]) {
        [SVTool TextButtonAction:self.view withSing:@"储值余额不足"];
        return;
    }
    
    self.storedValue = [NSString stringWithFormat:@"%.2f",[self.storedValue floatValue] - [self.twoView.amount.text floatValue]];
    
  
        if ( [[SVUserManager shareInstance].sv_uc_isenablepwd isEqualToString:@"0"] || kStringIsEmpty(self.sv_mr_pwd)) {
            [self requestQuickCashier];
        }else{
            
            [self.addCustomView.textView becomeFirstResponder];// 2
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
        }
}


#pragma mark - 会员密码输入
- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.name.text = @"输入会员密码";
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(addMemberPwdsureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}

- (void)unitCancelResponseEvent{
    [self.maskTheViewTwo removeFromSuperview];
    [self.addCustomView removeFromSuperview];
    self.addCustomView.textView.text = nil;
    [self handlePan];
}

#pragma mark - 输入密码确定按钮点击
- (void)addMemberPwdsureBtnClick{
    if ([self.addCustomView.textView.text isEqualToString:self.sv_mr_pwd]) {
        // [SVTool TextButtonActionWithSing:@"密码正确"];
        [self unitCancelResponseEvent];
         [self requestQuickCashier];
        
    }else{
        [SVTool TextButtonActionWithSing:@"密码错误"];
        [self unitCancelResponseEvent];
    }
}

@end
