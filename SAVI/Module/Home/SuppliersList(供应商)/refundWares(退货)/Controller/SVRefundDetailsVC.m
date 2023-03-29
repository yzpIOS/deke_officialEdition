//
//  SVRefundDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/25.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVRefundDetailsVC.h"
#import "SVHistoryDateilsCell.h"
#import "SVHistoryDateilsModel.h"
#import "SVaddPurchaseVC.h"
#import "SVReturnGoodsDetailCell.h"
#import "SVduoguigeModel.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"
//static NSString *RefundGoodsDetailsID = @"RefundGoodsDetailsCell";
static NSString *RefundGoodsDetailsID = @"SVReturnGoodsDetailCell";
@interface SVRefundDetailsVC () <UITableViewDelegate,UITableViewDataSource,CBCentralManagerDelegate>{
    JWBluetoothManage * manage;
}

@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;

//tableView
@property (nonatomic,strong) UITableView *tableView;
//模型数组
@property (nonatomic,strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_pnumber;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;
@property (weak, nonatomic) IBOutlet UILabel *sv_associated_code;
@property (weak, nonatomic) IBOutlet UILabel *sv_suname;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_operation;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UIButton *dayinBtn;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_note;
@property (weak, nonatomic) IBOutlet UIView *middleView;
@property (weak, nonatomic) IBOutlet UILabel *titleNameLabel;

//@property (weak, nonatomic) IBOutlet UILabel *sv_pc_note;
//@property (weak, nonatomic) IBOutlet UIView *middleView;

@end

@implementation SVRefundDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        self.titleNameLabel.text = @"款号/商品";
    }else{
        
        self.titleNameLabel.text = @"条码/商品";
    }
    
    self.navigationItem.title = @"退货详情";
    
    if ([_dic[@"sv_pc_statestr"] containsString:@"待审核"]) {
        self.dayinBtn.hidden = YES;
        self.bottomView.hidden = NO;
    }else{
       self.dayinBtn.hidden = NO;
        self.bottomView.hidden = YES;
    }
    
    //初始化对象，设置代理
      self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
      
      //创建蓝牙
      manage = [JWBluetoothManage sharedInstance];
      __weak typeof(self) weakSelf = self;
      //开始搜索
      [manage beginScanPerpheralSuccess:^(NSArray<CBPeripheral *> *peripherals, NSArray<NSNumber *> *rssis) {
          weakSelf.dataSource = [NSMutableArray arrayWithArray:peripherals];
          weakSelf.rssisArray = [NSMutableArray arrayWithArray:rssis];
          
      } failure:^(CBManagerState status) {
          //        [SVTool TextButtonAction:weakSelf.view withSing:[weakSelf getBluetoothErrorInfo:status]];
          
      }];
      //断开连接的block回调
      manage.disConnectBlock = ^(CBPeripheral *perpheral, NSError *error) {
          
      };
    
    //赋值
    self.sv_pc_noid.text = _dic[@"sv_pc_noid"];
    
    
    self.sv_pc_total.text = [NSString stringWithFormat:@"%@",_dic[@"sv_pc_total"]];
    
    [SVUserManager loadUserInfo];
      NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
       if (kDictIsEmpty(sv_versionpowersDict)) {
        
       }else{
           NSDictionary *StockManage = sv_versionpowersDict[@"StockManage"];
           if (kDictIsEmpty(StockManage)) {
            
           }else{
        
               // 底部是否添加会员
               NSString *ReturnGoods_Price_Total = [NSString stringWithFormat:@"%@",StockManage[@"ReturnGoods_Price_Total"]];
               if (kStringIsEmpty(ReturnGoods_Price_Total)) {
                 
               }else{
                   if ([ReturnGoods_Price_Total isEqualToString:@"1"]) {
                     
                   }else{
                       self.sv_pc_total.text = @"***";
                   }
               }
              
           }
                                     
           
       }
    self.sv_suname.text = self.dic[@"sv_suname"];
    self.sv_pc_operation.text = self.dic[@"sv_pc_operation"];
    
    NSString *sv_pc_note = self.dic[@"sv_pc_note"];
    if (kStringIsEmpty(sv_pc_note)) {
        self.sv_pc_note.text = @"无";
    }else{
        self.sv_pc_note.text = sv_pc_note;
    }

    self.date.text = [self.dic[@"sv_pc_cdate"] substringWithRange:NSMakeRange(0, 10)];
    self.time.text = [self.dic[@"sv_pc_cdate"] substringWithRange:NSMakeRange(11, 5)];
    
    //判断退货单号是否为空的
    if ([SVTool isBlankString:_dic[@"sv_associated_code"]]) {
        self.sv_associated_code.text = nil;
    } else {
        self.sv_associated_code.text = [NSString stringWithFormat:@"%@",_dic[@"sv_associated_code"]];
    }
    
//<<<<<<< HEAD
//    NSString *sv_pc_note = self.dic[@"sv_pc_note"];
//    if (kStringIsEmpty(sv_pc_note)) {
//        self.sv_pc_note.text = @"无";
//    }else{
//        self.sv_pc_note.text = sv_pc_note;
//    }
//
//=======
//    //分析数据
//>>>>>>> origin/oem_deduction_OrderCollection
    self.tableView = [[UITableView alloc] init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //指定代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;

    // 设置tableView的估算高度
    self.tableView.estimatedRowHeight = 70;

       // 设置tableView的估算高度
//       self.tableView.estimatedRowHeight = 70;
//>>>>>>> origin/oem_deduction_OrderCollection
    [self.view addSubview:self.tableView];
//    //分析数据
//    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.middleView.mas_bottom);
//        make.left.mas_equalTo(self.view.mas_left);
//        make.right.mas_equalTo(self.view.mas_right);
//        make.bottom.mas_equalTo(self.dayinBtn.mas_top);
//    }];
    
    //分析数据
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.middleView.mas_bottom);
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.dayinBtn.mas_top);
    }];
    
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVReturnGoodsDetailCell" bundle:nil] forCellReuseIdentifier:RefundGoodsDetailsID];
    
    //取数
    double totle = 0;
    if (![SVTool isEmpty:_dic[@"Prlist"]]) {
       
        for (NSDictionary *dict in _dic[@"Prlist"]) {
            
//            NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//            [dataDict setObject:dict[@"sv_p_name"] forKey:@"product_name"];
//            [dataDict setObject:dict[@"sv_pc_price"] forKey:@"sv_purchaseprice"];
//            [dataDict setObject:dict[@"sv_pc_pnumber"] forKey:@"product_num"];
//            [dataDict setObject:dict[@"product_id"] forKey:@"product_id"];
//            [dataDict setObject:@"1" forKey:@"order_stutia"];
//            [dataDict setObject:dict[@"sv_p_barcode"] forKey:@"sv_p_barcode"];
//            [dataDict setObject:dict[@"sv_p_unit"] forKey:@"sv_p_unit"];
            //给模型赋值
//            SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
            totle +=[dict[@"sv_pc_pnumber"] doubleValue] + [dict[@"sv_p_weight"] doubleValue];
            [self.modelArr addObject:dict];
            
        }
    } else {
        [SVTool TextButtonAction:self.view withSing:@"退货单商品为空"];
    }
    self.sv_pc_pnumber.text = [NSString stringWithFormat:@"%.2f",totle];
    [self.tableView reloadData];
    
}


#pragma mark - 蓝牙相关方法
-(NSString *)getBluetoothErrorInfo:(CBManagerState)status{
    NSString * tempStr = @"未知错误";
    switch (status) {
        case CBManagerStateUnknown:
            tempStr = @"未知错误";
            break;
        case CBManagerStateResetting:
            tempStr = @"正在重置";
            break;
        case CBManagerStateUnsupported:
            tempStr = @"设备不支持蓝牙";
            break;
        case CBManagerStateUnauthorized:
            tempStr = @"蓝牙未被授权";
            break;
        case CBManagerStatePoweredOff:
            tempStr = @"蓝牙可用，未打开";
            break;
        default:
            break;
    }
    return tempStr;
}

- (void)centralManagerDidUpdateState:(CBCentralManager *)central{
    NSString *message = nil;
    switch (central.state) {
        case 1:
            message = @"该设备不支持蓝牙功能,请检查系统设置";
            break;
        case 2:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 3:
            message = @"该设备蓝牙未授权,请检查系统设置";
            break;
        case 4:
            message = @"蓝牙未打开";
            break;
        case 5:
            message = @"蓝牙已经成功开启，可以打印";
            break;
        default:
            break;
    }
//    if([message isEqualToString:@"蓝牙未打开"]) {
//       // [SVTool TextButtonAction:self.view withSing:message];
//    } else {
//        //用延迟来作提示
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            if ([SVTool isBlankString:self.printeName]) {
//                [MBProgressHUD hideHUDForView:self.view animated:YES];
//                [SVTool TextButtonAction:self.view withSing:message];
//            }
//        });
//    }
}

- (IBAction)dayinClick:(id)sender {
    if (manage.stage != JWScanStageCharacteristics) {
          // self.title = @"会员充值";
           [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
           return;
       }
    //显示时间
       NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dic[@"sv_pc_date"] substringToIndex:10],[self.dic[@"sv_pc_date"] substringWithRange:NSMakeRange(11, 8)]];
       
       JWPrinter *printer = [[JWPrinter alloc] init];
       [printer defaultSetting];
       
       [SVUserManager loadUserInfo];
       
       [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    if ([_dic[@"sv_pc_statestr"] containsString:@"待审核"]) {
          [printer appendText:@"退货单-草稿" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    }else{
         [printer appendText:@"退货单-完成" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    }
   
    
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.dic[@"sv_pc_noid"]] fontSize:HLFontSizeTitleSmalle];
      [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
     [printer appendSeperatorLine];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        [printer appendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }else{
        
        [printer appendLeftText:@"品名/条码" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }
    
     
      [printer appendSeperatorLine];
    
    CGFloat total = 0.0;
     //  CGFloat totle_Discount_money = 0.0;
       CGFloat totle_count = 0.0;
    for (NSDictionary *dict in [self.dic objectForKey:@"Prlist"]) {
               NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
               // dict[@"sv_p_specs"]
               if (kStringIsEmpty(dict[@"sv_p_specs"])) {
                   [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
               }else{
                   [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
               }
               
             
                   [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"sv_pc_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f",[dict[@"sv_pc_pnumber"] floatValue]] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_combined"] floatValue]] isTitle:NO];
        
        total += [dict[@"sv_pc_combined"]floatValue];
        totle_count += [dict[@"sv_pc_pnumber"]floatValue];
           
       }
       [printer appendSeperatorLine];
       
       [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_count] priceText:[NSString stringWithFormat:@"%.2f",total] isTitle:NO];
       [printer appendSeperatorLine];
    
    [printer appendNewLine];
      [printer appendNewLine];
      [printer appendNewLine];
      [printer cutter];
      NSData *mainData = [printer getFinalData];
      __weak typeof(self) weakSelf = self;
      [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
          if (completion) {
              [SVTool TextButtonAction:self.view withSing:@"打印成功"];
              NSLog(@"打印成功");
          }else{
              NSLog(@"写入错误---:%@",error);
              [SVTool TextButtonAction:weakSelf.view withSing:error];
          }
          
        //  weakSelf.title = @"结算";
      }];
    
}

#pragma mark - 继续退货
- (IBAction)ContinueInventoryClick:(id)sender {
    SVaddPurchaseVC *VC = [[SVaddPurchaseVC alloc] init];
    VC.selectNumber = 2;
    VC.prlistArray = _dic[@"Prlist"];
    VC.dic = self.dic;
    [self.navigationController pushViewController:VC animated:YES];
}

#pragma mark - 完成退货
- (IBAction)CompleteReturnClick:(id)sender {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
               [parameters setObject:_dic[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
    NSString *sv_pc_id = [NSString stringWithFormat:@"%@",_dic[@"sv_pc_id"]];
            if (kStringIsEmpty(sv_pc_id)) {
             [parameters setObject:@"" forKey:@"sv_pc_id"];// 退货单id
          }else{
            [parameters setObject:sv_pc_id forKey:@"sv_pc_id"];// 退货单id
             }
          
              NSString *currentTimeString = [self getCurrentTimes];
               [parameters setObject:currentTimeString forKey:@"sv_pc_date"];
                 
                 [parameters setObject:[NSString stringWithFormat:@"%@",_dic[@"sv_suid"]] forKey:@"sv_suid"];
                 
                 [parameters setObject:@"" forKey:@"sv_pc_note"];
                 [parameters setObject:[NSString stringWithFormat:@"%@",_dic[@"sv_pc_total"]] forKey:@"sv_pc_combined"];
                 
                 [parameters setObject:[NSString stringWithFormat:@"%@",_dic[@"sv_pc_total"]] forKey:@"sv_pc_total"];
                 [parameters setObject:@(0) forKey:@"sv_pc_costs"];
               //  [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
      // if (self.openSwitch.on) {
              [parameters setValue:_dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
             // [parameters setValue:self.moneyLabel.text forKey:@"sv_pc_realpay"];
//          }else{
//              [parameters setValue:@"" forKey:@"sv_pc_settlement"];
//             // [parameters setValue:@"0" forKey:@"sv_pc_realpay"];
//          }
       
                 [parameters setObject:@(1) forKey:@"sv_pc_state"];
                 [parameters setObject:[NSString stringWithFormat:@"%@",_dic[@"sv_pc_total"]] forKey:@"sv_pc_realpay"];
              //   [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
              //   [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
               [parameters setObject:@"true" forKey:@"is_single_product"];
               [parameters setObject:@"300" forKey:@"sv_source_type"];
               
               
               NSMutableArray *prlistArr = [NSMutableArray array];
               for (NSDictionary *dict in self.modelArr) {
//                   SVduoguigeModel *model = [SVduoguigeModel mj_objectWithKeyValues:dict];
                   NSMutableDictionary *prlistDic = [NSMutableDictionary dictionary];
                   [prlistDic setObject:dict[@"product_id"] forKey:@"product_id"];
                   
                   [prlistDic setObject:dict[@"sv_record_id"] forKey:@"sv_record_id"];
                   
                   [prlistDic setObject:dict[@"sv_pc_price"] forKey:@"sv_pc_price"];
                   
                   NSString *combined = [NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_price"] floatValue] * [dict[@"sv_pc_pnumber"]floatValue]];
                   
                   [prlistDic setObject:combined forKey:@"sv_pc_combined"];
                   [prlistDic setObject:dict[@"sv_pricing_method"] forKey:@"sv_pricing_method"];
                   
                   [prlistDic setObject:dict[@"sv_p_barcode"] forKey:@"sv_p_barcode"];
                   if (!kStringIsEmpty(dict[@"sv_p_specs"])) {
                       [prlistDic setObject:dict[@"sv_p_specs"] forKey:@"sv_p_specs"];
                   }
//                   if ([[NSString stringWithFormat:@"%@",dict[@"sv_pricing_method"]] isEqualToString:@"0"]) {
                       [prlistDic setObject:[NSString stringWithFormat:@"%.2f", [dict[@"sv_pc_pnumber"]floatValue] + [dict[@"sv_p_weight"]floatValue]] forKey:@"sv_pc_pnumber"];
//                   } else {
//                       [prlistDic setObject:[NSString stringWithFormat:@"%ld", (long)[dict[@"sv_pc_pnumber"]floatValue]] forKey:@"sv_p_weight"];
//                   }
                   [prlistArr addObject:prlistDic];
                   
               }
               [parameters setObject:prlistArr forKey:@"Prlist"];
               
               [SVUserManager loadUserInfo];
               NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/addsv_purchasereturn_new?key=%@",[SVUserManager shareInstance].access_token];
               
               [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   
                   NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                   
                   if ([dic[@"succeed"] integerValue] == 1) {
                       
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       [SVTool TextButtonActionWithSing:@"退货成功"];
                       
//                       if (self.addPurchaseBlock) {
//                           self.addPurchaseBlock();
//                       }
                       
                       if (self.addRefundGoodsBlock) {
                           self.addRefundGoodsBlock();
                       }

                       //用延迟来移除提示框
                       dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                           //返回上一级
                           [self.navigationController popViewControllerAnimated:YES];
                       });
                       
                   } else {
                       
                       [MBProgressHUD hideHUDForView:self.view animated:YES];
                       NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
                       [SVTool TextButtonActionWithSing:errmsg];
                       
                   }
                   
                   //开启交互
                   [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
                   
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


- (IBAction)PrintingClick:(id)sender {
    
    if (manage.stage != JWScanStageCharacteristics) {
            // self.title = @"会员充值";
             [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
             return;
         }
      //显示时间
         NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.dic[@"sv_pc_date"] substringToIndex:10],[self.dic[@"sv_pc_date"] substringWithRange:NSMakeRange(11, 8)]];
         
         JWPrinter *printer = [[JWPrinter alloc] init];
         [printer defaultSetting];
         
         [SVUserManager loadUserInfo];
         
         [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
      if ([_dic[@"sv_pc_statestr"] containsString:@"待审核"]) {
            [printer appendText:@"退货单-草稿" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
      }else{
           [printer appendText:@"退货单-完成" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
      }
     
      
      [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.dic[@"sv_pc_noid"]] fontSize:HLFontSizeTitleSmalle];
        [printer appendTitle:@"时间:" value:timeString fontSize:HLFontSizeTitleSmalle];
       [printer appendSeperatorLine];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        [printer appendLeftText:@"品名/款号" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }else{
        
        [printer appendLeftText:@"品名/条码" middleText:@"单价" rightText:@"数量" priceText:@"小计" isTitle:NO];
    }
       
        [printer appendSeperatorLine];
      
      CGFloat total = 0.0;
       //  CGFloat totle_Discount_money = 0.0;
         CGFloat totle_count = 0.0;
      for (NSDictionary *dict in [self.dic objectForKey:@"Prlist"]) {
                 NSString *product_name = [NSString stringWithFormat:@"%@",dict[@"sv_p_name"]];
                 // dict[@"sv_p_specs"]
                 if (kStringIsEmpty(dict[@"sv_p_specs"])) {
                     [printer appendText:[NSString stringWithFormat:@"%@",product_name] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                 }else{
                     [printer appendText:[NSString stringWithFormat:@"%@ %@",product_name, dict[@"sv_p_specs"]] alignment:HLTextAlignmentLeft fontSize:HLFontSizeTitleSmalle];
                 }
                 
               
                     [printer appendLeftText:[NSString stringWithFormat:@"%@",dict[@"sv_p_barcode"]] middleText:[NSString stringWithFormat:@"%.1f",[dict[@"sv_pc_price"] floatValue]] rightText:[NSString stringWithFormat:@"%.1f",[dict[@"sv_pc_pnumber"] floatValue]] priceText:[NSString stringWithFormat:@"%.2f",[dict[@"sv_pc_combined"] floatValue]] isTitle:NO];
          
          total += [dict[@"sv_pc_combined"]floatValue];
          totle_count += [dict[@"sv_pc_pnumber"]floatValue];
             
         }
         [printer appendSeperatorLine];
         
         [printer appendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.1f",totle_count] priceText:[NSString stringWithFormat:@"%.2f",total] isTitle:NO];
         [printer appendSeperatorLine];
      
      [printer appendNewLine];
        [printer appendNewLine];
        [printer appendNewLine];
        [printer cutter];
        NSData *mainData = [printer getFinalData];
        __weak typeof(self) weakSelf = self;
        [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
            if (completion) {
                [SVTool TextButtonAction:self.view withSing:@"打印成功"];
                NSLog(@"打印成功");
            }else{
                NSLog(@"写入错误---:%@",error);
                [SVTool TextButtonAction:weakSelf.view withSing:error];
            }
            
          //  weakSelf.title = @"结算";
        }];
      
}

//- (IBAction)lookTransfersGoods {
//    
//    SVRefundGoodsDetailsVC *VC = [[SVRefundGoodsDetailsVC alloc]init];
//    VC.prlistArr = _dic[@"Prlist"];
//    [self.navigationController pushViewController:VC animated:YES];
//    
//}


#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //return self.waresNameArr.count;
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SVReturnGoodsDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:RefundGoodsDetailsID forIndexPath:indexPath];
    //如果没有就重新建一个
    if (!cell) {
        
        cell = [[NSBundle mainBundle] loadNibNamed:@"SVReturnGoodsDetailCell" owner:nil options:nil].lastObject;
        
    }
    
    //用模型数组给cell赋值
    cell.dict = self.modelArr[indexPath.row];
    
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

////设置cell的高度
//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

//}

#pragma mark - 懒加载
-(NSMutableArray *)modelArr{
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

//-(NSMutableArray *)prlistArr {
//    if (!_prlistArr) {
//        _prlistArr = [NSMutableArray array];
//    }
//    return _prlistArr;
//}

@end
