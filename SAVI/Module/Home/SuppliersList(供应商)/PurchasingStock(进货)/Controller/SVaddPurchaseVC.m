//
//  SVaddPurchaseVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/23.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVaddPurchaseVC.h"
//商品列表
#import "SVWaresListVC.h"
//弹框view
#import "SVSaveWarehousingView.h"
#import "SVvipPickerView.h"
//model
//#import "SVSupplierListModel.h"
//模型
#import "SVWaresListModel.h"
//cell
#import "SVaddPurchaseCell.h"
#import "SVduoguigeModel.h"
#import "SVPurchaseManagementVC.h"
#import "SVInventoryCompletedVC.h"
#import "SVSupplierListModel.h"
#import "SVRefundGoodsVC.h"
#import "SVNewSupplierListVC.h"
static NSString *addPurchaseCellID = @"addPurchaseCell";
@interface SVaddPurchaseVC () <UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>

//@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;

@property (nonatomic,strong) NSMutableArray *supplierArr;
@property (nonatomic,strong) NSMutableArray *supplierIDArr;
@property (nonatomic,strong) NSMutableArray *warehouseArr;
@property (nonatomic,strong) NSMutableArray *warehouseIDArr;
@property (nonatomic,strong) NSArray *payArr;
@property (nonatomic,strong) NSMutableArray *modelArr;

//记录ID的
@property (nonatomic,copy) NSString *supplierID;
@property (nonatomic,copy) NSString *warehouseID;
//记录入库状态 0是待入库，1是
@property (nonatomic,copy) NSString *state;
//记录点击的按钮
@property (nonatomic,assign) NSInteger buttonNum;
//
@property (nonatomic,assign) double sumMoney;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (nonatomic,strong) NSString *moneyLabelStr;
//三个弹view
@property (nonatomic,strong) SVvipPickerView *PickerView;
//保存view
@property (nonatomic,strong) SVSaveWarehousingView *singleView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UISwitch *openSwitch;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstrains;
@property (weak, nonatomic) IBOutlet UILabel *zhifuLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrow_icon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomDistance;
@property (weak, nonatomic) IBOutlet UIButton *addGoodsBtn;

@property (weak, nonatomic) IBOutlet UITextField *textF;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *caogaoBtn;

@property (weak, nonatomic) IBOutlet UIView *isLookPriceView;

@property (weak, nonatomic) IBOutlet UILabel *number;

@end

@implementation SVaddPurchaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.selectNumber == 2) { // 2是退货的
        self.navigationItem.title = @"新增退货";
        [self.addGoodsBtn setTitle:@"  添加退货商品" forState:UIControlStateNormal];
    }else{
        self.navigationItem.title = @"新增进货";
    }
    
    
    self.payArr = @[@"现金",@"银行卡",@"支付宝",@"微信"];
    
    //  self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 211.5, ScreenW, ScreenH-211-51-TopHeight)];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消tableView的选中
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // self.threeButton.titleLabel.text = @"";
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVaddPurchaseCell" bundle:nil] forCellReuseIdentifier:addPurchaseCellID];
    self.bottomDistance.constant = BottomHeight;
    //将tableView添加到veiw上面
    //  [self.view addSubview:self.tableView];
    
    [self.openSwitch addTarget:self action:@selector(openSwitchClick:) forControlEvents:UIControlEventTouchUpInside];
    [self requestDataIndex:1 pageSize:100 suid:0 name:@""];
    [self requestDatapageIndex:1 pageSize:100 searchCriteria:@""];
    
    if (!kArrayIsEmpty(self.prlistArray)) {
          for (NSDictionary *dict in self.prlistArray) {
              SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
                  if (self.modelArr.count == 0) {
                      //第一个选中时添加
                      model.sv_purchaseprice = [NSString stringWithFormat:@"%@",dict[@"sv_pc_price"]];
                      model.stockpurchaseNumber =  [NSString stringWithFormat:@"%@",dict[@"sv_pc_pnumber"]];
                      [self.modelArr addObject:model];
                      
                      
                  } else {
                      
                      for (SVduoguigeModel *modell in self.modelArr) {
                          // SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                          if (modell.product_id == model.product_id) {
                              // model.product_num += modell.product_num;
                              
                              //                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
                              [self.modelArr removeObject:modell];
                              break;
                          }
                      }
                      model.sv_purchaseprice = [NSString stringWithFormat:@"%@",dict[@"sv_pc_price"]];
                      model.stockpurchaseNumber =  [NSString stringWithFormat:@"%@",dict[@"sv_pc_pnumber"]];
                      [self.modelArr addObject:model];
                  }
                  
                  
              }
              
              [self.tableView reloadData];
    }
    
   
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
    NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
    if ([StockManage isEqualToString:@"0"]) {
        self.isLookPriceView.hidden = NO;
    }else{
        self.isLookPriceView.hidden = YES;
    }
}

#pragma mark - 开关按钮
- (void)openSwitchClick:(UISwitch *)swi{
    if (swi.isOn) { // 开着
        self.threeButton.hidden = NO;
        self.arrow_icon.hidden = NO;
        self.zhifuLabel.hidden = NO;
        self.heightConstrains.constant = 50;
        self.threeButton.titleLabel.text = @"现金";
    }else{
        self.threeButton.hidden = YES;
        self.arrow_icon.hidden = YES;
        self.zhifuLabel.hidden = YES;
        self.heightConstrains.constant = 0;
        self.threeButton.titleLabel.text = @"";
    }
}

# pragma mark - 请求数据
/**
 请求供应商
 @param pageIndex 页码
 @param pageSize 分页大小
 @param suid 0表示查询供应商列表，传入具体的供应商Id可查询单个供应商信息
 @param name 搜索关键字
 */
-(void)requestDataIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize suid:(NSInteger)suid name:(NSString *)name{
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/GetSupplierPageList?key=%@&keywards=%@&suid=%ld&page=%ld&pagesize=%ld",token,name,(long)suid,(long)pageIndex,(long)pageSize];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *listDic = dic[@"values"];
        
        NSArray *dataList = listDic[@"dataList"];
        
        if (![SVTool isEmpty:dataList]) {
            
            for (NSDictionary *dict in dataList) {
                //字典转模型
                //SVSupplierListModel *model = [SVSupplierListModel mj_objectWithKeyValues:dict];
                
                [self.supplierArr addObject:dict[@"sv_suname"]];
                
                [self.supplierIDArr addObject:dict[@"sv_suid"]];
                
            }
            
            [self.oneButton setTitle:self.supplierArr[0] forState:UIControlStateNormal];
            self.supplierID = [NSString stringWithFormat:@"%@",self.supplierIDArr[0]];
            
            if (!kDictIsEmpty(self.dic)) {
                   [self.oneButton setTitle:self.dic[@"sv_suname"] forState:UIControlStateNormal];
                   self.supplierID = [NSString stringWithFormat:@"%@",self.dic[@"sv_suid"]];
               }
            
        } else {
            
            
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}


/**
 请求仓库数据
 @param pageIndex 页数
 @param pageSize 每页几个
 @param searchCriteria 搜索关键词
 */
-(void)requestDatapageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize searchCriteria:(NSString *)searchCriteria {
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    //url
    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/GetWarehouselist?key=%@&pageIndex=%ld&pageSize=%ld&SearchCriteria=%@",token,pageIndex,pageSize,searchCriteria];
    
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            NSArray *warehouseList = dic[@"values"];
            
            if (![SVTool isEmpty:warehouseList]) { //这里数组有个问题
                //不选仓库，默认进入店铺
                [self.warehouseArr addObject:@"当前店铺"];
                [self.warehouseIDArr addObject:@""];
                
                for (NSDictionary *dict in warehouseList) {
                    //字典转模型
                    //SVSupplierListModel *model = [SVSupplierListModel mj_objectWithKeyValues:dict];
                    
                    [self.warehouseArr addObject:dict[@"sv_warehouse_name"]];
                    [self.warehouseIDArr addObject:dict[@"sv_warehouse_id"]];
                    
                }
                
                [self.twoButton setTitle:self.warehouseArr[0] forState:UIControlStateNormal];
                self.warehouseID = [NSString stringWithFormat:@"%@",self.warehouseIDArr[0]];
                
            } else {
                
            }
        } else {
            [SVTool TextButtonAction:self.view withSing:@"仓库数据请求失败"];
        }
        
        //隐藏提示框
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        //[MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleDefault;
}


#pragma mark - 选择供应商
- (IBAction)oneButtonResponseEvent {
    self.buttonNum = 1;
    
//        if ([SVTool isEmpty:self.supplierArr]) {
//            [SVTool TextButtonAction:self.view withSing:@"亲,没有供应商可选"];
//            return;
//        }
//
//        //指定代理
//        self.PickerView.vipPicker.delegate = self;
//        self.PickerView.vipPicker.dataSource = self;
//        //添加pickerView
//
//        [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.PickerView];
//    SVInventoryCompletedVC *inventoryCompletedVC = [[SVInventoryCompletedVC alloc] init];
//    inventoryCompletedVC.selectNumber = 1;
//    inventoryCompletedVC.selectSuplierBlock = ^(SVSupplierListModel * _Nonnull model) {
//        [self.oneButton setTitle:model.sv_suname forState:UIControlStateNormal];
//        self.supplierID = [NSString stringWithFormat:@"%@",model.sv_suid];
//    };
//    // VC.supplierBool = YES;
//    [self.navigationController pushViewController:inventoryCompletedVC animated:YES];
    
//    SVNewSupplierListVC *newSupplierListVC = [[SVNewSupplierListVC alloc] init];
//    newSupplierListVC.selectNumber = 1;
//    newSupplierListVC.selectSuplierBlock = ^(SVSupplierListModel * _Nonnull model) {
//        [self.oneButton setTitle:model.sv_suname forState:UIControlStateNormal];
//        self.supplierID = [NSString stringWithFormat:@"%@",model.sv_suid];
//    };
//    [self.navigationController pushViewController:newSupplierListVC animated:YES];
    
    SVInventoryCompletedVC *inventoryCompletedVC = [[SVInventoryCompletedVC alloc] init];
    inventoryCompletedVC.selectNumber = 1;
    inventoryCompletedVC.selectSuplierBlock = ^(SVSupplierListModel * _Nonnull model) {
        [self.oneButton setTitle:model.sv_suname forState:UIControlStateNormal];
        self.supplierID = [NSString stringWithFormat:@"%@",model.sv_suid];
    };
    // VC.supplierBool = YES;
    [self.navigationController pushViewController:inventoryCompletedVC animated:YES];
}

- (IBAction)twoButtonResponseEvent {
    self.buttonNum = 2;
    
    if ([SVTool isEmpty:self.warehouseArr]) {
        [SVTool TextButtonAction:self.view withSing:@"亲,没有仓库可选"];
        return;
    }
    //指定代理
    self.PickerView.vipPicker.delegate = self;
    self.PickerView.vipPicker.dataSource = self;
    //添加pickerView
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.PickerView];
}

- (IBAction)threeButtonResponseEvent {
    
    self.buttonNum = 3;
    //指定代理
    self.PickerView.vipPicker.delegate = self;
    self.PickerView.vipPicker.dataSource = self;
    //添加pickerView
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.PickerView];
}
#pragma mark - 保存草稿成功
- (IBAction)saveCaogaoClick:(id)sender {
    if ([SVTool isBlankString:self.supplierID]) {
        [SVTool TextButtonAction:self.view withSing:@"供应商信息不能为空"];
        return;
    }
    if ([SVTool isEmpty:self.modelArr]) {
        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
        return;
    }
    
    if (self.selectNumber == 2) {// 是退货的
        self.caogaoBtn.userInteractionEnabled = NO;
        [self.singleView.saveOneButton setEnabled:NO];
        [self returnGoodsReqeutsValidationCodeVerificationSing:@"保存退货草稿成功" sv_pc_state:0];
    }else{
         self.caogaoBtn.userInteractionEnabled = NO;
           self.state = @"0";
           [self.singleView.saveOneButton setEnabled:NO];
           [self oneCancelResponseEvent];
           [self reqeutsValidationCodeVerificationSing:@"保存成功"];
    }
//    self.state = @"0";
//    [self.singleView.saveOneButton setEnabled:NO];
//    [self oneCancelResponseEvent];
//    [self reqeutsValidationCodeVerificationSing:@"保存草稿成功"];
}


#pragma mark - 点击添加进货或者是退货商品
- (IBAction)goodsResponseEvent {
    
    SVPurchaseManagementVC *VC = [[SVPurchaseManagementVC alloc] init];
    if (self.selectNumber == 1) {// 进货
        VC.controllerNum = 1;
    }else{
         VC.controllerNum = 2;// 退货
    }
  //  VC.selectModelArray = self.modelArr;
   
    __weak typeof(self) weakSelf = self;
    VC.addWarehouseWares = ^(NSMutableArray *selectArr) {
        //        [weakSelf.modelArr isEqual:selectArr];
        //        [weakSelf.tableView reloadData];
        //  [weakSelf.modelArr removeAllObjects];
        
        for (SVduoguigeModel *model in selectArr) {
            if (weakSelf.modelArr.count == 0) {
                //第一个选中时添加
                
                [weakSelf.modelArr addObject:model];
                
                
            } else {
                
                for (SVduoguigeModel *modell in weakSelf.modelArr) {
                    // SVSelectedGoodsModel *modell = [SVSelectedGoodsModel mj_objectWithKeyValues:dict];
                    if (modell.product_id == model.product_id) {
                        // model.product_num += modell.product_num;
                        
                        //                    [dic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"product_num"];
                        [weakSelf.modelArr removeObject:modell];
                        break;
                    }
                }
                [weakSelf.modelArr addObject:model];
                
               
                
            }
           
            
        }
         double stockpurchaseNumber = 0.0;
        for (SVduoguigeModel *model in self.modelArr) {
            stockpurchaseNumber += model.stockpurchaseNumber.doubleValue;
        }
        self.number.text = [NSString stringWithFormat:@"数量：%.2f",stockpurchaseNumber];
        [weakSelf.tableView reloadData];
    };
    //跳转
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)saveResponseEvent {
    if ([SVTool isBlankString:self.supplierID]) {
        [SVTool TextButtonAction:self.view withSing:@"供应商信息不能为空"];
        return;
    }
    if ([SVTool isEmpty:self.modelArr]) {
        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
        return;
    }
    //    [self.singleView.saveOneButton setEnabled:YES];
    //    [self.singleView.saveTwoButton setEnabled:YES];
    //
    //    if ([SVTool isBlankString:self.supplierID]) {
    //        [SVTool TextButtonAction:self.view withSing:@"供应商信息不能为空"];
    //        return;
    //    }
    //
    //    if ([SVTool isEmpty:self.modelArr]) {
    //        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
    //        return;
    //    }
    //
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    //    [[UIApplication sharedApplication].keyWindow addSubview:self.singleView];
    
    if (self.selectNumber == 2) {// 是退货的
        [self.singleView.saveTwoButton setEnabled:NO];
        self.sureBtn.userInteractionEnabled = NO;
        [self returnGoodsReqeutsValidationCodeVerificationSing:@"退货成功"sv_pc_state:1];
    }else{
        self.state = @"1";
        self.sureBtn.userInteractionEnabled = NO;
         [self.singleView.saveTwoButton setEnabled:NO];
         [self oneCancelResponseEvent];
         [self reqeutsValidationCodeVerificationSing:@"进货成功"];
    }
    
}

#pragma mark - 保存草稿
- (void)saveOneButtonResponseEvent {
    if ([SVTool isBlankString:self.supplierID]) {
        [SVTool TextButtonAction:self.view withSing:@"供应商信息不能为空"];
        return;
    }
    if ([SVTool isEmpty:self.modelArr]) {
        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
        return;
    }
    
    if (self.selectNumber == 2) {// 是退货的
        [self.singleView.saveOneButton setEnabled:NO];
        [self returnGoodsReqeutsValidationCodeVerificationSing:@"保存退货草稿成功" sv_pc_state:0];
    }else{
           self.state = @"0";
           [self.singleView.saveOneButton setEnabled:NO];
           [self oneCancelResponseEvent];
           [self reqeutsValidationCodeVerificationSing:@"保存成功"];
    }
   
    
}

#pragma mark - 入库并审核
- (void)saveTwoButtonResponseEvent {
    
    self.state = @"1";
    [self.singleView.saveTwoButton setEnabled:NO];
    [self oneCancelResponseEvent];
    [self reqeutsValidationCodeVerificationSing:@"进货成功"];
    
}

#pragma mark - 新增进货保存
-(void)reqeutsValidationCodeVerificationSing:(NSString *)sing {
    
    [SVTool IndeterminateButtonAction:self.view withSing:nil];
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy-MM-dd hh:mm:ss"];
    NSString *DateTime = [formatter stringFromDate:date];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    //将参数拼接到URL后面
    NSString *sURL=[URLhead  stringByAppendingFormat:@"/api/Supplier/addsv_procurement?key=%@",token];
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [dic setValue:self.warehouseID forKey:@"sv_targetwarehouse_id"];
    [dic setValue:self.supplierID forKey:@"sv_suid"];
    [dic setValue:DateTime forKey:@"sv_pc_date"];
    [dic setValue:self.moneyLabel.text forKey:@"sv_pc_combined"];
    [dic setValue:self.moneyLabel.text forKey:@"sv_pc_total"];
    [dic setValue:@"0" forKey:@"sv_pc_costs"];
    [dic setValue:self.textF.text forKey:@"sv_pc_note"];// 备注
    if (self.openSwitch.on) {
        [dic setValue:self.threeButton.titleLabel.text forKey:@"sv_pc_settlement"];
        [dic setValue:self.moneyLabel.text forKey:@"sv_pc_realpay"];
    }else{
        [dic setValue:@"" forKey:@"sv_pc_settlement"];
        [dic setValue:@"0" forKey:@"sv_pc_realpay"];
    }
    
    [dic setValue:self.state forKey:@"sv_pc_state"];
    // [dic setValue:self.moneyLabel.text forKey:@"sv_pc_realpay"];
    
    NSDictionary *name = self.modelArr[0];
    SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:name];
    [dic setValue:model.sv_p_name forKey:@"sv_productname"];
    
    NSMutableArray *Prlist = [NSMutableArray array];
    for (NSDictionary *dict in self.modelArr) {
        SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
        NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
        [dataDict setObject:@"0" forKey:@"sv_pc_productid"];
        [dataDict setObject:model.product_id forKey:@"product_id"];
        [dataDict setObject:[NSString stringWithFormat:@"%ld", (long)model.stockpurchaseNumber.integerValue] forKey:@"sv_pc_pnumber"];
        [dataDict setObject:model.sv_purchaseprice forKey:@"sv_pc_price"];
        NSString *combined = [NSString stringWithFormat:@"%.2f",[model.sv_purchaseprice floatValue] * model.stockpurchaseNumber.floatValue];
        [dataDict setObject:combined forKey:@"sv_pc_combined"];
        [dataDict setObject:combined forKey:@"sv_paid_in_amount"];
        [dataDict setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
        // sv_purchaseprice
        [Prlist addObject:dataDict];
    }
    [dic setValue:Prlist forKey:@"Prlist"];
    NSLog(@"dic = %@",dic);
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"返回值dict = %@",dict);
        
        if ([dict[@"succeed"] integerValue] == 1) {
            
            if (self.addPurchaseBlock) {
                self.addPurchaseBlock();
            }
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"notifyAddShop" object:nil];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonActionWithSing:sing];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.9 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                //上一层
                [self.navigationController popViewControllerAnimated:YES];
                
            });
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            NSString *errmsg = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
            [SVTool TextButtonAction:self.view withSing:errmsg];
        }
        self.sureBtn.userInteractionEnabled = YES;
         self.caogaoBtn.userInteractionEnabled = YES;
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 新增退货
-(void)returnGoodsReqeutsValidationCodeVerificationSing:(NSString *)sing sv_pc_state:(NSInteger)sv_pc_state{
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
            [parameters setObject:@"" forKey:@"sv_pc_noid"];
            [parameters setObject:@(0) forKey:@"sv_pc_id"];// 退货单id
           NSString *currentTimeString = [self getCurrentTimes];
            [parameters setObject:currentTimeString forKey:@"sv_pc_date"];
              
              [parameters setObject:self.supplierID forKey:@"sv_suid"];
              
               [parameters setValue:self.textF.text forKey:@"sv_pc_note"];// 备注
              [parameters setObject:self.moneyLabel.text forKey:@"sv_pc_combined"];
              
              [parameters setObject:self.moneyLabel.text forKey:@"sv_pc_total"];
              [parameters setObject:@(0) forKey:@"sv_pc_costs"];
            //  [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
    if (self.openSwitch.on) {
           [parameters setValue:self.threeButton.titleLabel.text forKey:@"sv_pc_settlement"];
          // [parameters setValue:self.moneyLabel.text forKey:@"sv_pc_realpay"];
       }else{
           [parameters setValue:@"" forKey:@"sv_pc_settlement"];
          // [parameters setValue:@"0" forKey:@"sv_pc_realpay"];
       }
    
              [parameters setObject:@(sv_pc_state) forKey:@"sv_pc_state"];
              [parameters setObject:self.moneyLabel.text forKey:@"sv_pc_realpay"];
           //   [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
           //   [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
            [parameters setObject:@"true" forKey:@"is_single_product"];
            [parameters setObject:@"300" forKey:@"sv_source_type"];
            
            
            NSMutableArray *prlistArr = [NSMutableArray array];
            for (SVduoguigeModel *model in self.modelArr) {
               // SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
                NSMutableDictionary *prlistDic = [NSMutableDictionary dictionary];
                [prlistDic setObject:model.product_id forKey:@"product_id"];
                
                [prlistDic setObject:@(0) forKey:@"sv_record_id"];
                
                [prlistDic setObject:model.sv_purchaseprice forKey:@"sv_pc_price"];
                
                NSString *combined = [NSString stringWithFormat:@"%.2f",[model.sv_purchaseprice floatValue] * model.stockpurchaseNumber.floatValue];
                
                [prlistDic setObject:combined forKey:@"sv_pc_combined"];
                [prlistDic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
                
                [prlistDic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
                if (!kStringIsEmpty(model.sv_p_specs)) {
                    [prlistDic setObject:model.sv_p_specs forKey:@"sv_p_specs"];
                }
               // if ([model.sv_pricing_method isEqualToString:@"0"]) {
                    [prlistDic setObject:[NSString stringWithFormat:@"%.2f", model.stockpurchaseNumber.doubleValue] forKey:@"sv_pc_pnumber"];
//                } else {
//                    [prlistDic setObject:[NSString stringWithFormat:@"%ld", (long)model.stockpurchaseNumber.integerValue] forKey:@"sv_p_weight"];
//                }
                [prlistArr addObject:prlistDic];
                
            }
            [parameters setObject:prlistArr forKey:@"Prlist"];
            
            [SVUserManager loadUserInfo];
            NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/addsv_purchasereturn_new?key=%@",[SVUserManager shareInstance].access_token];
            
            [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"succeed"] integerValue] == 1) {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [SVTool TextButtonActionWithSing:sing];
                    
                    if (self.addPurchaseBlock) {
                        self.addPurchaseBlock();
                    }

                    //用延迟来移除提示框
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        //返回上一级
                       // [self.navigationController popViewControllerAnimated:YES];
                        
                        // 返回到任意界面
                               for (UIViewController *temp in self.navigationController.viewControllers) {
                                   if ([temp isKindOfClass:[SVRefundGoodsVC class]]) {
                                       
                                       [self.navigationController popToViewController:temp animated:YES];
                                   }
                               }
                    });
                    
                } else {
                    
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                    [SVTool TextButtonActionWithSing:errmsg];
                    
                }
                
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                self.sureBtn.userInteractionEnabled = YES;
                 self.caogaoBtn.userInteractionEnabled = YES;
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //            [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                //开启交互
                [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
            }];
}

-(NSString*)getCurrentTimes{

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];

    // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制

    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];

    //现在时间,你可以输出来看下是什么格式

    NSDate *datenow = [NSDate date];

    //----------将nsdate按formatter格式转成nsstring

    NSString *currentTimeString = [formatter stringFromDate:datenow];

    NSLog(@"currentTimeString =  %@",currentTimeString);

    return currentTimeString;

}


#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVaddPurchaseCell *cell = [tableView dequeueReusableCellWithIdentifier:addPurchaseCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVaddPurchaseCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addPurchaseCellID];
    }
    
    cell.model = self.modelArr[indexPath.row];
    
    //cell.indexPatch = indexPath;
    
    self.sumMoney = 0.00;
     double stockpurchaseNumber = 0.0;
    for (NSDictionary *dict in self.modelArr) {
        SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
        double money = [model.sv_purchaseprice doubleValue];
        self.sumMoney += model.stockpurchaseNumber.doubleValue * money;
        stockpurchaseNumber += model.stockpurchaseNumber.doubleValue;
    }
    self.number.text = [NSString stringWithFormat:@"数量：%.2f",stockpurchaseNumber];
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
    
    __weak typeof(self) weakSelf = self;
    [cell setCaddPurchaseBlock:^() {
        weakSelf.sumMoney = 0.00;
        double stockpurchaseNumber = 0.0;
        for (NSDictionary *dict in weakSelf.modelArr) {
            SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
            double money = [model.sv_purchaseprice doubleValue];
            weakSelf.sumMoney += model.stockpurchaseNumber.doubleValue * money;
            stockpurchaseNumber += model.stockpurchaseNumber.doubleValue;
        }
        //  SVWaresListModel
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.sumMoney];
        weakSelf.number.text = [NSString stringWithFormat:@"数量：%.2f",stockpurchaseNumber];

        
    }];
    
    [cell setRemoveAddPurchaseCellBlock:^(SVduoguigeModel *model) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除此商品吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [weakSelf.modelArr removeObject:model];
            double stockpurchaseNumber = 0.00;
            for (SVduoguigeModel *model in weakSelf.modelArr) {
                stockpurchaseNumber += model.stockpurchaseNumber.doubleValue;
            }
            weakSelf.number.text = [NSString stringWithFormat:@"数量：%.2f",stockpurchaseNumber];
            
            if (kArrayIsEmpty(self.modelArr)) {
                self.moneyLabel.text = @"0.00";
            }
            [weakSelf.tableView reloadData];
        }];
        
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alertController addAction:derAction];
        
        [alertController addAction:cancelAction];
        
        [weakSelf presentViewController:alertController animated:YES completion:nil];
    }];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TRUE;
    
}

//定义编辑样式
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return UITableViewCellEditingStyleDelete;
    
}

//修改编辑按钮文字
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath{
    return @"删除";
}

//进入编辑模式，按下出现的编辑按钮后
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<[self.modelArr count]) {
            
            //移除数据源的数据
            [self.modelArr removeObjectAtIndex:indexPath.row];
            
            //移除tableView中的数据
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
            
            double stockpurchaseNumber = 0.00;
            for (SVduoguigeModel *model in self.modelArr) {
                stockpurchaseNumber += model.stockpurchaseNumber.doubleValue;
            }
            self.number.text = [NSString stringWithFormat:@"数量：%.2f",stockpurchaseNumber];
            
            if (kArrayIsEmpty(self.modelArr)) {
                self.moneyLabel.text = @"0.00";
            }
            
            [self.tableView reloadData];
            
        }
        
    }
    
}

#pragma mark  - UIPickerView DataSource Method 数据源方法
//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (self.buttonNum == 1) {
        return self.supplierArr.count;
    } else if (self.buttonNum == 2) {
        return self.warehouseArr.count;
    } else if (self.buttonNum ==3) {
        return self.payArr.count;
    }
    return 0;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (self.buttonNum == 1) {
        return self.supplierArr[row];
    } else if (self.buttonNum == 2) {
        return self.warehouseArr[row];
    } else if (self.buttonNum ==3) {
        return self.payArr[row];
    }
    return 0;
}

#pragma mark - 懒加载
-(NSMutableArray *)supplierArr {
    if (!_supplierArr) {
        _supplierArr = [NSMutableArray array];
    }
    return _supplierArr;
}

-(NSMutableArray *)supplierIDArr {
    if (!_supplierIDArr) {
        _supplierIDArr = [NSMutableArray array];
    }
    return _supplierIDArr;
}

-(NSMutableArray *)warehouseArr {
    if (!_warehouseArr) {
        _warehouseArr = [NSMutableArray array];
    }
    return _warehouseArr;
}

-(NSMutableArray *)warehouseIDArr {
    if (!_warehouseIDArr) {
        _warehouseIDArr = [NSMutableArray array];
    }
    return _warehouseIDArr;
}

-(NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

//等级pickerView
-(SVvipPickerView *)PickerView{
    if (!_PickerView) {
        _PickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _PickerView.frame = CGRectMake(0, 0, 320, 230);
        _PickerView.center = [UIApplication sharedApplication].keyWindow.center;
        
        _PickerView.backgroundColor = [UIColor whiteColor];
        _PickerView.layer.cornerRadius = 10;
        
        [_PickerView.vipCancel addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_PickerView.vipDetermine addTarget:self action:@selector(vipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _PickerView;
}

//遮盖View
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

-(SVSaveWarehousingView *)singleView{
    if (!_singleView) {
        _singleView = [[NSBundle mainBundle] loadNibNamed:@"SVSaveWarehousingView" owner:nil options:nil].lastObject;
        CGFloat W = 320;
        CGFloat H = 200;
        CGFloat x = (ScreenW - W) / 2;
        CGFloat y = (ScreenH - H) / 2;
        _singleView.frame = CGRectMake(x, y, W, H);
        
        _singleView.layer.cornerRadius = 10;
        _singleView.saveOneButton.layer.cornerRadius = 3;
        _singleView.saveTwoButton.layer.cornerRadius = 3;
        
        [_singleView.deleteButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        [_singleView.saveOneButton addTarget:self action:@selector(saveOneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_singleView.saveTwoButton addTarget:self action:@selector(saveTwoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _singleView;
}

//确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    
    NSInteger row = [self.PickerView.vipPicker selectedRowInComponent:0];
    //
    //    self.number =[self.memberlevel_id[row] integerValue];
    
    //    self.threeButton.titleLabel.text = [self.dataArr objectAtIndex:row];
    
    if (self.buttonNum == 1) {
        [self.oneButton setTitle:[self.supplierArr objectAtIndex:row] forState:UIControlStateNormal];
        self.supplierID = [NSString stringWithFormat:@"%@",[self.supplierIDArr objectAtIndex:row]];
    } else if (self.buttonNum == 2) {
        [self.twoButton setTitle:[self.warehouseArr objectAtIndex:row] forState:UIControlStateNormal];
        self.warehouseID = [NSString stringWithFormat:@"%@",[self.warehouseIDArr objectAtIndex:row]];
    } else if (self.buttonNum == 3) {
        [self.threeButton setTitle:[self.payArr objectAtIndex:row] forState:UIControlStateNormal];
    }
    
    [self.PickerView removeFromSuperview];
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskOneView removeFromSuperview];
    [self.singleView removeFromSuperview];
    [self.PickerView removeFromSuperview];
    
}


@end
