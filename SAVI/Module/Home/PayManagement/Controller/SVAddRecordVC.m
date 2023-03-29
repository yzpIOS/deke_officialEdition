//
//  SVAddRecordVC.m
//  SAVI
//
//  Created by Sorgle on 2017/9/20.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAddRecordVC.h"
//选择分类
#import "SVvipPickerView.h"
//自定义cell
#import "SVSmallClassCell.h"
//添加小分类
#import "SVSmallClassView.h"
//添加大分类
#import "SVModifyClassView.h"
//编辑分类
#import "SVEditClassVC.h"
//日期XIB
#import "SVDatePickerView.h"
#import "SVPayManagementVC.h"

static NSString *smallCollectionViewID = @"smallCtionViewCell";

@interface SVAddRecordVC ()<UIPickerViewDataSource,UIPickerViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UITextFieldDelegate,dateStrControllerDelegate>

//选择分类按钮
@property (weak, nonatomic) IBOutlet UIButton *classButton;
@property (weak, nonatomic) IBOutlet UIButton *dateButton;


@property (weak, nonatomic) IBOutlet UICollectionView *smallCollectionView;

@property (weak, nonatomic) IBOutlet UITextField *money;
@property (weak, nonatomic) IBOutlet UITextField *remark;




//数组
@property (nonatomic,strong) NSMutableArray *classArr;
@property (nonatomic,strong) NSMutableArray *bigIDArr;
@property (nonatomic,strong) NSMutableArray *smallClassArr;
@property (nonatomic,strong) NSMutableArray *smallIDArr;
@property (nonatomic,copy) NSString *smallName;
@property (nonatomic,copy) NSString *bigID;
@property (nonatomic,copy) NSString *smallID;
//上一级的ID
//@property (nonatomic,copy) NSString *superiorecategoryid;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//选择大分类pickerView
@property (nonatomic,strong) SVvipPickerView *vipPickerView;

//新增小分类的view
@property (nonatomic,strong) UIView *maskTwoView;
@property (nonatomic,strong) SVSmallClassView *smallView;

//新增大分类的view
@property (nonatomic,strong) UIView *maskThreeView;
@property (nonatomic,strong) SVModifyClassView *BigView;

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *myDatePicker;

// 时分
@property (nonatomic,strong) NSString *MinutesndSeconds;


@end

@implementation SVAddRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    if (self.indexType == 1) {// 这是从点击修改过来的
//        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//        title.text = @"修改";
//        title.textAlignment = NSTextAlignmentCenter;
//        title.textColor = [UIColor whiteColor];
//        self.navigationItem.titleView = title;
        self.navigationItem.title = @"修改";
        //适配ios11偏移问题
        UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backltem;
        
        //底部按钮
        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight - 50, ScreenW, 50)];
        [button setTitle:@"确定" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize: 15];
        [button setBackgroundColor:navigationBackgroundColor];
        [self.view addSubview:button];
        [button addTarget:self action:@selector(addRecordButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //时间选择按钮
        [self.dateButton setTitle:[SVTool timeAcquireCurrentDate] forState:UIControlStateNormal];
        [self.dateButton addTarget:self action:@selector(addRecordDateButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //右上角按钮
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑类别" style:UIBarButtonItemStylePlain target:self action:@selector(aditClassbuttonResponseEvent)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        //指定collectionview代理
        self.smallCollectionView.delegate = self;
        self.smallCollectionView.dataSource = self;
        self.money.delegate = self;
        self.remark.delegate = self;
        
        //设置是否可以选择多项,如果为YES,会造成didDeselectItemAtIndexPath失效
        self.smallCollectionView.allowsMultipleSelection = NO;
        //注册collectionView的cell
        [self.smallCollectionView registerNib:[UINib nibWithNibName:@"SVSmallClassCell" bundle:nil] forCellWithReuseIdentifier:smallCollectionViewID];
        [self loadData];
        
        self.money.text = self.model.e_expenditure_money; // 总支出
        self.remark.text = self.model.e_expenditure_node; // 备注
       
        if ([self.model.e_expendituredate containsString:@"T"]) {
            NSArray *array = [self.model.e_expendituredate componentsSeparatedByString:@"T"]; //从字符-中分隔成2个元素的数组
            [self.dateButton setTitle: array[0] forState:UIControlStateNormal];
          //  self.MinutesndSeconds = array[1];
        }else{
           [self.dateButton setTitle:self.model.e_expendituredate forState:UIControlStateNormal];
        } // 时间
        self.smallID = self.model.e_expenditureclass; // 小分类ID
        self.bigID = self.model.parentid; // 大分类ID
        
        
        
    }else{
//        UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//        title.text = @"记一笔";
//        title.textAlignment = NSTextAlignmentCenter;
//        title.textColor = [UIColor whiteColor];
//        self.navigationItem.titleView = title;
        self.navigationItem.title = @"记一笔";
        //适配ios11偏移问题
        UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
        self.navigationItem.backBarButtonItem = backltem;
        
//        //底部按钮
//        UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight - 50, ScreenW, 50)];
//        [button setTitle:@"确定" forState:UIControlStateNormal];
//        button.titleLabel.font = [UIFont systemFontOfSize: 15];
//        [button setBackgroundColor:navigationBackgroundColor];
//        [self.view addSubview:button];
//        [button addTarget:self action:@selector(addRecordButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //时间选择按钮
        [self.dateButton setTitle:[SVTool timeAcquireCurrentDate] forState:UIControlStateNormal];
        [self.dateButton addTarget:self action:@selector(addRecordDateButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        
        //右上角按钮
        self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"编辑类别" style:UIBarButtonItemStylePlain target:self action:@selector(aditClassbuttonResponseEvent)];
        [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
        
        //指定collectionview代理
        self.smallCollectionView.delegate = self;
        self.smallCollectionView.dataSource = self;
        self.money.delegate = self;
        self.remark.delegate = self;
        
        //设置是否可以选择多项,如果为YES,会造成didDeselectItemAtIndexPath失效
        self.smallCollectionView.allowsMultipleSelection = NO;
        //注册collectionView的cell
        [self.smallCollectionView registerNib:[UINib nibWithNibName:@"SVSmallClassCell" bundle:nil] forCellWithReuseIdentifier:smallCollectionViewID];
        
        [self loadData];
        
    }
    
   

}
- (IBAction)sureClick:(id)sender {
    
    [self addRecordButtonResponseEvent];
}

//添加支出记录
- (void)addRecordButtonResponseEvent{
    
    if ([SVTool isBlankString:self.smallName]) {
//        [SVProgressHUD showErrorWithStatus:@"请选择分类"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"请选择分类"];
        return;
    }
    
    if ([SVTool isBlankString:self.money.text]) {
//        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"请输入金额"];
        return;
    }
    
    //不用交互
 //   [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
//    [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    [SVUserManager loadUserInfo];
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/AddPaymentInfo?key=%@",[SVUserManager shareInstance].access_token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.remark.text forKey:@"e_expenditure_node"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"管理号" forKey:@"e_expenditure_operation"];
    [parameters setObject:self.smallName forKey:@"e_expenditureclassname"];
    [parameters setObject:self.classButton.titleLabel.text forKey:@"e_expenditurename"];
    [parameters setObject:self.money.text forKey:@"e_expenditure_money"];
    [parameters setObject:self.smallID forKey:@"e_expenditureclass"];
    if ([SVTool isBlankString:self.model.e_expenditureid]) {
        [parameters setObject:@"0" forKey:@"e_expenditureid"];
    }else{
         [parameters setObject:self.model.e_expenditureid forKey:@"e_expenditureid"];
    }
    
    [parameters setObject:self.bigID forKey:@"parentid"];
    
    //取得当前时间
    NSDate *date = [NSDate date];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"hh:mm:ss"];
   // [formatter stringFromDate:date]
    //拼接选择的
    NSString *DateTime = [NSString stringWithFormat:@"%@T%@",self.dateButton.titleLabel.text,[formatter stringFromDate:date]];
    [parameters setObject:DateTime forKey:@"e_expendituredate"];
    
    self.money.text = nil;
    self.remark.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
            
            if ([SVTool isBlankString:self.model.e_expenditureid]) {
                //block
                if (self.addRecordBlock) {
                    self.addRecordBlock(self.dateButton.titleLabel.text);
                }
                
                //            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
                //            [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
                //            [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
                //            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //                [SVProgressHUD dismiss];
                //                [self.maskTwoView removeFromSuperview];
                //                [self.smallView removeFromSuperview];
                //
                //                //返回上一控制器
                //                [self.navigationController popViewControllerAnimated:YES];
                //            });
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"添加成功";
                hud.label.textColor = [UIColor whiteColor];//字体颜色
                
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.maskTwoView removeFromSuperview];
                    [self.smallView removeFromSuperview];
                    [self.navigationController popViewControllerAnimated:YES];
                });
            }else{
                if ([self.delegate respondsToSelector:@selector(dateStrControllerCellClick:)]) {
                    [self.delegate dateStrControllerCellClick:self.dateButton.titleLabel.text];
                }
                
                hud.mode = MBProgressHUDModeText;
                hud.label.text = @"修改成功";
                hud.label.textColor = [UIColor whiteColor];//字体颜色
                
                //用延迟来移除提示框
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                    if (self.addRecordBlock) {
//                        self.addRecordBlock(self.dateButton.titleLabel.text);
//                    }
                    //隐藏提示
                    [MBProgressHUD hideHUDForView:self.view animated:YES];
                    [self.maskTwoView removeFromSuperview];
                    [self.smallView removeFromSuperview];
                    
                    // 返回到任意界面
                    for (UIViewController *temp in self.navigationController.viewControllers) {
                        if ([temp isKindOfClass:[SVPayManagementVC class]]) {
                            [self.navigationController popToViewController:temp animated:YES];
                        }
                    }
                });
            }
        }
        
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
}

//跳转编辑类别
- (void)aditClassbuttonResponseEvent{
    
    SVEditClassVC *VC = [[SVEditClassVC alloc]init];
    //清空
    __weak typeof(self) weakSelf = self;
    
    VC.editBlock = ^(NSInteger num){
        
        if (num == 0) {
            
            [weakSelf.classArr removeAllObjects];
            [weakSelf.bigIDArr removeAllObjects];
            [weakSelf.classButton setTitle:@"未设置分类" forState:UIControlStateNormal];
            
            [weakSelf.smallClassArr removeAllObjects];
            [weakSelf.smallIDArr removeAllObjects];
            [weakSelf.smallCollectionView reloadData];
            
        }
        
        if (num == 1) {
            
            [weakSelf loadData];
        }
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
}

//时间选择按钮响应事件
- (void)addRecordDateButtonResponseEvent{
    
    //退出编辑状态
    [self.money endEditing:YES];
    [self.remark endEditing:YES];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.myDatePicker];
    
}

#pragma mark -  请求分类数据
//一级分类
- (void)loadData {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentGategories?key=%@",[SVUserManager shareInstance].access_token];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *aar = dict[@"dataList"];
        
        [self.classArr removeAllObjects];
        [self.bigIDArr removeAllObjects];
        
        for (NSDictionary *dic in aar) {
            [self.classArr addObject:dic[@"ecategoryname"]];
            [self.bigIDArr addObject:dic[@"ecategoryid"]];
        }
        
    
        
        if (self.indexType == 1) {
            if (![self.model.e_expenditurename containsString:@"-"]) {
//                 [self.classButton setTitle:[NSString stringWithFormat:@"%@ - %@",self.model.e_expenditurename,self.model.e_expenditureclassname] forState:UIControlStateNormal];
//                self.classNameLabel.text = [NSString stringWithFormat:@"%@ - %@",self.model.e_expenditurename,self.model.e_expenditureclassname];
                 [self.classButton setTitle: self.model.e_expenditurename forState:UIControlStateNormal];
            }else{
               // self.classNameLabel.text = self.model.e_expenditurename;
                NSArray *array = [self.model.e_expenditurename componentsSeparatedByString:@"-"]; //从字符-中分隔成2个元素的数组
                [self.classButton setTitle: array[0] forState:UIControlStateNormal];
            }
            
            
//            [self loadDataWithID:self.bigIDArr[0]];
//            //当有数据时，找到第一个类别的ID
//            NSDictionary *oneDic = aar[0];
//            self.bigID = oneDic[@"ecategoryid"];
            [self loadDataWithID:self.model.parentid];
            
        }else{
            if (![SVTool isEmpty:self.classArr]) {
                
                //将数组的第一个值设置为按钮的文字
                [self.classButton setTitle:self.classArr[0] forState:UIControlStateNormal];
                [self loadDataWithID:self.bigIDArr[0]];
                //当有数据时，找到第一个类别的ID
                NSDictionary *oneDic = aar[0];
                self.bigID = oneDic[@"ecategoryid"];
                
            }
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

//二级分类
- (void)loadDataWithID:(NSString *)catetoryId {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentGategories?key=%@&catetoryId=%@",[SVUserManager shareInstance].access_token,catetoryId];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSLog(@"dict = %@",dict);
        NSLog(@"self.model.e_expenditureid = %@",self.model.e_expenditureid);
        [self.smallClassArr removeAllObjects];
        [self.smallIDArr removeAllObjects];
        
        NSArray *aar = dict[@"dataList"];
        
        [self.smallClassArr addObject:@"自定义"];
        [self.smallIDArr addObject:@"自定义"];
        for (NSDictionary *dic in aar) {
            [self.smallClassArr addObject:dic[@"ecategoryname"]];
            [self.smallIDArr addObject:dic[@"ecategoryid"]];
        }
        
           [self.smallCollectionView reloadData];
        
        if ([SVTool isBlankString:self.model.e_expenditureid]) {
            //默认选中第一行
            NSIndexPath *firstPath = [NSIndexPath indexPathForRow:1 inSection:0];
            [self.smallCollectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
            
            //取到对应是二级名和二级ID;
            self.smallName = nil;
            self.smallID = nil;
            if (self.smallClassArr.count > 1) {
                
                self.smallName = self.smallClassArr[1];
                self.smallID = self.smallIDArr[1];
                
            }
        }else{
            for (NSInteger i = 0; i < self.smallIDArr.count; i++) {
                if (self.model.e_expenditureclass.integerValue == [self.smallIDArr[i] integerValue]) {
                    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:i inSection:0];
                    [self.smallCollectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                    
                    //取到对应是二级名和二级ID;
                    self.smallName = nil;
                    self.smallID = nil;
                    self.smallName = self.smallClassArr[i];
                    self.smallID = self.smallIDArr[i];
                }
            }
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

- (IBAction)classButtonResponseEvent {
    
    //退出编辑状态
    [self.money endEditing:YES];
    [self.remark endEditing:YES];
    
    if (self.classArr.count == 0) {
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskThreeView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.BigView];
        return;
    }
    
    //指定代理
    self.vipPickerView.vipPicker.delegate = self;
    self.vipPickerView.vipPicker.dataSource = self;
    //添加pickerView
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.vipPickerView];
    
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
        return self.classArr.count;
}

#pragma mark UIPickerView Delegate Method 代理方法

//指定每行如何展示数据（此处和tableview类似）
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
        return self.classArr[row];
}

#pragma mark - UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数
-( NSInteger )collectionView:( UICollectionView *)collectionView numberOfItemsInSection:( NSInteger )section {
    return self.smallClassArr.count;
}

//定义展示的Section的个数
-( NSInteger )numberOfSectionsInCollectionView:( UICollectionView *)collectionView {
    return 1 ;
}

//每个UICollectionView展示的内容
-( UICollectionViewCell *)collectionView:( UICollectionView *)collectionView cellForItemAtIndexPath:( NSIndexPath *)indexPath {
    SVSmallClassCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:smallCollectionViewID forIndexPath:indexPath];
    
    cell.titleLabel.text = self.smallClassArr[indexPath.item];
    
    if (indexPath.row == 0) {
        cell.img.image = [UIImage imageNamed:@"addImage_icon"];
        cell.titleLabel.textColor = [UIColor blackColor];
    } else {
        
        if (cell.isSelected) {
            cell.img.image = [UIImage imageNamed:@"select_red"];
            cell.titleLabel.textColor = RGBA(240, 195, 66, 1);
        } else {
            cell.img.image = [UIImage imageNamed:@"chargeType"];
            cell.titleLabel.textColor = [UIColor blackColor];
        }
        
    }

    return cell;
    
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- ( CGSize )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:( NSIndexPath *)indexPath {
        return CGSizeMake (60,70);
}

//定义每个UICollectionView 的边距
-( UIEdgeInsets )collectionView:( UICollectionView *)collectionView layout:( UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:( NSInteger )section {
    return UIEdgeInsetsMake (0,0,0,0);
}

#pragma mark - 点击跳转方法
//当选择了某一项的时候，调用这个方法进行处理
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    //[self.smallCollectionView deselectItemAtIndexPath:indexPath animated:NO];
    
    if (indexPath.row == 0) {
        
        //取到对应是二级名和二级ID;
        self.smallName = nil;
        self.smallID = nil;
        if (self.smallClassArr.count > 1) {
            
            self.smallName = self.smallClassArr[1];
            self.smallID = self.smallIDArr[1];
            
        }
        
        self.smallView.bigClassName.text = self.classButton.titleLabel.text;
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.smallView];
        return;
        
    }
    
    self.smallName = self.smallClassArr[indexPath.item];
    self.smallID = self.smallIDArr[indexPath.item];
    
    SVSmallClassCell *cell = (SVSmallClassCell *)[_smallCollectionView cellForItemAtIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:@"select_red"];
    cell.titleLabel.textColor = RGBA(240, 195, 66, 1);
    
    
}

//当你取消某项的选择的时候来触发
- (void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        
        return;
        
    }

    
    SVSmallClassCell *cell = (SVSmallClassCell *)[_smallCollectionView cellForItemAtIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:@"chargeType"];
    cell.titleLabel.textColor = [UIColor blackColor];
}

#pragma mark - textField
//限制只能输入一定长度的字符
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSCharacterSet *cs;
    if ([textField isEqual:self.money]) {
        // 小数点在字符串中的位置 第一个数字从0位置开始
        NSInteger dotLocation = [textField.text rangeOfString:@"."].location;
        // 判断字符串中是否有小数点，并且小数点不在第一位
        // NSNotFound 表示请求操作的某个内容或者item没有发现，或者不存在
        // range.location 表示的是当前输入的内容在整个字符串中的位置，位置编号从0开始
        if (dotLocation == NSNotFound && range.location != 0) {
            // 取只包含“myDotNumbers”中包含的内容，其余内容都被去掉
            /*
             [NSCharacterSet characterSetWithCharactersInString:myDotNumbers]的作用是去掉"myDotNumbers"中包含的所有内容，只要字符串中有内容与"myDotNumbers"中的部分内容相同都会被舍去
             在上述方法的末尾加上invertedSet就会使作用颠倒，只取与“myDotNumbers”中内容相同的字符
             */
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithDot] invertedSet];
            if (range.location >= 9) {
                
                if ([string isEqualToString:@"."] && range.location == 9) {
                    return YES;
                }
                
                return NO;
            }
        }else {
            cs = [[NSCharacterSet characterSetWithCharactersInString:NumbersWithoutDot] invertedSet];
        }
        
        // 按cs分离出数组,数组按@""分离出字符串
        NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
        BOOL basicTest = [string isEqualToString:filtered];
        if (!basicTest) {
            return NO;
        }
        
        if (dotLocation != NSNotFound && range.location > dotLocation + 2) {
            return NO;
        }
        
        if (textField.text.length > 11) {
            return NO;
        }
    }
    
    if ([textField isEqual:self.remark]) {
        NSInteger existedLength = textField.text.length;
        NSInteger selectedLength = range.length;
        NSInteger replaceLength = string.length;
        NSInteger pointLength = existedLength - selectedLength + replaceLength;
        
        //超过20位 就不能在输入了
        if (pointLength > 30) {
            return NO;
        } else {
            return YES;
        }
        
    }
    return YES;
}

#pragma mark - 懒加载

-(NSMutableArray *)classArr{
    if (!_classArr) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

-(NSMutableArray *)bigIDArr{
    if (!_bigIDArr) {
        _bigIDArr = [NSMutableArray array];
    }
    return _bigIDArr;
}

-(NSMutableArray *)smallClassArr{
    if (!_smallClassArr) {
        _smallClassArr = [NSMutableArray array];
    }
    return _smallClassArr;
}

-(NSMutableArray *)smallIDArr{
    if (!_smallIDArr) {
        _smallIDArr = [NSMutableArray array];
    }
    return _smallIDArr;
}

//#pragma mark - 选择一级分类的弹框
-(SVvipPickerView *)vipPickerView{
    if (!_vipPickerView) {
        _vipPickerView = [[NSBundle mainBundle] loadNibNamed:@"SVvipPickerView" owner:nil options:nil].lastObject;
        _vipPickerView.frame = CGRectMake(0, 0, 320, 230);
        _vipPickerView.center = self.view.center;
        _vipPickerView.backgroundColor = [UIColor whiteColor];
        _vipPickerView.layer.cornerRadius =10;
        
        [_vipPickerView.vipCancel addTarget:self action:@selector(vipCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_vipPickerView.vipDetermine addTarget:self action:@selector(vipDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _vipPickerView;
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

//取消按钮
- (void)vipCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.vipPickerView removeFromSuperview];
}

//确定按钮
- (void)vipDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    
    NSInteger row = [self.vipPickerView.vipPicker selectedRowInComponent:0];
    
    self.bigID = self.bigIDArr[row];
    
    [self loadDataWithID:self.bigID];
    
    [self.classButton setTitle:[self.classArr objectAtIndex:row] forState:UIControlStateNormal];
//    self.twoCell.levelLabel.text = [self.classArr objectAtIndex:row];

    [self.vipPickerView removeFromSuperview];
    
}

#pragma mark - 添加小分类XIB
//添加小class
-(SVSmallClassView *)smallView{
    if (!_smallView) {
        _smallView = [[[NSBundle mainBundle] loadNibNamed:@"SVSmallClassView" owner:nil options:nil] lastObject];
        _smallView.frame = CGRectMake(0, 0, 320, 230);
        _smallView.center = CGPointMake(ScreenW/2, ScreenH/2);
        _smallView.layer.cornerRadius = 10;
        //        _smallView.backgroundColor = [UIColor whiteColor];
        //        _smallView.bigClassName.text = self.bigClassName;
        
        //添加事件
        [_smallView.cancelButton addTarget:self action:@selector(maskTwoGesture) forControlEvents:UIControlEventTouchUpInside];
        [_smallView.determineButton addTarget:self action:@selector(addSmallClass) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _smallView;
}
//遮盖View
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskTwoGesture)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}


/**
 添加小分类
 */
-(void)addSmallClass{
    
    
    if ([SVTool isBlankString:self.smallView.smallClassName.text]) {
//        [SVProgressHUD showErrorWithStatus:@"类名不能为空!"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
//    [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/AddPaymentCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.smallView.smallClassName.text forKey:@"ecategoryname"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"0.0" forKey:@"e_expenditure_money"];
    [parameters setObject:@"0" forKey:@"e_expenditureclass"];
    [parameters setObject:@"0" forKey:@"e_expenditureid"];
    [parameters setObject:@"0" forKey:@"ecategoryid"];
    [parameters setObject:@"1" forKey:@"ecategorylive"];
    [parameters setObject:@"0" forKey:@"ecategorypaixu"];
    [parameters setObject:@"false" forKey:@"isdelete"];
    [parameters setObject:@"false" forKey:@"publicclass"];
    [parameters setObject:self.bigID forKey:@"superiorecategoryid"];
    
    self.smallView.smallClassName.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//            [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//            [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [self.maskTwoView removeFromSuperview];
//                [self.smallView removeFromSuperview];
//            });
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"添加成功";
            hud.label.textColor = [UIColor whiteColor];//字体颜色

            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.maskTwoView removeFromSuperview];
                [self.smallView removeFromSuperview];
            });
        }
        
        //根据id去请求二级分类的内容
        [self loadDataWithID:self.bigID];
        
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
    
    
}

//点击手势的点击事件
- (void)maskTwoGesture{
    
    if (self.smallClassArr.count > 1) {
        //默认选中第一行
        [self.smallCollectionView reloadData];
        NSIndexPath *firstPath = [NSIndexPath indexPathForRow:1 inSection:0];
        [self.smallCollectionView selectItemAtIndexPath:firstPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
    }
    
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
}


#pragma mark - 添加大分类XIB
//添加小class
-(SVModifyClassView *)BigView{
    if (!_BigView) {
        _BigView = [[[NSBundle mainBundle] loadNibNamed:@"SVModifyClassView" owner:nil options:nil] lastObject];
        _BigView.frame = CGRectMake(0, 0, 320, 230);
        _BigView.center = CGPointMake(ScreenW/2, ScreenH/2);
        _BigView.layer.cornerRadius = 10;
        //        _smallView.backgroundColor = [UIColor whiteColor];
        //        _smallView.bigClassName.text = self.bigClassName;
        
        //添加事件
        [_BigView.cancelButton addTarget:self action:@selector(maskThreeGesture) forControlEvents:UIControlEventTouchUpInside];
        [_BigView.determineTwoButton addTarget:self action:@selector(addBigClass) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
    return _BigView;
}
//遮盖View
-(UIView *)maskThreeView{
    if (!_maskThreeView) {
        _maskThreeView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskThreeView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskThreeGesture)];
        [_maskThreeView addGestureRecognizer:tap];
    }
    return _maskThreeView;
}


/**
 添加分类
 */
-(void)addBigClass{
    
    if ([SVTool isBlankString:self.BigView.Name.text]) {
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
//    [SVProgressHUD showWithStatus:@"正在提交中"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在提交中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/AddPaymentCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.BigView.Name.text forKey:@"ecategoryname"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"0.0" forKey:@"e_expenditure_money"];
    [parameters setObject:@"0" forKey:@"e_expenditureclass"];
    [parameters setObject:@"0" forKey:@"e_expenditureid"];
    [parameters setObject:@"0" forKey:@"ecategoryid"];
    [parameters setObject:@"0" forKey:@"ecategorylive"];
    [parameters setObject:@"0" forKey:@"ecategorypaixu"];
    [parameters setObject:@"false" forKey:@"isdelete"];
    [parameters setObject:@"false" forKey:@"publicclass"];
    [parameters setObject:@"0" forKey:@"superiorecategoryid"];
    
    self.BigView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"添加成功"];
//            [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//            [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [self.maskThreeView removeFromSuperview];
//                [self.BigView removeFromSuperview];
//            });
            
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"添加成功";
            hud.label.textColor = [UIColor whiteColor];//字体颜色

            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.maskThreeView removeFromSuperview];
                [self.BigView removeFromSuperview];
            });
        }
        
        //根据id去请求二级分类的内容
        [self loadData];
        
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
    
    
}

//点击手势的点击事件
- (void)maskThreeGesture{
    [self.maskThreeView removeFromSuperview];
    [self.BigView removeFromSuperview];
}

#pragma mark - 日期选择
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
#pragma mark - 点击时间弹框
- (void)dateDetermineResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    
    [self.dateButton setTitle:[dateFormatter stringFromDate:self.myDatePicker.datePickerView.date] forState:UIControlStateNormal];
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.myDatePicker removeFromSuperview];
}





@end
