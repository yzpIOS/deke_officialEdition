//
//  SVPayDetailsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/10/18.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVPayDetailsVC.h"
#import "SVAddRecordVC.h"
#import "SVPayManagementVC.h"
#import "SVPayManagementModel.h"
@interface SVPayDetailsVC ()
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *classNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *remarkLabel;

@end

@implementation SVPayDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"支出详情";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"支出详情";
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStylePlain target:self action:@selector(editClick)];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
  //  self.timeLabel.text = [self.model.e_expendituredate substringWithRange:NSMakeRange(0, 16)];
    if (self.model.e_expendituredate.length < 19) {
        self.timeLabel.text = self.model.e_expendituredate;
    }else{
        self.timeLabel.text =[self.model.e_expendituredate substringToIndex:19];//截取掉下标2之前的字符串
        if ([self.timeLabel.text containsString:@"T"]) {
            NSString *string = [self.timeLabel.text stringByReplacingOccurrencesOfString:@"T" withString:@" "];
            self.timeLabel.text = string;
        }
    }
    
    if (![self.model.e_expenditurename containsString:@"-"]) {
        self.classNameLabel.text = [NSString stringWithFormat:@"%@ - %@",self.model.e_expenditurename,self.model.e_expenditureclassname];
    }else{
         self.classNameLabel.text = self.model.e_expenditurename;
    }
    
    
    self.moneyLabel.text = self.model.e_expenditure_money;
    
    self.remarkLabel.text = self.model.e_expenditure_node;
    
    //底部按钮
    UIButton *button = [[UIButton alloc]init];
    button.layer.cornerRadius = 30;
    // [button setImage:[UIImage imageNamed:@"ic_addButton"] forState:UIWindowLevelNormal];
    [button setTitle:@"删除" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [button setBackgroundColor:navigationBackgroundColor];
    [button addTarget:self action:@selector(removeButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(60, 60));
        make.bottom.mas_equalTo(self.view).offset(-30);
        make.right.mas_equalTo(self.view).offset(-30);
    }];
    
}

- (void)editClick{
    SVAddRecordVC *addRecordVc = [[SVAddRecordVC alloc] init];
    addRecordVc.delegate = self.payManagementVC;
    addRecordVc.model  = self.model;
    addRecordVc.indexType = 1;
    [self.navigationController pushViewController:addRecordVc animated:YES];
}
// 删除
- (void)removeButton{
    
    [SVUserManager loadUserInfo];
    
    NSString *sURL = [URLhead stringByAppendingFormat:@"/api/Payment/DelPaymentInfo?key=%@&id=%i",[SVUserManager shareInstance].access_token,self.model.e_expenditureid.intValue];

     MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
     hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.yOffset = -50.0f;
    
    [[SVSaviTool sharedSaviTool] DELETE:sURL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict445 = %@",dic);
        if ([dic[@"success"] integerValue] == 1) {
            hud.mode = MBProgressHUDModeText;
            hud.label.text = [NSString stringWithFormat:@"%@",dic[@"msg"]];
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            // [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dic[@"msg"]]];
            if ([self.model.e_expendituredate containsString:@"T"]) {
                NSArray *array = [self.model.e_expendituredate componentsSeparatedByString:@"T"]; //从字符-中分隔成2个元素的数组
               // [self.dateButton setTitle: array[0] forState:UIControlStateNormal];
                //  self.MinutesndSeconds = array[1];
                if (self.payDetailBlock) {
                    self.payDetailBlock(array[0]);
                }
                
            }else{
//                [self.dateButton setTitle:self.model.e_expendituredate forState:UIControlStateNormal];
            } // 时间
           
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
              
                [self.navigationController popViewControllerAnimated:YES];
            });
            
           // [self.navigationController popViewControllerAnimated:YES];
        }else{
             [SVTool TextButtonAction:self.view withSing:[NSString stringWithFormat:@"%@",dic[@"msg"]]];
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //                //        [SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}


@end
