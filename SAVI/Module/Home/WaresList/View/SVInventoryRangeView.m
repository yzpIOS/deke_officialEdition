//
//  SVInventoryRangeView.m
//  SAVI
//
//  Created by houming Wang on 2021/1/29.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVInventoryRangeView.h"

@interface SVInventoryRangeView()
@property (weak, nonatomic) IBOutlet UIButton *oneBtn;
@property (weak, nonatomic) IBOutlet UIButton *twoBtn;

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
@property(retain,nonatomic) NSMutableString *twoString;
@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;
@property (nonatomic,assign) BOOL oneBtnOrTwoBtn;
@property (nonatomic,assign) NSInteger oneNumber;
@property (nonatomic,assign) NSInteger twoNumber;
@end

@implementation SVInventoryRangeView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.oneBtnOrTwoBtn = NO;
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
    self.topView.layer.cornerRadius = 20;
    self.topView.layer.masksToBounds = YES;
    self.oneNumber = -1;
    self.twoNumber = -1;
    [self.oneBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self.oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    
    self.oneBtn.layer.cornerRadius = 20.f;
    self.oneBtn.layer.masksToBounds = YES;
    
    self.oneBtn.layer.borderWidth = 1;
    [self.oneBtn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    self.oneBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    [self.oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];


    [self.oneBtn addTarget:self action:@selector(oneBtnClick:) forControlEvents:UIControlEventTouchUpInside];

//            [self.twoBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
//            [self.oneBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.twoBtn setBackgroundColor:[UIColor colorWithHexString:@"f7f7f7"]];
    [self.twoBtn setTitleColor:navigationBackgroundColor forState:UIControlStateSelected];
    
    self.twoBtn.layer.cornerRadius = 20.f;
    self.twoBtn.layer.masksToBounds = YES;
    
    self.twoBtn.layer.borderWidth = 1;
    self.twoBtn.layer.borderColor = [UIColor colorWithHexString:@"f4f4f4"].CGColor;


    [self.twoBtn addTarget:self action:@selector(twoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.string = [[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.twoString = [[NSMutableString alloc]init];
}
#pragma mark - 最小库存
- (void)oneBtnClick:(UIButton *)btn{
    self.oneBtnOrTwoBtn = NO;
    [self.oneBtn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    self.oneBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    [self.oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    
    [self.twoBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.twoBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.twoBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    
    
    
}

#pragma mark - 最大库存
- (void)twoBtnClick:(UIButton *)btn{
    self.oneBtnOrTwoBtn = YES;
    [self.twoBtn setBackgroundColor:[UIColor colorWithHexString:@"E6EAFF"]];
    self.twoBtn.layer.borderColor = navigationBackgroundColor.CGColor;
    [self.twoBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    
    [self.oneBtn setTitleColor: [UIColor colorWithHexString:@"666666"] forState:UIControlStateNormal];
    [self.oneBtn setBackgroundColor:[UIColor colorWithHexString:@"F8F8F8"]];
    self.oneBtn.layer.borderColor = [UIColor colorWithHexString:@"EEEEEE"].CGColor;
    
    
}

- (IBAction)selectNumberClick:(id)sender {
    if (self.oneBtnOrTwoBtn == NO) {
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
       // self.oneBtn. = self.string;
        NSString *str = [NSString stringWithFormat:@"%@",self.string];
        NSLog(@"str = %@",str);
        [self.oneBtn setTitle:str forState:UIControlStateNormal];
        self.oneNumber = str.integerValue;
    }else{
        //数字连续输入
        [self.twoString appendString:[sender currentTitle]];
      //  self.sumLabel.text = self.string;
        NSString *str = [NSString stringWithFormat:@"%@",self.twoString];
        [self.twoBtn setTitle:str forState:UIControlStateNormal];
        self.twoNumber = str.integerValue;
    }
   
}

- (IBAction)clearClick:(id)sender {
    if (self.oneBtnOrTwoBtn == NO) {
       // self.sumLabel.text = @"";
        [self.string setString:@""];//清空字符
        [self.oneBtn setTitle:@"最小库存" forState:UIControlStateNormal];
        self.oneNumber = -1;
    }else{
        [self.twoString setString:@""];//清空字符
        [self.twoBtn setTitle:@"最大库存" forState:UIControlStateNormal];
        self.twoNumber = -1;
    }
  
}

- (IBAction)sureClick:(id)sender {
  
    if (self.oneNumber == -1) {
        [SVTool TextButtonAction:self withSing:@"请输入最小库存"];
    }else if (self.twoNumber == -1){
        [SVTool TextButtonAction:self withSing:@"请输入最大库存"];
    }else{
        if (self.stockBlock) {
            self.stockBlock(self.oneNumber, self.twoNumber);
        }
        
    }
}

@end
