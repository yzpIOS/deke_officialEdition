//
//  SVRetrievePasswordTwoVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRetrievePasswordTwoVC.h"
#import "JWXUtils.h"
#import "SVSaviTool.h"
#import "SVRetrievePasswordThreeVC.h"

@interface SVRetrievePasswordTwoVC ()
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIButton *button;

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

@implementation SVRetrievePasswordTwoVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //navigation的标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"重置密码";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"重置密码";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//    image.image = [UIImage imageNamed:@"register_02"];
//    [self.view addSubview:image];
    
    if (@available(iOS 11.0, *)) {
              
              self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
              
          } else {
              
              if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
                  
                  self.edgesForExtendedLayout = UIRectEdgeNone;
                  
              }
              
          }
     self.scrollView.alwaysBounceVertical = YES;
    
    //设置textField的圆
//    self.viewOne.layer.cornerRadius = 25;
//    self.viewTwo.layer.cornerRadius = 25;
//    self.button.layer.cornerRadius = 25;
    
//    self.viewOne.backgroundColor = RGBA(250, 250, 250, 0.3);
//     self.viewTwo.backgroundColor = RGBA(250, 250, 250, 0.3);
//
//     NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.textFieldOne.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldOne.placeholder.color}];
//          self.textFieldOne.attributedPlaceholder = placeholderString;
//
//
//          NSMutableAttributedString *placeholderStringTwo = [[NSMutableAttributedString alloc] initWithString:self.textFieldTwo.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldTwo.placeholder.color}];
//          self.textFieldTwo.attributedPlaceholder = placeholderStringTwo;
    self.viewTopHeight.constant = TopHeight + 20;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.nextBtn.layer.cornerRadius = 22;
    self.nextBtn.layer.masksToBounds = YES;
}

#pragma mark - 修改密码确定按钮
- (IBAction)passwordButton {
    
    if ([SVTool isBlankString:self.textFieldOne.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入新密码"];
        return;
    }
    
    if ([SVTool isBlankString:self.textFieldTwo.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请再次输入新密码"];
        return;
    }
    
    
    if ([self.textFieldOne.text isEqualToString: self.textFieldTwo.text]) {
        [self reqouesData];
    }else{
        [SVTool TextButtonAction:self.view withSing:@"密码不一致"];
    }
    
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


#pragma mark - 修改密码的请求
-(void)reqouesData{
//    NSString *urlStr = [NSString stringWithFormat:@"http://120.24.234.146:81/System/RetrievePasswordWithCode"];
    NSString *urlStr = [URLhead stringByAppendingString:@"/System/RetrievePasswordWithCode"];
    //密码
    NSString *password = [NSString stringWithFormat:@"%@",self.textFieldTwo.text];
    //手机号码
    NSString *moble = [NSString stringWithFormat:@"%@",self.phoneNum];
    //验证码
    NSString *code = [NSString stringWithFormat:@"%@",self.code];//@"?&moble=%@&code=%@"
    NSString *sURL=[urlStr  stringByAppendingFormat:@"?password=%@&moble=%@&code=%@",password,moble,code];
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"succeed"] integerValue] == 1) {
            //跳转
            self.hidesBottomBarWhenPushed = YES;
            SVRetrievePasswordThreeVC *viewController = [[SVRetrievePasswordThreeVC alloc]init];
            [self.navigationController pushViewController:viewController animated:YES];
            self.hidesBottomBarWhenPushed = YES;
            
        }else {
            
            NSString *errmsg = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
            [SVTool TextButtonAction:self.view withSing:errmsg];
            
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (void)viewWillAppear:(BOOL)animated{
    
    //设置导航栏背景图片为一个空的image，这样就透明了
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    
    //去掉透明后导航栏下边的黑边
    [self.navigationController.navigationBar setShadowImage:[[UIImage alloc] init]];
     self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    //    如果不想让其他页面的导航栏变为透明 需要重置
//    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
//    [self.navigationController.navigationBar setShadowImage:nil];
//     self.navigationController.navigationBar.tintColor = GlobalFontColor;
//    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:GlobalFontColor}];
//    //更改navigation的背景色
//     self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
}

@end
