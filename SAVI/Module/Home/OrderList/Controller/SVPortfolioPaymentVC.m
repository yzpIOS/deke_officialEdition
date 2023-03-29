//
//  SVPortfolioPaymentVC.m
//  SAVI
//
//  Created by houming Wang on 2021/3/22.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVPortfolioPaymentVC.h"
#import "SVPaymentMethodCell.h"
#import "SVPortfolioPaymentView.h"
static NSString *const ID = @"SVPaymentMethodCell";
@interface SVPortfolioPaymentVC ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIView *bigView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property(nonatomic, assign) BOOL isSelected;
@property (nonatomic,strong) NSMutableArray * selectArr;
@property (nonatomic,strong) NSMutableArray * selectCellArray;
@property (nonatomic,strong) SVPortfolioPaymentView *portfolioPaymentView;
//遮盖view
@property (nonatomic,strong) UIView *maskTheView;

@property (weak, nonatomic) IBOutlet UILabel *AmountReceivable;

@property (nonatomic,strong) NSString * selectMoney;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomConstance;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@end

@implementation SVPortfolioPaymentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    self.title = @"组合支付";
    self.bigView.layer.cornerRadius = 10;
    self.bigView.layer.masksToBounds = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SVPaymentMethodCell" bundle:nil] forCellReuseIdentifier:ID];
    self.tableView.separatorStyle = NO;
    NSLog(@"self.titleArray = %@",self.titleArray);
    NSLog(@"self.imageArray = %@",self.imageArray);
    self.AmountReceivable.text = self.money;
    self.bottomConstance.constant = BottomHeight;
    self.sureBtn.backgroundColor = navigationBackgroundColor;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVPaymentMethodCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[SVPaymentMethodCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    
    cell.icon.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.title.text = self.titleArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    SVPaymentMethodCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *titleStr = self.titleArray[indexPath.row];
    cell.tag = indexPath.row;
    if (self.selectArr.count == 2) {

        NSDictionary *dict = self.selectArr[0];
        NSDictionary *dict1 = self.selectArr[1];
        if ([dict[@"index"] integerValue] == indexPath.row) {
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            self.portfolioPaymentView.TotleMoney = self.money;
            self.portfolioPaymentView.clearBtn.tag = indexPath.row;
            self.portfolioPaymentView.tuichu.tag = indexPath.row;
            self.portfolioPaymentView.title = titleStr;
            [[UIApplication sharedApplication].keyWindow addSubview:self.portfolioPaymentView];
        }else if ([dict1[@"index"] integerValue] == indexPath.row){
            [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
            self.portfolioPaymentView.TotleMoney = self.money;
            self.portfolioPaymentView.clearBtn.tag = indexPath.row;
            self.portfolioPaymentView.tuichu.tag = indexPath.row;
            self.portfolioPaymentView.title = titleStr;
            [[UIApplication sharedApplication].keyWindow addSubview:self.portfolioPaymentView];
        }else{
            return [SVTool TextButtonAction:self.view withSing:@"只支持两种支付方式"];
        }
       
    }else if (self.selectArr.count == 0){
        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
        self.portfolioPaymentView.TotleMoney = self.money;
        self.portfolioPaymentView.clearBtn.tag = indexPath.row;
        self.portfolioPaymentView.tuichu.tag = indexPath.row;
        self.portfolioPaymentView.title = titleStr;
        [[UIApplication sharedApplication].keyWindow addSubview:self.portfolioPaymentView];
    }
  
    __weak typeof(self) weakSelf = self;
    self.portfolioPaymentView.selectMoney = ^(NSString * _Nonnull money) {
        cell.backgroundColor =  RGBA(197, 205, 244, 1);
        cell.contentView.layer.cornerRadius = 5;
        cell.contentView.layer.masksToBounds = YES;
        cell.contentView.layer.borderWidth = 1;
        cell.contentView.layer.borderColor = navigationBackgroundColor.CGColor;
        
        for (NSDictionary *dict in weakSelf.selectArr) {
            if ([dict[@"index"] integerValue] == indexPath.row) {
                [weakSelf.selectArr removeObject:dict];
                break;
            }
        }
        
        for (SVPaymentMethodCell *cell in weakSelf.selectCellArray) {
            if (cell.tag == indexPath.row) {
                [weakSelf.selectCellArray removeObject:cell];
                break;
            }
        }

        cell.money.text =  [NSString stringWithFormat:@"%.2f",money.doubleValue];;
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
        dictM[@"money"] = [NSString stringWithFormat:@"%.2f",money.doubleValue];
        dictM[@"title"] = weakSelf.titleArray[indexPath.row];
        dictM[@"index"] = [NSString stringWithFormat:@"%ld",indexPath.row];
        [weakSelf.selectArr addObject:dictM];
        [weakSelf.selectCellArray addObject:cell];
        [weakSelf dateCancelResponseEvent];
        if (weakSelf.selectArr.count == 2) {
//            if (![titleStr isEqualToString:@"现金"]) {
//                NSMutableDictionary *dictM =  weakSelf.selectArr[0];
//                double money_0 = [dictM[@"money"] doubleValue];
//                if (money.doubleValue + money_0 < self.money.doubleValue) {
//
//                    SVPaymentMethodCell *cell_0 = weakSelf.selectCellArray[0];
//                    double money_1 = weakSelf.money.doubleValue - money.doubleValue;
//                    cell_0.money.text = [NSString stringWithFormat:@"%.2f",money_1];
//
//                    NSMutableDictionary *dictM =  weakSelf.selectArr[0];
//                    dictM[@"money"] = [NSString stringWithFormat:@"%.2f",money_1];
//                }
//
//            }else{
//                if (money.doubleValue >= self.money.doubleValue) {
//
//                }else{
                    SVPaymentMethodCell *cell_0 = weakSelf.selectCellArray[0];
                    double money_1 = weakSelf.money.doubleValue - money.doubleValue;
                    cell_0.money.text = [NSString stringWithFormat:@"%.2f",money_1];
                    
                    NSMutableDictionary *dictM =  weakSelf.selectArr[0];
                    dictM[@"money"] = [NSString stringWithFormat:@"%.2f",money_1];
                    NSLog(@"money_1 = %.2f",money_1);
               // }

          //  }
            
        }
        
    };
    // 等于1个的时候  第二个就自动用应收金额减去第一个的钱得到的结果
    if (self.selectArr.count == 1) {
        for (NSDictionary *dict in self.selectArr) {
            if ([dict[@"index"] integerValue] == indexPath.row) {
                [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
                self.portfolioPaymentView.TotleMoney = self.money;
                self.portfolioPaymentView.clearBtn.tag = indexPath.row;
                self.portfolioPaymentView.tuichu.tag = indexPath.row;
                self.portfolioPaymentView.title = titleStr;
                [[UIApplication sharedApplication].keyWindow addSubview:self.portfolioPaymentView];
                break;
            }else{
                NSDictionary *dict = self.selectArr[0];
                NSString *title = [NSString stringWithFormat:@"%@",dict[@"title"]];
                NSString *title2 = weakSelf.titleArray[indexPath.row];
                if (([title isEqualToString:@"支付宝"]&&[title2 isEqualToString:@"微信"]) || ([title isEqualToString:@"微信"]&&[title2 isEqualToString:@"支付宝"]) ) {
                    return [SVTool TextButtonAction:self.view withSing:@"微信和支付宝不能一起使用"];
                }else{
                    SVPaymentMethodCell *cell_0 = self.selectCellArray[0];
                    NSString *money = cell_0.money.text;
                    double money_1 = self.money.doubleValue - money.doubleValue;
                    if (money_1 <= 0) {
                        [[UIApplication sharedApplication].keyWindow addSubview:self.maskTheView];
                        self.portfolioPaymentView.TotleMoney = self.money;
                        self.portfolioPaymentView.clearBtn.tag = indexPath.row;
                        self.portfolioPaymentView.tuichu.tag = indexPath.row;
                        self.portfolioPaymentView.title = titleStr;
                        [[UIApplication sharedApplication].keyWindow addSubview:self.portfolioPaymentView];
                    }else{
                        
                        cell.backgroundColor =  RGBA(197, 205, 244, 1);
                        cell.contentView.layer.cornerRadius = 5;
                        cell.contentView.layer.masksToBounds = YES;
                        cell.contentView.layer.borderWidth = 1;
                        cell.contentView.layer.borderColor = navigationBackgroundColor.CGColor;
                        
                        cell.money.text = [NSString stringWithFormat:@"%.2f",money_1];
                        
                        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
                        dictM[@"money"] = [NSString stringWithFormat:@"%.2f",money_1];
                        dictM[@"title"] = weakSelf.titleArray[indexPath.row];
                        dictM[@"index"] = [NSString stringWithFormat:@"%ld",indexPath.row];
                        [weakSelf.selectArr addObject:dictM];
                        [weakSelf.selectCellArray addObject:cell];
                    }
                    
                }
                
            }
        }
        
    }

    
}

#pragma mark - 确定按钮的点击
- (IBAction)determineClick:(id)sender {
    
    for (NSDictionary *dict in self.selectArr) {
        NSString *title = dict[@"title"];
        NSString *money = dict[@"money"];
        if ([title isEqualToString:@"储值卡"] && self.stored.doubleValue < money.doubleValue) {
            return [SVTool TextButtonActionWithSing:@"会员余额不足"];
        }
        
        if (money.doubleValue <= 0) {
            return [SVTool TextButtonActionWithSing:@"不能输入0"];
        }
    }
    
    if (self.selectArr.count == 2) {
        if (self.selectMoneyArrayBlock) {
            self.selectMoneyArrayBlock(self.selectArr);
        }
    }else{
        [SVTool TextButtonAction:self.view withSing:@"请选择两种支付方式"];
    }
    NSLog(@"self.selectArr = %@",self.selectArr);
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 65;
}

- (NSMutableArray *)titleArray{
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
}

- (NSMutableArray *)imageArray{
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

- (NSMutableArray *)selectArr
{
    if (!_selectArr) {
        _selectArr = [NSMutableArray array];
    }
    return _selectArr;
}

- (NSMutableArray *)selectCellArray
{
    if (!_selectCellArray) {
        _selectCellArray = [NSMutableArray array];
    }
    return _selectCellArray;
}

- (SVPortfolioPaymentView *)portfolioPaymentView{
    if (!_portfolioPaymentView) {
        _portfolioPaymentView = [[NSBundle mainBundle]loadNibNamed:@"SVPortfolioPaymentView" owner:nil options:nil].lastObject;
        _portfolioPaymentView.frame = CGRectMake(30, 0, ScreenW -60,490);
       // .center = self.view.center;
        _portfolioPaymentView.center = CGPointMake(ScreenW / 2, ScreenH /2);
        _portfolioPaymentView.layer.cornerRadius = 10;
        _portfolioPaymentView.layer.masksToBounds = YES;
        [_portfolioPaymentView.tuichu addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_portfolioPaymentView.clearBtn addTarget:self action:@selector(clearBtnResponseEvent:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _portfolioPaymentView;
}



- (void)clearBtnResponseEvent:(UIButton *)btn{
    for (NSDictionary *dict in self.selectArr) {
        if ([dict[@"index"] integerValue] == btn.tag) {
            [self.selectArr removeObject:dict];
            break;
        }
    }
    
    for (SVPaymentMethodCell *cell in self.selectCellArray) {
        if (cell.tag == btn.tag) {
            [self.selectCellArray removeObject:cell];
            cell.backgroundColor = [UIColor whiteColor];
            cell.money.textColor = [UIColor grayColor];
            cell.money.text = @"输入金额";
            cell.contentView.layer.cornerRadius = 5;
            cell.contentView.layer.masksToBounds = YES;
            cell.contentView.layer.borderWidth = 1;
            cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
            [self dateCancelResponseEvent];
            break;
        }
    }
    
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
    [self.portfolioPaymentView removeFromSuperview];
    
}

@end
