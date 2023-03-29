//
//  SVMembershipLevelEditVC.m
//  SAVI
//
//  Created by 杨忠平 on 2022/7/24.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVMembershipLevelEditVC.h"
#import "SVDiscountAndNumberView.h"
#import "HLPopTableView.h"

@interface SVMembershipLevelEditVC ()
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (nonatomic,strong) SVDiscountAndNumberView *discountAndNumberView;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;

@property (weak, nonatomic) IBOutlet UIButton *menberBtn;
@property (weak, nonatomic) IBOutlet UIButton *saveBtn;
@property (nonatomic,assign) NSInteger index;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
@property (weak, nonatomic) IBOutlet UITextField *sv_ml_name;

@property (weak, nonatomic) IBOutlet UITextField *sv_ml_commondiscount;

@end

@implementation SVMembershipLevelEditVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = BlueBackgroundColor;
    self.saveBtn.backgroundColor = navigationBackgroundColor;
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap1Click)];
    [self.oneView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap2Click)];
    [self.twoView addGestureRecognizer:tap2];
    [self.menberBtn setTitle:@"" forState:UIControlStateNormal];
    self.menberBtn.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.menberBtn.layer.borderWidth = 1;
    [self.menberBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    self.menberBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    
//    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap3Click:)];
//    [self.threeView addGestureRecognizer:tap3];
    self.index = 0;
    if (self.model) {
        self.title = @"修改会员等级";
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"删除" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
        self.sv_ml_name.text = self.model.sv_ml_name;
        self.sv_ml_commondiscount.text = [NSString stringWithFormat:@"%ld",(long)self.model.sv_ml_commondiscount];
        self.oneLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.sv_ml_initpoint];
        self.twoLabel.text = [NSString stringWithFormat:@"%ld",(long)self.model.sv_ml_endpoint];
       
        if (self.model.sv_grade_price != NULL) {
            NSDictionary *dict = [SVTool dictionaryWithJsonString:self.model.sv_grade_price];
           NSString *v = dict[@"v"];
            if (v.intValue != 0) {
                [self.menberBtn setTitle:[NSString stringWithFormat:@"会员价%@",v] forState:UIControlStateNormal];
                self.index = v.intValue;
            }else{
                [self.menberBtn setTitle:@"" forState:UIControlStateNormal];
            }
           
        }else{
            [self.menberBtn setTitle:@"" forState:UIControlStateNormal];
        }
        
    }else{
        self.title = @"新增会员等级";
    }
}

- (void)selectbuttonResponseEvent{
    
    __weak typeof(self) weakSelf = self;
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除此会员等级吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [SVUserManager loadUserInfo];
        NSString *url = [URLhead stringByAppendingFormat:@"/api/UserV2/DeleteLive?key=%@",[SVUserManager shareInstance].access_token];
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        parame[@"id"] = [NSString stringWithFormat:@"%ld",(long)self.model.memberlevel_id];
        [[SVSaviTool sharedSaviTool] POST:url parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            if ([dic[@"code"] intValue] == 1) {
                [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                [self.navigationController popViewControllerAnimated:YES];
                if (self.suessBlock) {
                    self.suessBlock();
                }
              
            }else{
                NSString *msg = dic[@"msg"];
                if (kStringIsEmpty(msg)) {
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }else{
                    [SVTool TextButtonAction:self.view withSing:msg];
                }
                
            }
            
           
            
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:derAction];
    
    [alertController addAction:cancelAction];
    
    [weakSelf presentViewController:alertController animated:YES completion:nil];
}

- (void)tap1Click{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
    __weak typeof(self) weakSelf = self;
    self.discountAndNumberView.integralBlock = ^(NSString * _Nonnull integral) {
        weakSelf.discountAndNumberView.sumLabel.text = @"请输入积分";
        weakSelf.discountAndNumberView.sumLabel.textColor = [UIColor lightGrayColor];
        weakSelf.oneLabel.text = integral;
        [weakSelf dateCancelResponseEvent];
    };
    
    
    
    self.discountAndNumberView.clearBlock = ^{
        [weakSelf dateCancelResponseEvent];
    };
}

- (void)tap2Click{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
    __weak typeof(self) weakSelf = self;
    
    self.discountAndNumberView.integralBlock = ^(NSString * _Nonnull integral) {
        weakSelf.discountAndNumberView.sumLabel.text = @"请输入积分";
        weakSelf.twoLabel.text = integral;
        [weakSelf dateCancelResponseEvent];
    };
    
    
    
    self.discountAndNumberView.clearBlock = ^{
        [weakSelf dateCancelResponseEvent];
    };
}
#pragma mark - 点击会员价配置
- (IBAction)memberClick:(UIButton *)sender {
    
    NSArray * arr = @[@"会员价1",@"会员价2",@"会员价3",@"会员价4",@"会员价5"];
    HLPopTableView * hlPopView = [HLPopTableView initWithFrame:CGRectMake(0, 0, sender.width-5,220) dependView:sender textArr:arr block:^(NSString *region_name, NSInteger index) {
    //        self.selectTime = region_name;
    //        [self.yearBtn setTitle:region_name forState:UIControlStateNormal];
    //        NSLog(@"region_name = %@",region_name);
        self.index = index+1;
        [self.menberBtn setTitle:region_name forState:UIControlStateNormal];
       
        
    }];
    [self.view addSubview:hlPopView];
}


- (IBAction)saveClick:(id)sender {
    
    if (self.sv_ml_commondiscount.text.doubleValue < 0.01) {
        return  [SVTool TextButtonActionWithSing:@"折扣范围在0.01~10之间"];
    }
    
    if (self.sv_ml_commondiscount.text.doubleValue > 10.0) {
        return  [SVTool TextButtonActionWithSing:@"折扣范围在0.01~10之间"];
    }
    if (self.model) {
     
      
            [SVTool IndeterminateButtonAction:self.view withSing:nil];
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/UserV2/UpdateLive?key=%@",[SVUserManager shareInstance].access_token];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            NSMutableArray *array = [NSMutableArray array];
            [array addObject:parame];
            parame[@"memberlevel_id"] = [NSNumber numberWithInteger:self.model.memberlevel_id];
            parame[@"sv_discount_config"] = @"[]"; // dictionaryToJson
            parame[@"sv_grade_price"] = [NSString stringWithFormat:@"{\"i\":2,\"n\":\"\",\"t\":1,\"v\":%ld}",(long)self.index];
            parame[@"sv_ml_commondiscount"] = [NSNumber numberWithDouble:self.sv_ml_commondiscount.text.doubleValue];
            parame[@"sv_ml_endpoint"] = self.twoLabel.text;
            parame[@"sv_ml_initpoint"] = self.oneLabel.text;
            parame[@"sv_ml_name"] = self.sv_ml_name.text;
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:array progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([dic[@"code"] intValue] == 1) {
                  //  [self loadUpdateMemberlevelPriceData:dic];
                    [SVTool TextButtonAction:self.view withSing:@"请求成功"];
                    [self.navigationController popViewControllerAnimated:YES];
                    if (self.suessBlock) {
                        self.suessBlock();
                    }
                }else{
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                   // [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                    NSString *msg = dic[@"msg"];
                    if (kStringIsEmpty(msg)) {
                        [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                    }else{
                        [SVTool TextButtonAction:self.view withSing:msg];
                    }
                   
                }
                
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                }];
      //  }
      
    }else{
      //  if (self.sv_ml_commondiscount.text.doubleValue <= 10.0) {
            [SVTool IndeterminateButtonAction:self.view withSing:nil];
            [SVUserManager loadUserInfo];
            NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/UserV2/AddLive?key=%@",[SVUserManager shareInstance].access_token];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"memberlevel_id"] = @"0";
            parame[@"sv_discount_config"] = @"[]"; // dictionaryToJson
            parame[@"sv_grade_price"] = [NSString stringWithFormat:@"{\"i\":2,\"n\":\"\",\"t\":1,\"v\":%ld}",(long)self.index];
            parame[@"sv_ml_commondiscount"] = [NSNumber numberWithDouble:self.sv_ml_commondiscount.text.doubleValue];
            parame[@"sv_ml_endpoint"] = self.twoLabel.text;
            parame[@"sv_ml_initpoint"] = self.oneLabel.text;
            parame[@"sv_ml_name"] = self.sv_ml_name.text;
            [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                if ([dic[@"code"] intValue] == 1) {
                    [self loadUpdateMemberlevelPriceData:dic];
                }else{
                   
                   // [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                    NSString *msg = dic[@"msg"];
                    if (kStringIsEmpty(msg)) {
                        [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                    }else{
                        [SVTool TextButtonAction:self.view withSing:msg];
                    }
                   
                }
                
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
                }];
//        }else{
//            [SVTool TextButtonActionWithSing:@"折扣范围在0.01~10之间"];
//        }
     
    }
 
}

- (void)loadUpdateMemberlevelPriceData:(NSDictionary *)data{
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/UserModuleConfig/UpdateMemberlevelPrice?key=%@",[SVUserManager shareInstance].access_token];
    NSMutableDictionary *parame = [NSMutableDictionary dictionary];
    parame[@"jsonStr"] = [NSString stringWithFormat:@"{\"i\":2,\"n\":\"\",\"t\":1,\"v\":%ld}",(long)self.index];
    parame[@"id"]= data[@"data"];
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"code"] intValue] == 1) {
            [SVTool TextButtonAction:self.view withSing:@"请求成功"];
            [self.navigationController popViewControllerAnimated:YES];
            if (self.suessBlock) {
                self.suessBlock();
            }else{
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"数据开小差了"];
            }
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
    }];
}




- (SVDiscountAndNumberView *)discountAndNumberView{
    if (!_discountAndNumberView) {
        _discountAndNumberView = [[NSBundle mainBundle]loadNibNamed:@"SVDiscountAndNumberView" owner:nil options:nil].lastObject;
        _discountAndNumberView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
          _discountAndNumberView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _discountAndNumberView.layer.cornerRadius = 10;
        _discountAndNumberView.nameLabel.text = @"积分区间";
        _discountAndNumberView.isHiddenDecimalPoint = true;
        _discountAndNumberView.sumLabel.text = @"请输入积分";
        _discountAndNumberView.layer.masksToBounds = YES;
        [_discountAndNumberView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _discountAndNumberView;
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

//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.discountAndNumberView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    
    titleLabel.font = [UIFont systemFontOfSize:17];
    
    titleLabel.textColor = [UIColor whiteColor];;
    
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    titleLabel.text=self.title;
    
    self.navigationItem.titleView = titleLabel;
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = navigationBackgroundColor;

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
       [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
    
    if (@available(iOS 15.0, *)) {

           UINavigationBarAppearance *appperance = [[UINavigationBarAppearance alloc]init];

           //添加背景色

           appperance.backgroundColor = [UIColor whiteColor];

           appperance.shadowImage = [[UIImage alloc]init];

           appperance.shadowColor = nil;

           //设置字体颜色

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:GlobalFontColor}];

           self.navigationController.navigationBar.standardAppearance = appperance;

           self.navigationController.navigationBar.scrollEdgeAppearance = appperance;
        
          UITabBarAppearance * bar2 = [UITabBarAppearance new];
              bar2.backgroundColor = [UIColor whiteColor];
              bar2.backgroundEffect = nil;
              self.tabBarController.tabBar.scrollEdgeAppearance = bar2;
              self.tabBarController.tabBar.standardAppearance = bar2;

    }
}

@end
