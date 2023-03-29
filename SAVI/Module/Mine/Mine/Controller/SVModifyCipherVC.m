//
//  SVModifyCipherVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/6.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVModifyCipherVC.h"

@interface SVModifyCipherVC ()
@property (weak, nonatomic) IBOutlet UIView *oneView;
@property (weak, nonatomic) IBOutlet UIView *twoView;
@property (weak, nonatomic) IBOutlet UIView *threeView;
@property (weak, nonatomic) IBOutlet UIButton *button;

@property (weak, nonatomic) IBOutlet UITextField *onwTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoTextField;
@property (weak, nonatomic) IBOutlet UITextField *threeTextField;

@end

@implementation SVModifyCipherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"修改密码";
    self.view.backgroundColor = RGBA(241, 241, 241, 1);
    
    self.oneView.layer.cornerRadius = 25;
    self.twoView.layer.cornerRadius = 25;
    self.threeView.layer.cornerRadius = 25;
    self.button.layer.cornerRadius = 25;
    
}

- (IBAction)buttonResponseEvent {
    
    [SVUserManager loadUserInfo];
    if ([[SVUserManager shareInstance].account isEqualToString:@"13861745552"]) {
        [SVTool TextButtonAction:self.view withSing:@"体验帐号不可修改"];
        return;
    }
    
    if ([SVTool isBlankString:self.onwTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入旧密码"];
        return;
    }
    
    if (![self.onwTextField.text isEqualToString:[SVUserManager shareInstance].passwd]) {
        [SVTool TextButtonAction:self.view withSing:@"输入的旧密码有误"];
        return;
    }
    
    if ([SVTool isBlankString:self.twoTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请输入新密码"];
        return;
    }
    
    if ([SVTool isBlankString:self.threeTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"请再次输入新密码"];
        return;
    }
    
    if ([self.onwTextField.text isEqualToString:self.twoTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"新旧密码相同!"];
        return;
    }
    
    if (![self.twoTextField.text isEqualToString:self.threeTextField.text]) {
        [SVTool TextButtonAction:self.view withSing:@"两次新密码不一致"];
        return;
    }
    
    if (self.threeTextField.text.length <= 5) {
        [SVTool TextButtonAction:self.view withSing:@"请输入6-16位密码"];
        return;
    }
    
    //开启提示
    [SVTool IndeterminateButtonAction:self.view withSing:@"修改中…"];
    
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/System/ChangePwd?oldPassword=%@&newPassword=%@&account=%@&key=%@",self.onwTextField.text,self.threeTextField.text,[SVUserManager shareInstance].account,[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        NSString *errmsg = [NSString stringWithFormat:@"%@",dict[@"errmsg"]];
        [SVTool TextButtonAction:self.view withSing:errmsg];
        
        //更新沙盒密码
        [SVUserManager shareInstance].passwd = self.threeTextField.text;
        [SVUserManager saveUserInfo];
        
        if ([dict[@"succeed"] integerValue] == 1) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                //返回上一控制器
                [self.navigationController popViewControllerAnimated:YES];
            });
        }
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
    
    
}



@end
