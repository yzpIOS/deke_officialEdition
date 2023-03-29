//
//  SVAdministerClassVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/10.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAdministerClassVC.h"
//cell
#import "SVAdministerClassCell.h"
//弹框
#import "SVModifyClassView.h"

static NSString *AdministerClassID = @"AdministerClassCell";

@interface SVAdministerClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//数组
@property (nonatomic,strong) NSMutableArray *smallClassArr;
@property (nonatomic,strong) NSMutableArray *ecategoryidArr;
//一级的ID
//@property (nonatomic,copy) NSString *superiorecategoryid;
//本级类ID
@property (nonatomic,copy) NSString *ecategoryid;

//新增小分类的view
@property (nonatomic,strong) UIView *maskTwoView;
@property (nonatomic,strong) SVModifyClassView *smallView;

@end



@implementation SVAdministerClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"小分类";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"小分类";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    
    //style:UITableViewStylePlain
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - TopHeight)];
    //去掉多余的分割线,显示cell还有线
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVAdministerClassCell" bundle:nil] forCellReuseIdentifier:AdministerClassID];
    
    //底部按钮
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - 114, ScreenW, 50)];
//    [button setImage:[UIImage imageNamed:@"icom_addwhite"] forState:UIWindowLevelNormal];
//    [button setTitle:@"  新增小分类" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize: 14];
//    [button setBackgroundColor:navigationBackgroundColor];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(addSmallButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addSmallButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    
    [self loadDataWithID:self.number];
}

//添加小分类按钮响应事件
- (void)addSmallButtonResponseEvent{
    self.smallView.determineButton.hidden = NO;
    self.smallView.determineTwoButton.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.smallView];
    
}

#pragma mark - 请求数据
- (void)loadDataWithID:(NSString *)catetoryId {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentGategories?key=%@&catetoryId=%@",[SVUserManager shareInstance].access_token,catetoryId];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *aar = dict[@"dataList"];
        
        //清理数组
        [self.smallClassArr removeAllObjects];
        [self.ecategoryidArr removeAllObjects];
        
        for (NSDictionary *dic in aar) {
            
            [self.smallClassArr addObject:dic[@"ecategoryname"]];
            
            [self.ecategoryidArr addObject:dic[@"ecategoryid"]];
            
        }
        
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - tableVeiw

//展示几组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 2;
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.smallClassArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib的cell的创建
    SVAdministerClassCell *cell = [tableView dequeueReusableCellWithIdentifier:AdministerClassID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVAdministerClassCell" owner:nil options:nil].lastObject;
    }
    
    cell.Name.text = self.smallClassArr[indexPath.row];
    
    cell.Button.hidden = YES;
    
//    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    cell.imageView.image = [UIImage imageNamed:@"chargeType"];
//    //设置字体的大小
//    cell.textLabel.font = [UIFont systemFontOfSize:15];
//    cell.textLabel.text = self.classArr[indexPath.row];
//    //设置cell右边的小箭头
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//组与组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    if (section == 0) {
//        return 0;
//    }
    return 30;
}

/////组头
- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.className;
}

//点击响应方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.smallView.determineButton.hidden = YES;
    self.smallView.determineTwoButton.hidden = NO;
    
    self.smallView.Name.text = self.smallClassArr[indexPath.row];
    self.ecategoryid = self.ecategoryidArr[indexPath.row];
    
    //[self.smallView.determineTwoButton addTarget:self action:@selector(ModifySmallClassName) forControlEvents:UIControlEventTouchUpInside];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.smallView];
    
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
        
        if (indexPath.row<[self.smallClassArr count]) {
            
            [SVUserManager loadUserInfo];
            NSString *token = [SVUserManager shareInstance].access_token;
            NSString *categoryId = self.ecategoryidArr[indexPath.row];
            
            //url
            NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Payment/DelPaymentCategory?key=%@&categoryId=%@",token,categoryId];
            
            
            [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"success"] integerValue] == 1) {
                    
                    if (self.administerBlock) {
                        self.administerBlock();
                    }
                    
//                    [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
//                    //用延迟来移除提示框
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SVProgressHUD dismiss];
//                    });
                    [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                    //移除数据源的数据
                    [self.smallClassArr removeObjectAtIndex:indexPath.row];
                    [self.ecategoryidArr removeObjectAtIndex:indexPath.row];
                    
                    //移除tableView中的数据
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [self.tableView reloadData];
                    
                } else {
//                    [SVProgressHUD showErrorWithStatus:dic[@"msg"]];
//                    //用延迟来移除提示框
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SVProgressHUD dismiss];
//                    });
                    NSString *errmsg = dic[@"msg"];
                    [SVTool TextButtonAction:self.view withSing:errmsg];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                //[SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                
            }];
        }
    }
}



#pragma mark - 懒加载
-(NSMutableArray *)smallClassArr{
    if (!_smallClassArr) {
        _smallClassArr = [NSMutableArray array];
    }
    return _smallClassArr;
}

-(NSMutableArray *)ecategoryidArr{
    if (!_ecategoryidArr) {
        _ecategoryidArr = [NSMutableArray array];
    }
    return _ecategoryidArr;
}

#pragma mark - 添加小分类XIB
//添加小class
-(SVModifyClassView *)smallView{
    if (!_smallView) {
        _smallView = [[[NSBundle mainBundle] loadNibNamed:@"SVModifyClassView" owner:nil options:nil] lastObject];
        _smallView.frame = CGRectMake(0, 0, 320, 230);
        _smallView.center = CGPointMake(ScreenW/2, ScreenH/2);
        _smallView.layer.cornerRadius =10;
        //        _smallView.backgroundColor = [UIColor whiteColor];
        //        _smallView.bigClassName.text = self.bigClassName;
        
        //添加事件
        [_smallView.cancelButton addTarget:self action:@selector(maskTwoGesture) forControlEvents:UIControlEventTouchUpInside];
        
        [_smallView.determineButton addTarget:self action:@selector(addSmallClass) forControlEvents:UIControlEventTouchUpInside];
        [_smallView.determineTwoButton addTarget:self action:@selector(ModifySmallClassName) forControlEvents:UIControlEventTouchUpInside];
        
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
    
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
    
    if ([SVTool isBlankString:self.smallView.Name.text]) {
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中..."];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/AddPaymentCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.smallView.Name.text forKey:@"ecategoryname"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"0.0" forKey:@"e_expenditure_money"];
    [parameters setObject:@"0" forKey:@"e_expenditureclass"];
    [parameters setObject:@"0" forKey:@"e_expenditureid"];
    [parameters setObject:@"0" forKey:@"ecategoryid"];
    [parameters setObject:@"1" forKey:@"ecategorylive"];
    [parameters setObject:@"0" forKey:@"ecategorypaixu"];
    [parameters setObject:@"false" forKey:@"isdelete"];
    [parameters setObject:@"false" forKey:@"publicclass"];
    [parameters setObject:self.number forKey:@"superiorecategoryid"];
    
    self.smallView.Name.text = nil;

    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
            
            //block
            if (self.administerBlock) {
                self.administerBlock();
            }
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            
            //根据id去请求二级分类的内容
            [self loadDataWithID:self.number];
        } else {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据出错,添加失败"];
            
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

/**
 修改小分类
 */
- (void)ModifySmallClassName{
    
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
    
    if ([SVTool isBlankString:self.smallView.Name.text]) {
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中..."];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/AddPaymentCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //[parameters setObject:@"0001-01-01T00:00:00" forKey:@"e_expendituredate"];
    [parameters setObject:self.smallView.Name.text forKey:@"ecategoryname"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"0.0" forKey:@"e_expenditure_money"];
    [parameters setObject:@"0" forKey:@"e_expenditureclass"];
    [parameters setObject:@"0" forKey:@"e_expenditureid"];
    [parameters setObject:self.ecategoryid forKey:@"ecategoryid"];
    [parameters setObject:@"1" forKey:@"ecategorylive"];
    [parameters setObject:@"0" forKey:@"ecategorypaixu"];
    [parameters setObject:@"false" forKey:@"isdelete"];
    [parameters setObject:@"false" forKey:@"publicclass"];
    [parameters setObject:self.number forKey:@"superiorecategoryid"];
    
    self.smallView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
            
            //block
            if (self.administerBlock) {
                self.administerBlock();
            }
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"修改成功"];
            
            //根据id去请求二级分类的内容
            [self loadDataWithID:self.number];
            
        } else {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据出错,修改失败"];
            
        }
        
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
    }];
    
}

//点击手势的点击事件
- (void)maskTwoGesture{
    self.smallView.Name.text = nil;
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
}

@end
