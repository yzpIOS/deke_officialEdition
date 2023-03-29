//
//  SVDiscountAndNumberView.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/24.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVDiscountAndNumberView.h"

@interface SVDiscountAndNumberView()
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



 //NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property(retain,nonatomic) NSMutableString *stringNumber;
@property (nonatomic,strong) NSString *ZeroInventorySales_sv_detail_is_enable;
@end
@implementation SVDiscountAndNumberView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
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
    
    self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber = [[NSMutableString alloc]init];
    NSString *ZeroInventorySales_sv_detail_is_enable= [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].ZeroInventorySales_sv_detail_is_enable]; //
      self.ZeroInventorySales_sv_detail_is_enable = ZeroInventorySales_sv_detail_is_enable;
}

- (void)setOrderDetailsModel:(SVOrderDetailsModel *)orderDetailsModel
{
    self.sumLabel.text = @"";
    [self.string setString:@""];//清空字符
    _orderDetailsModel = orderDetailsModel;
     self.sumLabel.text = [NSString stringWithFormat:@"%.2f",orderDetailsModel.product_num.floatValue + orderDetailsModel.sv_p_weight.floatValue];
}

- (void)setDict:(NSMutableDictionary *)dict
{

    self.sumLabel.text = @"";
    [self.string setString:@""];//清空字符
    _dict = dict;
    self.sumLabel.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"]floatValue] + [dict[@"sv_p_weight"]floatValue]];
}

- (IBAction)selectNumberClick:(id)sender {
    
    //数字连续输入
    if (self.isHiddenDecimalPoint == true) {
        if (![[sender currentTitle] isEqualToString:@"."]) {
            [self.string appendString:[sender currentTitle]];

            self.sumLabel.text = self.string;
            self.sumLabel.textColor = navigationBackgroundColor;
        }
    }else{
        [self.string appendString:[sender currentTitle]];

        self.sumLabel.text = self.string;
        self.sumLabel.textColor = navigationBackgroundColor;
    }
}

- (IBAction)clearClick:(id)sender {
    self.sumLabel.text = @"";
    [self.string setString:@""];//清空字符
    
}

- (IBAction)sureClick:(id)sender {
    
    if (self.orderDetailsModelBlock) {
//        self.orderDetailsModel.product_num = [NSString stringWithFormat:@"%@",self.sumLabel.text];
//        self.orderDetailsModelBlock(self.orderDetailsModel);
        if ([self.ZeroInventorySales_sv_detail_is_enable isEqualToString:@"0"]) {
                         if (self.sumLabel.text.doubleValue>[self.dict[@"sv_p_storage"] doubleValue]) {
                                  [SVTool TextButtonAction:self withSing:@"库存不足"];
                             }else{
                                 self.dict[@"product_num"] = [NSString stringWithFormat:@"%@",self.sumLabel.text];
                                        self.orderDetailsModelBlock(self.dict);
                                 
                                 if (self.clearBlock) {
                                        self.clearBlock();
                                    }
                             }
        }else{
            self.dict[@"product_num"] = [NSString stringWithFormat:@"%@",self.sumLabel.text];
            self.orderDetailsModelBlock(self.dict);
            
            if (self.clearBlock) {
                self.clearBlock();
            }
        }
    
       
    }
    
    // 供应商这边的 和还款记录
    if (self.moneyBlock) {
        if ([self.sumLabel.text isEqualToString:@"请输入金额"]) {
            [SVTool TextButtonActionWithSing:@"请输入金额"];
        }else if (self.huankuanMoney < self.sumLabel.text.doubleValue){
            [SVTool TextButtonActionWithSing:@"不能大于还款金额"];
        }else{
            self.moneyBlock([NSString stringWithFormat:@"%@",self.sumLabel.text]);
        }
        
        
    }
    
    if (self.chuqiBlock) {
        if ([self.sumLabel.text isEqualToString:@"请输入金额"]) {
            [SVTool TextButtonActionWithSing:@"请输入金额"];
        }else{
            self.chuqiBlock([NSString stringWithFormat:@"%@",self.sumLabel.text]);
        }
    }
    
    if (self.integralBlock) {
        if ([self.sumLabel.text isEqualToString:@"请输入积分"]) {
            [SVTool TextButtonActionWithSing:@"请输入积分"];
        }else{
          //  self.sumLabel.text = @"";
            [self.string setString:@""];//清空字符
            self.integralBlock([NSString stringWithFormat:@"%@",self.sumLabel.text]);
        }
    }
   
}

@end
