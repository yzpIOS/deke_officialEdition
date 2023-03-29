//
//  SVViewController.m
//  SAVI
//
//  Created by houming Wang on 2018/12/5.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVViewController.h"
#import "SVShoppingCardCell.h"
#import "SVNumBlockModel.h"
#import "SVSelectedGoodsModel.h"
#import "SVOrderDetailsModel.h"
#import "SVCashierSpecModel.h"
static NSString *const ID = @"SVShoppingCardCell";
@interface SVViewController ()<UITableViewDelegate,UITableViewDataSource,XMGShopCellDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UILabel *typeNumberL;// 种类的数量
@property (weak, nonatomic) IBOutlet UILabel *sumNumberL;// 总共的数量
@property (nonatomic,assign) NSInteger num;



@end

@implementation SVViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.typeNumberL.text = [NSString stringWithFormat:@"%ld",self.modelArr.count];
   
    self.sumNumberL.text = [NSString stringWithFormat:@"%ld",self.sumCount];
//    self.sumNumberL.text =
    [_tableView setSeparatorColor:cellSeparatorColor];
    _tableView.separatorStyle = UITableViewCellEditingStyleNone;
    //取消选中
    _tableView.allowsSelection = NO;
   // [self addSubview:_tableView];
    
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //注册cell
    [_tableView registerNib:[UINib nibWithNibName:@"SVShoppingCardCell" bundle:nil] forCellReuseIdentifier:ID];
  
    NSLog(@"modelArr = %@",self.modelArr);
    
    self.num = 0;
}
- (IBAction)btnClick:(id)sender {
    [self cancleVC];
}


#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSLog(@"self.modelArr.count = %ld",self.modelArr.count);
    return self.modelArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SVShoppingCardCell *cell = [tableView dequeueReusableCellWithIdentifier:ID forIndexPath:indexPath];
    if (!cell) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"SVShoppingCardCell" owner:nil options:nil].lastObject;
    }
    cell.sv_discount_configArray = self.sv_discount_configArray;
    cell.grade = self.grade;
    cell.dic = self.modelArr[indexPath.row];
    cell.delegate = self;
   
   
    cell.numZeroBlock = ^{
        if (indexPath.row<[self.modelArr count]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVUserManager loadUserInfo];
                [self.modelArr removeObjectAtIndex:indexPath.row];
                NSInteger number = 0;
                for (NSMutableDictionary *dic in self.modelArr) {
                    number += [dic[@"product_num"] integerValue];
                }
                NSLog(@"self.num = %ld",number);
                
                self.sumNumberL.text = [NSString stringWithFormat:@"%ld",number];
                self.typeNumberL.text = [NSString stringWithFormat:@"%ld", self.modelArr.count];
                [self.tableView reloadData];
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
    };

    return cell;
}

#pragma mark - XMGCellDelegate
- (void)wineCellDidClickPlusButton:(SVShoppingCardCell *)cell{

    NSInteger number = self.sumNumberL.text.integerValue + 1;
   // NSLog(@"number = %ld",number);
    self.sumNumberL.text = [NSString stringWithFormat:@"%ld",number];
    
//    NSInteger producr_num =[cell.dic[@"product_num"] integerValue];
//    producr_num += number;
    cell.dic[@"product_num"] = cell.number;
}

- (void)wineCellDidClickMinusButton:(SVShoppingCardCell *)cell{
    
   NSLog(@"cell.page = %d",cell.page);
    
    int number = self.sumNumberL.text.intValue - 1;
    self.sumNumberL.text = [NSString stringWithFormat:@"%d",number];
    cell.dic[@"product_num"] = cell.number;
}




-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 70;
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
    //这个方法里有一个出错 2018.1.09
    
 //   SVNumBlockModel *model = self.modelArr[indexPath.row];
    //如果编辑样式为删除样式
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        if (indexPath.row<[self.modelArr count]) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"确定要删除吗？" message:nil preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            UIAlertAction *defaultAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [SVUserManager loadUserInfo];
                [self.modelArr removeObjectAtIndex:indexPath.row];
                NSInteger number = 0;
                for (NSMutableDictionary *dic in self.modelArr) {
                    number += [dic[@"product_num"] integerValue];
                }
                NSLog(@"self.num = %ld",number);
                
                self.sumNumberL.text = [NSString stringWithFormat:@"%ld",number];
                self.typeNumberL.text = [NSString stringWithFormat:@"%ld", self.modelArr.count];
                [self.tableView reloadData];
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


- (IBAction)cancleClick:(id)sender {
    [self cancleVC];
}

// 退回上一个控制器
- (void)cancleVC{
    
    if (self.arrayBlock) {
       self.arrayBlock(self.modelArr);
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)removeClick:(id)sender {
    [self.modelArr removeAllObjects];
    [self.tableView reloadData];
    self.typeNumberL.text = @"0";
    self.sumNumberL.text = @"0";
    
    if (self.cleanBlock) {
        self.cleanBlock(self.modelArr);
    }
    
    
}

- (NSArray *)sv_discount_configArray{
    if (!_sv_discount_configArray) {
        _sv_discount_configArray = [NSArray array];
    }
    
    return _sv_discount_configArray;
}

@end
