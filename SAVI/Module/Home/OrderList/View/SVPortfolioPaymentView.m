//
//  SVPortfolioPaymentView.m
//  SAVI
//
//  Created by houming Wang on 2021/3/23.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPortfolioPaymentView.h"

@interface SVPortfolioPaymentView()
@property (weak, nonatomic) IBOutlet UIButton *btn_7;
@property (weak, nonatomic) IBOutlet UIButton *btn_8;
@property (weak, nonatomic) IBOutlet UIButton *btn_9;
@property (weak, nonatomic) IBOutlet UIButton *btn_4;
@property (weak, nonatomic) IBOutlet UIButton *btn_5;
@property (weak, nonatomic) IBOutlet UIButton *btn_6;
@property (weak, nonatomic) IBOutlet UIButton *btn_1;
@property (weak, nonatomic) IBOutlet UIButton *btn_2;
@property (weak, nonatomic) IBOutlet UIButton *btn_3;
@property (weak, nonatomic) IBOutlet UIButton *btn_circle;
@property (weak, nonatomic) IBOutlet UIButton *btn_0;
@property (weak, nonatomic) IBOutlet UIButton *btn_clear_0;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIView *topView;

@property (weak, nonatomic) IBOutlet UILabel *sumLabel;

@property(retain,nonatomic) NSMutableString *string;  //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(retain,nonatomic) NSMutableString *stringNumber;
@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;

@property (nonatomic,strong) NSString * money;

@end
@implementation SVPortfolioPaymentView


- (void)awakeFromNib
{
    [super awakeFromNib];
    
    self.clearBtn.layer.cornerRadius = 25;
    self.clearBtn.layer.masksToBounds = YES;
    self.clearBtn.layer.borderWidth = 1;
    self.clearBtn.layer.borderColor = [UIColor grayColor].CGColor;
    
    self.btn_7.layer.cornerRadius = 30;
    self.btn_7.layer.masksToBounds = YES;
    self.btn_8.layer.cornerRadius = 30;
    self.btn_8.layer.masksToBounds = YES;
    self.btn_9.layer.cornerRadius = 30;
    self.btn_9.layer.masksToBounds = YES;
    self.btn_4.layer.cornerRadius = 30;
    self.btn_4.layer.masksToBounds = YES;
    self.btn_5.layer.cornerRadius = 30;
    self.btn_5.layer.masksToBounds = YES;
    self.btn_6.layer.cornerRadius = 30;
    self.btn_6.layer.masksToBounds = YES;
    self.btn_1.layer.cornerRadius = 30;
    self.btn_1.layer.masksToBounds = YES;
    self.btn_2.layer.cornerRadius = 30;
    self.btn_2.layer.masksToBounds = YES;
    self.btn_3.layer.cornerRadius = 30;
    self.btn_3.layer.masksToBounds = YES;
    self.btn_circle.layer.cornerRadius = 30;
    self.btn_circle.layer.masksToBounds = YES;
    self.btn_0.layer.cornerRadius = 30;
    self.btn_0.layer.masksToBounds = YES;
    self.btn_clear_0.layer.cornerRadius = 30;
    self.btn_clear_0.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.topView.layer.cornerRadius = 25;
    self.topView.layer.masksToBounds = YES;
    self.sumLabel.textColor = GreyFontColor;
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
    NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
      self.ZeroInventorySales_sv_detail_is_enable = ZeroInventorySales_sv_detail_is_enable;
}

- (IBAction)qingchuClick:(id)sender {
    self.sumLabel.text = @"请输入金额";
    self.sumLabel.textColor = GreyFontColor;
    [self.string setString:@""];//清空字符
    self.money = self.string;
}


- (IBAction)shanchu:(id)sender {
    self.sumLabel.text = @"请输入金额";
    self.sumLabel.textColor = GreyFontColor;
    [self.string setString:@""];//清空字符
    self.money = self.string;
}

- (IBAction)selectNumberClick:(id)sender {
    
    //数字连续输入
    [self.string appendString:[sender currentTitle]];
    self.sumLabel.textColor = navigationBackgroundColor;
    self.sumLabel.text = self.string;
    self.money = self.string;
    
}



- (IBAction)clearClick:(id)sender {
    self.sumLabel.text = @"请输入金额";
    self.sumLabel.textColor = GreyFontColor;
    [self.string setString:@""];//清空字符
    self.money = self.string;
}

- (IBAction)sureClick:(id)sender {
    NSLog(@"self.TotleMoney = %@",self.TotleMoney);
    NSLog(@"self.title = %@",self.title);
    // 保留现金找零的代码
//    if (self.TotleMoney.doubleValue < self.money.doubleValue && ![self.title isEqualToString:@"现金"]) {
//        [SVTool TextButtonAction:self withSing:@"支付金额不能大于应收金额"];
//    }else if (self.money.doubleValue <= 0){
//        [SVTool TextButtonAction:self withSing:@"还没输入金额"];
//    }else{
//        if (self.selectMoney) {
//            self.selectMoney(self.money);
//        }
//        self.sumLabel.text = @"请输入金额";
//        self.sumLabel.textColor = GreyFontColor;
//        [self.string setString:@""];//清空字符
//        self.money = self.string;
//    }

    if (self.TotleMoney.doubleValue < self.money.doubleValue) {
        [SVTool TextButtonAction:self withSing:@"支付金额不能大于应收金额"];
    }else if (self.money.doubleValue <= 0){
        [SVTool TextButtonAction:self withSing:@"还没输入金额"];
    }else{
        if (self.selectMoney) {
            self.selectMoney(self.money);
        }
        self.sumLabel.text = @"请输入金额";
        self.sumLabel.textColor = GreyFontColor;
        [self.string setString:@""];//清空字符
        self.money = self.string;
    }
}

@end
