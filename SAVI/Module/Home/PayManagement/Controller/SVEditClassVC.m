//
//  SVEditClassVC.m
//  SAVI
//
//  Created by Sorgle on 2017/9/28.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVEditClassVC.h"
//跳到分类管理
#import "SVAdministerClassVC.h"
//cell
#import "SVAdministerClassCell.h"
//弹框
#import "SVModifyClassView.h"


static NSString *editClassID = @"editClassCell";

@interface SVEditClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//数组
@property (nonatomic,strong) NSMutableArray *classArr;
@property (nonatomic,strong) NSMutableArray *ecategoryidArr;
//本级类ID
@property (nonatomic,copy) NSString *ecategoryid;

//新增小分类的view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) SVModifyClassView *bigView;

@end

@implementation SVEditClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"大分类";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"大分类";
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
    [self.tableView registerNib:[UINib nibWithNibName:@"SVAdministerClassCell" bundle:nil] forCellReuseIdentifier:editClassID];
    
//    //底部按钮
//    UIButton *button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - 114, ScreenW, 50)];
//    [button setImage:[UIImage imageNamed:@"icom_addwhite"] forState:UIWindowLevelNormal];
//    [button setTitle:@"  新增大分类" forState:UIControlStateNormal];
//    button.titleLabel.font = [UIFont systemFontOfSize: 14];
//    [button setBackgroundColor:navigationBackgroundColor];
//    [self.view addSubview:button];
//    [button addTarget:self action:@selector(addBigButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 22.5;
    [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button addTarget:self action:@selector(addBigButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(45, 45));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
    [self loadData];
    

}

//添加大分类按钮响应事件
- (void)addBigButtonResponseEvent{
    self.bigView.determineButton.hidden = NO;
    self.bigView.determineTwoButton.hidden = YES;
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigView];
}

//cell的按钮响应事件
- (void)ModifyBigClassView:(UIButton *)btn{
    self.bigView.determineButton.hidden = YES;
    self.bigView.determineTwoButton.hidden = NO;
    
    self.bigView.Name.text = self.classArr[btn.tag];
    self.ecategoryid = self.ecategoryidArr[btn.tag];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigView];
    
}


#pragma mark -  请求分类数据
- (void)loadData {
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/Payment/GetPaymentGategories?key=%@",[SVUserManager shareInstance].access_token];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSArray *aar = dict[@"dataList"];
        
        //清理数组
        [self.classArr removeAllObjects];
        [self.ecategoryidArr removeAllObjects];
        
        for (NSDictionary *dic in aar) {
            [self.classArr addObject:dic[@"ecategoryname"]];
            [self.ecategoryidArr addObject:dic[@"ecategoryid"]];
        }
        
        //刷新很重要
        [self.tableView reloadData];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


#pragma mark - tableVeiw
//展示几组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//    return 1;
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 5;
    return self.classArr.count;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //xib的cell的创建
    SVAdministerClassCell *cell = [tableView dequeueReusableCellWithIdentifier:editClassID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVAdministerClassCell" owner:nil options:nil].lastObject;
    }
    cell.Img.hidden = YES;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体的大小
    //cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.Name.text = self.classArr[indexPath.row];
    //设置cell右边的小箭头
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    //tag
    cell.Button.tag = indexPath.row;
    [cell.Button addTarget:self action:@selector(ModifyBigClassView:) forControlEvents:UIControlEventTouchUpInside];
    
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    SVAdministerClassVC *VC = [[SVAdministerClassVC alloc]init];
    
    VC.className = self.classArr[indexPath.row];
    
    VC.number = self.ecategoryidArr[indexPath.row];
    
    __weak typeof(self) weakSelf = self;
    
    VC.administerBlock = ^(){
      
        if (weakSelf.editBlock) {
            
            weakSelf.editBlock(1);
            
        }
        
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    
    
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
        
        if (indexPath.row<[self.classArr count]) {
            
            [SVUserManager loadUserInfo];
            NSString *token = [SVUserManager shareInstance].access_token;
            NSString *categoryId = self.ecategoryidArr[indexPath.row];
            
            //url
            NSString *strURL = [URLhead stringByAppendingFormat:@"/api/Payment/DelPaymentCategory?key=%@&categoryId=%@",token,categoryId];
            
            
            [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"success"] integerValue] == 1) {
                    
                    //当删除完了之后
                    if (self.classArr.count == 1) {
                        if (self.editBlock) {
                            self.editBlock(0);
                        }
                    } else {
                        if (self.editBlock) {
                            self.editBlock(1);
                            
                        }
                    }
                    
//                    [SVProgressHUD showSuccessWithStatus:dic[@"msg"]];
//                    //用延迟来移除提示框
//                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                        [SVProgressHUD dismiss];
//                    });
                    [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                    //移除数据源的数据
                    [self.classArr removeObjectAtIndex:indexPath.row];
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
                
//                [SVTool requestFailed];
                [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                
            }];
        }
    }
}

#pragma mark - 懒加载

-(NSMutableArray *)classArr{
    if (!_classArr) {
        _classArr = [NSMutableArray array];
    }
    return _classArr;
}

-(NSMutableArray *)ecategoryidArr{
    if (!_ecategoryidArr) {
        _ecategoryidArr = [NSMutableArray array];
    }
    return _ecategoryidArr;
}

#pragma mark - 添加分类的弹框
//添加小class
-(SVModifyClassView *)bigView{
    if (!_bigView) {
        _bigView = [[[NSBundle mainBundle] loadNibNamed:@"SVModifyClassView" owner:nil options:nil] lastObject];
        _bigView.frame = CGRectMake(0, 0, 320, 230);
        _bigView.center = CGPointMake(ScreenW/2, ScreenH/2);
        _bigView.layer.cornerRadius = 10;
        //        _smallView.backgroundColor = [UIColor whiteColor];
        //        _smallView.bigClassName.text = self.bigClassName;
        
        //添加事件
        [_bigView.cancelButton addTarget:self action:@selector(maskTwoGesture) forControlEvents:UIControlEventTouchUpInside];
        
        [_bigView.determineButton addTarget:self action:@selector(addEditBigClass) forControlEvents:UIControlEventTouchUpInside];
        [_bigView.determineTwoButton addTarget:self action:@selector(ModifyBigClassName) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _bigView;
}
//遮盖View
-(UIView *)maskView{
    if (!_maskView) {
        _maskView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskTwoGesture)];
        [_maskView addGestureRecognizer:tap];
    }
    return _maskView;
}


/**
 添加一级分类
 */
-(void)addEditBigClass{
    
    [self.maskView removeFromSuperview];
    [self.bigView removeFromSuperview];
    
    if ([SVTool isBlankString:self.bigView.Name.text]) {
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
    
    [parameters setObject:self.bigView.Name.text forKey:@"ecategoryname"];
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
    
    self.bigView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
            
            if (self.editBlock) {
                self.editBlock(1);
            }
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            //重新请求刷新
            [self loadData];
            
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
 修改分类
 */
- (void)ModifyBigClassName{
    
    [self.maskView removeFromSuperview];
    [self.bigView removeFromSuperview];
    
    if ([SVTool isBlankString:self.bigView.Name.text]) {
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
    [parameters setObject:self.bigView.Name.text forKey:@"ecategoryname"];
    [parameters setObject:[SVUserManager shareInstance].user_id forKey:@"user_id"];
    [parameters setObject:@"0.0" forKey:@"e_expenditure_money"];
    [parameters setObject:@"0" forKey:@"e_expenditureclass"];
    [parameters setObject:@"0" forKey:@"e_expenditureid"];
    [parameters setObject:self.ecategoryid forKey:@"ecategoryid"];
    [parameters setObject:@"0" forKey:@"ecategorylive"];
    [parameters setObject:@"0" forKey:@"ecategorypaixu"];
    [parameters setObject:@"false" forKey:@"isdelete"];
    [parameters setObject:@"false" forKey:@"publicclass"];
    [parameters setObject:@"0" forKey:@"superiorecategoryid"];
    
    self.bigView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"success"] integerValue] == 1) {
            
            if (self.editBlock) {
                self.editBlock(1);
            }
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            //根据id去请求二级分类的内容
            [self loadData];
            
        } else {
            
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据出错，修改失败"];
            
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

//点击手势的点击事件
- (void)maskTwoGesture{
    self.bigView.Name.text = nil;
    [self.maskView removeFromSuperview];
    [self.bigView removeFromSuperview];
}


@end
