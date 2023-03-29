//
//  SVRegisteredTwoVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVRegisteredTwoVC.h"
#import "SVRegisteredThreeVC.h"
#import "SVSaviTool.h"
#import "JWXUtils.h"

@interface SVRegisteredTwoVC ()<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textFieldOne;
@property (weak, nonatomic) IBOutlet UITextField *textFieldTwo;
@property (weak, nonatomic) IBOutlet UILabel *telLabel;
@property (weak, nonatomic) IBOutlet UILabel *passLabel;
@property (weak, nonatomic) IBOutlet UIView *telView;
@property (weak, nonatomic) IBOutlet UIView *passView;


@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIView *choiceView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *choiceViewHeight;
@property (nonatomic ,assign) BOOL selected;

@property (weak, nonatomic) IBOutlet UIButton *chorceBtn;
@property (nonatomic,strong) NSArray *industryArray;
@property (nonatomic,assign) int industrytype;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *viewTopHeight;
@property (weak, nonatomic) IBOutlet UIButton *registerNewBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *telBottomHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *passBottomHeight;
@property (weak, nonatomic) IBOutlet UIImageView *icon;

@end

@implementation SVRegisteredTwoVC
- (NSArray *)industryArray{
    if (_industryArray == nil) {
        _industryArray = [NSArray array];
    }
    return _industryArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (ScreenH <= 800) {
        self.icon.image = [UIImage imageNamed:@"icon_8p"];

    } else {
        self.icon.image = [UIImage imageNamed:@"icon_proMax"];
        
    }
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"注册帐号";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"注册帐号";
    self.viewTopHeight.constant = TopHeight + 20;
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    self.registerNewBtn.layer.cornerRadius = 22;
    self.registerNewBtn.layer.masksToBounds = YES;
    
    if (@available(iOS 11.0, *)) {
              
              self.scrollView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
              
          } else {
              
              if([UIViewController instancesRespondToSelector:@selector(edgesForExtendedLayout)]) {
                  
                  self.edgesForExtendedLayout = UIRectEdgeNone;
                  
              }
              
          }
     self.scrollView.alwaysBounceVertical = YES;
    
//    UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, TopHeight, ScreenW, 44)];
//    image.image = [UIImage imageNamed:@"back_02"];
//    [self.view addSubview:image];
    
//    self.choiceView.layer.cornerRadius = 25;
//    self.choiceView.layer.masksToBounds = YES;
    
    //设置textField的圆
    self.viewOne.layer.cornerRadius = 25;
    self.viewTwo.layer.cornerRadius = 25;
    self.button.layer.cornerRadius = 25;
    
    self.viewOne.backgroundColor = RGBA(250, 250, 250, 0.3);
    self.viewTwo.backgroundColor = RGBA(250, 250, 250, 0.3);
   // self.choiceView.backgroundColor = RGBA(250, 250, 250, 0.3);
    
//    NSMutableAttributedString *placeholderString = [[NSMutableAttributedString alloc] initWithString:self.textFieldOne.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldOne.placeholder.color}];
//      self.textFieldOne.attributedPlaceholder = placeholderString;
//
//      
//      NSMutableAttributedString *placeholderStringTwo = [[NSMutableAttributedString alloc] initWithString:self.textFieldTwo.placeholder attributes:@{NSForegroundColorAttributeName : self.textFieldTwo.placeholder.color}];
//      self.textFieldTwo.attributedPlaceholder = placeholderStringTwo;
      NSArray *industryArray = @[@"生活服务",@"商超零售",@"服装鞋帽",@"生鲜水果"];
    self.industryArray = industryArray;
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.contentSize = CGSizeMake(0, industryArray.count *60);
    [self.choiceView addSubview:scrollView];
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.choiceView.mas_left);
        make.right.mas_equalTo(self.choiceView.mas_right);
        make.top.mas_equalTo(self.chorceBtn.mas_bottom);
        make.bottom.mas_equalTo(self.choiceView.mas_bottom);
    }];
    scrollView.backgroundColor = [UIColor clearColor];

         CGFloat y = 0;
         //for (NSString *nameStr in industryArray) {
             for (int i = 0; i < industryArray.count; i++) {
                 NSString *nameStr = industryArray[i];
                   UIButton *btn =[UIButton buttonWithType:UIButtonTypeSystem];
                 btn.tag = i;
                 btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
                 btn.titleEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 0);
                 btn.titleLabel.font = [UIFont systemFontOfSize:15];
                 [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                 btn.frame = CGRectMake(0, y, ScreenW - 40, 60);
                 [btn setTitle:nameStr forState:UIControlStateNormal];
                 [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
                 y = CGRectGetMaxY(btn.frame);
                 [scrollView addSubview:btn];
             }
           
        // }

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

- (void)btnClick:(UIButton*)btn{
    [UIView animateWithDuration:.3 animations:^{
         //旋转
         self.chorceBtn.imageView.transform = CGAffineTransformRotate(self.chorceBtn.imageView.transform, M_PI);
     }];
    _selected = !_selected;
    switch (btn.tag) {
        case 0:
          //  =industryArray[btn.tag];
            [self.chorceBtn setTitle:self.industryArray[btn.tag] forState:UIControlStateNormal];
             self.choiceViewHeight.constant = 50;
            self.industrytype = 16;
            break;
            
            case 1:
                   //  =industryArray[btn.tag];
                     [self.chorceBtn setTitle:self.industryArray[btn.tag] forState:UIControlStateNormal];
             self.choiceViewHeight.constant = 50;
             self.industrytype = 15;
                     break;
            
            case 2:
                   //  =industryArray[btn.tag];
                     [self.chorceBtn setTitle:self.industryArray[btn.tag] forState:UIControlStateNormal];
             self.choiceViewHeight.constant = 50;
            self.industrytype = 18;
                     break;
            
            case 3:
                   //  =industryArray[btn.tag];
                     [self.chorceBtn setTitle:self.industryArray[btn.tag] forState:UIControlStateNormal];
             self.choiceViewHeight.constant = 50;
            self.industrytype = 5;
                     break;
            
        default:
            break;
    }
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
    //self.navigationController.navigationBar.subviews[0].subviews[0].hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
     [self.navigationController.navigationBar setTranslucent:false];
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

}


#pragma mark - 选择行业
- (IBAction)ChoiceClick:(id)sender {
    [UIView animateWithDuration:.3 animations:^{
         //旋转
         self.chorceBtn.imageView.transform = CGAffineTransformRotate(self.chorceBtn.imageView.transform, M_PI);
     }];
      NSLog(@"%d",_selected);
    
            _selected = !_selected;
    
            if(_selected) {
    
              self.choiceViewHeight.constant = 200;
    
            }else {
    
             self.choiceViewHeight.constant = 50;
    
            }
    
}

//跳转到下一个界面
- (IBAction)jumpToRegisteredAccountThree:(id)sender {
    //判断第一个textField是否为空
    if ([SVTool isBlankString:self.textFieldOne.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入店名"];
        return;
    }
    //判断第二个textField是否为空
    if ([SVTool isBlankString:self.textFieldTwo.text]){
        [SVTool TextButtonAction:self.view withSing:@"请输入姓名"];
        return;
    }
    
    //提示正在注册中
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在注册中…"];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        //请求数据
        [self requestData];
    });

    
}

-(void)requestData{
    
    if ([self.chorceBtn.titleLabel.text containsString:@"请选择行业"]) {
        [SVTool TextButtonActionWithSing:@"请选择行业"];
        //隐藏提示
                           [MBProgressHUD hideHUDForView:self.view animated:YES];
    }else{
          //NSString *urlStr = [NSString stringWithFormat:@"http://120.24.234.146:81/api/login/UserRegister"];
            NSString *urlStr = [URLhead stringByAppendingString:@"/api/login/UserRegister"];
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //    NSString *mobile = self.phoneNum;
        //    NSString *name = self.textFieldTwo.text;
        //    NSString *loginpwd = self.password;
        //    NSString *shopname = self.textFieldOne.text;
            [parameters setObject:self.textFieldOne.text forKey:@"sv_us_name"];
            [parameters setObject:self.textFieldTwo.text forKey:@"sv_ul_name"];
            [parameters setObject:self.phoneNum forKey:@"sv_ul_mobile"];
            [parameters setObject:@"IOS" forKey:@"sv_regsource"];
            [parameters setObject:[NSNumber numberWithInt:self.industrytype] forKey:@"sv_us_industrytype"];
            [parameters setObject:[JWXUtils EncodingWithMD5:self.password] forKey:@"sv_ul_loginpwd"];
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                //解析数据
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dict[@"succeed"] integerValue] == 1) {
                    
                    //跳转到下一个页面
                    self.hidesBottomBarWhenPushed = YES;
                    SVRegisteredThreeVC *viewController = [[SVRegisteredThreeVC alloc]init];
                    viewController.phoneNum = self.phoneNum;
                    viewController.password = self.password;
                    [self.navigationController pushViewController:viewController animated:YES];
                    self.hidesBottomBarWhenPushed = YES;
                    
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                } else {
                    
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    
                    NSString *errmsg = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
                    [SVTool TextButtonAction:self.view withSing:errmsg];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                
                [SVTool TextButtonAction:self.view withSing:@"网络出错!注册失败"];
            }];
    }
    
  
}



@end
