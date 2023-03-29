//
//  SVRechargeReportCell.m
//  SAVI
//
//  Created by 杨忠平 on 2019/12/31.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVRechargeReportCell.h"
#import "SVShopReportModel.h"
#import "SVAddCustomView.h"
#import "ZJViewShow.h"

@interface SVRechargeReportCell()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *nameText;
@property (weak, nonatomic) IBOutlet UILabel *RechargeMoney;
@property (weak, nonatomic) IBOutlet UILabel *giteMoney;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIButton *RevokeBtn;
@property (nonatomic,strong) SVAddCustomView *addCustomView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) ZJViewShow *showView;

@end

@implementation SVRechargeReportCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.nameText.adjustsFontSizeToFitWidth = YES;
    self.nameText.minimumScaleFactor = 0.5;
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
    
   
   //  NSString *RechargeReport = [NSString stringWithFormat:@"%@",AnalyticsDic[@"RechargeReport"]];
    
  //  RechargeReportRevoke
}



- (void)keyboardWillShow:(NSNotification *)aNotification
{
    //获取键盘的高度
    
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    int width = keyboardRect.size.width;
    self.addCustomView.center = CGPointMake(ScreenW / 2, ScreenH - height - 120);
    NSLog(@"键盘高度是  %d",height);
    NSLog(@"键盘宽度是  %d",width);
    
    
}

//当键退出时调用
- (void)keyboardWillHide:(NSNotification *)aNotification
{
     [self.addCustomView.textView becomeFirstResponder];// 2
}

- (void)setModel:(SVShopReportModel *)model
{
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *AnalyticsDic = sv_versionpowersDict[@"Analytics"];
    
    
 
    

    _model = model;
    self.nameText.text = model.sv_mr_name;
    self.RechargeMoney.text = [NSString stringWithFormat:@"%.2f",[model.sv_mrr_money floatValue]];
    self.giteMoney.text = [NSString stringWithFormat:@"%.2f",[model.sv_mrr_present floatValue]];
   // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    NSString *str2 = [model.sv_mrr_date substringWithRange:NSMakeRange(5,5)];//str2 = "is"
    NSString *str3 = [model.sv_mrr_date substringWithRange:NSMakeRange(11,5)];//str2 = "is"
    self.date.text = [NSString stringWithFormat:@"%@ %@",str2,str3];
    NSLog(@"%@-%@",model.sv_mrr_state,model.sv_mrr_type);
    
    if (model.sv_mrr_state.integerValue == 0 &&model.sv_mrr_type.integerValue != -1 && model.sv_mrr_type.integerValue != -2) {
        
        
        if (kDictIsEmpty(sv_versionpowersDict)) {
            [self.RevokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
            [self.RevokeBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
            self.RevokeBtn.userInteractionEnabled = YES;
        }else{
            NSString *RechargeReportRevoke = [NSString stringWithFormat:@"%@",AnalyticsDic[@"RechargeReportRevoke"]];
            if (kStringIsEmpty(RechargeReportRevoke)) {
                [self.RevokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
                [self.RevokeBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
                self.RevokeBtn.userInteractionEnabled = YES;
            }else{
                if ([RechargeReportRevoke isEqualToString:@"1"]) {
                    [self.RevokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
                    [self.RevokeBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
                    self.RevokeBtn.userInteractionEnabled = YES;
                }else{
                    [self.RevokeBtn setTitle:@"撤销" forState:UIControlStateNormal];
                    [self.RevokeBtn setTitleColor:GreyFontColor forState:UIControlStateNormal];
                    self.RevokeBtn.userInteractionEnabled = NO;
                }
            }
        }
    }else{
      //  if ([model.sv_mrr_desc isEqualToString:@"充值退款"]) {
            [self.RevokeBtn setTitle:@"已撤销" forState:UIControlStateNormal];
            [self.RevokeBtn setTitleColor:GreyFontColor forState:UIControlStateNormal];
            self.RevokeBtn.userInteractionEnabled = NO;
       // }
        
    }
}

- (IBAction)RevokeClick:(id)sender {

    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"你确定要撤销吗？" preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction * confirmAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {

//        NSString *dec_payment_method =[SVUserManager shareInstance].dec_payment_method;
//        if ([dec_payment_method isEqualToString:@"5"] && ([self.model.sv_mrr_payment isEqualToString:@"支付宝"] || [self.model.sv_mrr_payment isEqualToString:@"微信"] || [self.model.sv_mrr_payment isEqualToString:@"微信支付"])) {
            
        
       
[SVUserManager loadUserInfo];
NSString *ConvergePay = [SVUserManager shareInstance].ConvergePay;
if (!kStringIsEmpty(ConvergePay) && ConvergePay.doubleValue == 1) {// 开通了聚合支付
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
                                           
                                           [self tuihuoFuction];
                                       }else{
                                           NSDictionary *dict1 = childDetailList[0];
                                           
                                         NSString *sv_detail_is_enable = [NSString stringWithFormat:@"%@",dict1[@"sv_detail_is_enable"]];
                                           
                                           if (sv_detail_is_enable.intValue == 1)  {
                                               
                                               [self.addCustomView.textView becomeFirstResponder];// 2
                                               [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
                                               [[UIApplication sharedApplication].keyWindow addSubview:self.addCustomView];
                                           }else{
//                                               [SVTool TextButtonActionWithSing:@"没有开通密码开关"];
                                               [self tuihuoFuction];
                                           }
                                           
                                       }
                                       
                                       break;
                                   }else{
                                       [self tuihuoFuction];
                                   }
                               }
                           }else{
                               [self tuihuoFuction];
                           }
                       } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                               //隐藏提示框
                           [MBProgressHUD hideHUDForView:self animated:YES];
                           [SVTool TextButtonAction:self withSing:@"网络开小差了"];
                       }];
            
            
            
        }else{
            [self tuihuoFuction];
        }
                
     
    }];

    [alertController addAction:confirmAction];
    //创建用于显示alertController的UIViewController
    UIViewController *alertVC = [[UIViewController alloc]init];
    [self addSubview:alertVC.view];
    
    UIAlertAction *cancelBtn = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
//        [alertVC presentViewController:alertController animated:YES completion:^{
//            //移除用于显示alertController的UIViewController
//            [alertVC.view removeFromSuperview];
//        }];
    }];
    [alertController addAction:cancelBtn];
  
    [alertVC presentViewController:alertController animated:YES completion:^{
        //移除用于显示alertController的UIViewController
        [alertVC.view removeFromSuperview];
    }];
    
  
}

#pragma mark - 退货
- (void)tuihuoFuction{
    [SVTool IndeterminateButtonActionWithSing:@"处理中..."];
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *dURL=[URLhead stringByAppendingFormat:@"/rechargeable/Post_cancelto_up?key=%@&id=%@",token,self.model.recharge_id];
                  NSLog(@"充值dURL = %@",dURL);
                  [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                      NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                      if ([dic[@"succeed"]intValue] == 1) {
                          if (self.RevokeBlock) {
                              self.RevokeBlock();
                          }
                          [SVTool TextButtonActionWithSing:@"撤销成功"];
                      }else{
                          [SVTool TextButtonActionWithSing:@"撤销失败"];
                      }
             
                  } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                      //隐藏提示框
                        [MBProgressHUD hideHUDForView:self animated:YES];
                      [SVTool TextButtonAction:self withSing:@"网络开小差了"];
                  }];
}

#pragma mark - 自定义弹框的确定按钮
- (void)sureBtnClick{
   
    if (!kStringIsEmpty(self.addCustomView.textView.text)) {
            
              [SVUserManager loadUserInfo];
                NSString *token = [SVUserManager shareInstance].access_token;
                NSString *dec_payment_method =[SVUserManager shareInstance].dec_payment_method;
//                if ([dec_payment_method isEqualToString:@"5"] && ([self.model.sv_mrr_payment isEqualToString:@"支付宝"] || [self.model.sv_mrr_payment isEqualToString:@"微信"] || [self.model.sv_mrr_payment isEqualToString:@"微信支付"])) {
                     [SVTool IndeterminateButtonActionWithSing:@"处理中..."];
                    NSString *passWord = self.addCustomView.textView.text;
                    //密码进行MD5加密
                       NSString *pwdMD5=[JWXUtils EncodingWithMD5:passWord].uppercaseString;
                    
        NSString *dURL=[URLhead stringByAppendingFormat:@"/rechargeable/Post_cancelto_up?key=%@&id=%@&refundPassword=%@",token,[NSString stringWithFormat:@"%@",self.model.recharge_id],pwdMD5];
      //  NSString *strURL = [dURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                         NSLog(@"充值dURL = %@",dURL);
        [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                             NSLog(@"原理退款dic=%@",dic);
                             if ([dic[@"succeed"]intValue] == 1) {
                                
                                 NSString *order_number = [NSString stringWithFormat:@"%@",dic[@"order_number"]];
                                 self.showView = [[ZJViewShow alloc]initWithFrame:self.frame];
                                 self.showView.center = self.center;
                                 //  self.showView.delegate = self;
                                 [[UIApplication sharedApplication].keyWindow addSubview:self.showView];
                                 // [self.view addSubview:self.showView];
                                 
                                 //按钮实现倒计时
                                 __block int timeout=60; //倒计时时间
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
                                         [self refundResultQueryId:order_number _timer:_timer];
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
                                  [SVTool TextButtonActionWithSing:@"撤销成功"];
                             }else{
                                NSString *values = dic[@"values"];
                                 if (!kStringIsEmpty(values)) {
                                     [SVTool TextButtonActionWithSing:values];
                                 }else{
                                  [SVTool TextButtonActionWithSing:@"撤销失败"];
                                 }
                                 
                             }
                         } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                             [SVTool TextButtonAction:self withSing:@"网络开小差了"];
                         }];
              //  }
            
            [self.addCustomView.textView endEditing:YES];
            [self vipCancelResponseEvent];
            
            self.addCustomView.textView.text = nil;
    
    }else{
        [SVTool TextButtonActionWithSing:@"请输入密码"];
    }
  
}

#pragma mark - 查询退款结果 轮训
- (void)refundResultQueryId:(NSString *)queryId _timer:(dispatch_source_t)_timer{
    [SVUserManager loadUserInfo];
    NSString *url = [URLhead stringByAppendingFormat:@"/api/Refund/%@?key=%@",queryId,[SVUserManager shareInstance].access_token];
  //  NSString *strURL = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[SVSaviTool sharedSaviTool]GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

          NSLog(@"dic查询退款结果 == %@",dic);
         if ([dic[@"code"] integerValue] == 1) {
             NSString *action = [NSString stringWithFormat:@"%@",dic[@"data"][@"action"]];
             NSString *msg = dic[@"data"][@"msg"];
             if (action.integerValue == -1) {// 停止轮训
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 [SVTool TextButtonActionWithSing:!kStringIsEmpty(msg)?msg:@"停止轮训"];
             }else if(action.integerValue == 1){// 1:Success,取到结果;
                 [SVTool TextButtonActionWithSing:@"退款成功"];
                 if (self.RevokeBlock) {
                     self.RevokeBlock();
                 }
                 
                 //隐藏提示
                 [MBProgressHUD hideHUDForView:self animated:YES];
                 dispatch_source_cancel(_timer);
                 [self.showView removeFromSuperview];
                 
//                 //用延迟来移除提示框
//                 dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                     //隐藏提示
//                     [MBProgressHUD hideHUDForView:self animated:YES];
//                     //返回上一控制器
//                     [self.navigationController popViewControllerAnimated:YES];
//                 });
                 
             }else{// 2:Continue,继续轮询;

             }
         }else{

         }


    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         //隐藏提示框
        [MBProgressHUD hideHUDForView:self animated:YES];
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
}

- (SVAddCustomView *)addCustomView
{
    if (!_addCustomView) {
        _addCustomView = [[NSBundle mainBundle]loadNibNamed:@"SVAddCustomView" owner:nil options:nil].lastObject;
        _addCustomView.textView.delegate = self;
        _addCustomView.frame = CGRectMake(10, 10, ScreenW - 20, 200);
        _addCustomView.layer.cornerRadius = 10;
        _addCustomView.name.text = @"请输入密码";
        _addCustomView.layer.masksToBounds = YES;
        _addCustomView.center = CGPointMake(ScreenW / 2, ScreenH);
        [_addCustomView.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
        [_addCustomView.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _addCustomView;
}
- (void)cancleBtnClick{
  //  [self sureBtnClick];
    [self vipCancelResponseEvent];
}

//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
   // [self.vipPickerView removeFromSuperview];
    [self.addCustomView removeFromSuperview];
  //  [self.setUserdItemView removeFromSuperview];
    
    //[self.tableView reloadData];
    
}

/**
 等级遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

@end
