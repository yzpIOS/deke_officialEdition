//
//  SVaddRefundGoodsVC.m
//  SAVI
//
//  Created by Sorgle on 2018/3/29.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVaddRefundGoodsVC.h"

//增加选择界面
#import "SVProcurementListVC.h"
//弹框view
#import "SVvipPickerView.h"
//模型
#import "SVPurchaseDeteilsModel.h"
//cell
//#import "SVPurchaseDeteilsCell.h"
#import "SVRefundGoodsCell.h"

static NSString *addRefundGoodsCellID = @"addRefundGoodsCell";
@interface SVaddRefundGoodsVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView *tableView;

@property (weak, nonatomic) IBOutlet UILabel *supplierLabel;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;//支付
@property (weak, nonatomic) IBOutlet UIButton *refundButton;
@property (weak, nonatomic) IBOutlet UIButton *addButton;
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *selectView;

@property (nonatomic,strong) NSArray *payArr;
@property (nonatomic,strong) NSMutableArray *modelArr;

@property(nonatomic, strong) NSDictionary *dic;
//记录ID的
@property (nonatomic,copy) NSString *supplierID;//供应商
//记录入库状态 0是待入库，1是
@property (nonatomic,copy) NSString *state;

@property (nonatomic,assign) double sumMoney;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

//三个弹view
@property (nonatomic,strong) SVvipPickerView *PickerView;
//保存view
//@property (nonatomic,strong) SVSaveWarehousingView *singleView;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@end

@implementation SVaddRefundGoodsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"新增退货";
    self.refundButton.hidden = YES;
    //    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"进货单" style:UIBarButtonItemStylePlain target:self action:@selector(rightButtonResponseEvent)];
    //    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    self.supplierLabel.text = nil;
    
    self.payArr = @[@"现金",@"银行卡",@"支付宝",@"微信"];
    
//    [self.selectView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.view);
//    }];
    [self.oneView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
    }];
    [self.twoView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(51);
    }];
    [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view);
    }];
    
//    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 161, ScreenW, ScreenH-161-51-64)];
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SVRefundGoodsCell" bundle:nil] forCellReuseIdentifier:addRefundGoodsCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-TopHeight-51));
        make.top.mas_equalTo(self.selectView.mas_bottom).offset(1);
    }];
    
}



- (IBAction)threeButtonResponseEvent {
    
    //指定代理
    self.PickerView.vipPicker.delegate = self;
    self.PickerView.vipPicker.dataSource = self;
    //添加pickerView
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.PickerView];
    
}

- (IBAction)goodsResponseEvent {
    
    SVProcurementListVC *VC = [[SVProcurementListVC alloc]init];
    VC.controllerNum = 1;
    //记录筛选
    VC.oneState = 2;
    VC.twoState = 2;
    VC.threeState = 2;
    VC.fourState = 2;
    
    __weak typeof(self) weakSelf = self;
    VC.procurementListBlock = ^(NSDictionary *dic) {
        
        [self.selectView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.view).offset(111);
        }];
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-162-51-TopHeight));
            make.top.mas_equalTo(self.selectView.mas_bottom).offset(1);
        }];
        
        
        self.refundButton.hidden = NO;
        [weakSelf.modelArr removeAllObjects];
        weakSelf.dic = dic;
        weakSelf.supplierID = dic[@"sv_suid"];
        [weakSelf.addButton setImage:nil forState:UIControlStateNormal];
        [weakSelf.addButton setTitle:dic[@"sv_pc_noid"] forState:UIControlStateNormal];
        
        if ([SVTool isBlankString:dic[@"sv_suname"]]) {
            weakSelf.supplierLabel.text = @"无";
        } else {
            weakSelf.supplierLabel.text = [NSString stringWithFormat:@"%@",dic[@"sv_suname"]];
        }
        
        //取数据数组
        for (NSDictionary *dict in dic[@"Prlist"]) {
            SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
            [weakSelf.modelArr addObject:model];
        }
        
        [weakSelf.tableView reloadData];
        
    };
    //跳转
    [self.navigationController pushViewController:VC animated:YES];
    
}

- (IBAction)saveResponseEvent {
    
    //    if ([SVTool isBlankString:self.supplierID]) {
    //        [SVTool TextButtonAction:self.view withSing:@"请选择退货单"];
    //        return;
    //    }
    //
    //    if ([SVTool isEmpty:self.modelArr]) {
    //        [SVTool TextButtonAction:self.view withSing:@"请选择商品"];
    //        return;
    //    }
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定要退货吗?" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //不用交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
        //提示在退单中
        [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中……"];
        
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        
//        [parameters setObject:self.dic[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
//        [parameters setObject:@(0) forKey:@"sv_pc_id"];// 退货单id
//
//      //  [parameters setObject:self.dic[@"sv_orgwarehouse_id"] forKey:@"sv_orgwarehouse_id"];
//
//        [parameters setObject:self.dic[@"sv_suid"] forKey:@"sv_suid"];
//
//        [parameters setObject:self.dic[@"sv_pc_note"] forKey:@"sv_pc_note"];
//        [parameters setObject:self.dic[@"sv_pc_combined"] forKey:@"sv_pc_combined"];
//
//        [parameters setObject:self.dic[@"sv_pc_total"] forKey:@"sv_pc_total"];
//        [parameters setObject:self.dic[@"sv_pc_costs"] forKey:@"sv_pc_costs"];
//        [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
//        [parameters setObject:self.dic[@"sv_pc_state"] forKey:@"sv_pc_state"];
//        [parameters setObject:self.dic[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];
//        [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
//        [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
        
        [parameters setObject:@"" forKey:@"sv_pc_noid"];
        [parameters setObject:@(0) forKey:@"sv_pc_id"];// 退货单id
       NSString *currentTimeString = [self getCurrentTimes];
        [parameters setObject:currentTimeString forKey:@"sv_pc_date"];
          
          [parameters setObject:self.dic[@"sv_suid"] forKey:@"sv_suid"];
          
          [parameters setObject:self.dic[@"sv_pc_note"] forKey:@"sv_pc_note"];
          [parameters setObject:self.dic[@"sv_pc_combined"] forKey:@"sv_pc_combined"];
          
          [parameters setObject:self.dic[@"sv_pc_total"] forKey:@"sv_pc_total"];
          [parameters setObject:self.dic[@"sv_pc_costs"] forKey:@"sv_pc_costs"];
          [parameters setObject:self.dic[@"sv_pc_settlement"] forKey:@"sv_pc_settlement"];
          [parameters setObject:self.dic[@"sv_pc_state"] forKey:@"sv_pc_state"];
          [parameters setObject:self.dic[@"sv_pc_realpay"] forKey:@"sv_pc_realpay"];
          [parameters setObject:self.dic[@"sv_productname"] forKey:@"sv_productname"];
       //   [parameters setObject:self.dic[@"sv_associated_code"] forKey:@"sv_associated_code"];
        [parameters setObject:@"true" forKey:@"is_single_product"];
        [parameters setObject:@"300" forKey:@"sv_source_type"];
        
        
        NSMutableArray *prlistArr = [NSMutableArray array];
        for (NSDictionary *dict in self.modelArr) {
            SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
            NSMutableDictionary *prlistDic = [NSMutableDictionary dictionary];
            [prlistDic setObject:model.product_id forKey:@"product_id"];
            
            [prlistDic setObject:@(model.sv_record_id) forKey:@"sv_record_id"];
            
            [prlistDic setObject:model.sv_pc_price forKey:@"sv_pc_price"];
            [prlistDic setObject:model.sv_pc_combined forKey:@"sv_pc_combined"];
            [prlistDic setObject:model.sv_pricing_method forKey:@"sv_pricing_method"];
            [prlistDic setObject:model.sv_p_barcode forKey:@"sv_p_barcode"];
            if (!kStringIsEmpty(model.sv_p_specs)) {
                [prlistDic setObject:model.sv_p_specs forKey:@"sv_p_specs"];
            }
            if ([model.sv_pricing_method isEqualToString:@"0"]) {
                [prlistDic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"sv_pc_pnumber"];
            } else {
                [prlistDic setObject:[NSString stringWithFormat:@"%ld",(long)model.product_num] forKey:@"sv_p_weight"];
            }
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
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alertController addAction:derAction];
    
    [alertController addAction:cancelAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
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

#pragma mark - 退货


#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVRefundGoodsCell *cell = [tableView dequeueReusableCellWithIdentifier:addRefundGoodsCellID forIndexPath:indexPath];
    
    if (!cell) {
        cell = [[SVRefundGoodsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addRefundGoodsCellID];
    }
    
    cell.model = self.modelArr[indexPath.row];
    
    self.sumMoney = 0.00;
    for (NSDictionary *dict in self.modelArr) {
        SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
        double money = [model.sv_pc_price doubleValue];
        self.sumMoney += model.product_num * money;
    }
    
    self.moneyLabel.text = [NSString stringWithFormat:@"%.2f",self.sumMoney];
    
    __weak typeof(self) weakSelf = self;
    [cell setPurchaseDeteilsBlock:^() {
        weakSelf.sumMoney = 0.00;
        for (NSDictionary *dict in weakSelf.modelArr) {
            SVPurchaseDeteilsModel *model = [SVPurchaseDeteilsModel mj_objectWithKeyValues:dict];
            double money = [model.sv_pc_price doubleValue];
            weakSelf.sumMoney += model.product_num * money;
        }
        
        weakSelf.moneyLabel.text = [NSString stringWithFormat:@"%.2f",weakSelf.sumMoney];
    }];
    
    //当减到1的时候，再点一下就提示删除
    [cell setRemoveRefundGoodsCellBlock:^(SVPurchaseDeteilsModel *model) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"确定删除此商品吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *derAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            [weakSelf.modelArr removeObject:model];
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
    return self.payArr.count;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.payArr[row];
}

#pragma mark - 懒加载

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

//确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    
    NSInteger row = [self.PickerView.vipPicker selectedRowInComponent:0];
    [self.threeButton setTitle:[self.payArr objectAtIndex:row] forState:UIControlStateNormal];
    
    [self.PickerView removeFromSuperview];
}

//点击手势的点击事件
- (void)oneCancelResponseEvent{
    
    [self.maskOneView removeFromSuperview];
    [self.PickerView removeFromSuperview];
    
}


@end
