//
//  SVTexting.m
//  SAVI
//
//  Created by Sorgle on 2017/6/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVTexting.h"

@interface SVTexting ()<UITextViewDelegate>
{
    UILabel *_placeHolderLabel;
    UILabel *_numLabel;
}

@property (weak, nonatomic) IBOutlet UILabel *number;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UITextView *content;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIView *oneView;

//全局按钮
@property (nonatomic,strong) UIButton *button;

@end

@implementation SVTexting

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"发短信";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"发短信";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //显示会员数
    self.number.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.phoneIDArr.count];
    
    //显示签名
    [SVUserManager loadUserInfo];
    self.name.text = [NSString stringWithFormat:@"%@",[SVUserManager shareInstance].sv_us_name];
    
    //底部按钮
    self.button = [[UIButton alloc]initWithFrame:CGRectMake(0, ScreenH - 50 - TopHeight, ScreenW, 50)];
    [self.button setTitle:@"发短信" forState:UIControlStateNormal];
    [self.button setBackgroundColor:navigationBackgroundColor];
    [self.button addTarget:self action:@selector(textingButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.button];
    
    //指定UITextView
    self.content.delegate = self;
    //创建Label
    _placeHolderLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, ScreenW - 10, 20)];
    _placeHolderLabel.textAlignment = NSTextAlignmentLeft;
    _placeHolderLabel.font = [UIFont systemFontOfSize:14];
    _placeHolderLabel.text = @"请把短信内容写在这里…";
    _placeHolderLabel.textColor = [UIColor grayColor];
    [self.content addSubview:_placeHolderLabel];
    
    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 140, ScreenW-10, 15)];
    _numLabel.textAlignment = NSTextAlignmentRight;
    _numLabel.font = [UIFont systemFontOfSize:14];
    _numLabel.hidden = YES;
    _numLabel.textColor = placeholderFontColor;
    [self.content addSubview:_numLabel];
    
    self.numberLabel.hidden = YES;
    
    //设置圆角
    self.oneView.layer.cornerRadius = 6;
    
}

//设置textView的placeholder
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{

    //[text isEqualToString:@""] 表示输入的是退格键
    if (![text isEqualToString:@""]) {
        _placeHolderLabel.hidden = YES;
        _numLabel.hidden = NO;
    }

    //range.location == 0 && range.length == 1 表示输入的是第一个字符
    if ([text isEqualToString:@""] && range.location == 0 && range.length == 1) {
        _placeHolderLabel.hidden = NO;
        _numLabel.hidden = YES;
    }
    NSInteger existedLength = textView.text.length;
    NSInteger selectedLength = range.length;
    NSInteger replaceLength = text.length;
    NSInteger pointLength = existedLength - selectedLength + replaceLength;
    
    _numLabel.text = [NSString stringWithFormat:@"%ld",pointLength];
    
    return YES;

}

#pragma mark - 群发送短信按钮
-(void)textingButtonResponseEvent{
    
    if ([SVTool isBlankString:self.content.text]) {
        [SVTool TextButtonAction:self.view withSing:@"短信内容不能为空"];
        return;
    }
    
//    if (self.content.text.length > 56) {
//        [SVTool TextButtonAction:self.view withSing:@"短信内容不得多于56字"];
//        return;
//    }
    
    //让按钮不可点
    [self.button setEnabled:NO];
    [self.button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //不能交互
    [[UIApplication sharedApplication].keyWindow setUserInteractionEnabled:NO];
    
    //提示用户
//    [SVProgressHUD showWithStatus:@"正在发送中……"];
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.label.text = @"正在发送中...";
    hud.label.textColor = [UIColor whiteColor];//字体颜色
    hud.bezelView.color = [UIColor blackColor];//背景颜色
    hud.cornerRadius = 10;//设置背景框的圆角值，默认是10
    hud.activityIndicatorColor = [UIColor whiteColor];//设置菊花（活动指示器）颜色
    //指定距离中心点的X轴和Y轴的位置，不指定则在屏幕中间显示
    hud.yOffset = -50.0f;
    
    [SVUserManager loadUserInfo];
    NSString *token = [SVUserManager shareInstance].access_token;
    
    
    NSString *strURL = [URLhead stringByAppendingString:@"/api/user/SendSms"];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [parameters setObject:token forKey:@"key"];
    
    [parameters setObject:self.content.text forKey:@"msg"];
    
    [parameters setObject:self.phoneIDArr forKey:@"list"];
    
    [parameters setObject:@"0" forKey:@"type"];
    
    [parameters setObject:self.name.text forKey:@"shopName"];
    
    [[SVSaviTool sharedSaviTool]POST:strURL parameters:parameters progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        if ([dict[@"succeed"] integerValue] == 1) {
//            [SVProgressHUD showSuccessWithStatus:@"短信发送成功!"];
//            [SVProgressHUD setBackgroundColor:BackgroundColor]; //背景颜色
//            [SVProgressHUD setForegroundColor:GlobalFontColor]; //字体颜色
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//                [self.navigationController popViewControllerAnimated:YES];
//                
//            });
//            MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
            hud.mode = MBProgressHUDModeText;
            hud.label.text = @"短信发送成功";
            hud.label.textColor = [UIColor whiteColor];//字体颜色
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                [self.navigationController popViewControllerAnimated:YES];
            });
            
        } else {
//            [SVProgressHUD showErrorWithStatus:dict[@"values"]];
//            //用延迟来移除提示框
//            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//                [SVProgressHUD dismiss];
//            });
            
            hud.mode = MBProgressHUDModeText;
//            hud.label.text = @"短信发送失败";
            hud.label.text = [NSString stringWithFormat:@"%@",dict[@"values"]];
            //用延迟来移除提示框
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //隐藏提示
                [MBProgressHUD hideHUDForView:self.view animated:YES];
                //让按钮不可点
                [self.button setEnabled:YES];
                [self.button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            });
            
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

@end
