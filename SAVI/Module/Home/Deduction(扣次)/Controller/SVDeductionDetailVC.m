//
//  SVDeductionDetailVC.m
//  SAVI
//
//  Created by 杨忠平 on 2019/10/22.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVDeductionDetailVC.h"
#import "SVSettlementTimesCountModel.h"
#import "SVExpandBtn.h"
//导入头文件
#import <CoreBluetooth/CoreBluetooth.h>
#import "JWBluetoothManage.h"
#import "SVUnitPickerView.h"

#define WeakSelf __block __weak typeof(self)weakSelf = self;
@interface SVDeductionDetailVC ()<UITextFieldDelegate,CBCentralManagerDelegate,UIPickerViewDataSource,UIPickerViewDelegate>
{
     JWBluetoothManage * manage;
}
@property (weak, nonatomic) IBOutlet UIView *careView;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UILabel *name_leval;
@property (weak, nonatomic) IBOutlet UILabel *care;
@property (weak, nonatomic) IBOutlet UILabel *storeValues;
@property (weak, nonatomic) IBOutlet UILabel *availablepoint;
@property (weak, nonatomic) IBOutlet UILabel *sumpoint;
@property (weak, nonatomic) IBOutlet UILabel *birthday;
@property (weak, nonatomic) IBOutlet UIImageView *header;

@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *big_height;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomView_height;

@property (nonatomic,strong) NSMutableArray *count_textArray;

@property (nonatomic,strong) NSMutableArray *insert_btnArray;

@property (nonatomic,strong) NSMutableArray *reduce_btnArray;

@property (nonatomic,strong) NSMutableArray *selectModelArray;
@property (nonatomic,strong) NSString *everyday_serialnumber;

//@property (strong,nonatomic) CBPeripheral *currPeripheral;//要连接的蓝牙名称
@property (nonatomic,copy) NSString *printeName;//已连接的蓝牙名称
@property (nonatomic, strong) NSMutableArray * dataSource; //设备列表
@property (nonatomic, strong) NSMutableArray * rssisArray; //信号强度 可选择性使用

@property(strong,nonatomic) CBCentralManager *CM;

@property (nonatomic,strong) NSDictionary *result;

@property (weak, nonatomic) IBOutlet UIButton *drawerBtn;

//自定义pickerView
@property(nonatomic,strong) SVUnitPickerView *pickerView;

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;

//销售人员
@property (nonatomic, copy) NSString *sv_employee_id;
@property (nonatomic, strong) NSMutableArray *sv_employee_idArr;
@property (nonatomic, strong) NSMutableArray *sv_employee_nameArr;
@property (nonatomic,strong) NSString *dateString;
@property (nonatomic,strong) SVOrderData *orderData;
@end

@implementation SVDeductionDetailVC

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
            message = @"未打开";
            break;
        case 5:
            message = @"蓝牙已经成功开启,请稍后再试";
            break;
        default:
            break;
    }
    if([message isEqualToString:@"未打开"]) {
        
    } else {
        //用延迟来作提示
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (![message containsString:@"蓝牙已经成功开启,请稍后再试"]) {
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [SVTool TextButtonAction:self.view withSing:@"未连接蓝牙,打印失败"];
               // self.title = @"结算";
            }
        });
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"快速扣次";
    // 加载提成人
        [self loadData];
    self.dataSource = @[].mutableCopy;
    self.rssisArray = @[].mutableCopy;
    self.careView.layer.cornerRadius = 10;
    self.careView.layer.masksToBounds = YES;
    
    self.sureBtn.layer.cornerRadius = 25;
    self.sureBtn.layer.masksToBounds = YES;
    self.drawerBtn.layer.cornerRadius = 25;
    self.drawerBtn.layer.masksToBounds = YES;
    
    self.header.layer.cornerRadius = 10;
    self.header.layer.masksToBounds = YES;
    
    self.name_leval.text = [NSString stringWithFormat:@"%@.%@",self.name,self.level];
    self.care.text = self.sv_mr_cardno;
    self.storeValues.text = self.storedValue;
    self.availablepoint.text = self.sv_mw_availablepoint;
    self.sumpoint.text = self.sv_mw_sumpoint;
   // 1.从第三个字符开始，截取长度为2的字符串.........注:空格算作一个字符
    self.birthday.text = [self.sv_mr_birthday substringWithRange:NSMakeRange(5,5)];//str2 = "is"
   // NSString *oneText = [self.sv_mr_birthday substringToIndex:10];//（length为7）];
    
    
    if (![SVTool isBlankString:self.headimg]) {
        [self.header sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.headimg]] placeholderImage:[UIImage imageNamed:@"foodimg"]];
    } else {
        
        self.header.image = [UIImage imageNamed:@"foodimg"];
    }
  
    // 加载单号
   // [self loadOddsMembers];
    CGFloat maxY = 0;

        for (NSInteger i = 0; i < self.timesCountArr.count; i++) {
        SVSettlementTimesCountModel *model = self.timesCountArr[i];
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, maxY, ScreenW, 60)];
        view.backgroundColor = [UIColor whiteColor];
            [self.bottomView addSubview:view];
        
        
      //  UILabel *nameL = [[UILabel alloc] init];
        UILabel *leftLabel = [[UILabel alloc] init];
        [view addSubview:leftLabel];
        leftLabel.backgroundColor = [UIColor whiteColor];
        leftLabel.textColor = [UIColor colorWithHexString:@"555555"];
        leftLabel.font = [UIFont systemFontOfSize:14];
        leftLabel.text = model.sv_p_name;
        [leftLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(view.mas_left).offset(20);
            make.centerY.mas_equalTo(view.mas_centerY);
            make.width.mas_equalTo(910);
        }];
        
        UILabel *middleLabel = [[UILabel alloc] init];
        [view addSubview:middleLabel];
        middleLabel.backgroundColor = [UIColor whiteColor];
        middleLabel.textColor = [UIColor colorWithHexString:@"555555"];
        middleLabel.font = [UIFont systemFontOfSize:12];
        middleLabel.text = [NSString stringWithFormat:@"（还剩%ld次）",model.sv_mcc_leftcount];
//        middleLabel.backgroundColor = [UIColor colorWithHexString:@"FCEAC3"];
        middleLabel.layer.cornerRadius = 3;
        middleLabel.layer.masksToBounds = YES;
        [middleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(leftLabel.mas_bottom).offset(0);
            make.left.mas_equalTo(view.mas_left).offset(20);
        }];
            
            
        SVExpandBtn *insert_btn = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
            insert_btn.tag = i;
            [self.insert_btnArray addObject:insert_btn];
        [view addSubview:insert_btn];
    
        [insert_btn addTarget:self action:@selector(insert_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        [insert_btn setImage:[UIImage imageNamed:@"icon_insert"] forState:UIControlStateNormal];
        [insert_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(view.mas_right).offset(-20);
        }];
 
            UITextField *count_text = [[UITextField alloc] init];
            count_text.tag = i;
            [self.count_textArray addObject:count_text];
            count_text.delegate = self;
            
            count_text.textColor = [UIColor grayColor];
            count_text.keyboardType = UIKeyboardTypeNumberPad;
            count_text.font = [UIFont systemFontOfSize:14];
            //  count_text.textColor = GlobalFontColor;
            count_text.textAlignment = NSTextAlignmentCenter;
            [view addSubview:count_text];
            [count_text mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.mas_equalTo(insert_btn.mas_left);
                make.centerY.mas_equalTo(view.mas_centerY);
                make.width.mas_equalTo(40);
                make.height.mas_equalTo(40);
            }];
            if (self.timesCountArr.count == 1) {
                if (model.sv_mcc_leftcount < 1) {
                    count_text.text = @"0";
                }else{
                    count_text.text = @"1";
                    model.product_num = @"1";
                    [self.selectModelArray addObject:model];
                }
          
            }else{
             count_text.text = @"0";
            }

        SVExpandBtn *reduce_btn = [SVExpandBtn buttonWithType:UIButtonTypeCustom];
            reduce_btn.tag = i;
            [self.reduce_btnArray addObject:reduce_btn];
        [view addSubview:reduce_btn];
        [reduce_btn addTarget:self action:@selector(reduce_btnClick:) forControlEvents:UIControlEventTouchUpInside];
        //  [circle_btn setImage:[UIImage imageNamed:@"ic_yixuan.png"] forState:UIControlStateSelected];
        [reduce_btn setImage:[UIImage imageNamed:@"icon_reduce"] forState:UIControlStateNormal];
        [reduce_btn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(view.mas_centerY);
            make.right.mas_equalTo(count_text.mas_left);
        }];
            
            UILabel *rightLabel = [[UILabel alloc] init];
            [view addSubview:rightLabel];
            rightLabel.backgroundColor = [UIColor whiteColor];
            rightLabel.textColor = [UIColor colorWithHexString:@"555555"];
            rightLabel.font = [UIFont systemFontOfSize:12];
            if (!kStringIsEmpty(model.validity_date)) {
                NSString *string = [model.validity_date substringToIndex:10];//（length为7）
                 rightLabel.text = [NSString stringWithFormat:@"过期时间：%@",string];
            }
           
            rightLabel.backgroundColor = [UIColor colorWithHexString:@"FCEAC3"];
            rightLabel.layer.cornerRadius = 3;
            rightLabel.layer.masksToBounds = YES;
            [rightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(leftLabel.mas_bottom).offset(0);
                make.left.mas_equalTo(middleLabel.mas_right).offset(10);
            }];
        
        maxY = CGRectGetMaxY(view.frame) + 1 ;
        
      
        
    }
    
    
    
    self.bottomView_height.constant = self.timesCountArr.count* 60 + self.timesCountArr.count -1;
    
    self.big_height.constant = self.bottomView_height.constant + self.careView.height;
    
    //初始化对象，设置代理
    self.CM = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    
    //创建蓝牙
    manage = [JWBluetoothManage sharedInstance];
    WeakSelf
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
    
  
}


#pragma mark -  请求计算提成的人
- (void)loadData{
   // [SVTool IndeterminateButtonActionWithSing:nil];
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/GetEmployeePageList?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employeeid] || [[SVUserManager shareInstance].sv_employeeid isEqualToString:@"<null>"]) {
            [self.sv_employee_idArr addObject:@""];
        } else {
            [self.sv_employee_idArr addObject:[SVUserManager shareInstance].sv_employeeid];
        }
        if ([SVTool isBlankString:[SVUserManager shareInstance].sv_employee_name] || [[SVUserManager shareInstance].sv_employee_name isEqualToString:@"<null>"]) {
            [self.sv_employee_nameArr addObject:@""];
        } else {
            [self.sv_employee_nameArr addObject:[SVUserManager shareInstance].sv_employee_name];
        }
        if ([dict[@"succeed"]integerValue]==1) {
            if (![SVTool isEmpty:[dict objectForKey:@"values"]]) {
                for (NSDictionary *dic in [dict objectForKey:@"values"]) {
                    [self.sv_employee_idArr addObject:dic[@"sv_employee_id"]];
                    [self.sv_employee_nameArr addObject:dic[@"sv_employee_name"]];
                }
            }
        }
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}

#pragma mark - 点击开单人按钮
- (IBAction)drawerClick:(id)sender {
    //pickerView指定代理
    self.pickerView.unitPicker.delegate = self;
    self.pickerView.unitPicker.dataSource = self;
    
    //为空是提示
    //    if ([SVTool isEmpty:self.pickViewArr]) {
    //        [SVTool TextButtonAction:self.view withSing:@"单位数据为空，可到电脑端添加单位"];
    //        return;
    //    }
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.pickerView];
}

/**
 遮盖View
 */
-(UIView *)maskTheView{
    if (!_maskTheView) {
        _maskTheView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTheView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(unitCancelResponseEvent)];
        [_maskTheView addGestureRecognizer:tap];
    }
    return _maskTheView;
}

#pragma mark - 开单人点击确定
- (void)unitDetermineResponseEvent{
    [self.pickerView removeFromSuperview];
    [self.maskTheView removeFromSuperview];
     //获取pickerView中第0列的选中值
     NSInteger row=[self.pickerView.unitPicker selectedRowInComponent:0];
     NSString *sv_employee_name = [self.sv_employee_nameArr objectAtIndex:row];
    [self.drawerBtn setTitle:sv_employee_name forState:UIControlStateNormal];
     self.sv_employee_id = [NSString stringWithFormat:@"%@",[self.sv_employee_idArr objectAtIndex:row]];
}

#pragma mark UIPickerView DataSource Method 数据源方法

//指定pickerview有几个表盘
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;//第一个展示字母、第二个展示数字
}

//指定每个表盘上有几行数据
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.sv_employee_idArr.count;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //self.unit = self.pickViewArr[row];
    
    return self.sv_employee_nameArr[row];
}

-(NSMutableArray *)sv_employee_idArr {
    if (!_sv_employee_idArr) {
        _sv_employee_idArr = [NSMutableArray array];
    }
    return _sv_employee_idArr;
}

-(NSMutableArray *)sv_employee_nameArr {
    if (!_sv_employee_nameArr) {
        _sv_employee_nameArr = [NSMutableArray array];
    }
    return _sv_employee_nameArr;
}

#pragma mark - 加载单号
- (void)loadOddsMembers{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/GetDailySerialNumber?key=%@&plusone=true",[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"6565656dic = %@",dic);
  
        self.everyday_serialnumber = dic[@"values"];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [DKTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - 点击加号
- (void)insert_btnClick:(UIButton *)insert_btn{
    for (UITextField *textF in self.count_textArray) {
        if (insert_btn.tag == textF.tag) {
            textF.textColor = [UIColor colorWithHexString:@"555555"];
            NSInteger count = [textF.text integerValue];
            count += 1;
            textF.text = [NSString stringWithFormat:@"%ld",count];
             SVSettlementTimesCountModel *model = self.timesCountArr[insert_btn.tag];
            if (model.sv_mcc_leftcount < textF.text.integerValue) {
                count -= 1;
                textF.text = [NSString stringWithFormat:@"%ld",count];
                [SVTool TextButtonActionWithSing:@"剩余扣次不足"];
            }else{
                if (kArrayIsEmpty(self.selectModelArray)) {
                    model.product_num = textF.text;
                    [self.selectModelArray addObject:model];
                }else{
                    for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {
                        if (selectModel.userecord_id == model.userecord_id) {
                            [self.selectModelArray removeObject:selectModel];
                            
                            model.product_num = textF.text;
                            
                           break;
                            
                        }
                        
                    }
                    model.product_num = textF.text;
                    [self.selectModelArray addObject:model];
                    
                    break;
                }
                
                //让图变大变小的
                textF.transform = CGAffineTransformMakeScale(1, 1);
                [UIView animateWithDuration:0.1   animations:^{
                    textF.transform = CGAffineTransformMakeScale(1.5, 1.5);
                }completion:^(BOOL finish){
                    [UIView animateWithDuration:0.1      animations:^{
                        textF.transform = CGAffineTransformMakeScale(0.9, 0.9);
                    }completion:^(BOOL finish){
                        [UIView animateWithDuration:0.1   animations:^{
                            textF.transform = CGAffineTransformMakeScale(1, 1);
                        }completion:^(BOOL finish){
                        }];
                    }];
                }];
            }
      
            
            
        }
    }
    
}

- (void)reduce_btnClick:(UIButton *)reduce_btn{
    
    for (UITextField *textF in self.count_textArray) {
      // UITextField *textF = self.count_textArray[reduce_btn.tag];
        if (reduce_btn.tag == textF.tag && textF.text.integerValue >0) {
            textF.textColor = [UIColor colorWithHexString:@"555555"];
            NSInteger count = [textF.text integerValue];
            count -= 1;
            textF.text = [NSString stringWithFormat:@"%ld",count];
            if (count <= 0) {
                if (!kArrayIsEmpty(self.selectModelArray)) {
//                    [self.selectModelArray enumerateObjectsUsingBlock:^(SVSettlementTimesCountModel *model2, NSUInteger idx, BOOL * _Nonnull stop) {
//
//                        if (model2.product_num.integerValue == 0) {
//                            [self.selectModelArray removeObject:model2];
//                            *stop = YES;
//                        }
//                    }];
                    
                    [self.selectModelArray removeObject:self.timesCountArr[reduce_btn.tag]];
                  
                }
                
            }else{
              
                    SVSettlementTimesCountModel *model = self.timesCountArr[reduce_btn.tag];
                if (kArrayIsEmpty(self.selectModelArray)) {
                    model.product_num = textF.text;
                    [self.selectModelArray addObject:model];
                }else{
                    for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {
                        SVSettlementTimesCountModel *model = self.timesCountArr[reduce_btn.tag];
                        if (selectModel.userecord_id == model.userecord_id) {
                            [self.selectModelArray removeObject:selectModel];
                            model.product_num = textF.text;
                            break;
                        }
                    }

                    [self.selectModelArray addObject:model];
                }

            }

            break;
        }
    }

}

#pragma mark - 确定
- (IBAction)sureClick:(id)sender {
  
     [self.maskTheView removeFromSuperview];
    if (kArrayIsEmpty(self.selectModelArray)) {
        [SVTool TextButtonActionWithSing:@"请选择扣次商品"];
    }else{
        
        self.sureBtn.userInteractionEnabled = NO;
        NSMutableDictionary *parame = [NSMutableDictionary dictionary];
        
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
        self.dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
      //  [parame setObject:dateString forKey:@"order_datetime"];
        
        [parame setObject:self.sv_mr_cardno forKey:@"sv_mr_cardno"];
        //会员卡号（实给会员ID)
        [parame setObject:self.member_id forKey:@"user_cardno"];
        
        [parame setObject:@"102" forKey:@"sv_source_type"];
//        //会员折扣
//        if ([self.discount isEqualToString:@"0"]) {
//            [parame setObject:@"1" forKey:@"sv_member_discount"];
//        } else {
//            NSString *vipfold = [NSString stringWithFormat:@"%.2f",[self.discount floatValue]*0.1];
//            [parame setObject:vipfold forKey:@"sv_member_discount"];
//        }
        
        
        
        if (!kStringIsEmpty(self.name)) {
            [parame setObject:self.name forKey:@"sv_mr_name"];
        }
        
        if (!kStringIsEmpty(self.sv_mr_cardno)) {
            [parame setObject:self.sv_mr_cardno forKey:@"sv_mr_cardno"];
        }
        
        // 流水单号
        if (!kStringIsEmpty(self.everyday_serialnumber)) {
            [parame setObject:self.everyday_serialnumber forKey:@"everyday_serialnumber"];
        }
        
//        //整单折扣
//        //  if ([SVTool isBlankString:self.oneCellText]) {
//        [parame setObject:@"1" forKey:@"order_discount"];
//        [parame setObject:@"1" forKey:@"order_discount_new"];
//
//        [parame setObject:@"0" forKey:@"order_receivable"];
//        //付款金额    decimal    order_money
//        [parame setObject:@"0" forKey:@"order_money"];
//        // 开启积分模式
//        [parame setObject:@"true" forKey:@"MembershipGradeGroupingIsON"];
        
        //应收原金额    decimal    order_receivabley
//        [parame setObject:[NSString stringWithFormat:@"%.2f",self.sumMoney] forKey:@"order_receivabley"];
        
        //收款方式    string    order_payment
        [parame setObject:@"扣次" forKey:@"order_payment"];
        
        //收款方式    string    order_payment2    给死@“待收”
        [parame setObject:@"待收" forKey:@"order_payment2"];
        
        //付款金额    decimal    order_money2    给死@“0”
//        [parame setObject:@"0" forKey:@"order_money2"];
        
//        //找零金额    decimal    order_change    给死@“0”
//        [parame setObject:@"0" forKey:@"order_change"];
//
//        //            if (!kStringIsEmpty(self.sv_coupon_amount)) {
//        //                [md setObject:self.sv_coupon_amount forKey:@"sv_coupon_amount"];
//        [parame setObject:@"0" forKey:@"sv_coupon_discount"];
        // }
        
        // if (!kStringIsEmpty(self.sv_coupon_discount)) {
        // [parame setObject:self.sv_coupon_discount forKey:@"sv_coupon_discount"];
      //  [parame setObject:@"0" forKey:@"sv_coupon_amount"];

//        //提成员工ID
//        if ([SVTool isBlankString:self.sv_employee_id]) {
//            [parame setObject:@"0" forKey:@"sv_commissionemployes"];
//        } else {
//            [parame setObject:self.sv_employee_id forKey:@"sv_commissionemployes"];
//        }
//
//        //备注
//
//        [parame setObject:@"" forKey:@"sv_remarks"];
         NSMutableArray *plist = [NSMutableArray array];
        for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {
            
            NSLog(@"%@-%@",selectModel.product_num, selectModel.sv_p_name);
            
           
            NSMutableDictionary *result = [NSMutableDictionary dictionary];
            
//            "product_id": 53827193,
//                "product_num": 1,
//                "sv_charge_type": 1,
//                "sv_mcc_leftcount": 7,
//                "sv_p_name": "猫咪洗澡",
//                "sv_serialnumber": "202211220336069494",
//                "userecord_id": 1764089,
//                "validity_date": "2024-11-22"
            [result setObject:@"1" forKey:@"sv_charge_type"];//扣次类型
            //会员折后的单价
            [result setObject:[NSNumber numberWithInteger:selectModel.sv_mcc_leftcount] forKey:@"sv_mcc_leftcount"];
            
            
//            [result setObject:@"0" forKey:@"product_total"];
//
//            [result setObject:@"0" forKey:@"product_unitprice"];
//            // 新折扣字段
//            [result setObject:@"0" forKey:@"product_discount_new"];
            
            result[@"sv_p_name"] = selectModel.sv_p_name;
         //   result[@"sv_p_barcode"] = [NSString stringWithFormat:@"%ld",selectModel.sv_p_barcode];
            result[@"product_num"] = selectModel.product_num;
            result[@"product_id"] = [NSNumber numberWithInteger:selectModel.product_id];
            if (kStringIsEmpty(selectModel.sv_serialnumber)) {
            }else{
               result[@"sv_serialnumber"] = selectModel.sv_serialnumber;
            }
            
            if (!kStringIsEmpty(selectModel.userecord_id)) {
                 result[@"userecord_id"] = selectModel.userecord_id;
            }
            
         
                 result[@"validity_date"] = selectModel.validity_date;
         
            
            [plist addObject:result];
             //   result[@"sv_product_type"] =
             NSLog(@"self.selectModelArray = %@",self.selectModelArray);
        };
        
        [parame setObject:plist forKey:@"prlist"];
        
        NSString*sURL = [URLhead stringByAppendingFormat:@"/api/MemberV2/MemberDeduction?key=%@",[SVUserManager shareInstance].access_token];
        
        [[SVSaviTool sharedSaviTool] POST:sURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            NSDictionary *responseDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dic----- = %@",responseDict);
            NSLog(@"surl = %@",sURL);
            SVHTTPResponse * response = [SVHTTPResponse responseWithObject:responseDict];
            if (response.code == PSResponseStatusSuccessCode) {
               
              // self.result = dic[@"result"];
                self.orderData = [SVOrderData mj_objectWithKeyValues:[SVTool dictionaryWithJsonString:response.data]];
               
               self.title = @"正在打印小票...";
               //  weakSelf.printeName = [NSString stringWithFormat:@"%@",perpheral.name];
               //延迟1秒，等待蓝牙连接后，再作打印
               dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [SVUserManager loadUserInfo];
                   if ([SVTool isBlankString:[SVUserManager shareInstance].printerNumber]) {
                       [SVUserManager shareInstance].printerNumber = @"1";
                       [SVUserManager saveUserInfo];
                   }
                   
                   
                   [SVUserManager loadUserInfo];
                   for (NSInteger i = 0; i < [[SVUserManager shareInstance].printerNumber intValue]; i++) {
                       if ([[SVUserManager shareInstance].printerSize intValue] == 58) {
                           [self fiftyEightPrinting];
                       }
                       
                       if ([[SVUserManager shareInstance].printerSize intValue] == 80) {
                           //[self eightyPrinting];
                           [self eightyPrinting];
                       }
                       
                       
                   }
                   
               });
               
               [SVTool TextButtonActionWithSing:@"扣次成功"];
               [self.navigationController popViewControllerAnimated:YES];
           }else{
               NSString *errmsg = [NSString stringWithFormat:@"%@",response.msg];
               [SVTool TextButtonAction:self.view withSing:errmsg];
           }
            
            self.sureBtn.userInteractionEnabled = YES;
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.sureBtn.userInteractionEnabled = YES;
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
   
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

- (void)fiftyEightPrinting {
    if (manage.stage != JWScanStageCharacteristics) {
        self.title = @"结算";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"order_datetime"] substringToIndex:10],[self.result[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"扣次结账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.orderData.order_id] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:self.dateString fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine];
    [SVUserManager loadUserInfo];

    [printer appendLeftText:@"项目" middleText:@"次数/剩" rightText:@"有效期" isTitle:YES];
    
    [printer appendSeperatorLine];
    
    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_count = 0.0;
    for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {

    NSInteger count = selectModel.sv_mcc_leftcount - [selectModel.product_num integerValue];
    [printer appendLeftText:selectModel.sv_p_name middleText:[NSString stringWithFormat:@"%@/%ld",selectModel.product_num,count] rightText: [NSString stringWithFormat:@"%@",[selectModel.validity_date substringToIndex:10]] isTitle:NO];
    totle_count += [selectModel.product_num floatValue];

    }
    [printer appendSeperatorLine];
    
    [printer appendLeftText:@"合计：" middleText:[NSString stringWithFormat:@"%.1f",totle_count] rightText:@"" isTitle:NO];
    [printer appendTitle:@"消费方式:" value:@"扣次消费" fontSize:HLFontSizeTitleSmalle];
  //  [printer appendSeperatorLine];
    
    
    if (!kStringIsEmpty(self.name)) {
        [printer appendSeperatorLine];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.name]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.sv_mr_cardno]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.storedValue floatValue]]];
        [printer appendTitle:@"会员电话：" value:[NSString stringWithFormat:@"%@",self.tel]];
 
        
    }
    [printer appendSeperatorLine];
    // [printer setLineSpace:60];
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_ul_mobile];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
    }

    if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)) {
            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            UIImage *image = [UIImage imageWithData:data];
            [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:200];
        }
    }
    
    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer cutter];
    NSData *mainData = [printer getFinalData];
    WeakSelf
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            [SVTool TextButtonAction:self.view withSing:@"打印成功"];
            NSLog(@"打印成功");
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        
        weakSelf.title = @"结算";
    }];
}

- (void)eightyPrinting{
    if (manage.stage != JWScanStageCharacteristics) {
        self.title = @"结算";
        [SVTool TextButtonAction:self.view withSing:@"您还未连接任何设备"];
        return;
    }
    //显示时间
    NSString *timeString = [NSString stringWithFormat:@"%@ %@",[self.result[@"order_datetime"] substringToIndex:10],[self.result[@"order_datetime"] substringWithRange:NSMakeRange(11, 8)]];
    
    JWPrinter *printer = [[JWPrinter alloc] init];
    [printer defaultSetting];
    
    [SVUserManager loadUserInfo];
    
    [printer appendText:[SVUserManager shareInstance].sv_us_name alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleMiddle];
    
    [printer appendText:@"结账单" alignment:HLTextAlignmentCenter fontSize:HLFontSizeTitleSmalle];
    [printer appendNewLine];
    [printer appendTitle:@"单号:" value:[NSString stringWithFormat:@"%@",self.orderData.order_id] fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"时间:" value:self.dateString fontSize:HLFontSizeTitleSmalle];
    [printer appendTitle:@"操作员:" value:[SVUserManager shareInstance].sv_employee_name fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine80];
    
    [SVUserManager loadUserInfo];

        
    [printer eightAppendLeftText:@"项目" middleText:@"次数/剩" rightText:@"有效期" isTitle:YES];
    
  
    [printer appendSeperatorLine80];
    
    CGFloat total = 0.0;
    CGFloat totle_Discount_money = 0.0;
    CGFloat totle_count = 0.0;
    for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {

    NSInteger count = selectModel.sv_mcc_leftcount - [selectModel.product_num integerValue];
    [printer eightAppendLeftText:selectModel.sv_p_name middleText:[NSString stringWithFormat:@"%@/%ld",selectModel.product_num,count] rightText:[NSString stringWithFormat:@"%@",[selectModel.validity_date substringToIndex:10]] isTitle:NO];
    totle_count += [selectModel.product_num floatValue];

    }
    
    [printer appendSeperatorLine80];
    
    [printer eightAppendLeftText:@"合计：" middleText:@"" rightText:[NSString stringWithFormat:@"%.f",totle_count] isTitle:NO];
    [printer appendTitle:@"消费方式:" value:@"扣次消费" fontSize:HLFontSizeTitleSmalle];
    [printer appendSeperatorLine80];
    
  
    
    
    if (!kStringIsEmpty(self.name)) {
        [printer appendSeperatorLine80];
        [printer appendTitle:@"会员姓名：" value:[NSString stringWithFormat:@"%@",self.name]];
        [printer appendTitle:@"会员卡号：" value:[NSString stringWithFormat:@"%@",self.sv_mr_cardno]];
        [printer appendTitle:@"储值余额：" value:[NSString stringWithFormat:@"%.1f",[self.storedValue floatValue]]];
        [printer appendTitle:@"会员电话：" value:[NSString stringWithFormat:@"%@",self.tel]];
        
    }
    [printer appendSeperatorLine80];
    // [printer setLineSpace:60];
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_ul_mobile)) {
        [printer appendTitle:@"电话：" value:[SVUserManager shareInstance].sv_ul_mobile];
    }
    
    if (!kStringIsEmpty([SVUserManager shareInstance].sv_us_address)) {
        [printer appendTitle:@"地址：" value:[SVUserManager shareInstance].sv_us_address];
    }

    
    if ([[SVUserManager shareInstance].imageOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].imageStr)) {
            NSString *str = [URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].imageStr];
            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:str]];
            UIImage *image = [UIImage imageWithData:data];
            [printer appendImage:image alignment:HLTextAlignmentCenter maxWidth:200];
        }
    }
    
    if ([[SVUserManager shareInstance].CustomInformationOpenOff isEqualToString:@"1"]) {
        if (!kStringIsEmpty([SVUserManager shareInstance].CustomInformation)) {
            [printer appendNewLine];
            [printer appendText:[SVUserManager shareInstance].CustomInformation alignment:HLTextAlignmentCenter];
        }
    }
    
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer appendNewLine];
    [printer cutter];
    NSData *mainData = [printer getFinalData];
    WeakSelf
    [[JWBluetoothManage sharedInstance] sendPrintData:mainData completion:^(BOOL completion, CBPeripheral *connectPerpheral,NSString *error) {
        if (completion) {
            [SVTool TextButtonAction:self.view withSing:@"打印成功"];
        }else{
            NSLog(@"写入错误---:%@",error);
            [SVTool TextButtonAction:weakSelf.view withSing:error];
        }
        weakSelf.title = @"结算";
    }];
}


#pragma mark - 点击输入框
- (void)textFieldDidEndEditing:(UITextField *)textF{
       SVSettlementTimesCountModel *model = self.timesCountArr[textF.tag];
    if (model.sv_mcc_leftcount < textF.text.integerValue) {
        if (model.sv_mcc_leftcount > 0) {
            textF.text = [NSString stringWithFormat:@"%ld",model.sv_mcc_leftcount];
             model.product_num = textF.text;
            
            if (kArrayIsEmpty(self.selectModelArray)) {
                [self.selectModelArray addObject:model];
            }else{
                for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {
                  //  SVSettlementTimesCountModel *model = self.timesCountArr[textF.tag];
                    if (selectModel.userecord_id == model.userecord_id) {
                        [self.selectModelArray removeObject:selectModel];
                        model.product_num = textF.text;
                        break;
                    }
                    
                }
                [self.selectModelArray addObject:model];
            }
            
        }else{
            textF.text = @"0";
        }
        
        [SVTool TextButtonActionWithSing:@"剩余扣次不足"];
    }else{
        model.product_num = textF.text;
        
        if (kArrayIsEmpty(self.selectModelArray)) {
            [self.selectModelArray addObject:model];
        }else{
            for (SVSettlementTimesCountModel *selectModel in self.selectModelArray) {
                SVSettlementTimesCountModel *model = self.timesCountArr[textF.tag];
                if (selectModel.userecord_id == model.userecord_id) {
                    [self.selectModelArray removeObject:selectModel];
                    model.product_num = textF.text;
                    break;
                }
                
            }
            [self.selectModelArray addObject:model];
        }
        
        
        //让图变大变小的
        textF.transform = CGAffineTransformMakeScale(1, 1);
        [UIView animateWithDuration:0.1   animations:^{
            textF.transform = CGAffineTransformMakeScale(1.5, 1.5);
        }completion:^(BOOL finish){
            [UIView animateWithDuration:0.1      animations:^{
                textF.transform = CGAffineTransformMakeScale(0.9, 0.9);
            }completion:^(BOOL finish){
                [UIView animateWithDuration:0.1   animations:^{
                    textF.transform = CGAffineTransformMakeScale(1, 1);
                }completion:^(BOOL finish){
                }];
            }];
        }];
    }
  
    
}


- (NSMutableArray *)count_textArray{
    if (_count_textArray == nil) {
        _count_textArray = [NSMutableArray array];
    }
    
    return _count_textArray;
}

- (NSMutableArray *)insert_btnArray{
    if (_insert_btnArray == nil) {
        _insert_btnArray = [NSMutableArray array];
    }
    
    return _insert_btnArray;
}

- (NSMutableArray *)reduce_btnArray{
    if (_reduce_btnArray == nil) {
        _reduce_btnArray = [NSMutableArray array];
    }
    
    return _reduce_btnArray;
}

- (NSMutableArray *)selectModelArray{
    if (_selectModelArray == nil) {
        _selectModelArray = [NSMutableArray array];
    }
    
    return _selectModelArray;
}

-(SVUnitPickerView *)pickerView{
    if (!_pickerView) {
        _pickerView = [[NSBundle mainBundle] loadNibNamed:@"SVUnitPickerView" owner:nil options:nil].lastObject;
        _pickerView.frame = CGRectMake(0, 0, 320, 230);
        _pickerView.center = self.view.center;
        _pickerView.backgroundColor = [UIColor whiteColor];
        _pickerView.layer.cornerRadius = 10;
        
        [_pickerView.unitCancel addTarget:self action:@selector(unitCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_pickerView.unitDetermine addTarget:self action:@selector(unitDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _pickerView;
}

- (void)unitCancelResponseEvent{
     [self.pickerView removeFromSuperview];
     [self.maskTheView removeFromSuperview];
}

@end
