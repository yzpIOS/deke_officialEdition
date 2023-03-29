//
//  SVSettlementCommodityCell.m
//  SAVI
//
//  Created by F on 2020/10/23.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVSettlementCommodityCell.h"
@interface SVSettlementCommodityCell()
//@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *waresName;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *sv_p_memberprice;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;

@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *sumMoney;

@property (nonatomic,assign) double price;

@property (weak, nonatomic) IBOutlet UILabel *bottomLabel;

@end
@implementation SVSettlementCommodityCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.waresName.adjustsFontSizeToFitWidth = YES;
    self.waresName.minimumScaleFactor = 0.5;
   // self.RemarksLabel
    self.remarksLabel.adjustsFontSizeToFitWidth = YES;
    self.remarksLabel.minimumScaleFactor = 0.5;
    
    self.money.adjustsFontSizeToFitWidth = YES;
    self.money.minimumScaleFactor = 0.5;
    
    self.sv_p_memberprice.adjustsFontSizeToFitWidth = YES;
    self.sv_p_memberprice.minimumScaleFactor = 0.5;
    
    self.sumMoney.adjustsFontSizeToFitWidth = YES;
    self.sumMoney.minimumScaleFactor = 0.5;
    
}

- (IBAction)clearClick:(id)sender {
    if (self.clearModelBlock) {
        self.clearModelBlock(self.dict, self.indexPath);
    }
}
#pragma mark - 结算页面的cell
-(void)setOrderDetailsModel:(SVOrderDetailsModel *)orderDetailsModel{
    _orderDetailsModel = orderDetailsModel;
//    NSString *num = [NSString stringWithFormat:@"%@",dict[@"isPriceChange"]];
       if ([orderDetailsModel.isPriceChange isEqualToString:@"1"]) { // 改价过来的

           self.waresName.text = orderDetailsModel.sv_p_name;
           self.number.text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.product_num.doubleValue + orderDetailsModel.sv_p_weight.doubleValue];
           
            if (kStringIsEmpty(orderDetailsModel.sv_p_specs)) { // 非多规格商品
                          self.bottomLabel.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_barcode];
                      }else{
                          self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@",orderDetailsModel.sv_p_artno?:orderDetailsModel.sv_p_barcode,orderDetailsModel.sv_p_specs];
      
                      }
          
           [self dicountMothodDict:orderDetailsModel concessionalRate:orderDetailsModel.priceChange.doubleValue OfferName:@"改价"];
           
       }else{
           // 设置分类折
                  double Discountedvalue = 0.0;
                  BOOL isCategoryDisCount = false;
                  for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
                      if (isCategoryDisCount == false) {
                      double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
                      NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
                      if (typeflag == 1) { // 是1的话就说明是一级分类
                          if ([orderDetailsModel.productcategory_id isEqualToString:Discountedpar]) {
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
                              if ([orderDetailsModel.productsubcategory_id isEqualToString:comdiscounted2]) {
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
           
           // self.waresName.text = orderDetailsModel.sv_p_name;
           NSString *sv_p_specs = orderDetailsModel.sv_p_specs;

           self.waresName.text = orderDetailsModel.sv_p_name;
               self.money.text = [NSString stringWithFormat:@"￥%@",orderDetailsModel.product_unitprice];

          self.price = [orderDetailsModel.product_unitprice doubleValue];
              // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
          self.number.text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.product_num.doubleValue + orderDetailsModel.sv_p_weight.doubleValue];
           
            if (kStringIsEmpty(orderDetailsModel.sv_p_specs)) { // 非多规格商品
                          self.bottomLabel.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_barcode];
                      }else{
                          self.bottomLabel.text = [NSString stringWithFormat:@"%@ %@",orderDetailsModel.sv_p_artno?:orderDetailsModel.sv_p_barcode,orderDetailsModel.sv_p_specs];
      
                      }
        
          double grade = 0.0;
           // 最低价
           double sv_p_minunitprice = orderDetailsModel.sv_p_minunitprice.doubleValue;
           // 最低折
           double sv_p_mindiscount = orderDetailsModel.sv_p_mindiscount.doubleValue;
           // 会员折
           double dicount = orderDetailsModel.discount.doubleValue;
           
           if (!kStringIsEmpty(self.grade)) {
               if ([self.grade isEqualToString:@"1"]) {
                   grade= [orderDetailsModel.sv_p_memberprice1 doubleValue];
               }else if ([self.grade isEqualToString:@"2"]){
                   grade=[orderDetailsModel.sv_p_memberprice2 doubleValue];
               }else if ([self.grade isEqualToString:@"3"]){
                   grade=[orderDetailsModel.sv_p_memberprice3 doubleValue];
               }else if ([self.grade isEqualToString:@"4"]){
                   grade=[orderDetailsModel.sv_p_memberprice4 doubleValue];
               }else {
                   grade=[orderDetailsModel.sv_p_memberprice5 doubleValue];
               }
           }
           if (grade > 0){
               self.money.text = [NSString stringWithFormat:@"￥%.2f",grade];
               
               self.price = grade;
               //            self.sv_p_memberprice.hidden = YES;
               //            self.remarksLabel.hidden = YES;
               self.sv_p_memberprice.hidden = NO;
               self.remarksLabel.hidden = NO;
               self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",grade];
               self.remarksLabel.text = [NSString stringWithFormat:@" 会员价%@",self.grade];
           }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || orderDetailsModel.sv_p_memberprice.doubleValue > 0){
               /**
                场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
                注：有以上这三种情况下，就没有会员折一说，会员折无效
                */
               if ([SVTool isBlankString:orderDetailsModel.member_id]) {
                   self.sv_p_memberprice.hidden = YES;
                   self.remarksLabel.hidden = YES;
               }else{

                   if ([orderDetailsModel.sv_p_memberprice doubleValue] > 0) {
                       [self dicountMothodDict:orderDetailsModel concessionalRate:[orderDetailsModel.sv_p_memberprice doubleValue] OfferName:@"会员价"];
                   }else if (sv_p_mindiscount > 0 && dicount > 0 && dicount < 10){
                       if (dicount >= 10 || dicount <= 0) {
                           [self dicountMothodDict:orderDetailsModel concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                       }else{
                           if (sv_p_mindiscount > dicount && dicount > 0 && dicount < 10) {
                          
                               [self dicountMothodDict:orderDetailsModel concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                           }else if (dicount > sv_p_mindiscount && dicount > 0 && dicount < 10){
                               // [self dicountMothodDict:dict concessionalRate:dicount OfferName:@"会员折"];
                               [self dicountMothodDict:orderDetailsModel concessionalRate:dicount OfferName:@"会员折"];
                            }else{
                                
                                [self unitPriceDict:orderDetailsModel];
                           }
                       }
                       
                   }else if (sv_p_minunitprice > 0 && dicount > 0 && dicount < 10){
                     //  场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                       if (dicount >= 10 || dicount <= 0) {
                           [self dicountMothodDict:orderDetailsModel concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                       }else{
                           double memberPrice = orderDetailsModel.sv_p_unitprice.doubleValue*dicount*0.1;
                           if (memberPrice > sv_p_minunitprice && dicount > 0 && dicount < 10) {

                               [self dicountMothodDict:orderDetailsModel concessionalRate:dicount OfferName:@"会员折"];
                           } else if( sv_p_minunitprice > memberPrice && dicount > 0 && dicount < 10) {
                               
                               [self dicountMothodDict:orderDetailsModel concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                           }else{

                               [self unitPriceDict:orderDetailsModel];
                           }
                       }
                          
                   }else{
                       
                       
                       [self unitPriceDict:orderDetailsModel];
                   }
                   
               }
               
           }
           else if (Discountedvalue > 0){
               [self dicountMothodDict:orderDetailsModel concessionalRate:Discountedvalue OfferName:@"分类折"];
           }else if (dicount > 0 && dicount < 10){
               [self dicountMothodDict:orderDetailsModel concessionalRate:dicount OfferName:@"会员折"];
           }
           
           else{
               [self unitPriceDict:orderDetailsModel];
           }
              
               
            
       }
    
    self.sumMoney.text = [NSString stringWithFormat:@"%.2f",self.price * ([orderDetailsModel.product_num floatValue] + [orderDetailsModel.sv_p_weight doubleValue])];

}
    
    
    - (void)unitPriceDict:(SVOrderDetailsModel *)orderDetailsModel{
        self.sv_p_memberprice.hidden = YES;
        self.remarksLabel.hidden = YES;
        NSString *sv_p_specs = orderDetailsModel.sv_p_specs;
        if (kStringIsEmpty(sv_p_specs)) {
            self.waresName.text = sv_p_specs?[NSString stringWithFormat:@"%@ %@",orderDetailsModel.sv_p_name,sv_p_specs]:orderDetailsModel.sv_p_name;
        }else{
            self.waresName.text = sv_p_specs?[NSString stringWithFormat:@"%@ (%@)",orderDetailsModel.sv_p_name,sv_p_specs]:orderDetailsModel.sv_p_name;
        }
         
                
         self.money.text = [NSString stringWithFormat:@"￥%@",orderDetailsModel.sv_p_unitprice];
                            
         self.price = [orderDetailsModel.sv_p_unitprice floatValue];
                // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
         self.number.text = [NSString stringWithFormat:@"x%.2f",[orderDetailsModel.product_num floatValue] + [orderDetailsModel.sv_p_weight floatValue]];
    }

    - (void)dicountMothodDict:(SVOrderDetailsModel *)orderDetailsModel concessionalRate:(double)concessionalRate OfferName:(NSString*)offerName{
        self.sv_p_memberprice.hidden = NO;
        self.remarksLabel.hidden = NO;
       self.money.text =  [NSString stringWithFormat:@"￥%.2f",[orderDetailsModel.sv_p_unitprice doubleValue]];
        if ([offerName isEqualToString:@"最低价"]) {
            self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
            self.price = concessionalRate;
        }else if ([offerName isEqualToString:@"会员价"]){
            self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
            self.price = concessionalRate;
        }else if ([offerName isEqualToString:@"改价"]){
            self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
            self.price = concessionalRate;
        }else{
            self.remarksLabel.text = [NSString stringWithFormat:@"(%@%.2f折)",offerName,concessionalRate];
            self.price = [orderDetailsModel.sv_p_unitprice doubleValue]*concessionalRate*0.1;
        }
      
        self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",[orderDetailsModel.sv_p_unitprice doubleValue]];
       
        
        self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
        NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
        [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
        self.sv_p_memberprice.attributedText = newPrice;
    }

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    NSString *num = [NSString stringWithFormat:@"%@",dict[@"isPriceChange"]];
    if ([num isEqualToString:@"1"]) { // 改价过来的
           //  self.waresName.text = dict[@"sv_p_name"];
               NSString *sv_p_specs = dict[@"sv_p_specs"];
               self.waresName.text = sv_p_specs?[NSString stringWithFormat:@"%@ (%@)",dict[@"sv_p_name"],sv_p_specs]:dict[@"sv_p_name"];
        
               self.money.text = [NSString stringWithFormat:@"￥%@",dict[@"sv_p_unitprice"]];
               
               self.price = [dict[@"sv_p_unitprice"] floatValue];
               // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
               self.number.text = [NSString stringWithFormat:@"x%.2f",[dict[@"product_num"]floatValue] + [dict[@"sv_p_weight"]floatValue]];
               //    }else{
               //        self.number.text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.sv_p_weight.floatValue];
               //    }
               
               
               //会员售价
             //  if ([SVTool isBlankString:dict[@"member_id"]]) {
                   self.sv_p_memberprice.hidden = YES;
                   self.remarksLabel.hidden = YES;
   
               self.sumMoney.text = [NSString stringWithFormat:@"%.2f",self.price * ([dict[@"product_num"] floatValue] + [dict[@"sv_p_weight"] floatValue])];
    }else{
        
         // 设置分类折
        double Discountedvalue = 0.0;
        for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
            double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
            NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
            if (typeflag == 1) { // 是1的话就说明是一级分类
                if ([dict[@"productcategory_id"] isEqualToString:Discountedpar]) {
                    Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                    break;
                }
            }
            
            if (typeflag == 2) { // 是2的话就说明是二级分类
                NSArray *comdiscounted = dictClassifiedBook[@"comdiscounted"];
                if (!kArrayIsEmpty(comdiscounted)) {
                    NSDictionary * dictComdiscounted = comdiscounted[0];
                    NSString *comdiscounted2 = [NSString stringWithFormat:@"%@",dictComdiscounted[@"comdiscounted"]];
                    if ([dict[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
                        Discountedvalue = [dictClassifiedBook[@"Discountedvalue"] doubleValue];
                        break;
                    }
                }
                
            }
        }
        
        NSLog(@"Discountedvalue4444 = %f",Discountedvalue);
       NSString *sv_p_specs = dict[@"sv_p_specs"];
        self.waresName.text = sv_p_specs?[NSString stringWithFormat:@"%@ (%@)",dict[@"sv_p_name"],sv_p_specs]:dict[@"sv_p_name"];
               
        self.money.text = [NSString stringWithFormat:@"￥%@",dict[@"sv_p_unitprice"]];
                           
        self.price = [dict[@"sv_p_unitprice"] floatValue];
               // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
        self.number.text = [NSString stringWithFormat:@"x%.2f",[dict[@"product_num"]floatValue] + [dict[@"sv_p_weight"]floatValue]];
          
        double grade = 0.0;
        if (!kStringIsEmpty(self.grade)) {
            if ([self.grade isEqualToString:@"1"]) {
                grade=[dict[@"sv_p_memberprice1"] doubleValue];
            }else if ([self.grade isEqualToString:@"2"]){
                grade=[dict[@"sv_p_memberprice2"] doubleValue];
            }else if ([self.grade isEqualToString:@"3"]){
                grade=[dict[@"sv_p_memberprice3"] doubleValue];
            }else if ([self.grade isEqualToString:@"4"]){
                grade=[dict[@"sv_p_memberprice4"] doubleValue];
            }else {
                grade=[dict[@"sv_p_memberprice5"] doubleValue];
            }
        }
        if (grade > 0){
            self.money.text = [NSString stringWithFormat:@"￥%.2f",grade];
                          
            self.price = grade;
//            self.sv_p_memberprice.hidden = YES;
//            self.remarksLabel.hidden = YES;
            self.sv_p_memberprice.hidden = NO;
            self.remarksLabel.hidden = NO;
            self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",grade];
            self.remarksLabel.text = [NSString stringWithFormat:@" 会员价%@",self.grade];
        }else if (Discountedvalue > 0){
           self.money.text =  [NSString stringWithFormat:@"￥%.2f",[dict[@"sv_p_unitprice"] doubleValue]*Discountedvalue*0.1];
           self.remarksLabel.text = [NSString stringWithFormat:@"(分类折%.2f折)",Discountedvalue];
            self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",[dict[@"sv_p_unitprice"] doubleValue]];
           self.price = [dict[@"sv_p_unitprice"] doubleValue]*Discountedvalue*0.1;
            
            self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
            NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
            [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
            self.sv_p_memberprice.attributedText = newPrice;
        }else{
             //会员售价
            if ([SVTool isBlankString:dict[@"member_id"]]) {
                self.sv_p_memberprice.hidden = YES;
                self.remarksLabel.hidden = YES;
            } else {
                if ([dict[@"sv_p_memberprice"] intValue] > 0) {
                    self.sv_p_memberprice.hidden = NO;
                    self.remarksLabel.hidden = NO;
                    
                    self.sv_p_memberprice.text = self.money.text;
                    self.remarksLabel.text = @"（会员价）";
                    
                    self.money.text = [NSString stringWithFormat:@"￥%@",dict[@"sv_p_memberprice"]];
                    self.price = [dict[@"sv_p_memberprice"] floatValue];
                    
                    self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
                    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
                    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
                    self.sv_p_memberprice.attributedText = newPrice;
                } else {
                    //会员折
                    if ([dict[@"discount"] floatValue] == 0 || [dict[@"discount"] floatValue] == 10) {
                        self.sv_p_memberprice.hidden = YES;
                        self.remarksLabel.hidden = YES;
                    } else {
                        self.sv_p_memberprice.hidden = NO;
                        self.remarksLabel.hidden = NO;
                        
                        self.sv_p_memberprice.text = self.money.text;
                        self.remarksLabel.text = [NSString stringWithFormat:@"（%.1f折）",[dict[@"discount"] floatValue]];
                        
                        self.money.text = [NSString stringWithFormat:@"￥%.2f",self.price * [dict[@"discount"] floatValue] * 0.1];
                        self.price = self.price * [dict[@"discount"] floatValue] * 0.1;
                        
                        self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
                        NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
                        [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
                        self.sv_p_memberprice.attributedText = newPrice;
                    }
                }
            }
                          
        }
              
               self.sumMoney.text = [NSString stringWithFormat:@"￥%.2f",self.price * ([dict[@"product_num"] floatValue] + [dict[@"sv_p_weight"] floatValue])];
    }
    
    
}

@end
