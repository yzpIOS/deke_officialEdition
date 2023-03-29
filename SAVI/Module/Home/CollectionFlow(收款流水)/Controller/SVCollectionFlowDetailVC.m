//
//  SVCollectionFlowDetailVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/19.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVCollectionFlowDetailVC.h"
#import "SVCollectionRefundVC.h"

@interface SVCollectionFlowDetailVC ()
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UILabel *shoudanjigouTextLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon;
@property (weak, nonatomic) IBOutlet UILabel *money_pay;
@property (weak, nonatomic) IBOutlet UILabel *money;

@property (weak, nonatomic) IBOutlet UILabel *MerchantName;// 商户名称
@property (weak, nonatomic) IBOutlet UILabel *MerchantNumber; // 商户号
@property (weak, nonatomic) IBOutlet UILabel *payNumber; // 支付系统订单号
@property (weak, nonatomic) IBOutlet UILabel *businessNumber; // 业务订单号
@property (weak, nonatomic) IBOutlet UILabel *payTime;
@property (weak, nonatomic) IBOutlet UILabel *LatestRepayment;
@property (weak, nonatomic) IBOutlet UILabel *RecentRefund;
@property (weak, nonatomic) IBOutlet UILabel *RefundState;
@property (weak, nonatomic) IBOutlet UIView *tuikuanView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tuikuanHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lastViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *refundBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstrain;
//@property (nonatomic,strong) NSDictionary *dict;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *twoheight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *shoudantop;

@property (weak, nonatomic) IBOutlet UILabel *oneLabel;

@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@end

@implementation SVCollectionFlowDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
       //适配ios11偏移问题
          UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
          self.navigationItem.backBarButtonItem = backltem;
    [SVUserManager loadUserInfo];
    NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
    if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
        [self loadData];
    }else{
        //适配ios11偏移问题
           UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
           self.navigationItem.backBarButtonItem = backltem;
     self.bottomConstrain.constant = BottomHeight;
     self.money_pay.text = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
     self.money.text = [NSString stringWithFormat:@"￥%@",self.dict[@"orderMoney"]];
     self.MerchantName.text = [NSString stringWithFormat:@"%@",self.dict[@"shopName"]];
     self.payNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"orderId"]];
        self.payNumber.hidden = YES;
     self.businessNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"serviceOrderId"]];
        self.businessNumber.hidden = YES;
     NSString *payTime = [NSString stringWithFormat:@"%@",self.dict[@"orderTime"]];
        if (kStringIsEmpty(payTime) || [payTime containsString:@"null"]) {
            self.payTime.text = @"";
        }else{
            NSString *timestr2 = [payTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
            NSString *timestr3 = [payTime substringWithRange:NSMakeRange(11,8)];//str2 = "is"

            self.payTime.text = [NSString stringWithFormat:@"%@ %@",timestr2,timestr3];
        }
   
 //   NSString *LatestRepayment = [NSString stringWithFormat:@"%@",self.dict[@"lastRefundTime"]];
 //    if ([LatestRepayment containsString:@"null"]) {
 //
 //    }else{
 //        NSString *str2 = [LatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
 //             NSString *str3 = [LatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
 //          self.LatestRepayment.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
 //    }


     self.RecentRefund.text = [NSString stringWithFormat:@"%@",self.dict[@"lastRefundMoney"]];
     self.RefundState.text = [NSString stringWithFormat:@"%@",self.dict[@"hasRefund"]];

     NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
     if ([payment containsString:@"支付宝"]) {
         self.icon.image = [UIImage imageNamed:@"sales_treasure"];
     }else if ([payment containsString:@"微信"]){
         self.icon.image = [UIImage imageNamed:@"sales_wechat"];
     }else if ([payment containsString:@"龙支付"]){
         self.icon.image = [UIImage imageNamed:@"jianhang"];
     }else if ([payment containsString:@"扫码"]){
         self.icon.image = [UIImage imageNamed:@"saoma"];
     }

     NSString *refunds = [NSString stringWithFormat:@"%@",self.dict[@"refunds"]];
     if ([refunds containsString:@"null"]) {
         self.tuikuanHeight.constant = 0;
         self.lastViewHeight.constant = 60;
     }else{
         NSArray *refundsArray = self.dict[@"refunds"];
         CGFloat refundmaxY = 0;
          for (NSDictionary *memDic in refundsArray) {
            UILabel *memLabel = [[UILabel alloc]init];
             memLabel.text = [NSString stringWithFormat:@"￥%@",memDic[@"money"]];
                      // 设置Label的字体 HelveticaNeue  Courier
                      UIFont *fnt = [UIFont systemFontOfSize:15];
                      memLabel.textColor= GlobalFontColor;
                      memLabel.font = fnt;
                      // 根据字体得到NSString的尺寸
                      CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                      // 名字的H
                      CGFloat nameH = size.height;
                      // 名字的W
                      CGFloat nameW = size.width;
                      memLabel.frame = CGRectMake(10,refundmaxY, nameW,nameH);
                      [self.tuikuanView addSubview:memLabel];



                      UILabel *memLabelAmount = [[UILabel alloc] init];
                      NSString *timeLatestRepayment= [NSString stringWithFormat:@"%@",memDic[@"createTime"]];
                      NSString *str2 = [timeLatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
                                  NSString *str3 = [timeLatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
                     memLabelAmount.text  = [NSString stringWithFormat:@"%@ %@",str2,str3];

                      // 设置Label的字体 HelveticaNeue  Courier
                      UIFont *fntMount = [UIFont systemFontOfSize:15];
                      memLabelAmount.textColor= GlobalFontColor;
                      memLabelAmount.font = fntMount;
                      // 根据字体得到NSString的尺寸
                      CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
                      // 名字的H
                      CGFloat nameHM = sizeMount.height;
                      // 名字的W
                      CGFloat nameWM = sizeMount.width;
                      memLabelAmount.frame = CGRectMake(self.tuikuanView.width - nameWM -50,refundmaxY, nameWM,nameHM);

                      [self.tuikuanView addSubview:memLabelAmount];
                      refundmaxY = CGRectGetMaxY(memLabel.frame) + 20;
         }

         self.tuikuanHeight.constant = refundmaxY;
         self.lastViewHeight.constant = refundmaxY + 60;

     }


     self.title = @"订单详情";
     self.oneView.layer.cornerRadius = 10;
     self.oneView.layer.masksToBounds = YES;
     self.twoView.layer.cornerRadius = 10;
     self.twoView.layer.masksToBounds = YES;
     self.threeView.layer.cornerRadius = 10;
     self.threeView.layer.masksToBounds = YES;

   UIImage *image =[self resizeCodeWithString:[NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]] BCSize:CGSizeMake(ScreenW - 40, 80)];
     UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.shoudanjigouTextLabel.frame) + 20 ,ScreenW - 40, 80)];
     imageView.image = image;
     [self.twoView addSubview:imageView];

     UILabel *label = [[UILabel alloc] init];
     label.text = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
     label.numberOfLines = 0;

        NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
        CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(ScreenW, 10000) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
      [label setFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 10, ScreenW -40, textSize.height)];
     label.textAlignment = NSTextAlignmentCenter;
    // label.centerX = self.twoView.centerX;
     [self.twoView addSubview:label];
        
        double surplus= [self.dict[@"orderMoney"]doubleValue] - [self.dict[@"refundMoney"]doubleValue];
        if (surplus <= 0) {
            self.refundBtn.userInteractionEnabled = NO;
            self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
        }else{
            self.refundBtn.userInteractionEnabled = YES;
        }
     //   NSString *hasFullRefund = [NSString stringWithFormat:@"%@",self.dict[@"hasFullRefund"]];
        
//        [SVUserManager loadUserInfo];
//        NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
//        if (ConvergePay.doubleValue == 1 && !kStringIsEmpty(ConvergePay)) {
//            double surplus= [self.dict[@"money"]doubleValue] - [self.dict[@"refundMoney"]doubleValue];
//
//        }else{
//
//        }
//     if ([hasFullRefund isEqualToString:@"false"] || hasFullRefund.integerValue == 0) {
//         self.refundBtn.userInteractionEnabled = NO;
//         self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
//     }else{
//         self.refundBtn.userInteractionEnabled = YES;
//     }

    }
   

}

- (void)loadData{
    [SVUserManager loadUserInfo];

    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *url = [URLhead stringByAppendingFormat:@"/api/Report/V2/Details?QueryId=%@&key=%@",self.dictData[@"queryId"],token];
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
               NSLog(@"dic888 == %@",dic);
        if ([dic[@"code"] isEqual:@1]) {
            self.dict = dic[@"data"];
            
//            if ([[NSString stringWithFormat:@"%@",self.dict[@"isRefund"]] isEqualToString:@"true"]) { // 是已还
//                self.money.text = [NSString stringWithFormat:@"-%.2f",[self.dict[@"money"]doubleValue]];
//            }else{
//                self.money.text = [NSString stringWithFormat:@"+%.2f",[self.dict[@"money"]doubleValue]];
//            }
            
            self.money.text = [NSString stringWithFormat:@"+%.2f",[self.dict[@"money"]doubleValue]];
            
             self.bottomConstrain.constant = BottomHeight;
                self.money_pay.text = [NSString stringWithFormat:@"%@",self.dict[@"paymentTypeString"]];
              //  self.money.text = [NSString stringWithFormat:@"￥%@",self.dict[@"money"]];
                self.MerchantName.text = [NSString stringWithFormat:@"%@",self.dict[@"shopName"]];
                self.MerchantNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"shopName"]];
                self.payNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
                self.businessNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"businessTypeString"]];
                NSString *payTime = [NSString stringWithFormat:@"%@",self.dict[@"orderTime"]];
                NSString *timestr2 = [payTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
                NSString *timestr3 = [payTime substringWithRange:NSMakeRange(11,8)];//str2 = "is"
               self.twoheight.constant = 291;
                self.payTime.text = [NSString stringWithFormat:@"%@ %@",timestr2,timestr3];
                self.RecentRefund.text = [NSString stringWithFormat:@"%@",self.dict[@"lastRefundMoney"]];
                self.RefundState.text = [NSString stringWithFormat:@"%@",self.dict[@"hasRefund"]];
            
            self.oneLabel.hidden = YES;
            self.twoLabel.hidden = YES;
            self.payNumber.hidden = YES;
            self.businessNumber.hidden = YES;
                NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"paymentTypeString"]];
                if ([payment containsString:@"支付宝"]) {
                    self.icon.image = [UIImage imageNamed:@"sales_treasure"];
                }else if ([payment containsString:@"微信"]){
                    self.icon.image = [UIImage imageNamed:@"sales_wechat"];
                }else if ([payment containsString:@"龙支付"]){
                    self.icon.image = [UIImage imageNamed:@"jianhang"];
                }else if ([payment containsString:@"扫码"]){
                    self.icon.image = [UIImage imageNamed:@"saoma"];
                }

                NSString *refunds = [NSString stringWithFormat:@"%@",self.dict[@"refunds"]];
                if (kStringIsEmpty(refunds)) {
                    self.tuikuanHeight.constant = 0;
                    self.lastViewHeight.constant = 60;
                }else{
                    NSArray *refundsArray = self.dict[@"refunds"];
                    CGFloat refundmaxY = 0;
                     for (NSDictionary *memDic in refundsArray) {
                       UILabel *memLabel = [[UILabel alloc]init];
                        memLabel.text = [NSString stringWithFormat:@"￥%@",memDic[@"money"]];
                                 // 设置Label的字体 HelveticaNeue  Courier
                                 UIFont *fnt = [UIFont systemFontOfSize:15];
                                 memLabel.textColor= GlobalFontColor;
                                 memLabel.font = fnt;
                                 // 根据字体得到NSString的尺寸
                                 CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
                                 // 名字的H
                                 CGFloat nameH = size.height;
                                 // 名字的W
                                 CGFloat nameW = size.width;
                                 memLabel.frame = CGRectMake(10,refundmaxY, nameW,nameH);
                                 [self.tuikuanView addSubview:memLabel];

                                 UILabel *memLabelAmount = [[UILabel alloc] init];
                                 NSString *timeLatestRepayment= [NSString stringWithFormat:@"%@",memDic[@"createTime"]];
                         if (kStringIsEmpty(timeLatestRepayment) || [timeLatestRepayment containsString:@"null"]) {
//                             NSString *str2 = [timeLatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
//                                         NSString *str3 = [timeLatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
                             memLabelAmount.text  = @"";
                         }else{
                             NSString *str2 = [timeLatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
                                         NSString *str3 = [timeLatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
                            memLabelAmount.text  = [NSString stringWithFormat:@"%@ %@",str2,str3];
                         }
                                

                                 // 设置Label的字体 HelveticaNeue  Courier
                                 UIFont *fntMount = [UIFont systemFontOfSize:15];
                                 memLabelAmount.textColor= GlobalFontColor;
                                 memLabelAmount.font = fntMount;
                                 // 根据字体得到NSString的尺寸
                                 CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
                                 // 名字的H
                                 CGFloat nameHM = sizeMount.height;
                                 // 名字的W
                                 CGFloat nameWM = sizeMount.width;
                                 memLabelAmount.frame = CGRectMake(self.tuikuanView.width - nameWM -50,refundmaxY, nameWM,nameHM);

                                 [self.tuikuanView addSubview:memLabelAmount];
                                 refundmaxY = CGRectGetMaxY(memLabel.frame) + 20;
                    }

                    self.tuikuanHeight.constant = refundmaxY;
                    self.lastViewHeight.constant = refundmaxY + 60;

                }


                self.title = @"订单详情";
                self.oneView.layer.cornerRadius = 10;
                self.oneView.layer.masksToBounds = YES;
                self.twoView.layer.cornerRadius = 10;
                self.twoView.layer.masksToBounds = YES;
                self.threeView.layer.cornerRadius = 10;
                self.threeView.layer.masksToBounds = YES;
            self.shoudanjigouTextLabel.text = @"支付订单号";
            self.shoudantop.constant = 20;
              UIImage *image =[self resizeCodeWithString:[NSString stringWithFormat:@"%@",self.dict[@"queryId"]] BCSize:CGSizeMake(ScreenW - 40, 80)];
             //   UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.shoudanjigouTextLabel.frame) + 20 ,ScreenW - 40, 80)];
            UIImageView *imageView = [[UIImageView alloc] init];
                imageView.image = image;
                [self.twoView addSubview:imageView];
            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(self.shoudanjigouTextLabel.mas_bottom).offset(20);
                make.left.mas_equalTo(self.twoView.mas_left).offset(10);
                make.right.mas_equalTo(self.twoView.mas_right).offset(-10);
                make.height.mas_equalTo(80);
            }];

                UILabel *label = [[UILabel alloc] init];
                label.text = [NSString stringWithFormat:@"%@",self.dict[@"queryId"]];
                label.numberOfLines = 0;

                   NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
                   CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(ScreenW, 10000) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
                // [label setFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 10, ScreenW -40, textSize.height)];
                label.textAlignment = NSTextAlignmentCenter;
               // label.centerX = self.twoView.centerX;
                [self.twoView addSubview:label];
            [label mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(imageView.mas_bottom).offset(10);
                make.left.mas_equalTo(self.twoView.mas_left).offset(10);
                make.right.mas_equalTo(self.twoView.mas_right).offset(-10);
                make.height.mas_equalTo(textSize.height);
            }];

                if ([self.dict[@"hasFullRefund"] integerValue] == 1) {
                    self.refundBtn.userInteractionEnabled = NO;
                    self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
                    
//                    self.money.text = [NSString stringWithFormat:@"-%.2f",[self.dict[@"money"]doubleValue]];
                }else{
                    self.refundBtn.userInteractionEnabled = YES;
                    
                   
                }
        }else{
            NSString *msg = dic[@"msg"];
            [SVTool TextButtonActionWithSing:msg?:@"请求错误"];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



#pragma mark - 点击退款
- (IBAction)refundClick:(id)sender {


    SVCollectionRefundVC *VC = [[SVCollectionRefundVC alloc] init];
    VC.delegate = self.collectionFlowVC;
    VC.dict = self.dict;
    [self.navigationController pushViewController:VC animated:YES];
}

/**
 *  生成条形码
 *
 *  @return 生成条形码的UIImage对象
 */
- (UIImage *)resizeCodeWithString:(NSString *)text BCSize:(CGSize)size
{
    CIImage *image = [self generateBarCodeImage:text];

    return [self resizeCodeImage:image withSize:size];
}

- (CIImage *)generateBarCodeImage:(NSString *)source
{
    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        // 注意生成条形码的编码方式
        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
        [filter setValue:data forKey:@"inputMessage"];
        // 设置生成的条形码的上，下，左，右的margins的值
        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
        return filter.outputImage;
    }else{
        return nil;
    }
}
- (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size
{
    if (image) {
        CGRect extent = CGRectIntegral(image.extent);
        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
        size_t width = CGRectGetWidth(extent) * scaleWidth;
        size_t height = CGRectGetHeight(extent) * scaleHeight;
        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
        CIContext *context = [CIContext contextWithOptions:nil];
        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
        CGContextDrawImage(contentRef, extent, imageRef);
        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
        UIImage *barImage = [UIImage imageWithCGImage:imageRefResized];

        //Core Foundation 框架下内存泄露问题。
        CGContextRelease(contentRef);
        CGColorSpaceRelease(colorSpaceRef);
        CGImageRelease(imageRef);
        CGImageRelease(imageRefResized);
        return barImage;
    }else{
        return nil;
    }
}


//- (void)viewDidLoad {
//    [super viewDidLoad];
//       //适配ios11偏移问题
//          UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
//          self.navigationItem.backBarButtonItem = backltem;
//    self.bottomConstrain.constant = BottomHeight;
//    self.money_pay.text = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
//    self.money.text = [NSString stringWithFormat:@"￥%@",self.dict[@"orderMoney"]];
//    self.MerchantName.text = [NSString stringWithFormat:@"%@",self.dict[@"shopName"]];
//    self.MerchantNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"shopName"]];
//    self.payNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"orderId"]];
//    self.businessNumber.text = [NSString stringWithFormat:@"%@",self.dict[@"serviceOrderId"]];
//    NSString *payTime = [NSString stringWithFormat:@"%@",self.dict[@"orderTime"]];
//    NSString *timestr2 = [payTime substringWithRange:NSMakeRange(0,10)];//str2 = "is"
//    NSString *timestr3 = [payTime substringWithRange:NSMakeRange(11,8)];//str2 = "is"
//
//    self.payTime.text = [NSString stringWithFormat:@"%@ %@",timestr2,timestr3];
////   NSString *LatestRepayment = [NSString stringWithFormat:@"%@",self.dict[@"lastRefundTime"]];
////    if ([LatestRepayment containsString:@"null"]) {
////
////    }else{
////        NSString *str2 = [LatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
////             NSString *str3 = [LatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
////          self.LatestRepayment.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
////    }
//
//
//    self.RecentRefund.text = [NSString stringWithFormat:@"%@",self.dict[@"lastRefundMoney"]];
//    self.RefundState.text = [NSString stringWithFormat:@"%@",self.dict[@"hasRefund"]];
//
//    NSString *payment = [NSString stringWithFormat:@"%@",self.dict[@"payment"]];
//    if ([payment containsString:@"支付宝"]) {
//        self.icon.image = [UIImage imageNamed:@"sales_treasure"];
//    }else if ([payment containsString:@"微信"]){
//        self.icon.image = [UIImage imageNamed:@"sales_wechat"];
//    }else if ([payment containsString:@"龙支付"]){
//        self.icon.image = [UIImage imageNamed:@"jianhang"];
//    }else if ([payment containsString:@"扫码"]){
//        self.icon.image = [UIImage imageNamed:@"saoma"];
//    }
//
//    NSString *refunds = [NSString stringWithFormat:@"%@",self.dict[@"refunds"]];
//    if ([refunds containsString:@"null"]) {
//        self.tuikuanHeight.constant = 0;
//        self.lastViewHeight.constant = 60;
//    }else{
//        NSArray *refundsArray = self.dict[@"refunds"];
//        CGFloat refundmaxY = 0;
//         for (NSDictionary *memDic in refundsArray) {
//           UILabel *memLabel = [[UILabel alloc]init];
//            memLabel.text = [NSString stringWithFormat:@"￥%@",memDic[@"money"]];
//                     // 设置Label的字体 HelveticaNeue  Courier
//                     UIFont *fnt = [UIFont systemFontOfSize:15];
//                     memLabel.textColor= GlobalFontColor;
//                     memLabel.font = fnt;
//                     // 根据字体得到NSString的尺寸
//                     CGSize size = [memLabel.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fnt,NSFontAttributeName, nil]];
//                     // 名字的H
//                     CGFloat nameH = size.height;
//                     // 名字的W
//                     CGFloat nameW = size.width;
//                     memLabel.frame = CGRectMake(10,refundmaxY, nameW,nameH);
//                     [self.tuikuanView addSubview:memLabel];
//
//
//
//                     UILabel *memLabelAmount = [[UILabel alloc] init];
//                     NSString *timeLatestRepayment= [NSString stringWithFormat:@"%@",memDic[@"createTime"]];
//                     NSString *str2 = [timeLatestRepayment substringWithRange:NSMakeRange(0,10)];//str2 = "is"
//                                 NSString *str3 = [timeLatestRepayment substringWithRange:NSMakeRange(11,8)];//str2 = "is"
//                    memLabelAmount.text  = [NSString stringWithFormat:@"%@ %@",str2,str3];
//
//                     // 设置Label的字体 HelveticaNeue  Courier
//                     UIFont *fntMount = [UIFont systemFontOfSize:15];
//                     memLabelAmount.textColor= GlobalFontColor;
//                     memLabelAmount.font = fntMount;
//                     // 根据字体得到NSString的尺寸
//                     CGSize sizeMount = [memLabelAmount.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:fntMount,NSFontAttributeName, nil]];
//                     // 名字的H
//                     CGFloat nameHM = sizeMount.height;
//                     // 名字的W
//                     CGFloat nameWM = sizeMount.width;
//                     memLabelAmount.frame = CGRectMake(self.tuikuanView.width - nameWM -50,refundmaxY, nameWM,nameHM);
//
//                     [self.tuikuanView addSubview:memLabelAmount];
//                     refundmaxY = CGRectGetMaxY(memLabel.frame) + 20;
//        }
//
//        self.tuikuanHeight.constant = refundmaxY;
//        self.lastViewHeight.constant = refundmaxY + 60;
//
//    }
//
//
//    self.title = @"订单详情";
//    self.oneView.layer.cornerRadius = 10;
//    self.oneView.layer.masksToBounds = YES;
//    self.twoView.layer.cornerRadius = 10;
//    self.twoView.layer.masksToBounds = YES;
//    self.threeView.layer.cornerRadius = 10;
//    self.threeView.layer.masksToBounds = YES;
//
//  UIImage *image =[self resizeCodeWithString:[NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]] BCSize:CGSizeMake(ScreenW - 40, 80)];
//    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10,CGRectGetMaxY(self.shoudanjigouTextLabel.frame) + 20 ,ScreenW - 40, 80)];
//    imageView.image = image;
//    [self.twoView addSubview:imageView];
//
//    UILabel *label = [[UILabel alloc] init];
//    label.text = [NSString stringWithFormat:@"%@",self.dict[@"payOrderId"]];
//    label.numberOfLines = 0;
//
//       NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:15],};
//       CGSize textSize = [label.text boundingRectWithSize:CGSizeMake(ScreenW, 10000) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
//     [label setFrame:CGRectMake(10, CGRectGetMaxY(imageView.frame) + 10, ScreenW -40, textSize.height)];
//    label.textAlignment = NSTextAlignmentCenter;
//   // label.centerX = self.twoView.centerX;
//    [self.twoView addSubview:label];
//
//    if ([self.dict[@"hasFullRefund"] integerValue] == 1) {
//        self.refundBtn.userInteractionEnabled = NO;
//        self.refundBtn.backgroundColor = [UIColor colorWithHexString:@"999999"];
//    }else{
//        self.refundBtn.userInteractionEnabled = YES;
//    }
//
//}

//#pragma mark - 点击退款
//- (IBAction)refundClick:(id)sender {
//
//
//    SVCollectionRefundVC *VC = [[SVCollectionRefundVC alloc] init];
//    VC.delegate = self.collectionFlowVC;
//    VC.dict = self.dict;
//    [self.navigationController pushViewController:VC animated:YES];
//}
//
///**
// *  生成条形码
// *
// *  @return 生成条形码的UIImage对象
// */
//- (UIImage *)resizeCodeWithString:(NSString *)text BCSize:(CGSize)size
//{
//    CIImage *image = [self generateBarCodeImage:text];
//
//    return [self resizeCodeImage:image withSize:size];
//}
//
//- (CIImage *)generateBarCodeImage:(NSString *)source
//{
//    // iOS 8.0以上的系统才支持条形码的生成，iOS8.0以下使用第三方控件生成
//    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
//        // 注意生成条形码的编码方式
//        NSData *data = [source dataUsingEncoding: NSASCIIStringEncoding];
//        CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];
//        [filter setValue:data forKey:@"inputMessage"];
//        // 设置生成的条形码的上，下，左，右的margins的值
//        [filter setValue:[NSNumber numberWithInteger:0] forKey:@"inputQuietSpace"];
//        return filter.outputImage;
//    }else{
//        return nil;
//    }
//}
//- (UIImage *)resizeCodeImage:(CIImage *)image withSize:(CGSize)size
//{
//    if (image) {
//        CGRect extent = CGRectIntegral(image.extent);
//        CGFloat scaleWidth = size.width/CGRectGetWidth(extent);
//        CGFloat scaleHeight = size.height/CGRectGetHeight(extent);
//        size_t width = CGRectGetWidth(extent) * scaleWidth;
//        size_t height = CGRectGetHeight(extent) * scaleHeight;
//        CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceGray();
//        CGContextRef contentRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpaceRef, (CGBitmapInfo)kCGImageAlphaNone);
//        CIContext *context = [CIContext contextWithOptions:nil];
//        CGImageRef imageRef = [context createCGImage:image fromRect:extent];
//        CGContextSetInterpolationQuality(contentRef, kCGInterpolationNone);
//        CGContextScaleCTM(contentRef, scaleWidth, scaleHeight);
//        CGContextDrawImage(contentRef, extent, imageRef);
//        CGImageRef imageRefResized = CGBitmapContextCreateImage(contentRef);
//        UIImage *barImage = [UIImage imageWithCGImage:imageRefResized];
//
//        //Core Foundation 框架下内存泄露问题。
//        CGContextRelease(contentRef);
//        CGColorSpaceRelease(colorSpaceRef);
//        CGImageRelease(imageRef);
//        CGImageRelease(imageRefResized);
//        return barImage;
//    }else{
//        return nil;
//    }
//}

@end
