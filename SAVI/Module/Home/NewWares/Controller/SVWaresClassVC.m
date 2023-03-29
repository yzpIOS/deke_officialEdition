//
//  SVWaresClassVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/8.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresClassVC.h"
//弹框的方式
#import "SVBigClassView.h"
#import "SVSmallClassView.h"

#import "SVSmallViewModel.h"
#import "SVBigViewModel.h"

//大类cell
static NSString *BigClassID = @"bigClass";
//小类cell
static NSString *SmallClassID = @"smallClass";

@interface SVWaresClassVC () <UITableViewDelegate,UITableViewDataSource>
//第一个tableView
@property (nonatomic,strong) UITableView *oneTableView;
//第二个tableView
@property (nonatomic,strong) UITableView *twoTableView;
//第一个cell的数组
@property (nonatomic,strong) NSMutableArray *arr;
//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
@property (nonatomic,strong) UIView *maskTwoView;
//新增大分类的View
@property (nonatomic,strong) SVBigClassView *bigView;
//新增小分类的view
@property (nonatomic,strong) SVSmallClassView *smallView;


/**
 里面装着二级分类的ID
 */
@property (nonatomic,strong) NSMutableArray *bigDataArr;
/**
 里面装着二级分类的内容
 */
@property (nonatomic,strong) NSMutableArray *smallDataArr;
@property (nonatomic,assign) NSNumber *productcategory_id;
//@property (nonatomic,strong) NSString *bigClassName;

@property (nonatomic,copy) NSString *tag;

//@property (nonatomic,copy) NSString *stringName;

//记录选择了第几个
@property (nonatomic,assign) NSInteger number;

@end

@implementation SVWaresClassVC



- (void)viewDidLoad {
    [super viewDidLoad];
    //设置View的背景色
    self.view.backgroundColor = RGBA(223, 223, 223, 1);
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"商品分类";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.title = @"商品分类";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    
    //布局界面
    [self setTheInterface];
    
    
    [self addOneButtonResponseEvent];
    
    
    [self loadBigData];
    
    
}

//设置界面
- (void)setTheInterface{
    UILabel *bigLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenW/5*2-1, 50)];
    bigLabel.text = @"一级分类";
    bigLabel.textAlignment = NSTextAlignmentCenter;
    bigLabel.textColor = RGBA(153, 153, 153, 1);
    bigLabel.backgroundColor = [UIColor whiteColor];
    bigLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:bigLabel];
    
    UIButton *oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - TopHeight-51, ScreenW, 50)];
//    UIButton *oneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 64, ScreenW/5*2-1, 50)];
    [oneBtn setTitle:@"  新增一级分类" forState:UIControlStateNormal];
    [oneBtn setImage:[UIImage imageNamed:@"icom_addwhite"] forState:UIWindowLevelNormal];
    oneBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
//    [oneBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    [oneBtn setBackgroundColor:navigationBackgroundColor];
    [oneBtn addTarget:self action:@selector(jumpBigClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:oneBtn];
    
    UIButton *twoBtn =[[UIButton alloc]initWithFrame:CGRectMake(ScreenW/5*2, 0, ScreenW/5*3, 50)];
    [twoBtn setTitle:@" 新增二级分类" forState:UIControlStateNormal];
    [twoBtn setImage:[UIImage imageNamed:@"ic_xinzeng"] forState:UIWindowLevelNormal];
    twoBtn.titleLabel.font = [UIFont systemFontOfSize: 14];
    [twoBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
    [twoBtn setBackgroundColor:[UIColor whiteColor]];
    [twoBtn addTarget:self action:@selector(jumpSmallClass) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:twoBtn];
    
    //右上角按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"选择" style:UIBarButtonItemStylePlain target:self action:@selector(selectbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    //指定代理
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource =self;
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    
    [self.view addSubview:self.oneTableView];
    [self.view addSubview:self.twoTableView];
    //注册cell
    [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BigClassID];
    [self.twoTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:SmallClassID];
}

#pragma mark - 点击按钮响应的方法

//添加大分类按钮响应方法
-(void)jumpBigClass{
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.bigView];
    
}

//添加小分类按钮响应方法
-(void)jumpSmallClass{
    
    if ([SVTool isEmpty:self.arr]) {
        
        //当没有大分类时作当示
//        [SVProgressHUD showInfoWithStatus:@"请先添加大分类"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"请先添加一级分类"];
        
    } else {
        
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
        [[UIApplication sharedApplication].keyWindow addSubview:self.smallView];
        
    }
    
}

/**
 完成按钮响应方法
 */
-(void)selectbuttonResponseEvent{
    
    if (![SVTool isEmpty:self.arr]) {
        
        if ([SVTool isEmpty:self.smallDataArr]) {
            
            SVBigViewModel *bigModel = self.arr[self.number];
            //取出模型里面对应的二级分类名
            NSString *name = bigModel.sv_pc_name;
            //大分类ID
            NSString *productcategory_id = bigModel.productcategory_id;
            //产品二级分类
            NSString *productsubcategory_id = bigModel.productsubcategory_id;
            //这个是产品类型分3种，具体可以从大分类里面获取
            NSString *producttype_id = bigModel.producttype_id;
            //利用block进行回调
            if (self.nameBlock) {
                
                self.nameBlock(name,productcategory_id,productsubcategory_id,producttype_id);
                
            }
            //返回上一个界面
            [self.navigationController popViewControllerAnimated:YES];
            
        } else {
            
//            [SVProgressHUD showInfoWithStatus:@"请选择一个小分类"];
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
            //[SVTool TextButtonAction:self.view withSing:@"请选择一个小分类"];
            [SVTool TextButtonActionWithSing:@"请选择一个二级分类"];
            
        }
        
    } else {
        
//        [SVProgressHUD showInfoWithStatus:@"亲，你还没有分类可选择"];
//        //用延迟来移除提示框
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            [SVProgressHUD dismiss];
//        });
        [SVTool TextButtonAction:self.view withSing:@"亲,你还没有分类可选择"];
        
    }
    
    
}



#pragma mark - tablevewiDegelate
//默认选中第一行
//-(void)viewDidAppear:(BOOL)animated{
//    [super viewDidAppear:animated];
//    //默认选中第一行
//    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
//    
//}

//几组
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    if (tableView == self.oneTableView) {
//        return 1;
//    }else{
//        return 0;
//    }
//}

//每组几个cell
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.oneTableView) {
        return self.arr.count;
    }else {
        return self.smallDataArr.count;
    }
}

//自定义Cell的创建
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == self.oneTableView) {
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:BigClassID forIndexPath:indexPath];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigClassID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigClassID];
        }
        //取出对应的模型
        SVBigViewModel *bigModel = self.arr[indexPath.row];
        //给cell赋值
        cell.textLabel.text = bigModel.sv_pc_name;
        //赋值
//        cell.textLabel.text = self.arr[indexPath.row];
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //字体中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //字体颜色
        cell.textLabel.textColor = GlobalFontColor;
        //背景色
        cell.backgroundColor = BackgroundColor;
        //选中后显示的效果
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil highlightedImage:[UIImage imageNamed:@"leftbackgroup_red"]];
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        
        
    
        
        return cell;
    }else{
        //UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:SmallClassID forIndexPath:indexPath];
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallClassID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SmallClassID];
        }
        //赋值
        //取出对应的模型
        SVSmallViewModel *smallModel = self.smallDataArr[indexPath.row];
        //给cell赋值
        cell.textLabel.text = smallModel.sv_psc_name;
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //字体中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //字体颜色
        cell.textLabel.textColor = GlobalFontColor;
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        

        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.twoTableView) {
        
        return 55;
    }else{
        return 55;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先判断点击的是不是大分类
    if (tableView == self.oneTableView) {
        //记录选择了第几个
        self.number = indexPath.row;
//        self.smallView.bigClassName.text = [self.arr objectAtIndex:indexPath.row];
        SVBigViewModel *bigModel = self.arr[indexPath.row];
        self.smallView.bigClassName.text = bigModel.sv_pc_name;
        //取出对应二级分类的id
        self.productcategory_id = @([bigModel.productcategory_id intValue]);
        //根据id去请求二级分类的内容
        [self loadSmallDataWithCid:self.productcategory_id];
        
    }else{
        
        //取出对应的模型
        SVSmallViewModel *smallModel = self.smallDataArr[indexPath.row];
        //取出模型里面对应的二级分类名
        NSString *name = smallModel.sv_psc_name;
        //大分类ID
        NSString *productcategory_id = [NSString stringWithFormat:@"%@",self.productcategory_id];
        //产品二级分类
        NSString *productsubcategory_id = smallModel.productsubcategory_id;
        //这个是产品类型分3种，具体可以从大分类里面获取
        NSString *producttype_id = smallModel.producttype_id;
        //利用block进行回调
        if (self.nameBlock) {
            
            self.nameBlock(name,productcategory_id,productsubcategory_id,producttype_id);
        }
        //返回上一个界面
        [self.navigationController popViewControllerAnimated:YES];
    }
}

#pragma mark -- 数据请求
/**
 一级分类请求
 */
-(void)loadBigData{
    //URL
    NSString *urlStr = [URLhead stringByAppendingString:@"/product/GetFirstCategory"];
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"access_token"];
    
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
        if ([dic[@"succeed"] intValue] == 1) {
            
            [self.arr removeAllObjects];
            
            //偏好设置
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            
            NSMutableArray *bigNameArr = [NSMutableArray array];
            NSMutableArray *bigIDArr = [NSMutableArray array];
            [bigNameArr addObject:@"全部商品"];
            [bigIDArr addObject:@"0"];
            
            NSMutableArray *valuesArr = dic[@"values"];
         //   NSLog(@"valuesArr = %@",valuesArr);
            
            if (![SVTool isEmpty:valuesArr]) {
                
                //将数组里边的字典遍历一次,就可以拿到每个字典里的东西了
                for (NSDictionary *dict in valuesArr) {
                    //字典转模型
                    SVBigViewModel *bigModel = [SVBigViewModel modelWithDict:dict];
                    //把模型装到数组里面
                    [self.arr addObject:bigModel];
                    
                    [bigNameArr addObject:dict[@"sv_pc_name"]];
                    
                    [bigIDArr addObject:dict[@"productcategory_id"]];
                    
                }
                [defaults setObject:bigNameArr forKey:@"bigName_Arr"];
                [defaults setObject:bigIDArr forKey:@"bigID_Arr"];
                
                [defaults synchronize];
                
                [self.oneTableView reloadData];
                
                //默认选中第一行
                NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
                [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
                //        self.smallView.bigClassName.text = _arr[0];
                
                //取出对应的模型
                SVBigViewModel *bigModel = self.arr[0];
                //取出模型里面对应的二级分类名
                self.smallView.bigClassName.text = bigModel.sv_pc_name;
                
                //默认显示第一个子分类商品
              //  if (indexPath.row == 0) {
                    // 字符串转为NSNumber对象类型
                    self.productcategory_id = @([bigModel.productcategory_id intValue]);
                    //self.productcategory_id = [self.bigDataArr objectAtIndex:indexPath.row];
                    //[self getDataPageIndex:1 pageSize:10 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
                    [self loadSmallDataWithCid:self.productcategory_id];
               // }
                
            }
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

/**
 二级分类请求
 */
-(void)loadSmallDataWithCid:(NSNumber *)cid {
    NSString *small_path = @"/product/GetCategoryById";
//    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//    NSString *token = [defaults objectForKey:@"access_token"];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"%@?key=%@&cid=%@",small_path,token,cid];
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        if ([dic[@"succeed"] intValue] == 1) {
            //清理数据
            [self.smallDataArr removeAllObjects];
            if (![SVTool isEmpty:dic[@"values"]]) {
                
                for (NSDictionary *valuesDic in dic[@"values"]) {
                    
                    //字典转模型
                    SVSmallViewModel *smallModel = [SVSmallViewModel modelWithDict:valuesDic];
                    //把模型装到数组里面
                    [self.smallDataArr addObject:smallModel];
                }
            }
            
            //刷新tableview的数据
            [self.twoTableView reloadData];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

#pragma mark - 懒加载 
-(UITableView *)oneTableView{
    if (!_oneTableView) {
        _oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 51, ScreenW/5*2, ScreenH-TopHeight-51-50)];
        //设置样式
        _oneTableView.tableFooterView = [[UIView alloc]init];
        _oneTableView.showsVerticalScrollIndicator = NO;
        _oneTableView.backgroundColor = BackgroundColor;
        //改变cell分割线的颜色
        [_oneTableView setSeparatorColor:[UIColor whiteColor]];
        // 设置距离左右各10的距离
        [_oneTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    }
    return _oneTableView;
}

-(UITableView *)twoTableView{
    if (!_twoTableView) {
        _twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/5*2, 51, ScreenW/5*3, ScreenH-TopHeight-51-50)];
        //设置样式
        _twoTableView.tableFooterView = [[UIView alloc]init];
        //改变cell分割线的颜色
        [_twoTableView setSeparatorColor:cellSeparatorColor];
        // 设置距离左右各10的距离
        [_twoTableView setSeparatorInset:UIEdgeInsetsMake(0, 10, 0, 0)];
    }
    return _twoTableView;
}

/**
 数组
 */
-(NSMutableArray *)arr{
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}

//大类tableView数组
-(NSMutableArray *)bigDataArr{
    if (!_bigDataArr) {
        _bigDataArr = [NSMutableArray array];
    }
    return _bigDataArr;
}

//小类tableView数组
-(NSMutableArray *)smallDataArr{
    if (!_smallDataArr) {
        _smallDataArr = [NSMutableArray array];
    }
    return _smallDataArr;
}

//添加大class
-(SVBigClassView *)bigView{
    if (!_bigView) {
        _bigView = [[[NSBundle mainBundle] loadNibNamed:@"SVBigClassView" owner:nil options:nil] lastObject];
        _bigView.frame = CGRectMake(0, 0, 320, 230);
        _bigView.center = CGPointMake(self.view.frame.size.width/2, self.view.frame.size.height/2);
        _bigView.backgroundColor = [UIColor whiteColor];
        _bigView.layer.cornerRadius = 10;
        
        [_bigView.oneButton addTarget:self action:@selector(addOneButtonResponseEvent) forControlEvents:UIControlEventTouchDown];
        [_bigView.twoButton addTarget:self action:@selector(addTwoButtonResponseEvent) forControlEvents:UIControlEventTouchDown];
        
        [_bigView.bigCancelButton addTarget:self action:@selector(maskOneGesture) forControlEvents:UIControlEventTouchDown];
        [_bigView.bigDetermineButton addTarget:self action:@selector(addBigClass) forControlEvents:UIControlEventTouchDown];
    }
    return _bigView;
}

-(void)addOneButtonResponseEvent{
    
    self.tag = @"0";
    
    self.bigView.oneButton.selected = YES;
    
    self.bigView.twoButton.selected = NO;
}

-(void)addTwoButtonResponseEvent{
    
    self.tag = @"1";
    
    self.bigView.oneButton.selected = NO;
    
    self.bigView.twoButton.selected = YES;
    
    
}


/**
 添加大分类
 */
-(void)addBigClass{
    
    [self.maskOneView removeFromSuperview];
    [self.bigView removeFromSuperview];
    
    if ([SVTool isBlankString:self.bigView.bigClassName.text]) {
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //[self.bigView.bigDetermineButton setEnabled:NO];
    //不用交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中..."];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/product/SaveCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:@"0" forKey:@"productcategory_id"];
    [parameters setObject:self.bigView.bigClassName.text forKey:@"sv_pc_name"];
    [parameters setObject:self.tag forKey:@"producttype_id"];
    self.bigView.bigClassName.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            [self loadBigData];
            [self.oneTableView reloadData];
            
        } else {
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据出错，添加失败"];
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

//遮盖View
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(maskOneGesture)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//
-(void)maskOneGesture{
    [self.maskOneView removeFromSuperview];
    [self.bigView removeFromSuperview];
}

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
    
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
    
    if ([SVTool isBlankString:self.smallView.smallClassName.text]) {
        [SVTool TextButtonAction:self.view withSing:@"类名不能为空"];
        return;
    }
    
    //[self.smallView.determineButton setEnabled:NO];
    //不让交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    //提示在支付中
    [SVTool IndeterminateButtonAction:self.view withSing:@"正在提交中..."];
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/product/SaveCategory?key=%@",token];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:self.productcategory_id forKey:@"productcategory_id"];
    [parameters setObject:self.smallView.smallClassName.text forKey:@"sv_pc_name"];
    self.smallView.smallClassName.text = nil;
    
    [[SVSaviTool sharedSaviTool] POST:sURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dic[@"succeed"] integerValue] == 1) {
            
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"添加成功"];
            
            //根据id去请求二级分类的内容
            [self loadSmallDataWithCid:self.productcategory_id];
            
            [self.twoTableView reloadData];
        } else {
            //隐藏提示
            [MBProgressHUD hideHUDForView:self.view animated:YES];
            [SVTool TextButtonAction:self.view withSing:@"数据出错，添加失败"];
        }
        
        //开启交互
        [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:YES];
        //[self.smallView.determineButton setEnabled:YES];
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
    [self.maskTwoView removeFromSuperview];
    [self.smallView removeFromSuperview];
}

@end
