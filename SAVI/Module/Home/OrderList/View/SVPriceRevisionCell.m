//
//  SVPriceRevisionCell.m
//  SAVI
//
//  Created by 杨忠平 on 2020/2/24.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVPriceRevisionCell.h"
#import "DWSegmentedControl.h"
//#import "SVduoguigeModel.h"
@interface SVPriceRevisionCell()<DWSegmentedControlDelegate>
@property (weak, nonatomic) IBOutlet UILabel *OriginalpriceLabel;
@property(retain,nonatomic) NSMutableString *string;
//NSMutableString用来处理可变对象，如需要处理字符串并更改字符串中的字符
@property (nonatomic,assign) NSInteger selectNumber;
@property (nonatomic,strong) NSMutableString *stringNumber;
@property (weak, nonatomic) IBOutlet UILabel *disCountLabel;
//"sv_p_mindiscount" = 5;
//"sv_p_minunitprice" = 0;
/**
 最低折
 */
@property (nonatomic,assign) double sv_p_mindiscount;
/**
 最低价
 */
@property (nonatomic,assign) double sv_p_minunitprice;

@end
@implementation SVPriceRevisionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    DWSegmentedControl *test = [[DWSegmentedControl alloc] initWithFrame:CGRectMake(30, 40, self.frame.size.width-60, 40)];
    test.backgroundColor = [UIColor whiteColor];
    test.selectedViewColor = navigationBackgroundColor;
    test.normalLabelColor = navigationBackgroundColor;
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
    test.delegate = self;
    test.titles = @[@"现金",@"折扣"];
    [self addSubview:test];
   
    self.btn_7.layer.cornerRadius = 25;
    self.btn_7.layer.masksToBounds = YES;
    self.btn_8.layer.cornerRadius = 25;
    self.btn_8.layer.masksToBounds = YES;
    self.btn_9.layer.cornerRadius = 25;
    self.btn_9.layer.masksToBounds = YES;
    self.btn_4.layer.cornerRadius = 25;
    self.btn_4.layer.masksToBounds = YES;
    self.btn_5.layer.cornerRadius = 25;
    self.btn_5.layer.masksToBounds = YES;
    self.btn_6.layer.cornerRadius = 25;
    self.btn_6.layer.masksToBounds = YES;
    self.btn_1.layer.cornerRadius = 25;
    self.btn_1.layer.masksToBounds = YES;
    self.btn_2.layer.cornerRadius = 25;
    self.btn_2.layer.masksToBounds = YES;
    self.btn_3.layer.cornerRadius = 25;
    self.btn_3.layer.masksToBounds = YES;
    self.btn_circle.layer.cornerRadius = 25;
    self.btn_circle.layer.masksToBounds = YES;
    self.btn_0.layer.cornerRadius = 25;
    self.btn_0.layer.masksToBounds = YES;
    self.btn_clear_0.layer.cornerRadius = 25;
    self.btn_clear_0.layer.masksToBounds = YES;
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.yuanjia.layer.cornerRadius = 20;
    self.yuanjia.layer.masksToBounds = YES;
    self.selectNumber = 0;
    
     self.string=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
    self.stringNumber=[[NSMutableString alloc]init];//初始化可变字符串，分配内存
}

-(void)dw_segmentedControl:(DWSegmentedControl *)control didSeletRow:(NSInteger)row{
    
    NSLog(@"你选择了第%ld个",row);
    self.OriginalpriceLabel.hidden = YES;
    self.disCountLabel.hidden = NO;
    self.selectNumber = row;
    
}

- (IBAction)clearClick:(id)sender {
    
    [self.string setString:@""];//清空字符
    self.OriginalpriceLabel.text = self.string;
    
    [self.stringNumber setString:@""];//清空字符
    self.OriginalpriceLabel.text = self.stringNumber;
    self.OriginalpriceLabel.hidden = YES;
    self.disCountLabel.hidden = NO;
}

- (IBAction)sureClick:(UIButton *)sender {
    NSString *sv_p_unitprice = _dict[@"sv_p_unitprice"];
    if (self.selectNumber == 1) {// 那就是折扣
        NSString *disCount = self.OriginalpriceLabel.text;
        double disDount = disCount.doubleValue;
       
        if (self.OriginalpriceLabel.hidden == YES) {
            // _dict[@"sv_p_unitprice"] = _dict[@"sv_p_unitprice"];
        }else{
            if (self.sv_p_minunitprice > 0) {
                double sv_p_minunitprice = disDount *0.1 * sv_p_unitprice.doubleValue;
                if (self.sv_p_minunitprice > sv_p_minunitprice) {
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f元",self.sv_p_minunitprice]];
                }else{
                    _dict[@"isPriceChange"] = @"1";// 改价的
                    _dict[@"priceChange"] = [NSString stringWithFormat:@"%.2f",sv_p_minunitprice];
                    self.sureBtnClickBlock_dict(sender.tag, _dict);
                }
            }else if (self.sv_p_mindiscount > 0){
              
                if (self.sv_p_mindiscount > disDount) {
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f折",self.sv_p_mindiscount]];
                }else{
                    _dict[@"isPriceChange"] = @"1";// 改价的
                    double sv_p_minunitprice = disDount *0.1 * sv_p_unitprice.doubleValue;
                    _dict[@"priceChange"] = [NSString stringWithFormat:@"%.2f",sv_p_minunitprice];
                    self.sureBtnClickBlock_dict(sender.tag, _dict);
                }
                
            }else{
                _dict[@"isPriceChange"] = @"1";// 改价的
                _dict[@"priceChange"] = [NSString stringWithFormat:@"%.2f",(disDount *0.1 * sv_p_unitprice.doubleValue)];
                self.sureBtnClickBlock_dict(sender.tag, _dict);
            }
        }
    
        
    }else{// 现金
        if (self.OriginalpriceLabel.hidden == YES) {
           //  _dict[@"sv_p_unitprice"] = self.OriginalpriceLabel.text;
        }else{
           //  _dict[@"sv_p_unitprice"] = self.OriginalpriceLabel.text;
            NSString *money = self.OriginalpriceLabel.text;
            if (self.sv_p_minunitprice > 0) {
               // double sv_p_minunitprice = disDount *0.1 * sv_p_unitprice.doubleValue;
                if (self.sv_p_minunitprice > money.doubleValue) {
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f元",self.sv_p_minunitprice]];
                }else{
                    _dict[@"isPriceChange"] = @"1";// 改价的
                    _dict[@"priceChange"] = self.OriginalpriceLabel.text;
                    self.sureBtnClickBlock_dict(sender.tag, _dict);
                }
            }else if (self.sv_p_mindiscount > 0){
                double sv_p_mindiscount = self.sv_p_mindiscount *0.1 * sv_p_unitprice.doubleValue;
                if (sv_p_mindiscount > money.doubleValue) {
                    return [SVTool TextButtonActionWithSing:[NSString stringWithFormat:@"不能低于%.2f元",sv_p_mindiscount]];
                }else{
                    _dict[@"isPriceChange"] = @"1";// 改价的
                   // double sv_p_minunitprice = disDount *0.1 * sv_p_unitprice.doubleValue;
                    _dict[@"priceChange"] = self.OriginalpriceLabel.text;
                    self.sureBtnClickBlock_dict(sender.tag, _dict);
                }
                
            }else{
                _dict[@"isPriceChange"] = @"1";// 改价的
                _dict[@"priceChange"] = self.OriginalpriceLabel.text;
                self.sureBtnClickBlock_dict(sender.tag, _dict);
            }
            
        }
       
    }

}


- (IBAction)keyBoardNumberClick:(UIButton *)sender {
    self.disCountLabel.hidden = YES;
    self.OriginalpriceLabel.hidden = NO;
    if (self.selectNumber == 0) {
        //数字连续输入
        [self.string appendString:[sender currentTitle]];
        self.OriginalpriceLabel.text = [NSString stringWithFormat:@"%@",self.string];
    }else{
        
        if ((self.stringNumber.length == 0 || [self.stringNumber hasSuffix:@"."]) && [[sender currentTitle] isEqualToString:@"."]) {
           
            return;
        }
        
      
        
        //数字连续输入
        [self.stringNumber appendString:[sender currentTitle]];
        
        if (self.stringNumber.integerValue > 10) {
            [self.stringNumber setString:@""];//清空字符
            self.OriginalpriceLabel.text = [NSString stringWithFormat:@"10折"];
            return;
        }
        
        self.OriginalpriceLabel.text = [NSString stringWithFormat:@"%@",self.stringNumber];
    }
    
}

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    [self.string setString:@""];//清空字符
    [self.stringNumber setString:@""];//清空字符
    self.OriginalpriceLabel.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]]; // 改成价格
    self.sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
    self.sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
    self.OriginalpriceLabel.hidden = YES;
    self.disCountLabel.hidden = NO;
    NSString *sv_p_unitprice = _dict[@"sv_p_unitprice"];
    self.disCountLabel.text = [NSString stringWithFormat:@"原价 %.2f",[sv_p_unitprice doubleValue]];
}

@end
