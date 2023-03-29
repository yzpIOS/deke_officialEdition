//
//  SVWaresScreeningVC.m
//  SAVI
//
//  Created by Sorgle on 2017/6/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVWaresScreeningVC.h"
//跳到分类管理
#import "SVAdministerClassVC.h"
//cell
#import "SVAdministerClassCell.h"
//弹框
#import "SVModifyClassView.h"



static NSString *waresScreeningID = @"waresScreeningCell";

@interface SVWaresScreeningVC ()

@property (nonatomic,strong) NSMutableArray *bigClassArr;

@property (nonatomic, strong) NSMutableArray *productcategory_id_Arr;

//@property (nonatomic,assign) NSInteger *productcategory_id;

@end

@implementation SVWaresScreeningVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"筛选类别";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
     self.navigationItem.title = @"筛选类别";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.tableView.tableFooterView = [[UIView alloc]init];
    //去掉滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //注册cell
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:waresScreeningID];
    
    
}



#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.bigClassArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //普通cell的创建
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waresScreeningID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:waresScreeningID];
    }
    cell.textLabel.text = self.bigClassArr[indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    //设置字体大小
    cell.textLabel.font = [UIFont systemFontOfSize: 13];
    //字体颜色
    cell.textLabel.textColor = GlobalFontColor;
    //取消高亮
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *productcategory_id = self.productcategory_id_Arr[indexPath.row];
        //利用block进行回调
        if (self.productsubcategory_idBlock) {
            
            self.productsubcategory_idBlock([productcategory_id integerValue]);
        }
        //返回上一个界面
        [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark - 懒加载
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
                
                [self.productcategory_id_Arr addObject:dict[@"productcategory_id"]];
                
            }
            [self.tableView reloadData];
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//            [SVTool requestFailed];
            [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
        }];
    }
    return _bigClassArr;
}

-(NSMutableArray *)productcategory_id_Arr{
    if (!_productcategory_id_Arr) {
        _productcategory_id_Arr = [NSMutableArray array];
    }
    return _productcategory_id_Arr;
}


@end
