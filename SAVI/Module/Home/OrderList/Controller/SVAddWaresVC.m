//
//  SVAddWaresVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/3.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVAddWaresVC.h"
//cell
#import "SVAddWaresCell.h"
//模型
#import "SVAddWaresModel.h"

//大类cell
static NSString *BigoneTableID = @"bigOneTable";
//小类cell
static NSString *SmalltwoTableID = @"smallTwoTable";

@interface SVAddWaresVC ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>

//tableView
@property (nonatomic,strong) UITableView *oneTableView;
@property (nonatomic,strong) UITableView *twoTableView;
//搜索栏
@property (strong, nonatomic) UISearchBar *searchBar;

//第一个tableViewcell的数组
@property (nonatomic,strong) NSMutableArray *bigClassArr;
@property (nonatomic, strong) NSMutableArray *product_id_Arr;

@property (nonatomic,strong) NSMutableArray *goodsModelArr;

@property (nonatomic,strong) NSNumber *productcategory_id;


@end

@implementation SVAddWaresVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"添加商品";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"添加商品";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //搜索栏
    [self setUpSearchBar];
    
    //tableView
    [self setUpTavbleView];
}

#pragma mark - 布局界面
//搜索栏
- (void)setUpSearchBar{
    
    UISearchBar  *searchbar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, ScreenW, 45)];
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].sv_uit_cache_name isEqualToString:@"cache_name_clothing_and_shoes"]){
        
        searchbar.placeholder = @"请输入商品名称,款号";
    }else{
        
        searchbar.placeholder = @"请输入商品名称,条码";
    }
   
    // 修改cancel
    searchbar.showsCancelButton=NO;
    searchbar.barStyle=UIBarStyleDefault;
    searchbar.keyboardType=UIKeyboardTypeNamePhonePad;
    searchbar.delegate = self;
    // 修改cancel
    searchbar.showsSearchResultsButton=NO;
    //为UISearchBar添加背景图片
    searchbar.backgroundColor = [UIColor whiteColor];
    searchbar.backgroundImage = [UIImage imageNamed:@"searBarBackgroundImage"];
    //一下代码为修改placeholder字体的颜色和大小
    UITextField * searchField = [searchbar valueForKey:@"_searchField"];
    // 输入文本颜色
    searchField.textColor = GlobalFontColor;
    searchField.font = [UIFont systemFontOfSize:15];
    // 默认文本大小
    [searchField setValue:[UIFont boldSystemFontOfSize:13] forKeyPath:@"_placeholderLabel.font"];
    [self.view addSubview:searchbar];
    
    self.searchBar=searchbar;
}

//tableView
-(void)setUpTavbleView{
    //指定代理
    self.oneTableView.delegate = self;
    self.oneTableView.dataSource =self;
    self.twoTableView.delegate = self;
    self.twoTableView.dataSource = self;
    
    [self.view addSubview:self.oneTableView];
    [self.view addSubview:self.twoTableView];
    //注册cell
    [self.oneTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:BigoneTableID];
    //Xib注册cell
    [self.twoTableView registerNib:[UINib nibWithNibName:@"SVAddWaresCell" bundle:nil] forCellReuseIdentifier:SmalltwoTableID];
}

#pragma mark - tablevewiDegelate
//进来默认选中第一行
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    //默认选中第一行
    NSIndexPath *firstPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.oneTableView selectRowAtIndexPath:firstPath animated:YES scrollPosition:UITableViewScrollPositionTop];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (tableView == self.twoTableView) {
        
        return 70;
    }else{
        return 44;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.oneTableView) {
        return self.bigClassArr.count;
    }else{
        return self.goodsModelArr.count;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.oneTableView) {
        UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigoneTableID];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:BigoneTableID];
        }
        //赋值
        cell.textLabel.text = self.bigClassArr[indexPath.row];
        //设置字体大小
        cell.textLabel.font = [UIFont systemFontOfSize: 13];
        //字体中
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        //背景色
        cell.backgroundColor = BackgroundColor;
        //选中后显示的效果
        cell.selectedBackgroundView = [[UIImageView alloc]initWithImage:nil highlightedImage:[UIImage imageNamed:@"leftbackgroup_red"]];
        //选中后字体颜色
        cell.textLabel.highlightedTextColor = [UIColor redColor];
        
        
        //默认显示第一个子分类商品
        if (indexPath.row == 0) {
            self.productcategory_id = [self.product_id_Arr objectAtIndex:indexPath.row];
            [self getDataPageIndex:1 pageSize:10 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
        }
        
        
        return cell;
    } else {
        SVAddWaresCell *cell = [tableView dequeueReusableCellWithIdentifier:SmalltwoTableID forIndexPath:indexPath];
        
        if (!cell) {
            
            cell = [[NSBundle mainBundle] loadNibNamed:@"SVAddWaresCell" owner:nil options:nil].lastObject;
        }
        //取消高亮
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        cell.model = self.goodsModelArr[indexPath.row];
        
        return cell;
    }
    
}

/**
 二级分类
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //先判断点击的是不是大分类
    if (tableView == self.oneTableView) {
        //取出对应二级分类的id
        self.productcategory_id = [self.product_id_Arr objectAtIndex:indexPath.row];
        //        //根据id去请求二级分类的内容
        [self getDataPageIndex:1 pageSize:10 category:[[NSString stringWithFormat:@"%@",self.productcategory_id] integerValue] name:@""];
    }
}


/**
 获取产品列表
 
 @param pageIndex 第几页
 @param pageSize 每页有几个
 @param category 只限大分类
 @param name 搜索关键字
 */
- (void)getDataPageIndex:(NSInteger)pageIndex pageSize:(NSInteger)pageSize category:(NSInteger)category name:(NSString *)name {
    
//    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"access_token"],pageIndex,pageSize,category,name];
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/product?key=%@&pageIndex=%li&pageSize=%li&category=%li&name=%@",[SVUserManager shareInstance].access_token,(long)pageIndex,(long)pageSize,category,name];
    
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        NSDictionary *valuesDic = dic[@"values"];
        
        NSArray *listArr = valuesDic[@"list"];
        
        
        for (NSDictionary *goodsDic in listArr) {
            
            SVAddWaresModel *goodsModel = [SVAddWaresModel mj_objectWithKeyValues:goodsDic];
            
            [self.goodsModelArr addObject:goodsModel];
        }
        
        
        [self.twoTableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}



#pragma mark - 懒加载
-(UITableView *)oneTableView{
    if (!_oneTableView) {
        _oneTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 54, ScreenW/6*2, ScreenH-54)];
        //设置样式
        _oneTableView.tableFooterView = [[UIView alloc]init];
    }
    return _oneTableView;
}

-(UITableView *)twoTableView{
    if (!_twoTableView) {
        _twoTableView = [[UITableView alloc]initWithFrame:CGRectMake(ScreenW/6*2, 54, ScreenW/6*4, ScreenH-54)];
        //设置样式
        _twoTableView.tableFooterView = [[UIView alloc]init];
    }
    return _twoTableView;
}

-(NSMutableArray *)bigClassArr{
    if (!_bigClassArr) {
        _bigClassArr = [NSMutableArray array];
        //URL
        NSString *urlStr = [URLhead stringByAppendingString:@"/product/GetFirstCategory"];
//        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//        NSString *token = [defaults objectForKey:@"access_token"];
        
        //创建可变字典
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
        //将key放到字典里
//        [parameters setObject:token forKey:@"key"];
        
        [SVUserManager loadUserInfo];
        [parameters setObject:[SVUserManager shareInstance].access_token forKey:@"key"];
        
        //请求数据
        [[SVSaviTool sharedSaviTool] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            
            NSMutableArray *valuesArr = dic[@"values"];
            //将数组里边的字典遍历一次,就可以拿到每个字典里的东西了
            
            for (NSDictionary *dict in valuesArr) {
                [_bigClassArr addObject:dict[@"sv_pc_name"]];
                
                [self.product_id_Arr addObject:dict[@"productcategory_id"]];
                
            }
            [self.oneTableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
    return _bigClassArr;
}

- (NSMutableArray *)product_id_Arr {
    
    if (!_product_id_Arr) {
        
        _product_id_Arr = [NSMutableArray array];
    }
    return _product_id_Arr;
}

- (NSMutableArray *)goodsModelArr {
    
    if (!_goodsModelArr) {
        
        _goodsModelArr = [NSMutableArray array];
    }
    return _goodsModelArr;
}

@end
