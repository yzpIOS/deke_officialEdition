//
//  SVRetrievePasswordOneVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRetrievePasswordOneVC.h"
#import "SVRetrievePasswordTwoVC.h"
//#import "SVProgressHUD.h"
#import "SVSaviTool.h"
#import "JWXUtils.h"

@interface SVRetrievePasswordOneVC ()

@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;

@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;

@property (weak, nonatomic) IBOutlet UIButton *attainButton;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIImageView *image;


@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet UIView *passView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telBottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passBottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopHeight;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation SVRetrievePasswordOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewTopHeight.constant = TopHeight + 20;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    if (@available(iOS 11.0, *)) {
              
              self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
              
          } else {
              
              if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
                  
                  self.edgesForExtendedLayout = UIRectEdgeNone;
                  
              }
              
          }
     self.scrollView.alwaysBounceVertical = YES;
    //navigation的标题
//    UILabel *tilet = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    tilet.text = @"重置密码";
//    tilet.textAlignment = NSTextAlignmentCenter;
//    tilet.textColor = GlobalFontColor;
//    self.navigationItem.titleView = tilet;
//    self.image.frame = CGRectMake(0, 0, ScreenW, ScreenH);
//    self.image.image = [UIImage imageNamed:@"ditu"];
    self.title = @"重置密码";
    //适配ios11偏移问题
//    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
//    self.navigationItem.backBarButtonItem = backltem;
    
//    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.textFieldOne.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldOne.placeholder.color}];
//         self.textFieldOne.attributedPlaceholder = placeholderString;
//
//
//         NSMutableAttributedString *placeholderStringTwo = [[NSMutableAttributedString alloc] initWithString:self.textFieldTwo.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldTwo.placeholder.color}];
//         self.textFieldTwo.attributedPlaceholder = placeholderStringTwo;
    
//    if (self.selectNum == 1) {
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, 44)];
//        image.image = [UIImage imageNamed:@"back_01"];
//        [self.view addSubview:image];
//    }else{
//        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//        image.image = [UIImage imageNamed:@"back_01"];
//        [self.view addSubview:image];
//    }
 
    
    //设置textField的圆

    self.attainButton.layer.cornerRadius = 10;
    self.attainButton.layer.masksToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.layer.masksToBounds = YES;

}

#pragma mark - 获取验证码
- (IBAction)getVerificationCode {
    if ([SVTool valiMobile:self.textFieldOne.text]){
         [self requestDataPhone:self.textFieldOne.text];
        [self countdown];
    }else{
        [SVTool TextButtonAction:self.view withSing:@"请输入正确的手机号"];
    }
}

#pragma mark - 下一步
- (IBAction)theNextStep {
    if ([SVTool isBlankString:self.textFieldOne.text]) {

        [SVTool TextButtonAction:self.view withSing:@"请输入手机号"];
        return;
    }

    if ([SVTool isBlankString:self.textFieldTwo.text]){

        [SVTool TextButtonAction:self.view withSing:@"请输入验证码"];
        return;
    }
    [self reqeutsValidationCodeVerification];
}

#pragma mark - 请求验证短信
-(void)requestDataPhone:(NSString *)phone{
    //    NSString *urlStr =  [NSString stringWithFormat:@"http://120.24.234.146:81/System/ResendVerificationCode"];
    NSString *sURL = [URLhead stringByAppendingString:@"/System/ResetVerificationCode2"];
    // NSString *moble = [NSString stringWithFormat:@"%@", self.textFieldOne.text];
    //将参数拼接到URL后面
    // NSString *sURL=[urlStr  stringByAppendingFormat:@"?&moble=%@",moble];
    NSString *pwd = @"visitor123456";
    //时间戳
    NSString *timestamp = [JWXUtils genTimeStamp];
    //随机数
    NSString *nonce = [NSString stringWithFormat:@"%d",arc4random()%1000000-1];
    //密码
    //   NSString *pwd = password;
    //密码进行MD5加密
    NSString *pwdMD5=[JWXUtils EncodingWithMD5:pwd].uppercaseString;
    //加入数组进行排序
    NSArray *values=[[NSArray alloc]initWithObjects:pwdMD5,timestamp,nonce, nil];
    //加入数组进行排序
    //  NSArray *values=[[NSArray alloc]initWithObjects:timestamp,nonce, nil];
    //转成字符串产生签名
    NSString  *signature=[JWXUtils asSortAndSubString:values];
    //把签名再次进行Hash MD5加密
    signature=[JWXUtils EncodingWithMD5:signature];
    //接收加密后的签名
    NSString *Signature = signature;
    
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:phone forKey:@"userName"];
    [parameters setObject:timestamp forKey:@"timestamp"];
    [parameters setObject:nonce forKey:@"nonce"];
    [parameters setObject:Signature forKey:@"signature"];
    
    NSLog(@"parameters= %@",parameters);
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"succeed"]integerValue] == 1) {
            
        } else {
            NSString *str = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
            [SVTool TextButtonAction:self.view withSing:str];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.textFieldOne) {
        self.telLabel.textColor = navigationBackgroundColor;
        self.telView.backgroundColor = navigationBackgroundColor;
        self.telBottomHeight.constant = 32;
    }else if (textField == self.textFieldTwo){
        self.passLabel.textColor = navigationBackgroundColor;
        self.passView.backgroundColor = navigationBackgroundColor;
        self.passBottomHeight.constant = 32;
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.textFieldOne) {
        self.telLabel.textColor = [UIColor whiteColor];
        self.telView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.telBottomHeight.constant = 5;
        }
    }else if (textField == self.textFieldTwo){
        self.passLabel.textColor = [UIColor whiteColor];
        self.passView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.passBottomHeight.constant = 5;
        }
       // self.telBottomHeight.constant = 32;
    }
}

#pragma mark - 请求验证码校验
-(void)reqeutsValidationCodeVerification{
   // 创建url
//    NSString *urlStr = [NSString stringWithFormat:@"http://120.24.234.146:81/api/login/checkoutCode"];
    NSString *urlStr = [URLhead stringByAppendingString:@"/api/login/checkoutCode"];
    NSString *code = [NSString  stringWithFormat:@"%@",self.textFieldTwo.text];
    NSString *moble = [NSString stringWithFormat:@"%@", self.textFieldOne.text];
    //将参数拼接到URL后面
    NSString *sURL=[urlStr  stringByAppendingFormat:@"?&moble=%@&code=%@",moble,code];

    [[SVSaviTool sharedSaviTool] POST:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if ([dict[@"succeed"] integerValue] == 1) {
            
            self.hidesBottomBarWhenPushed = YES;
            SVRetrievePasswordTwoVC *viewController = [[SVRetrievePasswordTwoVC alloc]init];
            viewController.phoneNum = self.textFieldOne.text;
            viewController.code = self.textFieldTwo.text;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
        } else {
            
            NSString *errmsg = dict[@"errmsg"];
            [SVTool TextButtonAction:self.view withSing:errmsg];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 按钮实现倒计时
-(void)countdown{
    //按钮实现倒计时
    __block int timeout=60; //倒计时时间
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(_timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(_timer, ^{
        if(timeout<=0){ //倒计时结束，关闭
            dispatch_source_cancel(_timer);
            dispatch_async(dispatch_get_main_queue(), ^{
                //设置界面的按钮显示 根据自己需求设置
                [self.attainButton setTitle:@"重新获取" forState:UIControlStateNormal];
                self.attainButton.userInteractionEnabled = YES;
                //self.attainButton.backgroundColor = [UIColor purpleColor];
            });
        }else{
            int seconds = timeout;
            NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
            dispatch_async(dispatch_get_main_queue(), ^{
                //让按钮变为不可点击的灰色
                //self.attainButton.backgroundColor = [UIColor grayColor];
                self.attainButton.userInteractionEnabled = NO;
                //设置界面的按钮显示 根据自己需求设置
                [UIView beginAnimations:nil context:nil];
                [UIView setAnimationDuration:1];
                [self.attainButton setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                [UIView commitAnimations];
            });
            timeout--;
        }
    });
    dispatch_resume(_timer);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}

@end
