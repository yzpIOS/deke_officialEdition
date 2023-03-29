//
//  SVPurchaseDeteilsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVPurchaseDeteilsVC.h"
//cell
#import "SVPurchaseDeteilsCell.h"
//model
#import "SVPurchaseDeteilsModel.h"
//单件退货view
#import "SVSinglePieceView.h"


static NSString *PurchaseCellID = @"PurchaseCell";
@interface SVPurchaseDeteilsVC () <UITableViewDelegate,UITableViewDataSource>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *modelArr;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_statestr;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;
@property (weak, nonatomic) IBOutlet UILabel *sv_suname;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;

//一键入库
@property (weak, nonatomic) IBOutlet UIButton *awaitButton;

//记录左边点击
@property(nonatomic, assign) NSInteger number;
@property (nonatomic,strong) UIButton *button;

////记录单件退货的件数
//@property (nonatomic,assign) NSString *num;
////记录单件退商品的信息
//@property (nonatomic,strong) SVPurchaseDeteilsModel *model;
//
@property(nonatomic, strong) NSMutableArray *prlistArr;
////单件退货view
//@property (nonatomic,strong) SVSinglePieceView *singleView;
////遮盖view
//@property (nonatomic,strong) UIView *maskOneView;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_note;
@property (nonatomic,assign) BOOL isLookPrice;
@end

@implementation SVPurchaseDeteilsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [SVUserManager loadUserInfo];
     NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
     NSDictionary *StockManageDic = sv_versionpowersDict[@"StockManage"];
     NSString *StockManage = [NSString stringWithFormat:@"%@",StockManageDic[@"Procurement_Price_Total"]];
     if ([StockManage isEqualToString:@"0"]) {
         self.isLookPrice = NO;
     }else{
         self.isLookPrice = YES;
     }
    self.navigationItem.title = @"采购详情";
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, ScreenW, ScreenH-64-130)];
    self.tableView = [[UITableView alloc]init];
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消tableView的选中
    self.tableView.allowsSelection = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPurchaseDeteilsCell" bundle:nil] forCellReuseIdentifier:PurchaseCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH - 130-TopHeight));
        make.centerY.mas_equalTo(self.view).offset(64);
        make.centerX.mas_equalTo(self.view).offset(0);
    }];
    

    //赋值
    self.date.text = [self.dic[@"sv_pc_cdate"] substringWithRange:NSMakeRange(0, 10)];
    self.time.text = [self.dic[@"sv_pc_cdate"] substringWithRange:NSMakeRange(11, 5)];
    self.sv_pc_noid.text = self.dic[@"sv_pc_noid"];
    self.sv_pc_statestr.text = self.dic[@"sv_pc_statestr"];
    if (self.isLookPrice == true) {
         self.sv_pc_total.text = [NSString stringWithFormat:@"￥%.2f",[self.dic[@"sv_pc_total"] floatValue]];
    }else{
         self.sv_pc_total.text = @"****";
    }
   
    if ([SVTool isBlankString:self.dic[@"sv_suname"]]) {
        self.sv_suname.text = @"无";
    } else {
        self.sv_suname.text = [NSString stringWithFormat:@"%@",self.dic[@"sv_suname"]];
    }
    
    NSString *sv_pc_note = self.dic[@"sv_pc_note"];
    if (kStringIsEmpty(sv_pc_note)) {
        self.sv_pc_note.text = @"无";
    }else{
        self.sv_pc_note.text = self.dic[@"sv_pc_note"];
    }
    
    //判断是否已入库
    self.awaitButton.layer.cornerRadius = 3;
    if ([self.dic[@"sv_pc_statestr"] isEqualToString:@"已入库"]) {
        self.awaitButton.hidden = YES;
//        self.number = 0;
//        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退货" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonResponseEvent)];
//        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    }

    //取数据数组
    for (NSDictionary *dict in self.dic[@"Prlist"]) {
        SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
        [self.modelArr addObject:model];
    }
    
    //底部按钮
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - 114, ScreenW, 50)];
    [self.button setTitle:@"退货" forState:UIControlStateNormal];
    self.button.titleLabel.font = [UIFont systemFontOfSize: 15];
    [self.button setBackgroundColor:navigationBackgroundColor];
    [self.button addTarget:self action:@selector(wholeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    self.button.hidden = YES;
    
    
}

- (void)rightButtonResponseEvent{
    
    if (self.number == 0) {
        self.number = 1;
        self.navigationItem.rightBarButtonItem.title = @"取消";
        //改变frame
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH - 130-64-50));
            make.centerY.mas_equalTo(self.view).offset(39);
            make.centerX.mas_equalTo(self.view).offset(0);
        }];
        
        self.button.hidden = NO;
    } else {
        self.number = 0;
        self.navigationItem.rightBarButtonItem.title = @"退货";
        //改变frame
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH - 130-64));
            make.centerY.mas_equalTo(self.view).offset(64);
            make.centerX.mas_equalTo(self.view).offset(0);
        }];
        self.button.hidden = YES;
    }
    [self.tableView reloadData];
}


#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVPurchaseDeteilsCell *cell = [tableView dequeueReusableCellWithIdentifier:PurchaseCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVPurchaseDeteilsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:PurchaseCellID];
    }
    
    cell.model = self.modelArr[indexPath.row];
    
    if (self.number == 0) {
        cell.numButtonView.hidden = YES;
    } else {
        cell.numButtonView.hidden = NO;
    }
    
//    cell.returnButton.tag = indexPath.row;
//
//    //设置单件退货
//    [cell.returnButton addTarget:self action:@selector(singleButtonResponseEvent:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


//点击响应方法
//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//
//    SVSupplierDetailsVC *VC = [[SVSupplierDetailsVC alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
//
//}

#pragma mark - 滑动删除 Cell
//先要设Cell可编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (self.button.hidden == NO) {
        return TRUE;
    }
    return FALSE;
    
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
            
            [self.tableView reloadData];
            
        }
        
    }
    
}

#pragma mark - 一键入库
- (IBAction)awaitButtonResponseEvent {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要将此进行入库吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        
        [SVUserManager loadUserInfo];
        
        //不用交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
        //提示在退单中
        [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中……"];
        
        NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Repertory/updatesv_procurement?key=%@&id=%@&sate=%d",[SVUserManager shareInstance].access_token,self.dic[@"sv_pc_noid"],1];
        
        [[SVSaviTool sharedSaviTool] POST:strURL parameters:self.dic progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            if ([dic[@"succeed"] integerValue] == 1) {
                
                if (self.purchaseDeteilsBlock) {
                    self.purchaseDeteilsBlock();
                }
                
                self.awaitButton.hidden = YES;
                self.sv_pc_statestr.text = @"已入库";
                
                //self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"退货" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonResponseEvent)];
                //[self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonActionWithSing:@"入库成功"];
                
            } else {
                
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonActionWithSing:@"数据出错，入库失败"];
                
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
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:derAction];
    [alertController addAction:cancelAction];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - 退单按钮
//整单退货
-(void)wholeButtonResponseEvent{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要退货吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //不用交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
        //提示在退单中
        [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中……"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
        [parameters setObject:self.dic[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
        [parameters setObject:self.dic[@"sv_orgwarehouse_id"] forKey:@"sv_orgwarehouse_id"];
        [parameters setObject:self.dic[@"sv_suid"] forKey:@"sv_suid"];
        [parameters setObject:self.dic[@"sv_pc_note"] forKey:@"sv_pc_note"];
        [parameters setObject:self.dic[@"sv_pc_combined"] forKey:@"sv_pc_combined"];
        [parameters setObject:self.dic[@"sv_pc_total"] forKey:@"sv_pc_total"];
        [parameters setObject:self.dic[@"sv_pc_costs"] forKey:@"sv_pc_costs"];
        [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
        [parameters setObject:self.dic[@"sv_pc_state"] forKey:@"sv_pc_state"];
        [parameters setObject:self.dic[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];
        [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
        [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
        
        [self.prlistArr removeAllObjects];
        for (NSDictionary *dict in self.modelArr) {
            SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
            NSMutableDictionary *prlistDic = [NSMutableDictionary dictionary];
            [prlistDic setObject:model.product_id forKey:@"product_id"];
            [prlistDic setObject:model.sv_pc_price forKey:@"sv_pc_price"];
            [prlistDic setObject:model.sv_pc_combined forKey:@"sv_pc_combined"];
            [prlistDic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
            if ([model.sv_pricing_method isEqualToString:@"0"]) {
                [prlistDic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"sv_pc_pnumber"];
            } else {
                [prlistDic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"sv_p_weight"];
            }
            [self.prlistArr addObject:prlistDic];
            
        }
        [parameters setObject:self.prlistArr forKey:@"Prlist"];
        
        [SVUserManager loadUserInfo];
        NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/addsv_purchasereturn?key=%@",[SVUserManager shareInstance].access_token];

        [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];

            if ([dic[@"succeed"] integerValue] == 1) {

                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonActionWithSing:@"退货成功"];

                if (self.purchaseDeteilsBlock) {
                    self.purchaseDeteilsBlock();
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
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:derAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

//单件退货弹框
//-(void)singleButtonResponseEvent:(UIButton *)button{
//
//    self.model = self.modelArr[button.tag];
//
//    self.singleView.number.text = @"1";
//    self.singleView.note.text = nil;
//    self.singleView.waresName.text = self.model.sv_p_name;
//
//    if ([self.model.sv_pricing_method isEqualToString:@"0"]) {
//        self.num = self.model.sv_pc_pnumber;
//    } else {
//        self.num = self.model.sv_p_weight;
//    }
//
//    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
//    [[UIApplication sharedApplication].keyWindow addSubview:self.singleView];
//
//    //设置字体的颜色
//    [self.singleView.oneButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//    [self.singleView.twoButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//    [self.singleView.threeButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//
//}

/**
 单件退货确定按钮
 */
//-(void)oneDetermineResponseEvent{
//
//    if ([self.singleView.number.text integerValue] == 0) {
//        [SVTool TextButtonAction:self.singleView withSing:@"请输入退货数量"];
//        return;
//    }
//
//    if ([self.singleView.number.text integerValue] > [self.num integerValue]) {
//        [SVTool TextButtonAction:self.singleView withSing:@"数量过大"];
//        return;
//    }
//
//    [self oneCancelResponseEvent];
//
//    [SVUserManager loadUserInfo];
//
//    //让按钮不可点
//    [self.singleView.determineButton setEnabled:NO];
//    //不用交互
//    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
//    //提示在退单中
//    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中……"];
//
//    NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Supplier/addsv_purchasereturn?key=%@",[SVUserManager shareInstance].access_token];
//
//    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
//
//    [parameters setObject:self.dic[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
//    [parameters setObject:self.dic[@"sv_orgwarehouse_id"] forKey:@"sv_orgwarehouse_id"];
//    [parameters setObject:self.dic[@"sv_suid"] forKey:@"sv_suid"];
//    [parameters setObject:self.dic[@"sv_pc_note"] forKey:@"sv_pc_note"];
//    [parameters setObject:self.dic[@"sv_pc_combined"] forKey:@"sv_pc_combined"];
//    [parameters setObject:self.dic[@"sv_pc_total"] forKey:@"sv_pc_total"];
//    [parameters setObject:self.dic[@"sv_pc_costs"] forKey:@"sv_pc_costs"];
//    [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
//    [parameters setObject:self.dic[@"sv_pc_state"] forKey:@"sv_pc_state"];
//    [parameters setObject:self.dic[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];
//    [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
//    [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
//    [parameters setObject:self.singleView.note.text forKey:@"sv_procurement.sv_pc_note"];
//
//    NSMutableDictionary *prlistDic = [NSMutableDictionary dictionary];
//    [prlistDic setObject:self.model.product_id forKey:@"product_id"];
//    [prlistDic setObject:self.model.sv_pc_price forKey:@"sv_pc_price"];
//    [prlistDic setObject:self.model.sv_pc_combined forKey:@"sv_pc_combined"];
//    [prlistDic setObject:self.model.sv_pricing_method forKey:@"sv_pricing_method"];
//    if ([self.model.sv_pricing_method isEqualToString:@"0"]) {
//        [prlistDic setObject:self.model.sv_pc_pnumber forKey:@"sv_pc_pnumber"];
//    } else {
//        [prlistDic setObject:self.model.sv_p_weight forKey:@"sv_p_weight"];
//    }
//    [self.prlistArr addObject:prlistDic];
//    [parameters setObject:self.prlistArr forKey:@"Prlist"];
//
//    [[SVSaviTool sharedSaviTool] POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//        if ([dic[@"succeed"] integerValue] == 1) {
//
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            [SVTool TextButtonActionWithSing:@"退货成功"];
//
//            if (self.purchaseDeteilsBlock) {
//                self.purchaseDeteilsBlock();
//            }
//
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                //返回上一级
//                [self.navigationController popViewControllerAnimated:YES];
//            });
//
//        } else {
//
//            [MBProgressHUD hideHUDForView:self.view animated:YES];
//            NSString *errmsg = [NSString stringWithFormat:@"%@",dic[@"errmsg"]];
//            [SVTool TextButtonActionWithSing:errmsg];
//
//        }
//
//        //开启交互
////        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
//
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        //隐藏提示
//        [MBProgressHUD hideHUDForView:self.view animated:YES];
//        //            [SVTool requestFailed];
//        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
//
//    }];
//
//    //让按钮不可点
//    [self.singleView.determineButton setEnabled:YES];
//    //开启交互
//    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
//
//}

#pragma mark - 懒加载
//-(UITableView *)tableView{
//    if (!_tableView) {
//        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 130, ScreenW, ScreenH-64-130-50)];
//        _tableView.tableFooterView = [[UIView alloc]init];
//        //取消tableView的选中
//        _tableView.allowsSelection = NO;
//        _tableView.showsVerticalScrollIndicator = NO;
//        //指定代理
//        _tableView.delegate = self;
//        _tableView.dataSource = self;
//
//
//        [self.view addSubview:_tableView];
//    }
//    return _tableView;
//}

- (NSMutableArray *)modelArr {
    
    if (!_modelArr) {
        
        _modelArr = [NSMutableArray array];
        
    }
    return _modelArr;
}

-(NSMutableArray *)prlistArr {
    if (!_prlistArr) {
        _prlistArr = [NSMutableArray array];
    }
    return _prlistArr;
}

//遮盖View
//-(UIView *)maskOneView{
//    if (!_maskOneView) {
//        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
//        //添加一个点击手势
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(oneCancelResponseEvent)];
//        [_maskOneView addGestureRecognizer:tap];
//    }
//    return _maskOneView;
//}
//
//-(SVSinglePieceView *)singleView{
//    if (!_singleView) {
//        _singleView = [[NSBundle mainBundle] loadNibNamed:@"SVSinglePieceView" owner:nil options:nil].lastObject;
//        CGFloat W = 320;
//        CGFloat H = 400;
//
//        CGFloat x = (ScreenW - W) / 2;
//        CGFloat y = (ScreenH - H) / 2;
//
//        _singleView.frame = CGRectMake(x, y, W, H);
//        _singleView.layer.cornerRadius = 10;
//        _singleView.determineButton.layer.cornerRadius = 10;
//        //只要值发生改变就会调用
//        [_singleView.note addTarget:self action:@selector(textFiledDidChange) forControlEvents:UIControlEventEditingChanged];
//        //
//        [_singleView.exitButton addTarget:self action:@selector(oneCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//        [_singleView.determineButton addTarget:self action:@selector(oneDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//
//
//        [_singleView.oneButton addTarget:self action:@selector(oneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//        [_singleView.twoButton addTarget:self action:@selector(twoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//        [_singleView.threeButton addTarget:self action:@selector(threeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
//
//    }
//    return _singleView;
//}
//
////点击手势的点击事件
//- (void)oneCancelResponseEvent{
//
//    [self.maskOneView removeFromSuperview];
//    [self.singleView removeFromSuperview];
//
//}
//
//-(void)oneButtonResponseEvent{
//
//    self.singleView.oneButton.selected = YES;
//    self.singleView.twoButton.selected = NO;
//    self.singleView.threeButton.selected = NO;
//
//    [self.singleView.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//
//    self.singleView.note.text = self.singleView.oneButton.titleLabel.text;
//
//}
//
//-(void)twoButtonResponseEvent{
//
//    self.singleView.oneButton.selected = NO;
//    self.singleView.twoButton.selected = YES;
//    self.singleView.threeButton.selected = NO;
//
//    [self.singleView.twoButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//
//    self.singleView.note.text = self.singleView.twoButton.titleLabel.text;
//
//}
//
//-(void)threeButtonResponseEvent{
//
//    self.singleView.oneButton.selected = NO;
//    self.singleView.twoButton.selected = NO;
//    self.singleView.threeButton.selected = YES;
//
//    [self.singleView.threeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//
//    self.singleView.note.text = self.singleView.threeButton.titleLabel.text;
//
//
//}
//
////当输入框内容发生变化时，就会触发，能够及时获取到输入框最新的内容
//-(void)textFiledDidChange {
//
//    if ([self.singleView.note.text isEqualToString:@"商品质量问题"]) {
//        [self.singleView.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    } else {
//        [self.singleView.oneButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//    }
//
//    if ([self.singleView.note.text isEqualToString:@"商品不一致"]) {
//        [self.singleView.twoButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    } else {
//        [self.singleView.twoButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//    }
//
//    if ([self.singleView.note.text isEqualToString:@"其他原因"]) {
//        [self.singleView.threeButton setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
//    } else {
//        [self.singleView.threeButton setTitleColor:RGBA(104, 104, 104, 1) forState:UIControlStateSelected];
//    }
//
//}



@end
