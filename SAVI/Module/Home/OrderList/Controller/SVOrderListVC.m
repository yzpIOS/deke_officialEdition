//
//  SVOrderListVC.m
//  SAVI
//
//  Created by Sorgle on 17/4/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVOrderListVC.h"
#import "SVOrderListCell.h"
#import "SVOrderListModel.h"
//订单详情
#import "SVOrderDetailsVC.h"


@interface SVOrderListVC ()

@property (nonatomic,strong) NSMutableArray *modelArr;


@end

@implementation SVOrderListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置导航标题
//    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"挂单列表";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"挂单列表";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //去掉多余的分割线,显示cell还有线
    self.tableView.tableFooterView = [[UIView alloc]init];
    //改变cell分割线的颜色
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVOrderListCell" bundle:nil] forCellReuseIdentifier:@"SVOrderListCell"];
    
    //提示加载中
    [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
    [self requesData];
    
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onToggleOrderListVisible:) name:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:nil];
    
}

- (void)onToggleOrderListVisible:(NSNotification*)noti{
    if ([noti.object isEqualToString:@"1"]) {
        //提示加载中
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requesData];
    }
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TOGGLE_ORDERLIST_VISIBLE_NOTI" object:nil];
}

#pragma mark - 请求数据
-(void)requesData{
    //URL
    NSString *urlStr = [URLhead stringByAppendingString:@"/order/Getguandan"];
    
    [SVUserManager loadUserInfo];
    
    //创建可变字典
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //将key放到字典里
    [parameters setObject:[SVUserManager shareInstance].access_token forKey:@"key"];
    //请求数据
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"挂单列表dic = %@",dic);
        
        [self.modelArr removeAllObjects];
        
        if ([dic[@"succeed"] intValue] == 1) {
            NSMutableArray *valuesArr = dic[@"values"];
            
            //判断是否为空，如果为空就不走这
            if (![SVTool isEmpty:valuesArr]) {
                //将数组存放顺序倒放
                //valuesArr = (NSMutableArray *)[[valuesArr reverseObjectEnumerator] allObjects];
                
                for (NSDictionary *dict in valuesArr) {
                    SVOrderListModel *model = [SVOrderListModel mj_objectWithKeyValues:dict];
                    [self.modelArr addObject:model];
                }
            }
            
            [self.tableView reloadData];
        }
        
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVOrderListCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[SVOrderListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SVOrderListCell"];
    }
    
    cell.OrderListModel = self.modelArr[indexPath.row];
    
    return cell;
}

//设置Cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 55;
}

#pragma mark - 点击方法
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.hidesBottomBarWhenPushed = YES;
    
    SVOrderListModel *model = self.modelArr[indexPath.row];
    SVOrderDetailsVC *VC = [[SVOrderDetailsVC alloc]init];
    VC.orderID = model.wt_nober;
    VC.sv_without_list_id = model.sv_without_list_id;
    VC.member_id = model.member_id;
    VC.sv_member_discount = model.sv_member_discount;
    //删除后的block回调
    VC.orderBlock = ^(){
        [SVTool IndeterminateButtonAction:self.view withSing:@"加载中…"];
        [self requesData];
    };
    
    [self.navigationController pushViewController:VC animated:YES];
    self.hidesBottomBarWhenPushed = YES;
    
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
        
        if (indexPath.row<[self.modelArr count]) {
            
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [SVUserManager loadUserInfo];
                SVOrderListModel *model = self.modelArr[indexPath.row];
                
                //url
                NSString *strURL = [URLhead stringByAppendingFormat:@"/order?key=%@&order_id=%@",[SVUserManager shareInstance].access_token,model.wt_nober];
                
                
                [[SVSaviTool sharedSaviTool] DELETE:strURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                    
                    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
                    
                    if ([dic[@"succeed"] integerValue] == 1) {
                        
                        [self.modelArr removeObjectAtIndex:indexPath.row];
                        
                        //移除tableView中的数据
                        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationLeft];
                        
                        [self.tableView reloadData];
                        
                    } else {
                        [SVTool TextButtonAction:self.view withSing:@"删除失败"];
                    }
                    
                } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                    [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
                    
                }];
            }];
            [cancelAction setValue:GreyFontColor forKey:@"titleTextColor"];
            [defaultAction setValue:navigationBackgroundColor forKey:@"titleTextColor"];
            
            NSMutableAttributedString *hogan = [[NSMutableAttributedString alloc] initWithString:@"确定要删除吗？"];
            //设置文本颜色
            [hogan addAttribute:NSForegroundColorAttributeName value:GlobalFontColor range:NSMakeRange(0, 7)];
            //设置文本字体大小
            [hogan addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSMakeRange(0, 7)];
            [alert setValue:hogan forKey:@"attributedTitle"];
            
            [alert addAction:cancelAction];
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)modelArr {
    if (!_modelArr) {
        _modelArr = [NSMutableArray array];
    }
    return _modelArr;
}

@end
