//
//  SVTransfersGoods.m
//  SAVI
//
//  Created by Sorgle on 2018/1/24.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVTransfersGoods.h"

static NSString *WarehouseCellID = @"WarehouseCell";
@interface SVTransfersGoods ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation SVTransfersGoods

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"调拨商品";
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64)];
    //取消tableView的选中
    //tableView.allowsSelection = NO;
    //滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:WarehouseCellID];
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //普通cell的创建
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarehouseCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:WarehouseCellID];
    }
    
    cell.textLabel.text = @"商品";
    
    return cell;
    
}

//设置cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


/**
 点击响应方法
 */
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    SVWarehouseDetailsVC *VC = [[SVWarehouseDetailsVC alloc]init];
//    [self.navigationController pushViewController:VC animated:YES];
    
}


@end
