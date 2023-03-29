//
//  SVRegisteredOneVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRegisteredOneVC.h"
#import "SVRegisteredTwoVC.h"
#import "SVSaviTool.h"
#import "JWXUtils.h"
#import "SVAgreementVC.h"
#import "ImageCodeView.h"
@interface SVRegisteredOneVC ()<UINavigationControllerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UIButton *attainButton;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UITextField *textFieldThree;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
//@property (weak, nonatomic) IBOutlet UIView *codeView;



// 新的页面
@property (weak, nonatomic) IBOutlet UITextField *telText;
@property (weak, nonatomic) IBOutlet UITextField *passText;

@property (weak, nonatomic) IBOutlet UITextField *GraphicCodeText;
@property (weak, nonatomic) IBOutlet UITextField *codeText;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopHeight;

@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UILabel *GraphicCodeLabel;

@property (weak, nonatomic) IBOutlet UILabel *codeLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telBottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *GraphicCodeBottomHeight;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *codeBottomHeight;
@property (weak, nonatomic) IBOutlet UIView *telView;

@property (weak, nonatomic) IBOutlet UIView *passView;
@property (weak, nonatomic) IBOutlet UIView *GraphicCodeView;

@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet ImageCodeView *imageCodeView;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;

@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
/**
* 是否点击
*/
@property(nonatomic,assign)BOOL isSecected;

@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (nonatomic,strong)NSString *CodeStrT;
@property (nonatomic,assign) BOOL isCodeStr;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation SVRegisteredOneVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置navigation设置文字
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"注册帐号";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    
//    UIImageView *image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH)];
//    image.image = [UIImage imageNamed:@"LaudingImage_03"];
//    [self.view addSubview:image];
//    self.topHeight.constant = -TopHeight;
//    self.bottomHeight.constant = kTabbarHeight;
//    self.navigationController.delegate = self;
    //更改返回箭头颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.isCodeStr = false;
    [self.imageCodeView getStrCode];
    self.CodeStrT=self.imageCodeView.CodeStr;
    self.navigationItem.title = @"注册帐号";
    self.viewTopHeight.constant = TopHeight + 20;
    self.imageCodeView.layer.cornerRadius = 5;
    self.imageCodeView.layer.masksToBounds = YES;
    
    self.codeBtn.layer.cornerRadius = 5;
    self.codeBtn.layer.masksToBounds = YES;
    
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.layer.masksToBounds = YES;
    
    [self.selectBtn setImage:[UIImage imageNamed:@"box_select"] forState:UIControlStateSelected];
    [self.selectBtn setImage:[UIImage imageNamed:@"box_noSelect"] forState:UIControlStateNormal];
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
    
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//    image.image = [UIImage imageNamed:@"register_01"];
//    [self.view addSubview:image];
//    [image mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.size.mas_equalTo(CGSizeMake(ScreenW, 44));
//        make.top.mas_equalTo(self.view);
//        make.left.mas_equalTo(self.view);
//    }];
    
    //设置textField、button的圆
    self.viewOne.layer.cornerRadius = 25;
    self.viewTwo.layer.cornerRadius = 25;
    self.viewThree.layer.cornerRadius = 25;
    self.attainButton.layer.cornerRadius = 25;
    self.loginButton.layer.cornerRadius = 25;
    
    self.viewOne.backgroundColor = RGBA(250, 250, 250, 0.3);
    self.viewTwo.backgroundColor = RGBA(250, 250, 250, 0.3);
    self.viewThree.backgroundColor = RGBA(250, 250, 250, 0.3);
  //  self.attainButton.backgroundColor = RGBA(250, 250, 250, 0.3);
  //  self.codeView.backgroundColor = RGBA(250, 250, 250, 0.3);
    
    
//     NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.textFieldOne.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldOne.placeholder.color}];
//     self.textFieldOne.attributedPlaceholder = placeholderString;
//    
//     NSMutableAttributedString *placeholderStringTwo = [[NSMutableAttributedString alloc] initWithString:@"请输入密码" attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
//         self.textFieldTwo.attributedPlaceholder = placeholderStringTwo;
//    
//    NSMutableAttributedString *placeholderStringthree = [[NSMutableAttributedString alloc] initWithString:self.textFieldThree.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldThree.placeholder.color}];
//    self.textFieldThree.attributedPlaceholder = placeholderStringthree;
    
   
    
}
#pragma mark - 服务条款
- (IBAction)serverClick:(id)sender {
    self.hidesBottomBarWhenPushed =YES;
    SVAgreementVC *viewControler = [[SVAgreementVC alloc]init];
    viewControler.pathName = @"service";
    [self.navigationController pushViewController:viewControler animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField == self.telText) {
        self.telLabel.textColor = navigationBackgroundColor;
        self.telView.backgroundColor = navigationBackgroundColor;
        self.telBottomHeight.constant = 32;
    }else if (textField == self.passText){
        self.passLabel.textColor = navigationBackgroundColor;
        self.passView.backgroundColor = navigationBackgroundColor;
        self.passBottomHeight.constant = 32;
    }else if (textField == self.GraphicCodeText){
        self.GraphicCodeLabel.textColor = navigationBackgroundColor;
        self.GraphicCodeView.backgroundColor = navigationBackgroundColor;
        self.GraphicCodeBottomHeight.constant = 32;
    }else{
     
            self.codeLabel.textColor = navigationBackgroundColor;
            self.codeView.backgroundColor = navigationBackgroundColor;
            self.codeBottomHeight.constant = 32;
       
        
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField == self.telText) {
        self.telLabel.textColor = [UIColor whiteColor];
        self.telView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.telBottomHeight.constant = 5;
        }
    }else if (textField == self.passText){
        self.passLabel.textColor = [UIColor whiteColor];
        self.passView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.passBottomHeight.constant = 5;
        }
       // self.telBottomHeight.constant = 32;
    }else if (textField == self.GraphicCodeText){
        self.GraphicCodeLabel.textColor = [UIColor whiteColor];
        self.GraphicCodeView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.GraphicCodeBottomHeight.constant = 5;
        }
        
        __weak typeof(self)weakSelf = self;
        self.imageCodeView.CodeStrBlock = ^(NSString *CodeStr) {
            NSLog(@"CodeStr = %@",CodeStr);
            weakSelf.CodeStrT = CodeStr;
        };
        //    不区分大小写
            BOOL result = [textField.text compare:weakSelf.CodeStrT
                                     options:NSCaseInsensitiveSearch |NSNumericSearch] == NSOrderedSame;
            // 区分大小写
         //   BOOL result2 = [_str isEqualToString:_codeTextField.text];
            if (!result) {
                self.isCodeStr = false;
                return [SVTool TextButtonAction:self.view withSing:@"验证码有误"];
            }else{
                self.isCodeStr = true;
            }
       // self.telBottomHeight.constant = 32;
    }else{
        self.codeLabel.textColor = [UIColor whiteColor];
        self.codeView.backgroundColor = [UIColor whiteColor];
        if (kStringIsEmpty(textField.text)) {
            self.codeBottomHeight.constant = 5;
        }

    }
}

- (IBAction)bbuttonClick:(UIButton *)btn {
   
       _isSecected = !_isSecected;
//    sender.selected = !sender.selected;
//   // self.isAllSelect = sender.selected;
//    self.isSecected = sender.selected;
       if (_isSecected) {
           NSLog(@"选中");
           [self.selectBtn setImage:[UIImage imageNamed:@"box_select"] forState:UIControlStateNormal];
       }
       else
       {
           [self.selectBtn setImage:[UIImage imageNamed:@"box_noSelect"] forState:UIControlStateNormal];
           
           NSLog(@"取消选中");
       }
    
//    if (btn.selected == YES) {// 取消全选
//        [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
//        NSInteger totle = 0;
//        for (NSMutableArray *array in self.moreSpecifications) {
//            for (SVWaresListModel *model in array) {
//                model.isSelect = @"0";
//////                    model.sv_p_storage = self.textField.text;
////                NSInteger toCount = [model.sv_p_storage integerValue];
////                totle += toCount;
//
//            }
//        }
//        self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
//        [self.tableView reloadData];
//        self.allSelectBtn.selected = NO;
//
//    }else{// 全选
//        [self.allSelectBtn setImage:[UIImage imageNamed:@"ic_mo-ren"] forState:UIControlStateNormal];
//
//        NSInteger totle = 0;
//        for (NSMutableArray *array in self.moreSpecifications) {
//            for (SVWaresListModel *model in array) {
//                model.isSelect = @"1";
//               // model.sv_p_storage = self.textField.text;
//
//                NSInteger toCount = [model.sv_p_storage integerValue];
//                totle += toCount;
//
//            }
//        }
//        self.totleNumber.text = [NSString stringWithFormat:@"%ld",totle];
//        [self.tableView reloadData];
//         self.allSelectBtn.selected = YES;
//    }
}

//#pragma mark--点击获取验证码的按钮
//
//- (IBAction)getVerificationCode {
//    //判断textFieldOne.text是否是手机号
//    if ([SVTool valiMobile:self.textFieldOne.text]) {
//        //倒计时
//        [self countdown];
//        //请求验证码
//        [self requestValidation];
//    }else{
//        [SVTool TextButtonAction:self.view withSing:@"请输入正确的电话号码"];
//    }
//}

#pragma mark--跳转到一下个注册界面
- (IBAction)jumpToRegisteredAccountTwo:(id)sender {
    
//    self.hidesBottomBarWhenPushed = YES;
//    SVRegisteredTwoVC *viewController = [[SVRegisteredTwoVC alloc]init];
//    viewController.phoneNum = self.telText.text;
//    viewController.password = self.passText.text;
//    [self.navigationController pushViewController:viewController animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
    
    if (self.isSecected == NO) {
        [SVTool TextButtonAction:self.view withSing:@"请同意用户协议"];
    }else if ([SVTool isBlankString:self.telText.text]) {

        [SVTool TextButtonAction:self.view withSing:@"请输入手机号"];

    }else if ([SVTool isBlankString:self.passText.text]) {

        [SVTool TextButtonAction:self.view withSing:@"请输入密码"];

    }else if ([SVTool isBlankString:self.GraphicCodeText.text]){
        [SVTool TextButtonAction:self.view withSing:@"请输入图形码"];
    }else {

        if ([SVTool isBlankString:self.codeText.text]) {
            [SVTool TextButtonAction:self.view withSing:@"请输入验证码"];
        } else {
            //请求验证短信
            [self reqeutsValidationCodeVerification];
        }
    }
    
}

#pragma mark - 跳转德客协议按钮
- (IBAction)agreementButton {
    self.hidesBottomBarWhenPushed =YES;
    SVAgreementVC *viewControler = [[SVAgreementVC alloc]init];
    [self.navigationController pushViewController:viewControler animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
}

#pragma mark - 隐私条款
- (IBAction)PrivacyClick:(id)sender {
    self.hidesBottomBarWhenPushed =YES;
    SVAgreementVC *viewControler = [[SVAgreementVC alloc]init];
    viewControler.pathName = @"privacy";
    [self.navigationController pushViewController:viewControler animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}

#pragma mark - 获取验证码
- (IBAction)obtainCodeClick:(id)sender {
    if (self.isCodeStr == false) {
        return [SVTool TextButtonAction:self.view withSing:@"验证码有误"];
    }else{
        //判断textFieldOne.text是否是手机号
        if ([SVTool valiMobile:self.telText.text]) {
            //倒计时
            [self countdown];
            //请求验证码
            [self requestValidation];
        }else{
            [SVTool TextButtonAction:self.view withSing:@"请输入正确的电话号码"];
        }
    }
   
}


#pragma mark - 请求注册发送验证码
- (void)requestValidation{
    //创建URL  
//    NSString *urlStr =  [NSString stringWithFormat:@"http://120.24.234.146:81/api/login/Sendsms_reg"];
    NSString *urlStr = [URLhead stringByAppendingString:@"/api/login/Sendsms_reg"];
    //
    NSString *nonce=[NSString stringWithFormat:@"%d",arc4random()%1000000-1];
    //
    NSString *timestamp=[JWXUtils genTimeStamp];
    
    NSString *pwd=@"visitor123456";
    //创建可变数组
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:timestamp forKey:@"timestamp"];
    
    [parameters setObject:nonce forKey:@"nonce"];
    
    [parameters setObject:pwd forKey:@"pwd"];
    //
    NSString *pwdMD5=[parameters objectForKey:@"pwd"];
    //
    NSArray *values=[[NSArray alloc]initWithObjects:pwdMD5,[parameters objectForKey:@"timestamp"],[parameters objectForKey:@"nonce"], nil];
    //转成字符串
    NSString  *signature=[JWXUtils asSortAndSubString:values];
    
    signature=[JWXUtils EncodingWithMD5:signature];
    
    NSString *Signature= signature;
    
    NSString *number = self.telText.text;
    
    [parameters setObject:Signature forKey:@"Signature"];
    
    [parameters setObject:number forKey:@"userName"];
    
    [parameters removeObjectForKey:@"pwd"];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if ([dic[@"succeed"]integerValue] == 1) {
            
        }else{
            NSString *errmsg = dic[@"errmsg"];
            [SVTool TextButtonAction:self.view withSing:errmsg];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

#pragma mark - 下一步请求
-(void)reqeutsValidationCodeVerification{
    //创建url
//    NSString *urlStr = [NSString stringWithFormat:@"http://120.24.234.146:81/api/login/checkoutCode"];
    NSString *urlStr = [URLhead stringByAppendingString:@"/api/login/checkoutCode"];
    NSString *code = [NSString  stringWithFormat:@"%@",self.codeText.text];
    NSString *moble = [NSString stringWithFormat:@"%@", self.telText.text];
    //将参数拼接到URL后面
    NSString *sURL=[urlStr  stringByAppendingFormat:@"?&moble=%@&code=%@",moble,code];

    [[SVSaviTool sharedSaviTool] POST:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

        if ([dict[@"succeed"]integerValue] == 1) {
            self.hidesBottomBarWhenPushed = YES;
            SVRegisteredTwoVC *viewController = [[SVRegisteredTwoVC alloc]init];
            viewController.phoneNum = self.telText.text;
            viewController.password = self.passText.text;
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = NO;
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
                    [self.codeBtn setTitle:@"重新获取" forState:UIControlStateNormal];
                    self.codeBtn.userInteractionEnabled = YES;
//                    self.attainButton.backgroundColor = [UIColor purpleColor];
                });
            }else{
                int seconds = timeout;
                NSString *strTime = [NSString stringWithFormat:@"%.2d", seconds];
                dispatch_async(dispatch_get_main_queue(), ^{
                    //让按钮变为不可点击的灰色
//                    self.attainButton.backgroundColor = [UIColor grayColor];
                    self.codeBtn.userInteractionEnabled = NO;
                    //设置界面的按钮显示 根据自己需求设置
                    [UIView beginAnimations:nil context:nil];
                    [UIView setAnimationDuration:1];
                    [self.codeBtn setTitle:[NSString stringWithFormat:@"%@s",strTime] forState:UIControlStateNormal];
                    [UIView commitAnimations];
                });
                timeout--;
            }
        });
        dispatch_resume(_timer);
}

//- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated{
//
//    //隐藏导航栏
//    BOOL isVC = [viewController isKindOfClass:[self class]];
//    [self.navigationController setNavigationBarHidden:isVC animated:YES];
//}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    //设置导航栏透明
    [self.navigationController.navigationBar setTranslucent:true];
    //把背景设为空
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //处理导航栏有条线的问题
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
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
