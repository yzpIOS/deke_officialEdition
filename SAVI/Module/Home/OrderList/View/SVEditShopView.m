//
//  SVEditShopView.m
//  SAVI
//
//  Created by houming Wang on 2021/5/12.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVEditShopView.h"
#import "SVOrderDetailsModel.h"
#import "SVWholeAndSingleView.h"
@interface SVEditShopView()
@property (weak, nonatomic) IBOutlet UIButton *number;
@property (weak, nonatomic) IBOutlet UIButton *money;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *DiscountLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameText;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (nonatomic,assign) double price;
@property (nonatomic,strong) SVWholeAndSingleView * wholeAndSingleView;
@property (nonatomic,strong) UIView * maskTheView;
//@property (nonatomic,strong) SVOrderDetailsModel * orderDetailsModelTwo;
@property (nonatomic,strong) NSMutableDictionary * dictTwo;
@end
@implementation SVEditShopView

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.sureBtn.layer.cornerRadius = 5;
    self.sureBtn.layer.masksToBounds = YES;
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
}

- (void)setDict:(NSMutableDictionary *)dict
{
    _dict = dict;
    self.nameText.text = dict[@"sv_p_name"];
   // self.number.titleLabel.text = model.product_num;
    [self.number setTitle:dict[@"product_num"] forState:UIControlStateNormal];
  //  self.price.titleLabel.text = model.sv_p_unitprice;
    [self.money setTitle:dict[@"sv_p_unitprice"] forState:UIControlStateNormal];
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"] doubleValue] * [dict[@"sv_p_unitprice"]doubleValue]];
   // self.DiscountLabel.text = [NSString stringWithFormat:@"优惠：￥%.2f",]
   // self.DiscountLabel.text = @"优惠:￥10";
    
    
      //  _orderDetailsModel = orderDetailsModel;
    //    NSString *num = [NSString stringWithFormat:@"%@",dict[@"isPriceChange"]];
        // 设置显示图片
        if ([dict[@"sv_p_images"] containsString:@"UploadImg"]) {

        
                NSData *data = [dict[@"sv_p_images"] dataUsingEncoding:NSUTF8StringEncoding];
                NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                if (kArrayIsEmpty(arr)) {
                    NSString *sv_p_images_two = dict[@"sv_p_images"];
                   // sv_p_images = sv_p_images_two;
                    [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
                }else{
                    NSDictionary *dic = arr[0];
                    NSString *sv_p_images_two = dic[@"code"];
                   // sv_p_images = sv_p_images_two;
                    [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
                }
                
         

            //添加点击操作
//            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//            [tap addTarget:self action:@selector(tap:)];
//            [self.icon addGestureRecognizer:tap];
//            self.icon.userInteractionEnabled = YES;
           // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
        }else{
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }
        
           if ([dict[@"isPriceChange"] isEqualToString:@"1"]) { // 改价过来的

               self.nameText.text = dict[@"sv_p_name"];
               NSString *number = [NSString stringWithFormat:@"%.2f",[dict[@"product_num"]doubleValue] + [dict[@"sv_p_weight"]doubleValue]];
               
               [self.number setTitle:number forState:UIControlStateNormal];
               
               [self dicountMothodDict:dict concessionalRate:[dict[@"priceChange"] doubleValue] OfferName:@"改价"];
               
           }else{
               // 设置分类折
                      double Discountedvalue = 0.0;
                      BOOL isCategoryDisCount = false;
                      for (NSDictionary *dictClassifiedBook in self.sv_discount_configArray) {
                          if (isCategoryDisCount == false) {
                          double typeflag = [dictClassifiedBook[@"typeflag"] doubleValue];
                          NSString *Discountedpar = [NSString stringWithFormat:@"%@",dictClassifiedBook[@"Discountedpar"]];// 分类ID
                          if (typeflag == 1) { // 是1的话就说明是一级分类
                              if ([dict[@"productcategory_id"] isEqualToString:Discountedpar]) {
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
                                  if ([dict[@"productsubcategory_id"] isEqualToString:comdiscounted2]) {
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
               NSString *sv_p_specs = dict[@"sv_p_specs"];

               self.nameText.text =dict[@"sv_p_name"];
             //  self.money.text = [NSString stringWithFormat:@"￥%@",orderDetailsModel.product_unitprice];
               [self.money setTitle: [NSString stringWithFormat:@"%@",dict[@"product_unitprice"]] forState:UIControlStateNormal];
               
               self.price = [dict[@"product_unitprice"] doubleValue];
                  // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
              // .text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.product_num.doubleValue + orderDetailsModel.sv_p_weight.doubleValue];
               
               [self.number setTitle:[NSString stringWithFormat:@"%.2f",[dict[@"product_num"] doubleValue] + [dict[@"sv_p_weight"] doubleValue]] forState:UIControlStateNormal];
            
              double grade = 0.0;
               // 最低价
               double sv_p_minunitprice = [dict[@"sv_p_minunitprice"] doubleValue];
               // 最低折
               double sv_p_mindiscount = [dict[@"sv_p_mindiscount"] doubleValue];
               // 会员折
               double dicount = [dict[@"discount"] doubleValue];
               
               if (!kStringIsEmpty(self.grade)) {
                   if ([self.grade isEqualToString:@"1"]) {
                       grade= [dict[@"sv_p_memberprice1"] doubleValue];
                   }else if ([self.grade isEqualToString:@"2"]){
                       grade= [dict[@"sv_p_memberprice2"] doubleValue];
                   }else if ([self.grade isEqualToString:@"3"]){
                       grade=[dict[@"sv_p_memberprice3"] doubleValue];
                   }else if ([self.grade isEqualToString:@"4"]){
                       grade=[dict[@"sv_p_memberprice4"] doubleValue];
                   }else {
                       grade=[dict[@"sv_p_memberprice5"] doubleValue];
                   }
               }
               if (grade > 0){
                  // self.money.text = [NSString stringWithFormat:@"￥%.2f",grade];
                   [self.money setTitle:[NSString stringWithFormat:@"%.2f",grade] forState:UIControlStateNormal];
                   self.price = grade;
//                   //            self.sv_p_memberprice.hidden = YES;
//                   //            self.remarksLabel.hidden = YES;
//                   self.sv_p_memberprice.hidden = NO;
//                   self.remarksLabel.hidden = NO;
//                   self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",grade];
//                   self.remarksLabel.text = [NSString stringWithFormat:@" 会员价%@",self.grade];
               }else if (sv_p_minunitprice > 0 || sv_p_mindiscount > 0 || [dict[@"sv_p_memberprice"] doubleValue] > 0){
                   /**
                    场景一：会员价配置【会员价1-5】 ＞ 会员价/最低折/最低价【三选一】＞ 分类折
                    注：有以上这三种情况下，就没有会员折一说，会员折无效
                    */
                   if ([SVTool isBlankString:dict[@"member_id"]]) {
//                       self.sv_p_memberprice.hidden = YES;
//                       self.remarksLabel.hidden = YES;
                   }else{
                       
                       if ([dict[@"sv_p_memberprice"] doubleValue] > 0) {
                           [self dicountMothodDict:dict concessionalRate:[dict[@"sv_p_memberprice"] doubleValue] OfferName:@"会员价"];
                       }else if (sv_p_mindiscount > 0 && dicount > 0 && dicount < 10){
                           if (dicount >= 10 || dicount <= 0) {
                               [self dicountMothodDict:dict concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                           }else{
                               if (sv_p_mindiscount > dicount && dicount > 0 && dicount < 10) {
                              
                                   [self dicountMothodDict:dict concessionalRate:sv_p_mindiscount OfferName:@"最低折"];
                               }else if (dicount > sv_p_mindiscount && dicount > 0 && dicount < 10){
                                   [self dicountMothodDict:dict concessionalRate:dicount OfferName:@"会员折"];
                               }else{
                                   [self unitPriceDict:dict];
                                  
                               }
                           }
                           
                       }else if (sv_p_minunitprice > 0 && dicount > 0 && dicount < 10){
                         //  场景三：最低价、会员折同时存在，要拿单价来对比， 哪个大取哪个，不能低于最低价  会员折单价=会员折×单品合计金额
                           if (dicount >= 10 || dicount <= 0) {
                               [self dicountMothodDict:dict concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                           }else{
                               double memberPrice = [dict[@"sv_p_unitprice"] doubleValue]*dicount*0.1;
                               if (memberPrice > sv_p_minunitprice && dicount > 0 && dicount < 10) {

                                   [self dicountMothodDict:dict concessionalRate:dicount OfferName:@"会员折"];
                               }else if ( sv_p_minunitprice > memberPrice  && dicount > 0 && dicount < 10){
                                   // 最低价大于会员折
                                   [self dicountMothodDict:dict concessionalRate:sv_p_minunitprice OfferName:@"最低价"];
                               }else{
                                   [self unitPriceDict:dict];
                                  
                               }
                           }
                              
                       }else{
                           
                           
                           [self unitPriceDict:dict];
                       }
                       
                   }
                   
               }else if (Discountedvalue > 0){

                   [self dicountMothodDict:dict concessionalRate:Discountedvalue OfferName:@"分类折"];
               }else if (dicount > 0 && dicount < 10){
                   [self dicountMothodDict:dict concessionalRate:dicount OfferName:@"会员折"];
               }else{

                   [self unitPriceDict:dict];
               }
                  
                   
                
           }
        
    self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f",self.price * ([dict[@"product_num"] floatValue] + [dict[@"sv_p_weight"] floatValue])];
    
}

- (void)unitPriceDict:(NSDictionary *)dict{
//    self.sv_p_memberprice.hidden = YES;
//    self.remarksLabel.hidden = YES;
    NSString *sv_p_specs = dict[@"sv_p_specs"];
    if (kStringIsEmpty(sv_p_specs)) {
        self.nameText.text = sv_p_specs?[NSString stringWithFormat:@"%@ %@",dict[@"sv_p_name"],sv_p_specs]:dict[@"sv_p_name"];
    }else{
        self.nameText.text = sv_p_specs?[NSString stringWithFormat:@"%@ (%@)",dict[@"sv_p_name"],sv_p_specs]:dict[@"sv_p_name"];
    }
     
            
   //  self.money.text = ;
    [self.money setTitle:[NSString stringWithFormat:@"%@",dict[@"sv_p_unitprice"]] forState:UIControlStateNormal];
     self.price = [dict[@"sv_p_unitprice"] floatValue];
            // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
    // self.number.text = [NSString stringWithFormat:@"x%.2f",[orderDetailsModel.product_num floatValue] + [orderDetailsModel.sv_p_weight floatValue]];
    [self.number setTitle:[NSString stringWithFormat:@"%.2f",[dict[@"product_num"] floatValue] + [dict[@"sv_p_weight"] floatValue]] forState:UIControlStateNormal];
}

- (void)dicountMothodDict:(NSDictionary *)dict concessionalRate:(double)concessionalRate OfferName:(NSString*)offerName{
//    self.sv_p_memberprice.hidden = NO;
//    self.remarksLabel.hidden = NO;
  // self.money.text =  [NSString stringWithFormat:@"￥%.2f",[orderDetailsModel.sv_p_unitprice doubleValue]];
    [self.money setTitle:[NSString stringWithFormat:@"%.2f",[dict[@"sv_p_unitprice"] doubleValue]] forState:UIControlStateNormal];
    if ([offerName isEqualToString:@"最低价"]) {
       // self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"会员价"]){
       // self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"改价"]){
        //self.remarksLabel.text = [NSString stringWithFormat:@"(%@:￥%.2f)",offerName,concessionalRate];
        self.price = concessionalRate;
    }else{
        //self.remarksLabel.text = [NSString stringWithFormat:@"(%@%.2f折)",offerName,concessionalRate];
        self.price = [dict[@"sv_p_unitprice"] doubleValue]*concessionalRate*0.1;
    }
  
  //  self.sv_p_memberprice.text = [NSString stringWithFormat:@"￥%.2f",[orderDetailsModel.sv_p_unitprice doubleValue]];
    double discount = [dict[@"sv_p_unitprice"] doubleValue] - self.price * ([dict[@"product_num"] doubleValue] + [dict[@"sv_p_weight"] doubleValue]);
     self.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
    
    
//    self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.sv_p_memberprice.attributedText = newPrice;
}
#pragma mark - 点击改价
- (IBAction)priceChangeClick:(id)sender {
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.wholeAndSingleView];
    self.wholeAndSingleView.dict = self.dict;
        __weak typeof(self) weakSelf = self;
//        self.wholeAndSingleView.determineBlock = ^(SVOrderDetailsModel * _Nonnull orderDetailsModelTwo) {
//
//        };
    self.wholeAndSingleView.determineBlock = ^(NSMutableDictionary * _Nonnull dict) {
        weakSelf.dictTwo = dict;
       // weakSelf.orderDetailsModel.product_num = weakSelf.number.titleLabel.text;
        [weakSelf.money setTitle:dict[@"priceChange"] forState:UIControlStateNormal];
        weakSelf.price = [dict[@"priceChange"] doubleValue];
        double number = weakSelf.number.titleLabel.text.doubleValue;
        weakSelf.totleMoney.text = [NSString stringWithFormat:@"%.2f",number * weakSelf.price];
        double discount = [weakSelf.dict[@"sv_p_unitprice"] doubleValue] *number - weakSelf.price * number;
       //  self.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
        if (discount > 0) {
            weakSelf.DiscountLabel.hidden = NO;
            weakSelf.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
        }else{
            weakSelf.DiscountLabel.hidden = YES;
        }
        
        [weakSelf dateCancelResponseEvent];
    };
    
}


- (IBAction)reduceClick:(id)sender {
    double number = self.number.titleLabel.text.doubleValue;
    if (number <= 0) {
        [self.number setTitle:[NSString stringWithFormat:@"%.2f",number] forState:UIControlStateNormal];
    }else{
        number --;
        [self.number setTitle:[NSString stringWithFormat:@"%.2f",number] forState:UIControlStateNormal];
    }
    
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",number * self.price];
    double discount = [self.dict[@"sv_p_unitprice"] doubleValue] *number - self.price * number;
    if (discount > 0) {
        self.DiscountLabel.hidden = NO;
        self.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
    }else{
        self.DiscountLabel.hidden = YES;
    }
     
    
}

- (IBAction)addClick:(id)sender {
   double number = self.number.titleLabel.text.doubleValue;
    number ++;
    [self.number setTitle:[NSString stringWithFormat:@"%.2f",number] forState:UIControlStateNormal];
   // self.totleLabel.text = [NSString stringWithFormat:@"%.2f",number * self.model.sv_p_unitprice.doubleValue];
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",number * self.price];
    double discount = [self.dict[@"sv_p_unitprice"] doubleValue] *number - self.price * number;
   //  self.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
    if (discount > 0) {
        self.DiscountLabel.hidden = NO;
        self.DiscountLabel.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
    }else{
        self.DiscountLabel.hidden = YES;
    }
}

#pragma mark - 点击确定按钮
- (IBAction)sureClick:(id)sender {
    self.dict[@"product_num"] = [NSString stringWithFormat:@"%.2f",self.number.titleLabel.text.doubleValue];
    if ([self.dict[@"sv_p_unitprice"] doubleValue] != self.money.titleLabel.text.doubleValue) {
        self.dict[@"isPriceChange"] = @"1";
        self.dict[@"priceChange"] = [NSString stringWithFormat:@"%.2f",self.price];
        // 这个数据是为了显示商品列表里的平摊
        self.dict[@"price_danpin"] = [NSString stringWithFormat:@"%.2f",self.price];
    }
   
    if (self.editShopBlock) {
        self.editShopBlock();
    }
}

- (SVWholeAndSingleView *)wholeAndSingleView{
    if (!_wholeAndSingleView) {
        _wholeAndSingleView = [[NSBundle mainBundle]loadNibNamed:@"SVWholeAndSingleView" owner:nil options:nil].lastObject;
        _wholeAndSingleView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
        _wholeAndSingleView.titleLabel.text = @"单品优惠";
        _wholeAndSingleView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _wholeAndSingleView.layer.cornerRadius = 10;
        _wholeAndSingleView.layer.masksToBounds = YES;
        [_wholeAndSingleView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _wholeAndSingleView;
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

- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.wholeAndSingleView removeFromSuperview];
}

@end
