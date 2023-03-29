//
//  SVNewSettlementCell.m
//  SAVI
//
//  Created by houming Wang on 2021/5/10.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSettlementCell.h"
#import "JJPhotoManeger.h"
@interface SVNewSettlementCell()<JJPhotoDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_artno;
@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *money;
@property (weak, nonatomic) IBOutlet UILabel *totleMoney;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_memberprice;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *picUrlArr;
@property (nonatomic,assign) double price;
@property (weak, nonatomic) IBOutlet UILabel *remarksLabel;
@property (weak, nonatomic) IBOutlet UILabel *sv_p_specsLabel;


@end
@implementation SVNewSettlementCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;
}



- (void)setModel:(SVOrderDetailsModel *)model
{
    _model = model;
   // self.icon.image
    self.nameText.text = model.sv_p_name;
    self.sv_p_artno.text = model.sv_p_barcode;
    if (kStringIsEmpty(model.sv_p_unit)) {
        self.number.text = [NSString stringWithFormat:@"x%@",model.product_num];
    }else{
        self.number.text = [NSString stringWithFormat:@"x%@%@",model.product_num,model.sv_p_unit];
    }

    self.money.text = [NSString stringWithFormat:@"%.2f",model.sv_p_unitprice.doubleValue];
    self.totleMoney.text = [NSString stringWithFormat:@"%.2f",model.sv_p_unitprice.doubleValue];
   // self.dicount.text = [NSString stringWithFormat:@"%.2f",model.sv_p_unitprice.doubleValue];
    self.icon.layer.cornerRadius = 5;
    self.icon.layer.masksToBounds = YES;

    if ([model.sv_p_images containsString:@"UploadImg"]) {

        NSData *data = [model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        NSDictionary *dic = arr[0];
        NSString *sv_p_images_two = dic[@"code"];
       // sv_p_images = sv_p_images_two;
        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];

        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [self.icon addGestureRecognizer:tap];
        self.icon.userInteractionEnabled = YES;
       // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
    }else{
        self.icon.image = [UIImage imageNamed:@"foodimg"];
    }

}

- (void)setProductResultslList:(SVProductResultslList *)productResultslList
{
    _productResultslList = productResultslList;
    if (productResultslList.orderPromotions.count > 0) {
        self.sv_p_memberprice.hidden = NO;
        self.remarksLabel.hidden = NO;
        
        self.sv_p_memberprice.text = [NSString stringWithFormat:@"优惠￥%.2f",productResultslList.discountAmount];
        self.remarksLabel.text = productResultslList.preferential;
        
    }else{
        

            self.sv_p_memberprice.hidden = YES;
            self.remarksLabel.hidden = YES;
       
       
    }
    
    if (kStringIsEmpty(productResultslList.sepcs)) { // 非多规格商品
    self.sv_p_artno.text = [NSString stringWithFormat:@"%@",productResultslList.barCode];
        self.sv_p_specsLabel.hidden = YES;
    }else{
    self.sv_p_artno.text = [NSString stringWithFormat:@"%@",productResultslList.barCode];
        self.sv_p_specsLabel.hidden = NO;
        self.sv_p_specsLabel.text = productResultslList.sepcs;
    }
    self.nameText.text = productResultslList.productName;
    self.sv_p_artno.text = productResultslList.barCode;
    self.number.text = [NSString stringWithFormat:@"x%.2f",productResultslList.number];
    self.money.text = [NSString stringWithFormat:@"￥%.2f",productResultslList.price];
    self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f",productResultslList.dealMoney];
    
    if ([productResultslList.sv_p_images containsString:@"UploadImg"]) {

        NSData *data = [productResultslList.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        if (kArrayIsEmpty(arr)) {
//            NSDictionary *dic = arr[0];
//            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            NSString *sv_p_images_two = productResultslList.sv_p_images;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            [self.imageArr removeAllObjects];
            [self.imageArr addObject:self.icon];
           // self.iconView.userInteractionEnabled = YES;
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.icon addGestureRecognizer:tap];
            self.icon.userInteractionEnabled = YES;
        }else{
            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            [self.imageArr removeAllObjects];
            [self.imageArr addObject:self.icon];
           // self.iconView.userInteractionEnabled = YES;
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.icon addGestureRecognizer:tap];
            self.icon.userInteractionEnabled = YES;
        }
        
        
        
       // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
    }else{
        if ([productResultslList.sv_p_images2 containsString:@"UploadImg"]) {
//            NSData *data = [orderDetailsModel.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
//            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = productResultslList.sv_p_images2;
           // sv_p_images = sv_p_images_two;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            
           
        }else{
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }

    }
    
    
//    NSData *data = [productResultslList.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
//    NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//    if (kArrayIsEmpty(arr)) {
////            NSDictionary *dic = arr[0];
////            NSString *sv_p_images_two = dic[@"code"];
//       // sv_p_images = sv_p_images_two;
//        NSString *sv_p_images_two = productResultslList.sv_p_images;
//        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//        [self.imageArr removeAllObjects];
//        [self.imageArr addObject:self.icon];
//       // self.iconView.userInteractionEnabled = YES;
//        //添加点击操作
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tap:)];
//        [self.icon addGestureRecognizer:tap];
//        self.icon.userInteractionEnabled = YES;
//    }else{
//        NSDictionary *dic = arr[0];
//        NSString *sv_p_images_two = dic[@"code"];
//       // sv_p_images = sv_p_images_two;
//        [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//        [self.imageArr removeAllObjects];
//        [self.imageArr addObject:self.icon];
//       // self.iconView.userInteractionEnabled = YES;
//        //添加点击操作
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//        [tap addTarget:self action:@selector(tap:)];
//        [self.icon addGestureRecognizer:tap];
//        self.icon.userInteractionEnabled = YES;
//    }
    
    
//    NSString *sv_p_images_two = productResultslList.sv_p_images;
//    [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
//    [self.imageArr removeAllObjects];
//    [self.imageArr addObject:self.icon];
//   // self.iconView.userInteractionEnabled = YES;
//    //添加点击操作
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//    [tap addTarget:self action:@selector(tap:)];
//    [self.icon addGestureRecognizer:tap];
//    self.icon.userInteractionEnabled = YES;
   // self.sv_p_memberprice.text = productResultslList.productName;
}


#pragma mark - 结算页面的cell
-(void)setOrderDetailsModel:(SVOrderDetailsModel *)orderDetailsModel{
    _orderDetailsModel = orderDetailsModel;
    // 设置显示图片
    if ([orderDetailsModel.sv_p_images containsString:@"UploadImg"]) {

        NSData *data = [orderDetailsModel.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
        if (kArrayIsEmpty(arr)) {
//            NSDictionary *dic = arr[0];
//            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            NSString *sv_p_images_two = orderDetailsModel.sv_p_images;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            [self.imageArr removeAllObjects];
            [self.imageArr addObject:self.icon];
           // self.iconView.userInteractionEnabled = YES;
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.icon addGestureRecognizer:tap];
            self.icon.userInteractionEnabled = YES;
        }else{
            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = dic[@"code"];
           // sv_p_images = sv_p_images_two;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            [self.imageArr removeAllObjects];
            [self.imageArr addObject:self.icon];
           // self.iconView.userInteractionEnabled = YES;
            //添加点击操作
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
            [tap addTarget:self action:@selector(tap:)];
            [self.icon addGestureRecognizer:tap];
            self.icon.userInteractionEnabled = YES;
        }
        
        
        
       // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
    }else{
        if ([orderDetailsModel.sv_p_images2 containsString:@"UploadImg"]) {
//            NSData *data = [orderDetailsModel.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
//            NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//            NSDictionary *dic = arr[0];
            NSString *sv_p_images_two = orderDetailsModel.sv_p_images2;
           // sv_p_images = sv_p_images_two;
            [self.icon sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:sv_p_images_two]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
            
           
        }else{
            self.icon.image = [UIImage imageNamed:@"foodimg"];
        }

    }
    
       if ([orderDetailsModel.isPriceChange isEqualToString:@"1"]) { // 改价过来的

           self.nameText.text = orderDetailsModel.sv_p_name;
           self.number.text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.product_num.doubleValue + orderDetailsModel.sv_p_weight.doubleValue];
           
            if (kStringIsEmpty(orderDetailsModel.sv_p_specs)) { // 非多规格商品
            self.sv_p_artno.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_barcode];
                self.sv_p_specsLabel.hidden = YES;
            }else{
            self.sv_p_artno.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_artno?:orderDetailsModel.sv_p_barcode];
                self.sv_p_specsLabel.hidden = NO;
                self.sv_p_specsLabel.text = orderDetailsModel.sv_p_specs;
            }
           
           [self dicountMothodDict:orderDetailsModel concessionalRate:orderDetailsModel.price.doubleValue OfferName:@"改价"];
           
           self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f",self.price];
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

           self.nameText.text = orderDetailsModel.sv_p_name;
           self.money.text = [NSString stringWithFormat:@"￥%@",orderDetailsModel.product_unitprice];

           self.price = [orderDetailsModel.product_unitprice doubleValue];
              // if (orderDetailsModel.sv_pricing_method.integerValue == 0) {
           self.number.text = [NSString stringWithFormat:@"x%.2f",orderDetailsModel.product_num.doubleValue + orderDetailsModel.sv_p_weight.doubleValue];
           
//            if (kStringIsEmpty(orderDetailsModel.sv_p_specs)) { // 非多规格商品
//                          self.sv_p_artno.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_barcode];
//                      }else{
//                          self.sv_p_artno.text = [NSString stringWithFormat:@"%@ %@",orderDetailsModel.sv_p_artno?:orderDetailsModel.sv_p_barcode,orderDetailsModel.sv_p_specs];
//      
//                      }
           
           if (kStringIsEmpty(orderDetailsModel.sv_p_specs)) { // 非多规格商品
           self.sv_p_artno.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_barcode];
               self.sv_p_specsLabel.hidden = YES;
           }else{
           self.sv_p_artno.text = [NSString stringWithFormat:@"%@",orderDetailsModel.sv_p_artno?:orderDetailsModel.sv_p_barcode];
               self.sv_p_specsLabel.hidden = NO;
               self.sv_p_specsLabel.text = orderDetailsModel.sv_p_specs;
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
              
           self.totleMoney.text = [NSString stringWithFormat:@"￥%.2f",self.price * ([orderDetailsModel.product_num floatValue] + [orderDetailsModel.sv_p_weight doubleValue])];
            
       }
  

    

}

- (void)unitPriceDict:(SVOrderDetailsModel *)orderDetailsModel{
    self.sv_p_memberprice.hidden = YES;
    self.remarksLabel.hidden = YES;
    NSString *sv_p_specs = orderDetailsModel.sv_p_specs;
    if (kStringIsEmpty(sv_p_specs)) {
        self.nameText.text = sv_p_specs?[NSString stringWithFormat:@"%@ %@",orderDetailsModel.sv_p_name,sv_p_specs]:orderDetailsModel.sv_p_name;
    }else{
        self.nameText.text = sv_p_specs?[NSString stringWithFormat:@"%@ (%@)",orderDetailsModel.sv_p_name,sv_p_specs]:orderDetailsModel.sv_p_name;
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
        self.remarksLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"会员价"]){
        self.remarksLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",offerName,concessionalRate];
        self.price = concessionalRate;
    }else if ([offerName isEqualToString:@"改价"]){
        self.remarksLabel.text = [NSString stringWithFormat:@"%@:￥%.2f",offerName,orderDetailsModel.priceChange.doubleValue];
        self.price = concessionalRate;
    }else{
        self.remarksLabel.text = [NSString stringWithFormat:@"%@%.2f折",offerName,concessionalRate];
        self.price = [orderDetailsModel.sv_p_unitprice doubleValue]*concessionalRate*0.1;
    }
    
    if ([offerName isEqualToString:@"改价"]) {
        if ([orderDetailsModel.sv_p_unitprice doubleValue] *([orderDetailsModel.product_num doubleValue] + [orderDetailsModel.sv_p_weight doubleValue]) - self.price == 0) {
            self.sv_p_memberprice.hidden = YES;
            self.remarksLabel.hidden = YES;
        }else{
      
            double discount = ([orderDetailsModel.sv_p_unitprice doubleValue]* ([orderDetailsModel.product_num doubleValue] + [orderDetailsModel.sv_p_weight doubleValue]) - self.price);
            self.sv_p_memberprice.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
        }
    }else{
        if ([orderDetailsModel.sv_p_unitprice doubleValue] - self.price == 0) {
            self.sv_p_memberprice.hidden = YES;
            self.remarksLabel.hidden = YES;
        }else{
          
                double discount = ([orderDetailsModel.sv_p_unitprice doubleValue] - self.price) * ([orderDetailsModel.product_num doubleValue] + [orderDetailsModel.sv_p_weight doubleValue]);
                 self.sv_p_memberprice.text = [NSString stringWithFormat:@"优惠￥%.2f",discount];
            }
            
        }
   
   
   
   
    
//    self.sv_p_memberprice.textColor = [UIColor grayColor]; // 横线的颜色跟随label字体颜色改变
//    NSMutableAttributedString *newPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",self.sv_p_memberprice.text]];
//    [newPrice addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) range:NSMakeRange(0, newPrice.length)];
//    self.sv_p_memberprice.attributedText = newPrice;
}



//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
//    if ([self.model.sv_p_images containsString:@"UploadImg"]) {
//
//        NSData *data = [self.model.sv_p_images dataUsingEncoding:NSUTF8StringEncoding];
//        NSMutableArray *arr = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
//        if (kArrayIsEmpty(arr)) {
//            UIImageView *view = (UIImageView *)tap.view;
//            JJPhotoManeger *mg = [JJPhotoManeger maneger];
//            mg.delegate = self;
//            // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
//            [mg showLocalPhotoViewer:_imageArr selecView:view];
//        }else{
//            [self.picUrlArr removeAllObjects];
//            [self.imageArr removeAllObjects];
//            for (int i = 0; i < arr.count; i++) {
//                NSDictionary *dic = arr[i];
//                NSString *sv_p_images_two = dic[@"code"];
//               // sv_p_images = sv_p_images_two;
//
//                NSString *imageUrl = [NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two];
//               // [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]];
//                NSLog(@"sv_p_images_two----%@",[NSString stringWithFormat:@"%@%@",URLHeadPortrait,sv_p_images_two]);
//
//                 [self.picUrlArr addObject:imageUrl];
//                NSLog(@"self.picUrlArr = %@",self.picUrlArr);
//                  //添加点击操作
//                  UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
//                  [tap addTarget:self action:@selector(tap:)];
//                  [self.icon addGestureRecognizer:tap];
//                //        _picUrlArr = [NSMutableArray array];
//                [self.imageArr addObject:self.icon];
//                self.icon.userInteractionEnabled = YES;
//        }
//            [SVUserManager loadUserInfo];
//            [SVUserManager shareInstance].picUrlArr = self.picUrlArr;
//            [SVUserManager saveUserInfo];
//            UIImageView *view = (UIImageView *)tap.view;
//            JJPhotoManeger *mg = [JJPhotoManeger maneger];
//            mg.delegate = self;
//            [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
//    }
//
//    }
//    }else{
//       // _imageArr = [NSMutableArray array];
//        //        _picUrlArr = [NSMutableArray array];
//        UIImageView *view = (UIImageView *)tap.view;
//        JJPhotoManeger *mg = [JJPhotoManeger maneger];
//        mg.delegate = self;
//        // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
//        [mg showLocalPhotoViewer:_imageArr selecView:view];
//    }
    
    
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

- (NSMutableArray *)picUrlArr
{
    if (_picUrlArr == nil) {
        _picUrlArr = [NSMutableArray array];
    }
    return _picUrlArr;
}

- (NSMutableArray *)imageArr
{
    if (_imageArr == nil) {
        _imageArr = [NSMutableArray array];
    }
    return _imageArr;
}


-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    //  NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}


- (void)setFrame:(CGRect)frame{
   // frame.origin.x += 10;
    frame.origin.y += 5;
    frame.size.height -= 5;
   // frame.size.width -= 20;
    [super setFrame:frame];
}

@end
