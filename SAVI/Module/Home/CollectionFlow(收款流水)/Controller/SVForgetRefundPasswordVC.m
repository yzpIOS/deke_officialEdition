//
//  SVForgetRefundPasswordVC.m
//  SAVI
//
//  Created by 杨忠平 on 2020/5/21.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import "SVForgetRefundPasswordVC.h"
#import "NSDictionary+SVMutabledictionary.h"

@interface SVForgetRefundPasswordVC ()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UITextField *oneText;
@property (weak, nonatomic) IBOutlet UITextField *twoText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (nonatomic,strong) NSString *codeSucceed;
@property (nonatomic,strong) NSString *passSucceed;

@property (weak, nonatomic) IBOutlet UIButton *pwdOneBtn;
@property (weak, nonatomic) IBOutlet UIButton *pwdTwoBtn;


@end

@implementation SVForgetRefundPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.selectNum == 1) { // 是设置密码
         self.title = @"设置退款密码";
    }else{
       self.title = @"忘记退款密码";
    }
   
    
    self.oneView.layer.cornerRadius = 5;
       self.oneView.layer.masksToBounds = YES;
       
       self.oneView.layer.borderColor = BackgroundColor.CGColor;
       self.oneView.layer.borderWidth = 1;
       
       self.twoView.layer.cornerRadius = 5;
       self.twoView.layer.masksToBounds = YES;
       
       self.twoView.layer.borderColor = BackgroundColor.CGColor;
       self.twoView.layer.borderWidth = 1;
    
    self.threeView.layer.cornerRadius = 5;
        self.threeView.layer.masksToBounds = YES;
        
        self.threeView.layer.borderColor = BackgroundColor.CGColor;
        self.threeView.layer.borderWidth = 1;
    
       self.sureBtn.layer.cornerRadius = 25;
        self.sureBtn.layer.masksToBounds = YES;
    
    self.getCodeBtn.layer.cornerRadius = 5;
          self.getCodeBtn.layer.masksToBounds = YES;
    
    self.oneText.delegate = self;
    self.twoText.delegate = self;
    self.codeText.delegate = self;
     self.codeSucceed = @"0";
    self.passSucceed = @"0";
    
    self.oneText.keyboardType = UIKeyboardTypeASCIICapable;
    self.twoText.keyboardType = UIKeyboardTypeASCIICapable;
    self.codeText.keyboardType = UIKeyboardTypeASCIICapable;
     //监听输入内容

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)

                                                    name:@"UITextFieldTextDidChangeNotification"

                                                  object:self.oneText];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)

                                                       name:@"UITextFieldTextDidChangeNotification"

                                                     object:self.twoText];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(textFiledEditChanged:)

                                                         name:@"UITextFieldTextDidChangeNotification"

                                                       object:self.codeText];

}

    -(void)textFiledEditChanged:(NSNotification*)notification

    {

        UITextField*textField = notification.object;

        NSString*str = textField.text;

        for (int i = 0; i<str.length; i++)

        {

            NSString*string = [str substringFromIndex:i];

            NSString *regex = @"[\u4e00-\u9fa5]{0,}$"; // 中文

            // 2、拼接谓词

            NSPredicate *predicateRe1 = [NSPredicate predicateWithFormat:@"self matches %@", regex];

            // 3、匹配字符串

            BOOL resualt = [predicateRe1 evaluateWithObject:string];

            

            if (resualt)

            {

                str =  [str stringByReplacingOccurrencesOfString:[str substringFromIndex:i] withString:@""];

     

            }

        }

        textField.text = str;

    }


- (IBAction)pwdOneBtnClick:(UIButton *)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
       // 切换按钮的状态
       sender.selected = !sender.selected;
      
       if (sender.selected) { // 按下去了就是明文
    
           NSString *tempPwdStr = self.oneText.text;
                        self.oneText.text = @""; // 这句代码可以防止切换的时候光标偏移
                        self.oneText.secureTextEntry = NO;
                        self.oneText.text = tempPwdStr;
                      [self.pwdOneBtn setImage:[UIImage imageNamed:@"Plaintext"] forState:UIControlStateNormal];
      
       } else { // 暗文
      NSString *tempPwdStr = self.oneText.text;
              self.oneText.text = @"";
              self.oneText.secureTextEntry = YES;
              self.oneText.text = tempPwdStr;
              [self.pwdOneBtn setImage:[UIImage imageNamed:@"DarkText"] forState:UIControlStateNormal];
          
       }
}

- (IBAction)pwdTwoClick:(UIButton *)sender {
    // 前提:在xib中设置按钮的默认与选中状态的背景图
         // 切换按钮的状态
         sender.selected = !sender.selected;
        
         if (sender.selected) { // 按下去了就是明文
             NSString *tempPwdStr = self.twoText.text;
                            self.twoText.text = @""; // 这句代码可以防止切换的时候光标偏移
                            self.twoText.secureTextEntry = NO;
                            self.twoText.text = tempPwdStr;
                          [self.pwdTwoBtn setImage:[UIImage imageNamed:@"Plaintext"] forState:UIControlStateNormal];
        
         } else { // 暗文
        NSString *tempPwdStr = self.twoText.text;
                   self.twoText.text = @"";
                   self.twoText.secureTextEntry = YES;
                   self.twoText.text = tempPwdStr;
                   [self.pwdTwoBtn setImage:[UIImage imageNamed:@"DarkText"] forState:UIControlStateNormal];
            
         }
}


- (void)dealloc
{
       [[NSNotificationCenter defaultCenter] removeObserver:self name:@"UITextFieldTextDidChangeNotification" object:nil];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
//    if (textField == self.twoText) {
//        if (kStringIsEmpty(self.oneText.text)) {
//            [self.oneText becomeFirstResponder];
//       }
//    }else if (textField == self.oneText){
//          [self.oneText becomeFirstResponder];
//    }else if (textField == self.codeText){
//        if (kStringIsEmpty(self.oneText.text)) {
//             [self.oneText becomeFirstResponder];
//        }else if (kStringIsEmpty(self.twoText.text)){
//            [self.twoText becomeFirstResponder];
//        }
//    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.twoText) {
        if (kStringIsEmpty(self.oneText.text)) {
            [self.oneText becomeFirstResponder];
        }else{
            if ([self.oneText.text isEqualToString:self.twoText.text]) {
                 self.passLabel.hidden = YES;
                self.passSucceed = @"1";
            }else{
                self.passLabel.hidden = NO;
                self.passSucceed = @"0";
            }
        }
    }else if (textField == self.codeText){
        [SVUserManager loadUserInfo];
        // NSString *token = [SVUserManager shareInstance].access_token;
         NSString *sv_ul_mobile = [SVUserManager shareInstance].sv_ul_mobile;
          NSString *dURL=[URLhead stringByAppendingFormat:@"/System/CheckoutCode?moble=%@&code=%@",sv_ul_mobile,self.codeText.text];
        [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dic验证码验证 = %@",dic);
            if ([dic[@"succeed"] integerValue] == 1) {
                self.codeSucceed = @"1";
                self.codeLabel.hidden = YES;
            }else{
                self.codeSucceed = @"0";
                self.codeLabel.hidden = NO;
               // [SVTool TextButtonAction:self.view withSing:dic[@"values"]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
               //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
}

#pragma mark - 按钮实现倒计时
-(void)countdown{
    //按钮实现倒计时
        __block int timeout=120; //倒计时时间
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
        dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
        dispatch_source_set_event_handler(_timer, ^{
            if(timeout<=0){ //倒计时结束，关闭
                dispatch_source_cancel(_timer);
                dispatch_async(dispatch_get_main_queue(), ^{
                    //设置界面的按钮显示 根据自己需求设置
                    [self.getCodeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    self.getCodeBtn.userInteractionEnabled = YES;
//                    self.attainButton.backgroundColor = [UIColor purpleColor];
                });
            }else{
                int seconds = timeout;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //让按钮变为不可点击的灰色
//                    self.attainButton.backgroundColor = [UIColor grayColor];
                    self.getCodeBtn.userInteractionEnabled = NO;
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
}



#pragma mark - 获取短信验证码
- (IBAction)getCodeClick:(id)sender {
    //倒计时
    [self countdown];
    [SVUserManager loadUserInfo];
   // NSString *token = [SVUserManager shareInstance].access_token;
    NSString *sv_ul_mobile = [SVUserManager shareInstance].sv_ul_mobile;
     NSString *dURL=[URLhead stringByAppendingFormat:@"/System/RefundPasswordDataCode?moble=%@",sv_ul_mobile];
    
    [[SVSaviTool sharedSaviTool] POST:dURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
             NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                NSLog(@"dic验证码 = %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
              //隐藏提示框
                     [MBProgressHUD hideHUDForView:self.view animated:YES];
                     [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 确定
- (IBAction)sureClick:(id)sender {
    self.sureBtn.userInteractionEnabled = NO;
    if (self.passSucceed.integerValue == 0) {
        [SVTool TextButtonAction:self.view withSing:@"密码设置不正确"];
    }else if (self.codeSucceed.integerValue == 0){
        [SVTool TextButtonAction:self.view withSing:@"验证码不正确"];
    }else{
        [SVUserManager loadUserInfo];
                   NSString *token = [SVUserManager shareInstance].access_token;
                   NSString *ShopId = [SVUserManager shareInstance].user_id;
          NSString *dURL1=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Manage",token];
                     [[SVSaviTool sharedSaviTool] GET:dURL1 parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                           NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                 NSLog(@"dic9999 == %@",dic);
                         NSArray *childInfolist = dic[@"data"][@"childInfolist"];
                         NSMutableDictionary *dict = childInfolist[0];
                          NSLog(@"dict777 == %@",dict);
                       NSInteger sv_config_is_enable = [dict[@"sv_config_is_enable"] integerValue];
                         if (sv_config_is_enable == 1) {
                             NSMutableDictionary *dict2 = childInfolist[1];
                            NSMutableArray *childDetailList = dict2[@"childDetailList"];
                            // NSMutableDictionary *detailDict = [NSMutableDictionary dictionary];
                          NSDictionary*detailDict = childDetailList[0];
                            // NSString *sv_detail_value = detailDict[@"sv_detail_value"];
                             NSMutableArray *parame = [NSMutableArray array];
                         // NSMutableDictionary *detailDictM = [detailDict mutableDicDeepCopy];
                             NSMutableDictionary *detailDictM = [NSMutableDictionary dictionary];
                             //密码进行MD5加密
                             NSString *pwdMD5=[JWXUtils EncodingWithMD5:self.twoText.text].uppercaseString;
                             detailDictM[@"sv_detail_value"] = pwdMD5;
                             [parame addObject:detailDictM];
                 //            [parame setValue:detailDictM forKey:@"UserModuleConfigdetailModel"];
                              NSString *dURL2=[URLhead stringByAppendingFormat:@"/api/UserModuleConfig?key=%@&moduleCode=Refund_Password_Value",token];
                             [[SVSaviTool sharedSaviTool] POST:dURL2 parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                                // NSLog(@"dic退款 = %@",dic);
                                 if ([dic[@"code"] integerValue] == 1) {
                                     [self.navigationController popViewControllerAnimated:YES];
                                     [SVTool TextButtonActionWithSing:@"修改完成"];
                                 }else{
                                     [SVTool TextButtonActionWithSing:dic[@"msg"]];
                                 }
                 
                 
                             } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                                      //隐藏提示框
                                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                             }];
                 
                         }
                 self.sureBtn.userInteractionEnabled = YES;
                     } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                           //隐藏提示框
                          self.sureBtn.userInteractionEnabled = YES;
                         [MBProgressHUD hideHUDForView:self.view animated:YES];
                         [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                     }];
    }
    
    
  
}


@end
