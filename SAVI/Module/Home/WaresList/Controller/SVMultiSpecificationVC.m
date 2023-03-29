//
//  SVMultiSpecificationVC.m
//  SAVI
//
//  Created by houming Wang on 2018/11/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVMultiSpecificationVC.h"

@interface SVMultiSpecificationVC ()

@end

@implementation SVMultiSpecificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadData];
}

- (void)loadData{
    
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"product/GetMorespecSubProductList?id=%@&key=%@",self.product_id,[SVUserManager shareInstance].access_token];
    NSLog(@"urlStr = %@",urlStr);
    
    [[SVSaviTool sharedSaviTool] GET:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
          NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dic = %@",dic);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        //[SVTool requestFailed];
        [SVTool TextButtonAction:self.view withSing:@"网络开小差了"];
    }];
}

@end
