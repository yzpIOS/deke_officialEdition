//
//  SVVipDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/5/31.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVVipDetailsVC.h"
//修改会员
#import "SVModifyVipVC.h"
//会员充值
#import "SVVipChargeVC.h"
//会员销售
#import "SVSelectWaresVC.h"
//历史消费
#import "SVConsumptionHistoryVC.h"

#import "SVRepaymentVC.h"

#import "SVTimesCountVC.h"
#import "JJPhotoManeger.h"
#import "SVCardManagementVC.h"

@interface SVVipDetailsVC ()<JJPhotoDelegate>

//@property (weak, nonatomic) IBOutlet UIView *oneView;

//头像设置圆
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
//图片路径
@property (nonatomic,copy) NSString *imgURL;

/**
 折扣
 */
@property (nonatomic, copy) NSString *sv_ml_commondiscount;
/**
 会员ID
 */
@property (nonatomic, copy) NSString *member_id;

//卡号
@property (weak, nonatomic) IBOutlet UILabel *cardNumber;
//会员名
@property (weak, nonatomic) IBOutlet UILabel *vipName;

//会员等级
@property (weak, nonatomic) IBOutlet UILabel *vipLevel;
//会员级别ID
@property (nonatomic,assign) NSUInteger number;
//用户电话
//@property (weak, nonatomic) IBOutlet UILabel *phone;
@property (weak, nonatomic) IBOutlet UIButton *phoneButton;
@property (weak, nonatomic) IBOutlet UILabel *sv_registration;
@property (weak, nonatomic) IBOutlet UILabel *count;

//性别
@property (nonatomic,copy) NSString *gender;
//生日
@property (nonatomic,copy) NSString *birthday;

//地址
@property (nonatomic,copy) NSString *address;

//QQ
@property (nonatomic,copy) NSString *qq;
//微信
@property (nonatomic,copy) NSString *weChat;
//邮箱
@property (nonatomic,copy) NSString *email;
//备注
@property (nonatomic,copy) NSString *note;

@property (nonatomic,strong) NSMutableArray *modelArr;


//积分
@property (weak, nonatomic) IBOutlet UILabel *integral;
//储值余额
@property (weak, nonatomic) IBOutlet UILabel *balance;

//添加点击事件view
@property (weak, nonatomic) IBOutlet UIView *cellView;
@property (weak, nonatomic) IBOutlet UIView *vipView;
@property (weak, nonatomic) IBOutlet UIView *salesView;
@property (weak, nonatomic) IBOutlet UIView *consumptionView;

//设置点击事件的背影色
@property (weak, nonatomic) IBOutlet UIView *viewOne;
@property (weak, nonatomic) IBOutlet UIView *viewTwo;
@property (weak, nonatomic) IBOutlet UIView *viewThree;
@property (weak, nonatomic) IBOutlet UIView *viewFour;

@property (weak, nonatomic) IBOutlet UIView *hiddenView;
@property(nonatomic,strong)NSMutableArray *imageArr;
@property(nonatomic,strong)NSMutableArray *picUrlArr;

//@property (nonatomic,copy) NSString *sv_mw_availablepoint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *detailHeight;
@property (weak, nonatomic) IBOutlet UIView *detailView;
@property (nonatomic,strong) NSMutableArray *detailTextArray;
@property (nonatomic,strong) NSMutableArray *customArray;


@property (weak, nonatomic) IBOutlet UIView *cikaTaocanView;

/**
 分类折数组
 */
@property (nonatomic,strong) NSArray *getUserLevelArray;


/**
分类折配置数组
 */
@property (nonatomic,strong) NSArray *sv_discount_configArray;

@property (nonatomic,strong) NSString * telNumber;
@end

@implementation SVVipDetailsVC

- (NSMutableArray *)detailTextArray
{
    if (_detailTextArray == nil) {
        _detailTextArray = [NSMutableArray array];
    }
    return _detailTextArray;
}

- (NSMutableArray *)customArray
{
    if (_customArray == nil) {
        _customArray = [NSMutableArray array];
    }
    return _customArray;
}

- (NSArray *)getUserLevelArray{
    if (!_getUserLevelArray) {
        _getUserLevelArray = [NSArray array];
    }
    
    return _getUserLevelArray;
}

- (NSArray *)sv_discount_configArray{
    if (!_sv_discount_configArray) {
        _sv_discount_configArray = [NSArray array];
    }
    
    return _sv_discount_configArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"会员详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    
   [SVUserManager loadUserInfo];
      // 获取分类折
    self.getUserLevelArray = [SVUserManager shareInstance].getUserLevel;
          NSLog(@"getUserLevelArray = %@",self.getUserLevelArray);
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //隐藏暂时不用的View
    //    self.hiddenView.hidden = YES;
    
    //    self.oneView.backgroundColor = navigationBackgroundColor;
     self.title = @"会员详情";
    //设置view的圆角
    self.iconImg.layer.cornerRadius = 27.5;
    //UIImageView切圆的时候就要用到这一句了
    self.iconImg.layer.masksToBounds = YES;
    
    
    [self buttonResponse];
    [self loadGetMemberCustomList];
   
    [self ACharge];
    
    
    
}
- (IBAction)memberPayClick:(id)sender {
    [self repaymentResponseEvent];
}

- (void)loadGetMemberCustomList{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetMemberCustomInfo?key=%@&member_id=%@",[SVUserManager shareInstance].access_token,self.memberID];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
      //  [self.detailTextArray removeAllObjects];
       // NSMutableArray *array = dict[@"values"];
      //  [self.textArray addObjectsFromArray:array];
        if ([dict[@"succeed"] intValue] == 1) {
            [self.detailTextArray removeAllObjects];
            [self.detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
             NSMutableArray *array = dict[@"values"];
            self.customArray = array;
            for (NSDictionary *dic in array) {
                if (!kStringIsEmpty(dic[@"sv_field_value"])) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = dic[@"sv_field_name"];
                    dictM[@"detailText"] = dic[@"sv_field_value"];
                    [self.detailTextArray addObject:dictM];
                }
            }
            
            //请求数据
            [self requestData];
        }
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
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

           [appperance setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];

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

-(void)requestData{
    //token
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *setURL = [URLhead stringByAppendingFormat:@"/api/user/%@?key=%@",self.memberID,token];
    
    //请求
    [[SVSaviTool sharedSaviTool] GET:setURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic = %@",dic);
        
        if ([dic[@"succeed"] intValue] == 1) {
            
            NSDictionary *values = dic[@"values"];
            if (![SVTool isBlankDictionary:values]) {
                [self.detailTextArray removeAllObjects];
                [self.detailView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                //会员头像
                self.imgURL = [NSString stringWithFormat:@"%@",values[@"sv_mr_headimg"]];//3/5 报错
                if (![SVTool isBlankString:self.imgURL]) {
                    [self.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.imgURL]] placeholderImage:[UIImage imageNamed:@"iconView"]];
                } else {
                    self.iconImg.image = [UIImage imageNamed:@"iconView"];
                }
                
                _imageArr = [NSMutableArray array];
                //        _picUrlArr = [NSMutableArray array];
                [_imageArr addObject:self.iconImg];
                self.iconImg.userInteractionEnabled = YES;
                [_picUrlArr addObject:[NSString stringWithFormat:@"%@%@",URLHeadPortrait,self.imgURL]];
                //添加点击操作
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
                [tap addTarget:self action:@selector(tap:)];
                [self.iconImg addGestureRecognizer:tap];
                
                //会员名
                NSString *sv_mr_name = [NSString stringWithFormat:@"%@",values[@"sv_mr_name"]];
                self.vipName.text = sv_mr_name;
                
                //卡号
                NSString *sv_mr_cardno = [NSString stringWithFormat:@"%@",values[@"sv_mr_cardno"]];
                self.cardNumber.text = sv_mr_cardno;
                
                //会员等级
                 NSString *sv_ml_name = [NSString stringWithFormat:@"%@",values[@"sv_ml_name"]];
                if (!kStringIsEmpty(sv_ml_name)&& ![sv_ml_name isEqualToString:@"<null>"]) {
//                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
//                    dictM[@"name"] = @"QQ";
//                    dictM[@"detailText"] = sv_mr_qq;
//                    [self.detailTextArray addObject:dictM];
                    self.vipLevel.text = sv_ml_name;
                }else{
                    self.vipLevel.text = @"";
                }
               
                
                
                //会员ID
                NSString *member_id = [NSString stringWithFormat:@"%@",values[@"member_id"]];
                self.member_id = member_id;
                
                //会员等级篇号
               // NSString *memberlevel_id = [NSString stringWithFormat:@"%@",values[@"memberlevel_id"]];
                
                
                NSString *memberlevel_id = [NSString stringWithFormat:@"%@",values[@"memberlevel_id"]];
                if (!kStringIsEmpty(memberlevel_id)) {
                    self.number = [memberlevel_id integerValue];
                    for (NSDictionary *dict in self.getUserLevelArray) {
                        NSString *memberlevel_id_getUserLevel = [NSString stringWithFormat:@"%@",dict[@"memberlevel_id"]];
                        if ([memberlevel_id_getUserLevel isEqualToString:memberlevel_id]) {
                            NSString *sv_discount_config_json = dict[@"sv_discount_config"];
                            NSData *data = [sv_discount_config_json dataUsingEncoding:NSUTF8StringEncoding];
                            if (data != NULL) {
                                self.sv_discount_configArray = [NSJSONSerialization JSONObjectWithData: data options:NSJSONReadingAllowFragments error:nil];
                                NSLog(@"self.sv_discount_configArray = %@",self.sv_discount_configArray);
                            }
                            
                            
                            break;
                        }
                    }
                }
                
                //会员折扣
                self.sv_ml_commondiscount = [NSString stringWithFormat:@"%@",values[@"sv_ml_commondiscount"]];
                self.telNumber = [NSString stringWithFormat:@"%@",values[@"sv_mr_mobile"]];
                
                [SVUserManager loadUserInfo];
                          NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                   if (kDictIsEmpty(sv_versionpowersDict)) {
                       NSString *sv_mr_mobile = [NSString stringWithFormat:@"%@",values[@"sv_mr_mobile"]];
                                              [self.phoneButton setTitle:sv_mr_mobile forState:UIControlStateNormal];
                   }else{
                    NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
                       if ([MobilePhoneShow isEqualToString:@"1"]) {
                           NSString *sv_mr_mobile = [NSString stringWithFormat:@"%@",values[@"sv_mr_mobile"]];
                                                                        [self.phoneButton setTitle:sv_mr_mobile forState:UIControlStateNormal];
                       }else{
                               NSString *sv_mr_mobile_two = [NSString stringWithFormat:@"%@",values[@"sv_mr_mobile"]];
                           NSString *MobilePhone;
                           if (sv_mr_mobile_two.length < 11) {
                               MobilePhone = sv_mr_mobile_two;
                           }else{
                               MobilePhone = [[NSString stringWithFormat:@"%@",values[@"sv_mr_mobile"]] stringByReplacingCharactersInRange:NSMakeRange(3, 5)  withString:@"*****"];
                           }
                            [self.phoneButton setTitle:MobilePhone forState:UIControlStateNormal];
                       }
                   }
             
                
                //性别
                NSString *sv_mr_nick = [NSString stringWithFormat:@"%@",values[@"sv_mr_nick"]];
                self.gender = sv_mr_nick;
                if (!kStringIsEmpty(sv_mr_nick) && ![sv_mr_nick isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"称谓";
                    dictM[@"detailText"] = sv_mr_nick;
                    [self.detailTextArray addObject:dictM];
                }
                
                
                //生日
                NSString *sv_mr_birthday = [NSString stringWithFormat:@"%@",values[@"sv_mr_birthday"]];
                self.birthday = sv_mr_birthday;
                if (!kStringIsEmpty(sv_mr_birthday) && ![sv_mr_birthday isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"生日";
                    dictM[@"detailText"] = [sv_mr_birthday substringWithRange:NSMakeRange(5,5)];
                    [self.detailTextArray addObject:dictM];
                }
                
                //地址
                NSString *sv_mr_address = [NSString stringWithFormat:@"%@",values[@"sv_mr_address"]];
                self.address = sv_mr_address;
                if (!kStringIsEmpty(sv_mr_address)&& ![sv_mr_address isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"地址";
                    dictM[@"detailText"] = sv_mr_address;
                    [self.detailTextArray addObject:dictM];
                }
                
                //QQ
                NSString *sv_mr_qq = [NSString stringWithFormat:@"%@",values[@"sv_mr_qq"]];
                self.qq = sv_mr_qq;
                if (!kStringIsEmpty(sv_mr_qq)&& ![sv_mr_qq isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"QQ";
                    dictM[@"detailText"] = sv_mr_qq;
                    [self.detailTextArray addObject:dictM];
                }
                
                //微信
                NSString *sv_mr_wechat = [NSString stringWithFormat:@"%@",values[@"sv_mr_wechat"]];
                self.weChat = sv_mr_wechat;
                if (!kStringIsEmpty(sv_mr_wechat)&& ![sv_mr_wechat isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"微信";
                    dictM[@"detailText"] = sv_mr_wechat;
                    [self.detailTextArray addObject:dictM];
                }
                
                //邮箱
                NSString *sv_mr_email = [NSString stringWithFormat:@"%@",values[@"sv_mr_email"]];
                self.email = sv_mr_email;
                if (!kStringIsEmpty(sv_mr_email)&& ![sv_mr_email isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"邮箱";
                    dictM[@"detailText"] = sv_mr_email;
                    [self.detailTextArray addObject:dictM];
                }
                
                //备注
                NSString *sv_mr_remark = [NSString stringWithFormat:@"%@",values[@"sv_mr_remark"]];
                self.note = sv_mr_remark;
                if (!kStringIsEmpty(sv_mr_remark)&& ![sv_mr_remark isEqualToString:@"<null>"]) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"备注";
                    dictM[@"detailText"] = sv_mr_remark;
                    [self.detailTextArray addObject:dictM];
                }
                
                
                /**
                 车牌号码
                 */
                //备注
//                NSString *sv_mr_remark = [NSString stringWithFormat:@"%@",values[@"sv_mr_remark"]];
//                self.note = sv_mr_remark;
                if (!kStringIsEmpty(self.sv_mr_platenumber)) {
                    NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                    dictM[@"name"] = @"车牌号码";
                    dictM[@"detailText"] = self.sv_mr_platenumber;
                    [self.detailTextArray addObject:dictM];
                }
              //  @property (nonatomic,strong) NSString * sv_mr_platenumber;
                
                //积分
                NSString *sv_mw_availablepoint = [NSString stringWithFormat:@"%0.2f",[values[@"sv_mw_availablepoint"] floatValue]];
                self.integral.text = sv_mw_availablepoint;
                
                //储值余额
                NSString *sv_mw_availableamount = [NSString stringWithFormat:@"%@",values[@"sv_mw_availableamount"]];
                self.balance.text = [NSString stringWithFormat:@"%.2f",[sv_mw_availableamount floatValue]];
                
                if ([values[@"sv_registration"] floatValue] == 0) {
                    self.sv_registration.text = @"线下";
                } else {
                    self.sv_registration.text = @"微信";
                }
                
                if (!kArrayIsEmpty(self.detailTextArray)) {
                    self.detailHeight.constant = self.detailTextArray.count *40 + self.detailTextArray.count - 1;
                    for (int i = 0; i < self.detailTextArray.count; i++) {
                        NSDictionary *dict = self.detailTextArray[i];
                        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 40 *i +i, ScreenW, 40)];
                        view.backgroundColor = [UIColor whiteColor];
                        [self.detailView addSubview:view];
                        UILabel *leftLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 150, 30)];
                        leftLabel.textColor = [UIColor colorWithHexString:@"686868"];
                        leftLabel.font = [UIFont systemFontOfSize:14];
                      //  NSDictionary *dict = weakSelf.textArray[i];
                        leftLabel.text = [NSString stringWithFormat:@"%@",dict[@"name"]];
                        [leftLabel sizeToFit];
                        leftLabel.centerY = 40/2;
                        [view addSubview:leftLabel];
                        
                       
                        UILabel *rightLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenW - 10 - 150, 10, 150, 30)];
                        rightLabel.textColor = [UIColor colorWithHexString:@"686868"];
                        
                        rightLabel.font = [UIFont systemFontOfSize:14];
                        //  NSDictionary *dict = weakSelf.textArray[i];
                        rightLabel.text = [NSString stringWithFormat:@"%@",dict[@"detailText"]];
                       
                       // [rightLabel sizeToFit];
                        rightLabel.textAlignment = NSTextAlignmentRight;
                        
                     rightLabel.centerY = 40/2;
                        [view addSubview:rightLabel];
                    }
                }
            }
        }
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.selectNumber = 1;
    mg.delegate = self;
    [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
    // NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

-(void)ACharge {
    
    [SVUserManager loadUserInfo];
    NSString *setURL = [URLhead stringByAppendingFormat:@"/ACharge?key=%@&id=%@",[SVUserManager shareInstance].access_token,self.memberID];
    
    //请求
    [[SVSaviTool sharedSaviTool] GET:setURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        //  NSLog(@"dic = %@",dic);
        
        if ([dic[@"succeed"] floatValue] == 1) {
            [self.modelArr removeAllObjects];
            NSArray *array = dic[@"values"];
            for (NSDictionary *dict in array) {
                if ([dict[@"sv_mcc_leftcount"] doubleValue] >= 1) {
                    [self.modelArr addObject:dict];
                    self.count.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.modelArr.count];
                }
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

//跳转修改
-(void)rightbuttonResponseEvent{
    SVModifyVipVC *VC = [[SVModifyVipVC alloc]init];
    
    //图片
    VC.imgURL = self.imgURL;
    //卡号
    VC.cardNumber = self.cardNumber.text;
    
    //会员名
    VC.name = self.vipName.text;
    VC.memberID = self.memberID;
    
    //会员等级
    VC.vipLevel = self.vipLevel.text;
    VC.number = self.number;
    
    //用户电话
    VC.phone = self.phoneButton.titleLabel.text;
    VC.telNumber = self.telNumber;
    
    //性别
    VC.gender = self.gender;
    
    //生日
    VC.birthday = self.birthday;
    // 自定义字段
    VC.customArray = self.customArray;
    
    //地址
    VC.address = self.address;
    
    //QQ
    VC.qq = self.qq;
    
    //微信
    VC.weChat = self.weChat;
    
    //邮箱
    VC.email = self.email;
    
    //备注
    VC.note = self.note;
    VC.sv_mr_platenumber = self.sv_mr_platenumber;
    
    
    __weak typeof(self) weakSelf = self;
    VC.ModifyVipBlock = ^(){
        //请求数据
        [weakSelf loadGetMemberCustomList];
        if (weakSelf.VipDetailsBlock) {
            weakSelf.VipDetailsBlock();
        }
    };
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

//打电话
- (IBAction)cellResponseEvent {
    
//    //电话
//    if (![SVTool isBlankString:[SVUserManager shareInstance].sv_app_config]) {
//        
//        NSString *number = [SVUserManager shareInstance].sv_app_config;
//        if (number.length < 14) {
//            //判断电话号码
//            if (![SVTool valiMobile:self.phoneButton.titleLabel.text]) {
//                [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
//                return;
//            }
//            
//            NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneButton.titleLabel.text];
//            //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
//                
//            }];//此方法有一个报错
//        }else{
//            NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(14,1)];
//            
//            
//            if ([num isEqualToString:@"0"]) {
//                [SVTool TextButtonAction:self.view withSing:@"您没有权限拨打这个号码"];
//                
//            }else{// 不用显示*号
//                
//                //判断电话号码
//                if (![SVTool valiMobile:self.phoneButton.titleLabel.text]) {
//                    [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
//                    return;
//                }
//                
//                NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneButton.titleLabel.text];
//                //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
//                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
//                    
//                }];//此方法有一个报错
//                
//            }
//        }
//        //        NSString *num = [[SVUserManager shareInstance].sv_app_config substringWithRange:NSMakeRange(12+14,1)];
//        
//    }else{
//        //判断电话号码
//        if (![SVTool valiMobile:self.phoneButton.titleLabel.text]) {
//            [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
//            return;
//        }
//        
//        NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneButton.titleLabel.text];
//        //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
//            
//        }];//此方法有一个报错
//    }
    
    [SVUserManager loadUserInfo];
                             NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
                      if (kDictIsEmpty(sv_versionpowersDict)) {
                          //判断电话号码
                                    if (![SVTool valiMobile:self.phoneButton.titleLabel.text]) {
                                        [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
                                        return;
                                    }
                                    
                                    NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneButton.titleLabel.text];
                                    //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
                                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
                                        
                                    }];//此方法有一个报错
                      }else{
                       NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",sv_versionpowersDict[@"Member"][@"MobilePhoneShow"]];
                          if ([MobilePhoneShow isEqualToString:@"1"]) {
                              if (![SVTool valiMobile:self.phoneButton.titleLabel.text]) {
                                  [SVTool TextButtonAction:self.view withSing:@"号码有误,不能拨打"];
                                  return;
                              }
                              
                              NSMutableString *str=[[NSMutableString alloc] initWithFormat:@"tel:%@",self.phoneButton.titleLabel.text];
                              //    NSString *str = [NSString stringWithFormat:@"tel:%@",self.phone.text];
                              [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str] options:@{UIApplicationOpenURLOptionsSourceApplicationKey : @YES}  completionHandler:^(BOOL success) {//这句有一报错 / 2017.12.19
                                  
                              }];//此方法有一个报错
                                //判断电话号码
                          }else{
                               [SVTool TextButtonAction:self.view withSing:@"您没有权限拨打这个号码"];
                          }
                      }
    
    
    
}

#pragma mark - 手势与响应方法
- (void)buttonResponse{
    //初始化一个手势
    UITapGestureRecognizer *cellTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(vipResponseEvent)];
    //给dateLabel添加手势
    [self.cellView addGestureRecognizer:cellTap];
    
    //初始化一个手势
    UITapGestureRecognizer *vipTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(salesResponseEvent)];
    //给dateLabel添加手势
    [self.vipView addGestureRecognizer:vipTap];
    
    //初始化一个手势
    UITapGestureRecognizer *salesTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(consumptionResponseEvent)];
    //给dateLabel添加手势
    [self.salesView addGestureRecognizer:salesTap];
    
    //初始化一个手势
    UITapGestureRecognizer *consumptionTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(repaymentResponseEvent)];
    //给dateLabel添加手势
    [self.consumptionView addGestureRecognizer:consumptionTap];
    
    //初始化一个手势
    UITapGestureRecognizer *hiddenViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hiddenViewResponseEvent)];
    //给dateLabel添加手势
    [self.hiddenView addGestureRecognizer:hiddenViewTap];
    
    UITapGestureRecognizer *cikataocanTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cikataocanViewResponseEvent)];
    //给dateLabel添加手势
    [self.cikaTaocanView addGestureRecognizer:cikataocanTap];
    
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSLog(@"7777sv_versionpowersDict = %@",sv_versionpowersDict);
    
    if (kDictIsEmpty(sv_versionpowersDict)) {
        [self rightBtn];
    }else{
       NSDictionary *Member = sv_versionpowersDict[@"Member"];
        if (kDictIsEmpty(Member)) {
            [self rightBtn];
        }else{
            // 是否显示完整手机号
            NSString *UpdateMember = [NSString stringWithFormat:@"%@",Member[@"UpdateMember"]];
            if (kStringIsEmpty(UpdateMember)) {
                 [self rightBtn];
            }else{
                if ([UpdateMember isEqualToString:@"1"]) {
                   [self rightBtn];
                }else{
                  
                }
            }
        }
    }
    
}

- (void)rightBtn{
    //右上角按钮
               UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
               self.navigationItem.rightBarButtonItem = rightButon;
}

- (void)cikataocanViewResponseEvent{
    SVCardManagementVC *VC = [[SVCardManagementVC alloc] init];
    VC.member_id = self.member_id;
    VC.selectCount = 2;
    [self.navigationController pushViewController:VC animated:YES];
}

//充值
-(void)vipResponseEvent{
    
    [self.viewOne setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        SVVipChargeVC *VC = [[SVVipChargeVC alloc]init];
        VC.nameText = self.vipName.text;
        VC.careNum = self.cardNumber.text;
        VC.balance = self.balance.text;
        VC.memberID = self.memberID;
        VC.memberlevel_id = self.memberlevel_id;
        
        __weak typeof(self) weakSelf = self;
        VC.vipChargeBlock = ^{
            [weakSelf requestData];
            if (weakSelf.VipDetailsBlock) {
                weakSelf.VipDetailsBlock();
            }
        };
        
        [self.navigationController pushViewController:VC animated:YES];
        
        [self.viewOne setBackgroundColor:[UIColor clearColor]];
        
    });
    
}

#pragma mark - 会员销售
-(void)salesResponseEvent{
    __weak typeof(self) weakSelf = self;
    [self.viewTwo setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //        SVVipSalesVC *VC = [[SVVipSalesVC alloc]init];
        SVSelectWaresVC *VC = [[SVSelectWaresVC alloc] init];
        VC.interface = 2;
        VC.name = self.vipName.text;
        VC.phone = self.phoneButton.titleLabel.text;
        VC.discount = self.sv_ml_commondiscount;
        VC.member_id = self.member_id;
        VC.storedValue = self.balance.text;
        VC.headimg = self.imgURL;
        VC.sv_mr_cardno = self.cardNumber.text;
        VC.member_Cumulative = self.integral.text;
        VC.sv_discount_configArray = self.sv_discount_configArray;
        [self.navigationController pushViewController:VC animated:YES];
        VC.memberDetail = ^{
            [weakSelf requestData];
        };
        [self.viewTwo setBackgroundColor:[UIColor clearColor]];
    });
    
}

//历史消费
-(void)consumptionResponseEvent{
    
    [self.viewThree setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SVConsumptionHistoryVC *VC = [[SVConsumptionHistoryVC alloc]init];
        VC.memberID = self.member_id;
        [self.navigationController pushViewController:VC animated:YES];
        
        [self.viewThree setBackgroundColor:[UIColor clearColor]];
    });
    
}

-(void)repaymentResponseEvent {
    [self.viewFour setBackgroundColor:clickButtonBackgroundColor];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        SVRepaymentVC *VC = [[SVRepaymentVC alloc]init];
        VC.member_id = self.member_id;
        [self.navigationController pushViewController:VC animated:YES];
        
        [self.viewFour setBackgroundColor:[UIColor clearColor]];
    });
}
#pragma mark - 计次卡的点击
-(void)hiddenViewResponseEvent {
   // SVTimesCountVC
    SVTimesCountVC *VC = [[SVTimesCountVC alloc]init];
    VC.dateArr = self.modelArr;
    [self.navigationController pushViewController:VC animated:YES];
   
}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
