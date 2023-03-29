//
//  SVTransfersListVC.m
//  SAVI
//
//  Created by Sorgle on 2018/1/25.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVTransfersListVC.h"
//日期XIB
#import "SVDatePickerView.h"
//新增
#import "SVaddTransfersVC.h"
//详情
#import "SVTransfersDetailsVC.h"

@interface SVTransfersListVC () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

//四个按钮
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;

//时间三个按钮
@property (weak, nonatomic) IBOutlet UIView *dateView;
@property (weak, nonatomic) IBOutlet UIButton *oneDateButton;
@property (weak, nonatomic) IBOutlet UIButton *twoDateButton;
@property (weak, nonatomic) IBOutlet UIButton *queryButton;

//遮盖view
@property (nonatomic,strong) UIView *maskOneView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *oneDatePicker;

//遮盖view
@property (nonatomic,strong) UIView *maskTwoView;
//日期选择
@property (nonatomic, strong) SVDatePickerView *twoDatePicker;

@end

@implementation SVTransfersListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"库存调拨";
    
    //时间选择
    NSString *date = [NSString stringWithFormat:@"  %@",[SVTool timeAcquireCurrentDate]];
    
    [self.oneDateButton setTitle:date forState:UIControlStateNormal];
    self.oneDateButton.layer.cornerRadius = 1;
    self.oneDateButton.layer.borderColor = RGBA(223, 223, 223, 1).CGColor;
    self.oneDateButton.layer.borderWidth = 0.5f;
    self.oneDateButton.layer.masksToBounds = YES;
    
    [self.twoDateButton setTitle:date forState:UIControlStateNormal];
    self.twoDateButton.layer.cornerRadius = 1;
    self.twoDateButton.layer.borderColor = RGBA(223, 223, 223, 1).CGColor;
    self.twoDateButton.layer.borderWidth = 0.5f;
    self.twoDateButton.layer.masksToBounds = YES;
    
    self.queryButton.layer.cornerRadius = 1;
    self.queryButton.layer.masksToBounds = YES;
    
    self.dateView.hidden = YES;
    //默认选中第一个按钮
    [self.oneButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.oneButton setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
    
    //添加右上角按钮
    UIButton *saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [saveButton setImage:[UIImage imageNamed:@"add_icon"] forState:UIControlStateNormal];
    [saveButton addTarget:self action:@selector(addButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *pulishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [pulishButton setImage:[UIImage imageNamed:@"screening_icon"] forState:UIControlStateNormal];
    [pulishButton addTarget:self action:@selector(releaseInfoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    saveButton.frame=CGRectMake(0, 0, 20, 20);
    pulishButton.frame = CGRectMake(0, 0, 20, 20);
    
    UIBarButtonItem *save = [[UIBarButtonItem alloc] initWithCustomView:saveButton];
    UIBarButtonItem *pulish = [[UIBarButtonItem alloc] initWithCustomView:pulishButton];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects: pulish, save,nil]];
    
    //tableView
    self.tableView = [[UITableView alloc]init];
    //取消tableView的选中
    //tableView.allowsSelection = NO;
    //滚动条
    self.tableView.showsVerticalScrollIndicator = NO;
    //指定tableView代理
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Xib注册cell
//    [self.tableView registerNib:[UINib nibWithNibName:@"SVProcurementListCell" bundle:nil] forCellReuseIdentifier:ProcurementCellID];
    //普通cell的注册
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"oooocell"];
    
    
    //将tableView添加到veiw上面
    [self.view addSubview:self.tableView];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40));
        make.bottom.mas_equalTo(self.view);
    }];
    
}

#pragma mark - 四个按钮的响应方法
- (IBAction)oneButtonResponseEvent {
    
    self.dateView.hidden = YES;
    //高亮
    [self setSelectedButton:self.oneButton];
    
    [self setDefaultButton:self.twoButton];
    [self setDefaultButton:self.threeButton];
    
    
}

- (IBAction)twoButtonResponseEvent {
    
    self.dateView.hidden = YES;
    //高亮
    [self setSelectedButton:self.twoButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.threeButton];
    
}

- (IBAction)threeButtonResponseEvent {
    
    self.dateView.hidden = NO;
    //高亮
    [self setSelectedButton:self.threeButton];
    //默认
    [self setDefaultButton:self.oneButton];
    [self setDefaultButton:self.twoButton];
    
}

-(void)setSelectedButton:(UIButton *)btn {
    
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackgroundImage"] forState:UIControlStateNormal];
    
    if (self.dateView.hidden == YES) {
        
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40));
            make.bottom.mas_equalTo(self.view);
        }];
        
    } else {
        [self.tableView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(ScreenW, ScreenH-64-40-50));
            make.bottom.mas_equalTo(self.view);
        }];
    }
}

-(void)setDefaultButton:(UIButton *)btn {
    //默认
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"buttonBackground"] forState:UIControlStateNormal];
    
}

//选择第一个时间
- (IBAction)oneDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskOneView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.oneDatePicker];
    
}

//选择第二个时间
- (IBAction)twoDayButtonResponseEvent {
    
    [[UIApplication sharedApplication].keyWindow addSubview:self.maskTwoView];
    [[UIApplication sharedApplication].keyWindow addSubview:self.twoDatePicker];
    
}

-(void)addButtonResponseEvent {
    SVaddTransfersVC *VC = [[SVaddTransfersVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
}

//右上角反应方法
-(void)releaseInfoButtonResponseEvent {
    //set title
    //    YCXMenuItem *menuTitle = [YCXMenuItem menuTitle:@"Menu" WithIcon:nil];
    //    menuTitle.foreColor = [UIColor whiteColor];
    //    menuTitle.titleFont = [UIFont boldSystemFontOfSize:20.0f];
    //
    //    //set logout button
    //    YCXMenuItem *logoutItem = [YCXMenuItem menuItem:@"Logout" image:nil target:self action:@selector(logout:)];
    //    logoutItem.foreColor = [UIColor redColor];
    //    logoutItem.alignment = NSTextAlignmentCenter;
    
    NSArray *items = @[[YCXMenuItem menuItem:@"A仓" image:nil tag:1 userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"B仓" image:nil tag:2 userInfo:@{@"title":@"Menu"}],
                       [YCXMenuItem menuItem:@"C仓" image:nil tag:3 userInfo:@{@"title":@"Menu"}],
                       ];
    
    [YCXMenu showMenuInView:self.view fromRect:CGRectMake(ScreenW-27, 0, 0, 0) menuItems:items selected:^(NSInteger index, YCXMenuItem *item) {
        
        switch (index) {
            case 0:
            {
            //    NSLog(@"来了0");
            }
                break;
            case 1:
            {
              //  NSLog(@"来了1");
            }
                break;
                
            case 2:
            {
              //  NSLog(@"来了2");
            }
                break;
            default:
                break;
        }
    }];
    
}

#pragma mark - tableVeiw
//每组有几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 10;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
//    SVProcurementListCell *cell = [tableView dequeueReusableCellWithIdentifier:ProcurementCellID forIndexPath:indexPath];
//
//    if (!cell) {
//        cell = [[SVProcurementListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ProcurementCellID];
//    }
    
    //普通cell的创建
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oooocell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"oooocell"];
    }
    
    cell.textLabel.text = @"调拨单";
    
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
    
    SVTransfersDetailsVC *VC = [[SVTransfersDetailsVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
    
}


#pragma mark - 懒加载

-(SVDatePickerView *)oneDatePicker{
    if (!_oneDatePicker) {
        _oneDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _oneDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _oneDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _oneDatePicker.backgroundColor = [UIColor whiteColor];
        _oneDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_oneDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _oneDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _oneDatePicker.datePickerView.maximumDate = minDate;
        
        [_oneDatePicker.dateCancel addTarget:self action:@selector(dateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_oneDatePicker.dateDetermine addTarget:self action:@selector(dateDetermineResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _oneDatePicker;
}

/**
 日期遮盖View
 */
-(UIView *)maskOneView{
    if (!_maskOneView) {
        _maskOneView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskOneView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dateCancelResponseEvent)];
        [_maskOneView addGestureRecognizer:tap];
    }
    return _maskOneView;
}

//点击手势的点击事件
- (void)dateDetermineResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:self.oneDatePicker.datePickerView.date]];
    [self.oneDateButton setTitle:date forState:UIControlStateNormal];
    
    
}
//点击手势的点击事件
- (void)dateCancelResponseEvent{
    [self.maskOneView removeFromSuperview];
    [self.oneDatePicker removeFromSuperview];
}


/**
 第二个日期选择
 */
-(SVDatePickerView *)twoDatePicker{
    if (!_twoDatePicker) {
        _twoDatePicker = [[NSBundle mainBundle] loadNibNamed:@"SVDatePickerView" owner:nil options:nil].lastObject;
        _twoDatePicker.frame = CGRectMake(0, 0, 320, 230);
        _twoDatePicker.center = CGPointMake(ScreenW/2, ScreenH/2);
        _twoDatePicker.backgroundColor = [UIColor whiteColor];
        _twoDatePicker.layer.cornerRadius = 10;
        //设置显示模式
        [_twoDatePicker.datePickerView setDatePickerMode:UIDatePickerModeDate];
        //UIDatePicker时间范围限制
        NSDate *maxDate = [[NSDate alloc]initWithTimeIntervalSinceNow:24*60*60];
        _twoDatePicker.datePickerView.maximumDate = maxDate;
        NSDate *minDate = [NSDate date];
        _twoDatePicker.datePickerView.maximumDate = minDate;
        
        [_twoDatePicker.dateCancel addTarget:self action:@selector(twotwoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
        [_twoDatePicker.dateDetermine addTarget:self action:@selector(twoDateCancelResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    }
    return _twoDatePicker;
}

//日期遮盖View
-(UIView *)maskTwoView{
    if (!_maskTwoView) {
        _maskTwoView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
        _maskTwoView.backgroundColor = RGBA(0, 0, 0, 0.5);
        //添加一个点击手势
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(twotwoDateCancelResponseEvent)];
        [_maskTwoView addGestureRecognizer:tap];
    }
    return _maskTwoView;
}

//点击手势的点击事件
- (void)twoDateCancelResponseEvent {
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    //创建一个日期格式化器
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc]init];
    //设置时间样式
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSString *date = [NSString stringWithFormat:@"  %@",[dateFormatter stringFromDate:self.twoDatePicker.datePickerView.date]];
    [self.twoDateButton setTitle:date forState:UIControlStateNormal];
    
}

//点击手势的点击事件
- (void)twotwoDateCancelResponseEvent {
    
    [self.maskTwoView removeFromSuperview];
    [self.twoDatePicker removeFromSuperview];
    
}



@end
