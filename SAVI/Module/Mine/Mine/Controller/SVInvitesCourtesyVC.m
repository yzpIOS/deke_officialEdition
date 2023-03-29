//
//  SVInvitesCourtesyVC.m
//  SAVI
//
//  Created by houming Wang on 2018/4/28.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVInvitesCourtesyVC.h"
#import "SVClauseVC.h"//条款

#define URL [NSString stringWithFormat:@"http://www.decerp.cc/Share?u=%@&s=iOS",[SVUserManager shareInstance].user_id]
#define dekeSting  @"刚发现一个非常棒的开店做生意的软件，快来看看~~"
#define explainSting  @"收银、管理、营销、分析、让门店运营更简单"

@interface SVInvitesCourtesyVC ()
@property (weak, nonatomic) IBOutlet UIView *iconView;
@property (weak, nonatomic) IBOutlet UIButton *oneButton;
@property (weak, nonatomic) IBOutlet UIButton *twoButton;
@property (weak, nonatomic) IBOutlet UIButton *threeButton;
@property (weak, nonatomic) IBOutlet UIButton *fourButton;
@property (weak, nonatomic) IBOutlet UILabel *oneLabel;
@property (weak, nonatomic) IBOutlet UILabel *twoLabel;
@property (weak, nonatomic) IBOutlet UILabel *threeLabel;

@end

@implementation SVInvitesCourtesyVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"邀请有礼";
    self.hidesBottomBarWhenPushed = YES;
    //navigation右边按钮
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"条款" style:UIBarButtonItemStylePlain target:self action:@selector(rightbuttonResponseEvent)];
    [self.navigationItem.rightBarButtonItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:14],NSFontAttributeName, nil] forState:UIControlStateNormal];
    
    [self.oneButton addTarget:self action:@selector(oneButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.twoButton addTarget:self action:@selector(twoButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.threeButton addTarget:self action:@selector(threeButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.fourButton addTarget:self action:@selector(fourButtonResponseEvent) forControlEvents:UIControlEventTouchUpInside];
    
    [self.oneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    [self.twoLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:26]];
    
    [SVTool IndeterminateButtonAction:self.view withSing:@""];
    [self requestData];
}

-(void)rightbuttonResponseEvent {
//    self.hidesBottomBarWhenPushed = YES;
    SVClauseVC *VC = [[SVClauseVC alloc]init];
    [self.navigationController pushViewController:VC animated:YES];
//    self.hidesBottomBarWhenPushed = NO;
}

-(void)oneButtonResponseEvent {
    [SVUserManager loadUserInfo];
    [UMSocialData defaultData].extConfig.wechatSessionData.url = URL;
    
    [UMSocialData defaultData].extConfig.wechatSessionData.title = dekeSting;//标题
    //说明内容和设置图片/还有个回调
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatSession] content:explainSting image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)twoButtonResponseEvent {
    [SVUserManager loadUserInfo];
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = URL;
    
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = dekeSting;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToWechatTimeline] content:explainSting image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)threeButtonResponseEvent {
    [SVUserManager loadUserInfo];
    [UMSocialData defaultData].extConfig.qqData.url = URL;
    
    [UMSocialData defaultData].extConfig.qqData.title = dekeSting;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQQ] content:explainSting image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)fourButtonResponseEvent {
    [SVUserManager loadUserInfo];
    [UMSocialData defaultData].extConfig.qzoneData.url = URL;
    
    [UMSocialData defaultData].extConfig.qzoneData.title = dekeSting;
    [[UMSocialDataService defaultDataService]postSNSWithTypes:@[UMShareToQzone] content:explainSting image:[UIImage imageNamed:@"share_icon"] location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
}

-(void)requestData {
    [SVUserManager loadUserInfo];
    
    NSString *url = [URLhead stringByAppendingFormat:@"/System/GetUserShareOrderTotalInfo?key=%@",[SVUserManager shareInstance].access_token];
    
    [[SVSaviTool sharedSaviTool] GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if ([dict[@"succeed"] integerValue] == 1) {
            
            NSDictionary *dic = dict[@"values"];
            
            self.twoLabel.text = [NSString stringWithFormat:@"￥%ld",[dic[@"regincome"] integerValue] - [dic[@"repaid"] integerValue]];
            
            self.threeLabel.text = [NSString stringWithFormat:@"已邀请%ld位好友，共消费￥%.f,累计获得￥%ld",[dic[@"regcount"] integerValue],[dic[@"regincome"] integerValue]/0.15,[dic[@"regincome"] integerValue]];
            
        } else {
            [SVTool TextButtonAction:self.view withSing:@"数据出错"];
        }
        
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //隐藏提示框
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        [SVTool TextButtonAction:self.view withSing:@"网络出错,数据请求失败"];
    }];
    
}

@end
