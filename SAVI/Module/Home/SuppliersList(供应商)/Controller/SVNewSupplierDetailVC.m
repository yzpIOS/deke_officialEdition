//
//  SVNewSupplierDetailVC.m
//  SAVI
//
//  Created by houming Wang on 2021/4/13.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVNewSupplierDetailVC.h"
#import "SVSupplierListModel.h"
#import "SVAddSupplierVC.h"
#import "SVSupplierReconciliationVC.h"
#import "SVPaymentHistoryVC.h"
#import "SVSupplierRecordsVC.h"
//#import "SVBulletFrameView.h"
#import "SVPromptRenewalView.h"
@interface SVNewSupplierDetailVC ()
@property (weak, nonatomic) IBOutlet UILabel *supplier;
@property (weak, nonatomic) IBOutlet UILabel *contacts;
@property (weak, nonatomic) IBOutlet UILabel *tel;
@property (weak, nonatomic) IBOutlet UILabel *number;

@property (weak, nonatomic) IBOutlet UILabel *InitialArrears;

@property (weak, nonatomic) IBOutlet UILabel *address;

@property (weak, nonatomic) IBOutlet UILabel *remarks;
@property (weak, nonatomic) IBOutlet UILabel *discount;
@property (weak, nonatomic) IBOutlet UILabel *state;
@property (nonatomic,strong) SVSupplierListModel *model;
@property (nonatomic,strong) SVPromptRenewalView *promptRenewalView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) NSString *lastName;
@end

@implementation SVNewSupplierDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.hidesBottomBarWhenPushed = YES;
    
    //navigation右边按钮。正确创建方式，这样显示的图片就没有问题了
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"more_icon"] style:UIBarButtonItemStylePlain target:self action:@selector(payManagementButtonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;
    self.state.textColor = GreenBackgroundColor;
  
    [self loadData];
    
    
}

//- (void)payManagementButtonResponseEvent{
//    YCXMenuItem *memberTelTitle = [YCXMenuItem menuItem:@"编辑" image:nil target:self action:@selector(logout)];
//    memberTelTitle.foreColor = GlobalFontColor;
//    memberTelTitle.alignment = NSTextAlignmentLeft;
//    memberTelTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//    
//    YCXMenuItem *memberCardTitle = [YCXMenuItem menuItem:@"对账" image:nil target:self action:@selector(logout)];
//    memberCardTitle.foreColor = GlobalFontColor;
//    memberCardTitle.alignment = NSTextAlignmentLeft;
//    memberCardTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//    
//    YCXMenuItem *cashTitle = [YCXMenuItem menuItem:@"结算" image:nil target:self action:@selector(logout)];
//    cashTitle.foreColor = GlobalFontColor;
//    cashTitle.alignment = NSTextAlignmentLeft;
//    cashTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//    //cashTitle.titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:15];
//    
//    YCXMenuItem *menuTitle = [YCXMenuItem menuItem:@"供应商记录" image:nil target:self action:@selector(logout)];
//    menuTitle.foreColor = GlobalFontColor;
//    menuTitle.alignment = NSTextAlignmentLeft;
//    menuTitle.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//    NSArray *items = [NSArray array];
//    if (self.model.sv_enable == 1) {
//        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"暂停" image:nil target:self action:@selector(logout)];
//        logoutItem.foreColor = GlobalFontColor;
//        logoutItem.alignment = NSTextAlignmentLeft;
//        logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//        _promptRenewalView.renewLabel.text = @"是否暂停该供应商";
//        [_promptRenewalView.renewBtn setTitle:@"暂停" forState:UIControlStateNormal];
//       // NSArray *items = @[logoutItem,menuTitle,cashTitle,memberCardTitle,memberTelTitle];
//        items = @[memberTelTitle,memberCardTitle,cashTitle,menuTitle,logoutItem];
//        
//    }else{
//        YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"启用" image:nil target:self action:@selector(logout)];
//        logoutItem.foreColor = GlobalFontColor;
//        logoutItem.alignment = NSTextAlignmentLeft;
//        logoutItem.titleFont = [UIFont boldSystemFontOfSize:13.0f];
//        _promptRenewalView.renewLabel.text = @"是否启用该供应商";
//        [_promptRenewalView.renewBtn setTitle:@"启用" forState:UIControlStateNormal];
//       // NSArray *items = @[logoutItem,menuTitle,cashTitle,memberCardTitle,memberTelTitle];
//        items = @[memberTelTitle,memberCardTitle,cashTitle,menuTitle,logoutItem];
//        
//    }
//    
//   
//    [YCXMenu setCornerRadius:3.0f];
//    [YCXMenu setSeparatorColor:GreyFontColor];
//    [YCXMenu setSelectedColor:clickButtonBackgroundColor];
//    [YCXMenu setTintColor:[UIColor whiteColor]];
//    //name="state">0：查询全部，1：待入库，2：已入库
//    [YCXMenu showMenuInView:[UIApplication sharedApplication].keyWindow fromRect:CGRectMake(ScreenW-30, TopHeight, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
//        
//        switch (index) {
//            case 0:
//            {
//
//                SVAddSupplierVC *vc = [[SVAddSupplierVC alloc] init];
//                if ([self.state.text isEqualToString:@"已启用"]) {
//                    vc.isOpenSwi = YES;
//                }else{
//                    vc.isOpenSwi = NO;
//                }
//                
//                __weak typeof(self) weakSelf = self;
//                vc.modifySupplierBlock = ^{
//                    [weakSelf loadData];
//                };
//                vc.sv_suname = self.model.sv_suname;
//                vc.sv_sulinkmnm = self.model.sv_sulinkmnm;
//                vc.sv_sumoble = self.model.sv_sumoble;
//                vc.sv_supplier_code = self.model.sv_supplier_code;
//                vc.sv_initial_arrears = self.model.sv_initial_arrears;
//                vc.sv_suadress = self.model.sv_suadress;
//                vc.sv_subeizhu = self.model.sv_subeizhu;
//                vc.discount = self.model.sv_discount;
//                vc.sv_suid = self.model.sv_suid;
//                [self.navigationController pushViewController:vc animated:YES];
//
//            }
//                break;
//            case 1:
//            {
//                SVSupplierReconciliationVC *VC = [[SVSupplierReconciliationVC alloc] init];
//                VC.sv_suid = [self.model.sv_suid integerValue];
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//                break;
//            case 2:
//            {
//                
//                SVPaymentHistoryVC *VC = [[SVPaymentHistoryVC alloc] init];
//                VC.supp_id = self.model.sv_suid;
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//          break;
//            case 3:
//            {
//                SVSupplierRecordsVC *VC = [[SVSupplierRecordsVC alloc] init];
//                VC.supp_id = self.model.sv_suid;
//                [self.navigationController pushViewController:VC animated:YES];
//            }
//               break;
//            case 4:
//            {
//                [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//                [[UIApplication sharedApplication].keyWindow addSubview:self.promptRenewalView];
//            }
//
//                break;
//            default:
//                break;
//        }
//    }];
//}

- (void)logout{
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = navigationBackgroundColor;
    
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
   // self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.title = @"供应商详情";
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:17],NSForegroundColorAttributeName:[UIColor whiteColor]}];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)loadData{
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/GetSupplierDetails?key=%@&sv_suid=%@",token,self.sv_suid];
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
       // NSDictionary *data = dic[@"data"];
       
        if ([dic[@"code"] intValue] == 1) {
           
            NSDictionary *dataDic = dic[@"data"];
            SVSupplierListModel *model= [SVSupplierListModel mj_objectWithKeyValues:dataDic];
            self.model = model;
            NSString *sv_suname = model.sv_suname;
            
            NSString *sv_sulinkmnm = model.sv_sulinkmnm;
            
            NSString *sv_sumoble = model.sv_sumoble;
            
            NSString *sv_supplier_code = model.sv_supplier_code;
          //  NSString *sv_initial_arrears = model.sv_initial_arrears;
            NSString *sv_suadress = [NSString stringWithFormat:@"%@",dataDic[@"sv_suadress"]];
            
            /**
             *supplier;
             @property (weak, nonatomic) IBOutlet UILabel *contacts;
             @property (weak, nonatomic) IBOutlet UILabel *tel;
             @property (weak, nonatomic) IBOutlet UILabel *number;

             @property (weak, nonatomic) IBOutlet UILabel *InitialArrears;

             @property (weak, nonatomic) IBOutlet UILabel *address;

             @property (weak, nonatomic) IBOutlet UILabel *remarks;
             @property (weak, nonatomic) IBOutlet UILabel *discount;
             @property (weak, nonatomic) IBOutlet UILabel *state;
             */
            
            self.supplier.text = kStringIsEmpty(model.sv_suname) ?@"":model.sv_suname;
            self.contacts.text = kStringIsEmpty(model.sv_sulinkmnm) ?@"":model.sv_sulinkmnm;
            
            self.tel.text =kStringIsEmpty(model.sv_sumoble) ?@"":model.sv_sumoble;
            
//            if ([sv_supplier_code containsString:@"null"]) {
//                self.number.text = @"";
//            }else{
                self.number.text = kStringIsEmpty(model.sv_supplier_code) ?@"":model.sv_supplier_code;
           // }
            self.InitialArrears.text = [NSString stringWithFormat:@"%.2f",model.sv_initial_arrears];
            
            self.address.text = model.sv_suadress;
            self.remarks.text = model.sv_subeizhu;
            self.discount.text = [NSString stringWithFormat:@"%.2f",model.sv_discount];
            if (model.sv_enable == 1) {
                self.state.text = @"已启用";
                self.state.textColor = GreenBackgroundColor;
            }else{
                self.state.text = @"未启用";
                self.state.textColor = [UIColor redColor];
            }
            
           
        }else{
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
}


- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    self.navigationController.navigationBar.tintColor = [UIColor blackColor];

    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}

- (SVPromptRenewalView *)promptRenewalView{
    if (_promptRenewalView == nil) {
        _promptRenewalView = [[NSBundle mainBundle] loadNibNamed:@"SVPromptRenewalView" owner:nil options:nil].lastObject;
        _promptRenewalView.renewLabel.text = @"是否暂停该供应商";
        [_promptRenewalView.renewBtn setTitle:@"暂停" forState:UIControlStateNormal];
       _promptRenewalView.frame = CGRectMake(20, 20, ScreenW - 40, 250);
       _promptRenewalView.layer.cornerRadius = 10;
       _promptRenewalView.layer.masksToBounds = YES;
       _promptRenewalView.center = self.view.center;
      //  [_promptRenewalView.loginBtn addTarget:self action:@selector(loginBtnClick) forControlEvents:UIControlEventTouchUpInside];
         [_promptRenewalView.renewBtn addTarget:self action:@selector(goLoginClick) forControlEvents:UIControlEventTouchUpInside];
         [_promptRenewalView.clearBtn addTarget:self action:@selector(clearClick) forControlEvents:UIControlEventTouchUpInside];
    }
     return _promptRenewalView;
}

- (void)goLoginClick{
    self.promptRenewalView.renewBtn.userInteractionEnabled = NO;
    
    if ([SVTool isBlankString:self.model.sv_suname]) {
        [SVTool TextButtonActionWithSing:@"供应商名称不能为空"];
        self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
        return;
    }
    if ([SVTool isBlankString:self.model.sv_sulinkmnm]) {
        [SVTool TextButtonActionWithSing:@"联系人不能为空"];
        self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
        return;
    }
    if ([SVTool isBlankString:self.model.sv_sumoble]) {
        [SVTool TextButtonActionWithSing:@"电话不能为空"];
        self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
        return;
    }
    
    if ([SVTool isBlankString:self.model.sv_supplier_code]) {
        [SVTool TextButtonActionWithSing:@"编号不能为空"];
        self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
        return;
    }

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    [parameters setObject:self.model.sv_suname forKey:@"sv_suname"];
    [parameters setObject:self.model.sv_sulinkmnm forKey:@"sv_sulinkmnm"];
    [parameters setObject:self.model.sv_sumoble forKey:@"sv_sumoble"];
    [parameters setObject:self.model.sv_supplier_code forKey:@"sv_supplier_code"];
    [parameters setObject:[NSNumber numberWithDouble:self.model.sv_discount] forKey:@"sv_discount"];
//    if (!kStringIsEmpty(self.model.sv_suadress)) {
//        [parameters setObject:self.model.sv_suadress forKey:@"sv_suadress"];
//    }
    [parameters setObject:[NSNumber numberWithDouble:self.model.sv_initial_arrears] forKey:@"sv_initial_arrears"];
    [parameters setObject:@"300" forKey:@"sv_p_source"];
    if (!kStringIsEmpty(self.model.sv_suadress)) {
        [parameters setObject:self.model.sv_suadress forKey:@"sv_suadress"];
    }
    
    if (!kStringIsEmpty(self.model.sv_subeizhu)) {
        [parameters setObject:self.model.sv_subeizhu forKey:@"sv_subeizhu"];
    }
    
   
    [parameters setObject:self.model.sv_suid forKey:@"sv_suid"];
    if (self.model.sv_enable == 1) {
        [parameters setObject:@"false" forKey:@"sv_enable"];
    }else{
        [parameters setObject:@"true" forKey:@"sv_enable"];
    }
   
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/SupplierApi/EditSupplier?key=%@",token];
    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] intValue] == 1) {
            [self.maskOneView removeFromSuperview];
            [self.promptRenewalView removeFromSuperview];
            [self loadData];
            if (self.EditSupplierBlock) {
                self.EditSupplierBlock();
            }
        }else{
            //隐藏提示框 msg
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }
        self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.promptRenewalView.renewBtn.userInteractionEnabled = YES;
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
}

- (void)clearClick{
    [self.maskOneView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
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

- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.promptRenewalView removeFromSuperview];
}

@end
