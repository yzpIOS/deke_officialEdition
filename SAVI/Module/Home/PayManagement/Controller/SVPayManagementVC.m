//
//  SVPayManagementVC.m
//  SAVI
//
//  Created by Sorgle on 2017/9/16.
//  Copyright © 2017年 Sorgle. All rights reserved.▼ ▽ ⊿ ☟
//

#import "SVPayManagementVC.h"
//支出明细
#import "SVSpendingDetailVC.h"
//记一笔
#import "SVAddRecordVC.h"
//日期XIB
#import "SVDatePickerView.h"
//cell
#import "SVPayManagementCell.h"
//组头
#import "SVPayManagementView.h"
//支出详情
#import "SVPayDetailsVC.h"
//cell模型
#import "SVPayManagementModel.h"

static NSString *PayManagementID = @"PayManagementCell";

@interface SVPayManagementVC ()<UITableViewDelegate,UITableViewDataSource,dateStrControllerDelegate>

@property (nonatomic,strong) UITableView *tableView;

//日期label
@property (nonatomic,strong) UIButton *dateButton;
//支出总额
@property (nonatomic,strong) UILabel *sumLabel;
//此时段没有支出记录
@property (nonatomic,strong) UILabel *noLabel;

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;


@property (nonatomic,strong) NSMutableArray *weekArr;

@property (nonatomic,strong) NSMutableArray *sumMoneyArr;

@property (nonatomic,strong) NSMutableArray *payModelArr;

//日期选择
@property (nonatomic, strong) SVPayManagementView *headerview;

/**
 记录刷新次数
 */
@property (nonatomic,assign) NSInteger page;

@end

@implementation SVPayManagementVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"支出列表";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"支出列表";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //navigation右边按钮。正确创建方式，这样显示的图片就没有问题了
    UIBarButtonItem *rightButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"chargeDetail"] style:UIBarButtonItemStylePlain target:self action:@selector(payManagementButtonResponseEvent)];
    self.navigationItem.rightBarButtonItem = rightButon;
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.hidesBottomBarWhenPushed = YES;
    
    UIView *oneView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH/5)];
    oneView.backgroundColor = navigationBackgroundColor;
    [self.view addSubview:oneView];
    
    self.sumLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, oneView.frame.size.height/3-15, ScreenW, 30)];
    [self.sumLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:33]];
    self.sumLabel.textColor = [UIColor whiteColor];
    self.sumLabel.textAlignment = NSTextAlignmentCenter;
    [oneView addSubview:self.sumLabel];
    
    //底部按钮
    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight-50, ScreenW, 50)];
    [button setImage:[UIImage imageNamed:@"icom_addwhite"] forState:UIWindowLevelNormal];
    [button setTitle:@"  记一笔" forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize: 15];
    [button setBackgroundColor:navigationBackgroundColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(addRecordButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, ScreenH/5, ScreenW, ScreenH - TopHeight-50 - ScreenH/5)];
    //去掉多余的分割线,显示cell还有线
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPayManagementCell" bundle:nil] forCellReuseIdentifier:PayManagementID];
    
    //拿到当前时间
    NSString *todayTime = [SVTool timeAcquireCurrentDate];
    NSString *time = [todayTime substringWithRange:NSMakeRange(0, 7)];
    NSString *onedayTime = [NSString stringWithFormat:@"%@-01",time];
    
    //选择时间按钮
    self.dateButton = [[UIButton alloc]init];
    [self.dateButton setTitle:time forState:UIControlStateNormal];
    [self.dateButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.dateButton setImage:[UIImage imageNamed:@"arrow_whiteColor"] forState:UIControlStateNormal];
    [self.dateButton addTarget:self action:@selector(dateLabelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [oneView addSubview:self.dateButton];
    [self.dateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(120, 30));
        make.top.mas_equalTo(self.sumLabel.mas_bottom).offset(20);
        make.centerX.mas_equalTo(self.sumLabel);
    }];
    
    
    
    self.noLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    self.noLabel.text = @"此时段没有支出记录";
    self.noLabel.textColor = [UIColor grayColor];
    self.noLabel.center = CGPointMake(self.tableView.frame.size.width/2, self.tableView.frame.size.height/2);
    self.noLabel.textAlignment = NSTextAlignmentCenter;
    [self.tableView addSubview:self.noLabel];
    
    self.page = 1;
    //调用接口
    [self getDatabeginDate:todayTime endDate:todayTime page:1 pagesize:200];
    
    [self dateDetermineResponseEvent];
    
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

//跳到支出明细报表
-(void)payManagementButtonResponseEvent{
    
    SVSpendingDetailVC *VC = [[SVSpendingDetailVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}

//跳到记一笔
-(void)addRecordButtonResponseEvent{
    
    SVAddRecordVC *VC = [[SVAddRecordVC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    VC.addRecordBlock = ^(NSString *date){
        
        NSString *time = [date substringWithRange:NSMakeRange(0, 7)];
        
        [self.dateButton setTitle:time forState:UIControlStateNormal];
        
        NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
        
        NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
        NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
        
        //调用接口
        [weakSelf getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:200];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

/**
 日期选择
 */
-(void)dateLabelResponseEvent{
    
    //退出编辑
    //[self.tableView endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];

    
    
}

#pragma mark - 数据请求
/**
 获取支出信息

 @param beginDate 开始时间
 @param endDate 结束时间
 @param page 页码
 @param pagesize 页记录数
 */
-(void)getDatabeginDate:(NSString *)beginDate endDate:(NSString *)endDate page:(NSInteger)page pagesize:(NSInteger)pagesize{
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentInfosByDay?key=%@&beginDate=%@&endDate=%@&page=%li&pagesize=%li",[SVUserManager shareInstance].access_token,[NSString stringWithFormat:@"%@ 00:00:00",beginDate],[NSString stringWithFormat:@"%@ 23:59:59",endDate],(long)page,(long)pagesize];
    NSString *encoded = [urlStr stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
         [NSCharacterSet URLQueryAllowedCharacterSet];
    [[SVSaviTool sharedSaviTool] GET:encoded parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dic = %@",dic);
        
        [self.weekArr removeAllObjects];
        [self.sumMoneyArr removeAllObjects];
        [self.payModelArr removeAllObjects];
        
        NSArray *dataListArr = dic[@"dataList"];
        
        if (![SVTool isEmpty:dataListArr]) {
            
            self.noLabel.hidden = YES;
            
            for (NSDictionary *dict in dataListArr) {
                
                [self.weekArr addObject:[dict objectForKey:@"e_expendituredate"]];// 时间
                [self.sumMoneyArr addObject:[dict objectForKey:@"e_expenditure_money"]]; // 金额
                
                [self.payModelArr addObject:[dict objectForKey:@"modelList"]]; // 
                
            }
            
            float sum = 0;
            for (int i = 0; i<self.sumMoneyArr.count; i++) {
                sum = [self.sumMoneyArr[i] floatValue] + sum;
            }
            self.sumLabel.text = [NSString stringWithFormat:@"￥%.2f",sum];
            
            
            
        }  else {
            /** 所有数据加载完毕，没有更多的数据了 */
            self.noLabel.hidden = NO;
            
            self.sumLabel.text = @"￥0.00";
        }
        
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - tableVeiw
//展示几组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.payModelArr.count;
    
}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
    
    NSArray *listArr = self.payModelArr[section];
    
    return listArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib的cell的创建
    SVPayManagementCell *cell = [tableView dequeueReusableCellWithIdentifier:PayManagementID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVPayManagementCell" owner:nil options:nil].lastObject;
    }
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    NSDictionary *dic = self.payModelArr[indexPath.section][indexPath.row];
    
    SVPayManagementModel *model = [SVPayManagementModel mj_objectWithKeyValues:dic];
    
    cell.model = model;
    
    
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//组与组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

//section头部视图
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //创建组头view
    self.headerview = [[NSBundle mainBundle]loadNibNamed:@"SVPayManagementView" owner:self options:nil].firstObject;
    self.headerview.backgroundColor = RGBA(238, 238, 238, 1);
    
//    if (![SVTool isEmpty:self.payModelArr]) {
    
        //获取当前日期星期几
        NSString *time = [self.weekArr[section] substringWithRange:NSMakeRange(0, 10)];
        
        //求星期几
        self.headerview.weekLabel.text = [SVTool weekdayStringFromDate:time];
        
        //求日期
        self.headerview.dateLabel.text = [self.weekArr[section] substringWithRange:NSMakeRange(5, 5)];
        
        //金额
        self.headerview.moneyLabel.text = [NSString stringWithFormat:@"%@",self.sumMoneyArr[section]];
//    }
    
    return self.headerview;
    
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dic = self.payModelArr[indexPath.section][indexPath.row];
    
    SVPayManagementModel *model = [SVPayManagementModel mj_objectWithKeyValues:dic];
    
    SVPayDetailsVC *VC = [[SVPayDetailsVC alloc]init];
    VC.model = model;
    
    VC.payDetailBlock = ^(NSString *date) {
        NSString *time = [date substringWithRange:NSMakeRange(0, 7)];
        
        [self.dateButton setTitle:time forState:UIControlStateNormal];
        
        NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
        
        NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
        NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
        
        //调用接口
        [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:200];
    };
    
    VC.payManagementVC = self;
    VC.rowIndex = indexPath.row;
   // VC.sessionIndex = indexPath.section;
    
//    VC.e_expenditurename = model.e_expenditurename;
//    VC.e_expenditureclassname = model.e_expenditureclassname;
//    VC.e_expenditure_money = model.e_expenditure_money;
//    VC.e_expendituredate = model.e_expendituredate;
//    VC.e_expenditure_node = model.e_expenditure_node;
    
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

#pragma mark - addRecordVC的代理方法
- (void)dateStrControllerCellClick:(NSString *)dateStr
{
    NSString *time = [dateStr substringWithRange:NSMakeRange(0, 7)];
    
    [self.dateButton setTitle:time forState:UIControlStateNormal];
    
    NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
    
    NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
    NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
    
    //调用接口
    [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:200];
}

/**
 e_expenditureclass,parentid
 */

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
        
        NSDictionary *dic = self.payModelArr[indexPath.section][indexPath.row];
        
        SVPayManagementModel *model = [SVPayManagementModel mj_objectWithKeyValues:dic];
        
        [SVUserManager loadUserInfo];
        
        NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/DelPaymentInfo?key=%@&id=%i",[SVUserManager shareInstance].access_token,model.e_expenditureid.intValue];
        [[SVSaviTool sharedSaviTool] DELETE:sURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict445 = %@",dic);
            if ([dic[@"success"] integerValue] == 1) {
                // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dic[@"msg"]]];
                if ([model.e_expendituredate containsString:@"T"]) {
                    NSArray *array = [model.e_expendituredate componentsSeparatedByString:@"T"]; //从字符-中分隔成2个元素的数组
                    NSString *time = [array[0] substringWithRange:NSMakeRange(0, 7)];
                    
                    [self.dateButton setTitle:time forState:UIControlStateNormal];
                    
                    NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
                    
                    NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
                    NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
                    
                    //调用接口
//<<<<<<< HEAD
//                    [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:100];
//                   
//=======
                    [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:200];
                    
//>>>>>>> origin/oem_deduction_OrderCollection
                    
                }else{
                    //                [self.dateButton setTitle:self.model.e_expendituredate forState:UIControlStateNormal];
                } // 时间
                
//                //用延迟来移除提示框
//                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    //隐藏提示
//                    [MBProgressHUD hideHUDForView:self.view animated:YES];
//
//
//                });
                
                // [self.navigationController popViewControllerAnimated:YES];
            }else{
                [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dic[@"msg"]]];
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //                //        [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
        
        
//        if (indexPath.row<[self.payModelArr count]) {
//
//            [SVUserManager loadUserInfo];
//            NSString *token = [SVUserManager shareInstance].access_token;
//
//            NSDictionary *dic = self.payModelArr[indexPath.section][indexPath.row];
//            SVPayManagementModel *model = [SVPayManagementModel mj_objectWithKeyValues:dic];
//
//            //url
//            NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Payment/DelPaymentInfo?key=%@&categoryId=%@",token,model.e_expenditureid];
//
//
//            [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//
//                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
//
//
//                if ([dic[@"success"] integerValue] == 1) {
//                     [SVTool TextButtonAction:self.view withSing:dic[@"msg"]];
//                   // [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
//                    //移除数据源的数据
//                    [self.payModelArr removeObjectAtIndex:indexPath.row];
//
//                    //移除tableView中的数据
//                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
//
//                    [self.tableView reloadData];
//
//                } else {
//                  //  [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//                  //  [ [SVTool TextButtonAction:self.view withSing:dic[@"msg"]];
//                }
    }
}



#pragma mark - 懒加载

-(NSMutableArray *)weekArr{
    if (!_weekArr) {
        _weekArr = [NSMutableArray array];
    }
    return _weekArr;
}

-(NSMutableArray *)payModelArr{
    if (!_payModelArr) {
        _payModelArr = [NSMutableArray array];
    }
    return _payModelArr;
}

-(NSMutableArray *)sumMoneyArr{
    if (!_sumMoneyArr) {
        _sumMoneyArr = [NSMutableArray array];
    }
    return _sumMoneyArr;
}

/**
 日期选择
 */
-(SVDatePickerView *)myDatePicker{
    if (!_myDatePicker) {
        _myDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _myDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _myDatePicker.center = self.view.center;
        _myDatePicker.backgroundColor = [UIColor whiteColor];
        _myDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_myDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _myDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _myDatePicker.datePickerView.maximumDate = minDate;
        
        [_myDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_myDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _myDatePicker;
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
- (void)dateDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM"];
    [self.dateButton setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
    
    NSInteger number = [SVTool NumberOfDaysInMonthDate:self.dateButton.titleLabel.text];
    
    NSString *onedayDate = [NSString stringWithFormat:@"%@-01",self.dateButton.titleLabel.text];
    NSString *todayDate = [NSString stringWithFormat:@"%@-%ld",self.dateButton.titleLabel.text,(long)number];
    
    [self getDatabeginDate:onedayDate endDate:todayDate page:1 pagesize:200];
    
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
}

@end
