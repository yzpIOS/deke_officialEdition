//
//  SVWaresTwoClassVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/20.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWaresTwoClassVC.h"
//cell
#import "SVAdministerClassCell.h"
//弹框
#import "SVModifyClassView.h"


static NSString *AdministerClassID = @"AdministerClassCell";

@interface SVWaresTwoClassVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//数组
@property (nonatomic,strong) NSMutableArray *smallClassArr;
@property (nonatomic,strong) NSMutableArray *ecategoryidArr;

//本级类ID
@property (nonatomic,copy) NSString *ecategoryid;

//新增小分类的view
@property (nonatomic,strong) UIView *maskTwoView;
@property (nonatomic,strong) SVModifyClassView *smallView;

@end

@implementation SVWaresTwoClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"小分类";
    
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
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product/GetCategoryById?key=%@&cid=%@",[SVUserManager shareInstance].access_token,catetoryId];
    
    //get请求
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
        
        NSArray *aar = dict[@"values"];
        
        //清理数组
        [self.smallClassArr removeAllObjects];
        [self.ecategoryidArr removeAllObjects];
        
        for (NSDictionary *dic in aar) {
            
            [self.smallClassArr addObject:dic[@"sv_psc_name"]];
            
            [self.ecategoryidArr addObject:dic[@"productsubcategory_id"]];
            
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
//    return 1;
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
    
    //    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

//组头高
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}

/////组头
- ( NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    return self.className;
}

/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.smallView.determineButton.hidden = YES;
    self.smallView.determineTwoButton.hidden = NO;
    
    self.smallView.Name.text = self.smallClassArr[indexPath.row];
    self.ecategoryid = self.ecategoryidArr[indexPath.row];
    
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
            NSString *strURL = [URLhead stringByAppendingFormat:@"/product/DelCategory?key=%@&categoryId=%@&type=%@",token,categoryId,@"subc"];
            
            
            [[SVSaviTool sharedSaviTool] POST:strURL parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"succeed"] integerValue] == 1) {
                    
                    [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                    //移除数据源的数据
                    [self.smallClassArr removeObjectAtIndex:indexPath.row];
                    [self.ecategoryidArr removeObjectAtIndex:indexPath.row];
                    
                    //移除tableView中的数据
                    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                    
                    [self.tableView reloadData];
                    
                } else {
                    
                    [SVTool TextButtonAction:self.view withSing:@"删除失败"];
                    
                }
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
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


//添加小分类
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
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/ProductApi/Productsubcategory_Edit?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.smallView.Name.text forKey:@"sv_pc_name"];
    [parameters setObject:self.number forKey:@"sv_psc_parentid"];
    [parameters setObject:@"0" forKey:@"sv_sort"];
    [parameters setObject:@"0" forKey:@"id"];
    [parameters setObject:@"false" forKey:@"is_son"];
    
    self.smallView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"code"] integerValue] == 1) {
            
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

//修改小分类
- (void)ModifySmallClassName{
    
    //移除
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
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/product/SaveCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.smallView.Name.text forKey:@"sv_pc_name"];
    [parameters setObject:@"-1" forKey:@"producttype_id"];
    [parameters setObject:self.ecategoryid forKey:@"productsubcategory_id"];// 小的分类shu'ju
    [parameters setObject:self.number forKey:@"productcategory_id"];// 最后面那个是大的分类数据
    
    self.smallView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
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
        //        [SVTool requestFailed];
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
