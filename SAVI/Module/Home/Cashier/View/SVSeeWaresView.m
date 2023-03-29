//
//  SVSeeWaresView.m
//  SAVI
//
//  Created by houming Wang on 2018/6/6.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVSeeWaresView.h"
//模型
#import "SVOrderDetailsModel.h"
#import "SVDetailsCell.h"
#import "SVDiscountAndNumberView.h"
@interface SVSeeWaresView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *view;

@property (nonatomic,strong) SVDiscountAndNumberView *discountAndNumberView;

//遮盖view
@property (nonatomic,strong) UIView *maskTheView;




@end

@implementation SVSeeWaresView

- (void)awakeFromNib {
    [super awakeFromNib];
    _tableView = [[UITableView alloc]init];
    [self addSubview:_tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.mas_left);
        make.right.mas_equalTo(self.mas_right);
        make.top.mas_equalTo(self.view.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottom);
    }];
    //去分割线
    _tableView.tableFooterView = [[UIView alloc]init];
    [_tableView setSeparatorColor:cellSeparatorColor];
    //取消选中
  //  _tableView.allowsSelection = NO;
    [self addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"SVDetailsCell" bundle:nil] forCellReuseIdentifier:@"SVDetailsCell"];
    
    [self.tableView reloadData];
}

- (void)setModelArr:(NSMutableArray *)modelArr
{
    _modelArr = modelArr;
    [self.tableView reloadData];
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVDetailsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SVDetailsCell" forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVDetailsCell" owner:nil options:nil].lastObject;
    }
    cell.indexPath = indexPath;
   // cell.orderDetailsModel = self.modelArr[indexPath.row];
    cell.grade = self.grade;
    cell.sv_discount_configArray = self.sv_discount_configArray;
    cell.dict = self.modelArr[indexPath.row];
    
   
    
//    cell.clearModelBlock = ^(SVOrderDetailsModel *orderDetailsModel, NSIndexPath *indexPath) {
//        [self.modelArr removeObjectAtIndex:indexPath.row];
//        [self.tableView reloadData];
//    };
    __weak typeof(self) weakSelf = self;
    cell.clearModelBlock = ^(NSMutableDictionary *dict, NSIndexPath *indexPath) {
        NSLog(@"indexPath.row = %ld",indexPath.row);
        NSLog(@"dict = %@",dict);
       // dict[@"product_num"] = @"0";
      //  [weakSelf.modelArr replaceObjectAtIndex:indexPath.row withObject:dict];
        
        
        
        [weakSelf.modelArr removeObjectAtIndex:indexPath.row];
        
        [weakSelf.tableView reloadData];
        
        if (weakSelf.dictArrBlock) {
            weakSelf.dictArrBlock(weakSelf.modelArr);
        };
    };
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
}


//-(NSMutableArray *)modelArr{
//    if (!_modelArr) {
//        _modelArr = [NSMutableArray array];
//    }
//    return _modelArr;
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.discountAndNumberView];
    
    
//    self.discountAndNumberView.orderDetailsModel = self.modelArr[indexPath.row];
    self.discountAndNumberView.dict = self.modelArr[indexPath.row];
    __weak typeof(self) weakSelf = self;
    
//    self.discountAndNumberView.orderDetailsModelBlock = ^(SVOrderDetailsModel * _Nonnull orderDetailsModel) {
//        [weakSelf.modelArr replaceObjectAtIndex:indexPath.row withObject:orderDetailsModel];
//        [weakSelf.tableView reloadData];
//    };
    
    self.discountAndNumberView.orderDetailsModelBlock = ^(NSDictionary * _Nonnull dict) {
        if ([dict[@"product_num"] isEqualToString:@"0"]) {
            [weakSelf.modelArr removeObjectAtIndex:indexPath.row];
            [weakSelf.tableView reloadData];
        }else{
            [weakSelf.modelArr replaceObjectAtIndex:indexPath.row withObject:dict];
            [weakSelf.tableView reloadData];
        }
       
        
        if (weakSelf.dictArrBlock) {
            weakSelf.dictArrBlock(weakSelf.modelArr);
        };
        
    };
    
    
    
    self.discountAndNumberView.clearBlock = ^{
        [weakSelf dateCancelResponseEvent];
    };
    
}


- (SVDiscountAndNumberView *)discountAndNumberView{
    if (!_discountAndNumberView) {
        _discountAndNumberView = [[NSBundle mainBundle]loadNibNamed:@"SVDiscountAndNumberView" owner:nil options:nil].lastObject;
        _discountAndNumberView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
          _discountAndNumberView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _discountAndNumberView.layer.cornerRadius = 10;
        _discountAndNumberView.layer.masksToBounds = YES;
        [_discountAndNumberView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _discountAndNumberView;
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
- (void)dateCancelResponseEvent{
    [self.maskTheView removeFromSuperview];
    [self.discountAndNumberView removeFromSuperview];
}
@end
