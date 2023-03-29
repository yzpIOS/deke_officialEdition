//
//  SVWaresOneClassVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/6.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVWaresOneClassVC.h"
//cell
#import "SVAdministerClassCell.h"
//弹框
#import "SVModifyClassView.h"
//HeaderView
#import "SVWaresHeaderView.h"
//小分类
#import "SVWaresTwoClassVC.h"


static NSString *waresOneClassID = @"waresOneCell";

@interface SVWaresOneClassVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//数组
@property (nonatomic,strong) NSMutableArray *classArr;
@property (nonatomic,strong) NSMutableArray *ecategoryidArr;

//本级类ID
@property (nonatomic,copy) NSString *ecategoryid;

//新增小分类的view
@property (nonatomic,strong) UIView *maskView;
@property (nonatomic,strong) SVModifyClassView *bigView;
@property (nonatomic,strong) NSMutableArray * categaryArray;
@end

@implementation SVWaresOneClassVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"商品分类";
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    topView.backgroundColor = BackgroundColor;
    [self.view addSubview:topView];
    UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 20)];
    textLabel.centerY = topView.centerY;
    textLabel.textColor = GreyFontColor;
    textLabel.font = [UIFont systemFontOfSize:12];
    textLabel.text = @"左滑可操作删除";
    [topView addSubview:textLabel];
    
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 20, ScreenW, ScreenH - TopHeight - 20)];
    //去掉多余的分割线,显示cell还有线
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    //Xib注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVAdministerClassCell" bundle:nil] forCellReuseIdentifier:waresOneClassID];

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
    
  //  [self loadBigData];
    [self ProductApiGetProductcategoryProducttype_id];
    
}

//添加大分类按钮响应事件  底部按钮
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
    NSDictionary *dict = self.categaryArray[btn.tag];
    self.bigView.Name.text = dict[@"sv_pc_name"];
    self.ecategoryid = [NSString stringWithFormat:@"%@",dict[@"id"]];
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigView];
    
}


#pragma mark -  请求分类数据
//一级分类请求
-(void)loadBigData{
    //URL
    NSString *urlStr = [URLhead stringByAppendingString:@"/product/GetFirstCategory"];

    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;

    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //将key放到字典里
    [parameters setObject:token forKey:@"key"];
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        
        //清理数组
        [self.classArr removeAllObjects];
        [self.ecategoryidArr removeAllObjects];

        NSMutableArray *valuesArr = dic[@"values"];

        if (![SVTool isEmpty:valuesArr]) {

            //将数组里边的字典遍历一次,就可以拿到每个字典里的东西了
            for (NSDictionary *dic in valuesArr) {
                //字典转模型
//                SVBigViewModel *bigModel = [SVBigViewModel modelWithDict:dict];
                //把模型装到数组里面
//                [self.arr addObject:bigModel];
//                [self.arr addObject:dict[@"sv_pc_name"]];
//                [self.bigDataArr addObject:dict[@"productcategory_id"]];
                
                [self.classArr addObject:dic[@"sv_pc_name"]];
                [self.ecategoryidArr addObject:dic[@"productcategory_id"]];
            }
            
        }

            [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
   
}


- (void)ProductApiGetProductcategoryProducttype_id{
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/ProductApi/GetProductcategory?key=%@&page=1&pagesize=100&producttype_id=-1",[SVUserManager shareInstance].access_token];
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解释数据
        NSMutableDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSLog(@"dic ==== %@",dic);
        [self.categaryArray removeAllObjects];
        if ([dic[@"code"] intValue] == 1) {
            NSDictionary *data = dic[@"data"];
            NSArray *listArray = data[@"list"];
            [self.categaryArray addObjectsFromArray:listArray];
            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFirstCategoryPost" object:nil userInfo:dic];
        }else{
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
           // dic[@"msg"];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];

        }
        
        [self.tableView reloadData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //隐藏提示框
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            //[SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    
}

#pragma mark - tableVeiw
//展示几组
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
////    return 1;
//    return self.bigNameArr.count;
//}

//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    //    return 5;
    return self.categaryArray.count;

}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    //xib的cell的创建
    SVAdministerClassCell *cell = [tableView dequeueReusableCellWithIdentifier:waresOneClassID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVAdministerClassCell" owner:nil options:nil].lastObject;
    }
    cell.Img.hidden = YES;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //设置字体的大小
    //cell.textLabel.font = [UIFont systemFontOfSize:15];
    NSDictionary *dict = self.categaryArray[indexPath.row];
    cell.Name.text = dict[@"sv_pc_name"];
    //cell.Name.text = self.categaryArray[indexPath.row];
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

//点击响应方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SVWaresTwoClassVC *VC = [[SVWaresTwoClassVC alloc]init];
    NSDictionary *dict = self.categaryArray[indexPath.row];
    
    VC.className = dict[@"sv_pc_name"];
    VC.number = [NSString stringWithFormat:@"%@",dict[@"id"]];
    
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

        if (indexPath.row<[self.categaryArray count]) {

            [SVUserManager loadUserInfo];
            NSString *token = [SVUserManager shareInstance].access_token;
            NSDictionary *dict = self.categaryArray[indexPath.row];

            //url
            NSString *strURL = [URLhead stringByAppendingFormat:@"/api/ProductApi/DeleteCategory?key=%@",token];
            NSMutableDictionary *parame = [NSMutableDictionary dictionary];
            parame[@"id"] = [NSString stringWithFormat:@"%@",dict[@"id"]];
            parame[@"name"] = dict[@"sv_pc_name"];
            parame[@"sv_p_source"] = @"300";
            
            [[SVSaviTool sharedSaviTool]POST:strURL parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                
                if ([dic[@"code"] intValue] == 1) {
                    [SVTool TextButtonAction:self.view withSing:@"删除成功"];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFirstCategoryPost" object:nil userInfo:dic];
                    [self ProductApiGetProductcategoryProducttype_id];

                }else{
                    NSString *msg = dic[@"msg"];
                    [SVTool TextButtonAction:self.view withSing:kStringIsEmpty(msg)?@"删除失败":msg];
                }
                        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                            [SVTool TextButtonAction:self.view withSing:@"删除失败"];
                        }];
            

            
        }
    }
}

#pragma mark - 懒加载
-(NSMutableArray *)classArr{
    if (_classArr == nil) {
        
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
    
    //移除
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
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/product/SaveCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"0" forKey:@"productcategory_id"];
    [parameters setObject:self.bigView.Name.text forKey:@"sv_pc_name"];
    [parameters setObject:@"0" forKey:@"producttype_id"];
    self.bigView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFirstCategoryPost" object:nil userInfo:dic];
            //重新请求刷新
            [self ProductApiGetProductcategoryProducttype_id];
           // [self requestBigClassData];
            
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
    
    //移除
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
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/product/SaveCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.bigView.Name.text forKey:@"sv_pc_name"];
    [parameters setObject:@"2" forKey:@"producttype_id"];
    [parameters setObject:self.ecategoryid forKey:@"productsubcategory_id"];
    [parameters setObject:@"0" forKey:@"productcategory_id"];
    
    self.bigView.Name.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"修改成功"];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"GetFirstCategoryPost" object:nil userInfo:dic];
            //重新请求刷新
            [self ProductApiGetProductcategoryProducttype_id];
           // [self requestBigClassData];
            
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
    self.bigView.Name.text = nil;
    [self.maskView removeFromSuperview];
    [self.bigView removeFromSuperview];
}



- (NSMutableArray *)categaryArray
{
    if (!_categaryArray) {
        _categaryArray = [NSMutableArray array];
    }
    return _categaryArray;
}

@end
