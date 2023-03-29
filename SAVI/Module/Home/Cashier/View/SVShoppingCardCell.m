//
//  SVShoppingCardCell.m
//  SAVI
//
//  Created by houming Wang on 2018/12/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVShoppingCardCell.h"
#import "SVOrderDetailsModel.h"
#import "SVCashierSpecModel.h"
@interface SVShoppingCardCell()
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *moneyL;
@property (weak, nonatomic) IBOutlet UILabel *sumMoneyL;
@property (weak, nonatomic) IBOutlet UILabel *memberL;
@property (weak, nonatomic) IBOutlet UITextField *textFirld;
//@property (nonatomic,assign) NSInteger page;
@property (nonatomic,assign) float sum;
//@property (weak, nonatomic) IBOutlet UILabel *memberPriceL;
// 记录价格
@property (nonatomic,strong) NSString *money;
@property (weak, nonatomic) IBOutlet UILabel *SectextLabel;
//@property (weak, nonatomic) IBOutlet UILabel *memberDiscountL;
@property (weak, nonatomic) IBOutlet UILabel *spectL;
@property (nonatomic,assign) double price;
@end
@implementation SVShoppingCardCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.memberL.adjustsFontSizeToFitWidth = YES;
    self.memberL.minimumScaleFactor = 0.5;
    self.sum = 0.00;
}

- (void)setDic:(NSMutableDictionary *)dic
{
    
    
    _dic = dic;
    float money = 0.0;
    self.nameL.text = dic[@"sv_p_name"];
    NSString *num = [NSString stringWithFormat:@"%@",dic[@"isPriceChange"]];
    if ([num isEqualToString:@"1"]) { // 改价过来的
        [self dicountMothodDict:dic concessionalRate:[dic[@"priceChange"]doubleValue] OfferName:@"改价"];
        
    }else{
    // 设置分类折
    double Discountedvalue = 0.0;
    BOOL isCategoryDisCount = false;
    for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
        // 判断是否跳出循环的条件
        if (isCategoryDisCount == false) {
        double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
        NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
        if (typeflag == 1) { // 是1的话就说明是一级分类
            if ([dic[@"productcategory_id"] isEqualToString:Discountedpar]) {
                isCategoryDisCount = true;//有分类折跳出循环
                Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                break;
            }
        }
        
        if (typeflag == 2) { // 是2的话就说明是二级分类
            NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
            if (!kArrayIsEmpty(comdiscounted)) {
                for (NSDictionary * dictComdiscounted in comdiscounted) {
                NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                if ([dic[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
                    isCategoryDisCount = true;//有分类折跳出循环
                    Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                    break;
                }
                }
            }
            }
            
        }
    }
    
    NSLog(@"Discountedvalue4444 = %f",Discountedvalue);
    // 最低价
    double sv_p_minunitprice = [dic[@"sv_p_minunitprice"] doubleValue];
    // 最低折
    double sv_p_mindiscount = [dic[@"sv_p_mindiscount"] doubleValue];
    // 会员折
    double dicount = [dic[@"discount"] doubleValue];
    
    double grade = 0.0;
    if (!kStringIsEmpty(self.grade)) {
        if ([self.grade isEqualToString:@"1"]) {
            grade=[dic[@"sv_p_memberprice1"] doubleValue];
        }else if ([self.grade isEqualToString:@"2"]){
            grade=[dic[@"sv_p_memberprice2"] doubleValue];
        }else if ([self.grade isEqualToString:@"3"]){
            grade=[dic[@"sv_p_memberprice3"] doubleValue];
        }else if ([self.grade isEqualToString:@"4"]){
            grade=[dic[@"sv_p_memberprice4"] doubleValue];
        }else {
            grade=[dic[@"sv_p_memberprice5"] doubleValue];
        }
    }
    
    if (grade > 0){
        self.memberL.hidden = NO;
      //  self.remarksLabel.hidden = YES;
       // NSString *sv_p_specs = dict[@"sv_p_specs"];
         self.nameL.text = [NSString stringWithFormat:@"%@",dic[@"sv_p_name"]];
                
         self.moneyL.text = [NSString stringWithFormat:@"￥%@",dic[@"sv_p_unitprice"]];
         self.memberL.text = [NSString stringWithFormat:@"会员价%@",self.grade];
         self.price = grade;
                // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
         self.SectextLabel.text = [NSString stringWithFormat:@"x%.0f",[dic[@"product_num"]floatValue] + [dic[@"sv_p_weight"]floatValue]];
        if ([dic[@"sv_is_newspec"] integerValue] == 0) {// 不是多规格
             //  self.memberL.text = @"";
               self.spectL.text = @"";
           }else{
             //  self.memberL.text = dic[@"sv_p_specs"];
                self.spectL.text = [NSString stringWithFormat:@"%@",dic[@"sv_p_specs"]];
           }
        
    }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dic[@"sv_p_memberprice"] doubleValue] > 0){
        /**
         场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
         注：有以上这三种情况下，就没有会员折一说，会员折无效
         */
        if ([SVTool isBlankString:dic[@"member_id"]]) {
            self.memberL.hidden = YES;
            [self unitPriceDict:dic];
           // self.remarksLabel.hidden = YES;
        }else{

            if ([dic[@"sv_p_memberprice"] doubleValue] > 0) {
                [self dicountMothodDict:dic concessionalRate:[dic[@"sv_p_memberprice"] doubleValue] OfferName:@"会员价"];
            }else if (sv_p_mindiscount > 0 && dicount > 0 && dicount < 10){
                if (dicount >= 10 || dicount <= 0) {
                    [self dicountMothodDict:dic concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                }else{
                    if (sv_p_mindiscount > dicount && dicount > 0 && dicount < 10) {
                   
                        [self dicountMothodDict:dic concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                    }else if (dicount > sv_p_mindiscount && dicount > 0 && dicount < 10)
                        [self dicountMothodDict:dic concessionalRate:dicount OfferName:@"会员折"];
                    else{
                        [self unitPriceDict:dic];
                       
                    }
                }
                
            }else if (sv_p_minunitprice > 0 && dicount > 0 && dicount < 10){
              //  场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                if (dicount >= 10 || dicount <= 0) {
                    [self dicountMothodDict:dic concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                }else{
                    double memberPrice = [dic[@"sv_p_unitprice"] doubleValue]*dicount*0.1;
                    if (memberPrice > sv_p_minunitprice && dicount > 0 && dicount < 10) {

                        [self dicountMothodDict:dic concessionalRate:dicount OfferName:@"会员折"];
                    }else if ( sv_p_minunitprice > memberPrice  && dicount > 0 && dicount < 10){
                        // 最低价大于会员折
                        [self dicountMothodDict:dic concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                    }else{
                        [self unitPriceDict:dic];
                       
                    }
                }
                   
            }else{
                
                
                [self unitPriceDict:dic];
            }
            
        }
        
    }else if (Discountedvalue > 0){
//        money = [dic[@"sv_p_unitprice"] doubleValue] * Discountedvalue * 0.1;
//      self.memberL.text = [NSString stringWithFormat:@"分类折%.2f折",Discountedvalue];
        [self dicountMothodDict:dic concessionalRate:Discountedvalue OfferName:@"分类折"];
    }else if (dicount > 0 && dicount < 10){
        [self dicountMothodDict:dic concessionalRate:dicount OfferName:@"会员折"];
    }
    
    else{
        [self unitPriceDict:dic];
    }
    
   
    }
    self.sumMoneyL.text = [NSString stringWithFormat:@"%.2f",self.price * [dic[@"product_num"] integerValue]];
    
    self.page = [dic[@"product_num"] integerValue];
}


- (void)unitPriceDict:(NSDictionary *)dict{
    self.memberL.hidden = YES;
  //  self.remarksLabel.hidden = YES;
   // NSString *sv_p_specs = dict[@"sv_p_specs"];
     self.nameL.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
            
     self.moneyL.text = [NSString stringWithFormat:@"￥%@",dict[@"sv_p_unitprice"]];
                        
     self.price = [dict[@"sv_p_unitprice"] floatValue];
            // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
     self.SectextLabel.text = [NSString stringWithFormat:@"%.0f",[dict[@"product_num"]floatValue] + [dict[@"sv_p_weight"]floatValue]];
    if ([dict[@"sv_is_newspec"] integerValue] == 0) {// 不是多规格
         //  self.memberL.text = @"";
           self.spectL.text = @"";
       }else{
         //  self.memberL.text = dic[@"sv_p_specs"];
            self.spectL.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_specs"]];
       }
}

- (void)dicountMothodDict:(NSDictionary *)dict concessionalRate:(double)concessionalRate OfferName:(NSString*)offerName{
    self.memberL.hidden = NO;
   // self.remarksLabel.hidden = NO;
    self.nameL.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
   self.moneyL.text =  [NSString stringWithFormat:@"￥%.2f",[dict[@"sv_p_unitprice"] doubleValue]];
    if ([offerName isEqualToString:@"最低价"]) {
        self.memberL.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"会员价"]){
        self.memberL.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"改价"]){
        self.memberL.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else{
        self.memberL.text = [NSString stringWithFormat:@"(%@%.2f折)",offerName,concessionalRate];
        self.price = [dict[@"sv_p_unitprice"] doubleValue]*concessionalRate*0.1;
    }
    
    self.SectextLabel.text = [NSString stringWithFormat:@"%.0f",[dict[@"product_num"]floatValue] + [dict[@"sv_p_weight"]floatValue]];
    
    if ([dict[@"sv_is_newspec"] integerValue] == 0) {// 不是多规格
         //  self.memberL.text = @"";
           self.spectL.text = @"";
       }else{
         //  self.memberL.text = dic[@"sv_p_specs"];
            self.spectL.text = [NSString stringWithFormat:@"%@",dict[@"sv_p_specs"]];
       }
  
//    self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"sv_p_unitprice"] doubleValue]];
//
//
//    self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.sv_p_memberprice.attributedText = newPrice;
}


- (IBAction)reduceClick:(id)sender {
    if (self.page > 1) {
        self.page --;

//        self.model.secCount--;
//        self.sum = ([self.dic[@"sv_p_unitprice"] integerValue]) * self.page;
      //  if ([SVTool isBlankString:_dic[@"member_id"]]) {
            self.sum = self.price * self.page;
//        }else{
//            self.sum = [_dic[@"sv_p_memberprice"] floatValue] * self.page;
//        }
//        self.model.product_num = self.page;
//       NSInteger number = self.model.tf_count.integerValue;
//        number --;
//        self.model.tf_count = [NSString stringWithFormat:@"%ld",number];

        //        self.model.secCount--;
        //        self.sum = ([self.dic[@"sv_p_unitprice"] integerValue]) * self.page;
        //  if ([SVTool isBlankString:_dic[@"member_id"]]) {
        self.sum = [self.money doubleValue] * self.page;
        //        }else{
        //            self.sum = [_dic[@"sv_p_memberprice"] doubleValue] * self.page;
        //        }
        //        self.model.product_num = self.page;
        //       NSInteger number = self.model.tf_count.integerValue;
        //        number --;
        //        self.model.tf_count = [NSString stringWithFormat:@"%ld",number];

        
      //  NSLog(@"sum = %ld",self.sum);
        self.sumMoneyL.text = [NSString stringWithFormat:@"%.2f",self.sum];
        [self blockMethods];
        
        // 通知代理(调用代理的某个方法)
        if ([self.delegate respondsToSelector:@selector(wineCellDidClickMinusButton:)]) {
            
            [self.delegate wineCellDidClickMinusButton:self];
        }
    }else if (self.page == 1){
      
        
        if (self.numZeroBlock) {
            self.numZeroBlock();
            

//            self.page --;
//            self.sum = [self.money floatValue] * self.page;
//
//            self.sumMoneyL.text = [NSString stringWithFormat:@"%.2f",self.sum];
//            [self blockMethods];

            //            self.page --;
            //            self.sum = [self.money doubleValue] * self.page;
            //
            //            self.sumMoneyL.text = [NSString stringWithFormat:@"%.2f",self.sum];
            //            [self blockMethods];

        }
        
    }
    
   
    
}
- (IBAction)addClick:(id)sender {
    self.page ++;
//    self.model.count++;
    self.textFirld.transform = CGAffineTransformMakeScale(1, 1);
    
    [UIView animateWithDuration:0.1   animations:^{
        self.SectextLabel.transform = CGAffineTransformMakeScale(1.5, 1.5);
    }completion:^(BOOL finish){
        [UIView animateWithDuration:0.1      animations:^{
            self.SectextLabel.transform = CGAffineTransformMakeScale(0.9, 0.9);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1   animations:^{
                self.SectextLabel.transform = CGAffineTransformMakeScale(1, 1);
            }completion:^(BOOL finish){
            }];
        }];
    }];
     NSLog(@"self.page = %ld",self.page);
    

//    NSInteger number = self.model.tf_count.integerValue;
//    number ++;
 //   self.model.tf_count = [NSString stringWithFormat:@"%ld",number];
//    self.model.product_num = self.page;
  //  self.sum = ([self.dic[@"sv_p_unitprice"] integerValue]) * self.page;
//    if ([SVTool isBlankString:_dic[@"member_id"]]) {
//        self.sum = [_dic[@"sv_p_unitprice"] floatValue] * self.page;
//    }else{
//        self.sum = [_dic[@"sv_p_memberprice"] floatValue] * self.page;
//    }
      self.sum = self.price * self.page;
   // NSLog(@"sum = %ld",self.sum);

    //    NSInteger number = self.model.tf_count.integerValue;
    //    number ++;
    //   self.model.tf_count = [NSString stringWithFormat:@"%ld",number];
    //    self.model.product_num = self.page;
    //  self.sum = ([self.dic[@"sv_p_unitprice"] integerValue]) * self.page;
    //    if ([SVTool isBlankString:_dic[@"member_id"]]) {
    //        self.sum = [_dic[@"sv_p_unitprice"] doubleValue] * self.page;
    //    }else{
    //        self.sum = [_dic[@"sv_p_memberprice"] doubleValue] * self.page;
    //    }
 //   self.sum = [self.money doubleValue] * self.page;
    // NSLog(@"sum = %ld",self.sum);

    self.sumMoneyL.text = [NSString stringWithFormat:@"%.2f",self.sum];
    [self blockMethods];
    
    // 通知代理(调用代理的某个方法)
    if ([self.delegate respondsToSelector:@selector(wineCellDidClickPlusButton:)]) {
        
        [self.delegate wineCellDidClickPlusButton:self];
    }
}

/**
 调用block
 */
-(void)blockMethods{
    
    self.SectextLabel.text = [NSString stringWithFormat:@"%ld",self.page];
    self.number = [NSString stringWithFormat:@"%ld",self.page];
//    _model.tf_count = self.textFirld.text;
//    if (self.severalCopiesCellBlock) {
//        self.severalCopiesCellBlock(_model);
//    }
}

@end
