//
//  SVClauseVC.m
//  SAVI
//
//  Created by houming Wang on 2018/5/2.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import "SVClauseVC.h"

//字体大小
#define TextFont    13
#define BigFont    14

@interface SVClauseVC ()<UIScrollViewDelegate>

@end

@implementation SVClauseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"相关条款";
//    self.hidesBottomBarWhenPushed = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self.oneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    
    //scrollView    1542
    UIScrollView *todyScrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-TopHeight)];
    todyScrollView.contentSize = CGSizeMake(0, 620);
    todyScrollView.backgroundColor = RGBA(241, 241, 241, 1);
    // 隐藏滑动条
    todyScrollView.showsVerticalScrollIndicator = NO;
    //关掉弹簧效果
//    todyScrollView.bounces = NO;
    //指定代理
    todyScrollView.delegate = self;
    [self.view addSubview:todyScrollView];
    
    
    UILabel *oneLabel = [[UILabel alloc]init];
    oneLabel.text = @"奖励提现及活动条款";
    oneLabel.textAlignment = NSTextAlignmentCenter;
    [oneLabel setFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
    [todyScrollView addSubview:oneLabel];
    [oneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        //make.size.mas_equalTo(CGSizeMake(ScreenW-20, 30));
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(todyScrollView).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label1 = [[UILabel alloc]init];
    label1.text = @"1、被邀请人首次购买德客软件实付现金部分才会产生佣金奖励，抵值券、优惠券及抵扣部分、促销活动功能或套餐则不产生佣金奖励。";
    label1.textColor = GlobalFontColor;
    label1.font = [UIFont systemFontOfSize:TextFont];
    label1.numberOfLines = 0;
    [todyScrollView addSubview:label1];
    [label1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(oneLabel.mas_bottom).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label2 = [[UILabel alloc]init];
    label2.text = @"2、佣金累计满100元即可申请提现。";
    label2.numberOfLines = 0;
    label2.textColor = GlobalFontColor;
    label2.font = [UIFont systemFontOfSize:TextFont];
    [todyScrollView addSubview:label2];
    [label2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(label1.mas_bottom).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label3 = [[UILabel alloc]init];
    label3.text = @"3、抵值券只可用于购买德客商城的软件及硬件，不可提现，单笔订单只可用1张抵值券，抵值券不可叠加使用。若发生退款，已经使用的抵值券不退还，只退还实际现金付款部分。";
    label3.numberOfLines = 0;
    label3.textColor = GlobalFontColor;
    label3.font = [UIFont systemFontOfSize:TextFont];
    [todyScrollView addSubview:label3];
    [label3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(label2.mas_bottom).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label4 = [[UILabel alloc]init];
    label4.text = @"4、活动内容和活动时间若有调整会在介绍页体现，实际情况以页面展示为准。";
    label4.numberOfLines = 0;
    label4.textColor = GlobalFontColor;
    label4.font = [UIFont systemFontOfSize:TextFont];
    [todyScrollView addSubview:label4];
    [label4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(label3.mas_bottom).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label5 = [[UILabel alloc]init];
    label5.text = @"5、活动中若有任何恶意行为产生的不当得利，德客有权追讨并对涉及账号进行处理。";
    label5.numberOfLines = 0;
    label5.textColor = GlobalFontColor;
    label5.font = [UIFont systemFontOfSize:TextFont];
    [todyScrollView addSubview:label5];
    [label5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(ScreenW-20);
        make.top.mas_equalTo(label4.mas_bottom).offset(20);
        make.left.mas_equalTo(todyScrollView).offset(10);
    }];
    
    UILabel *label6 = [[UILabel alloc]init];
    label6.text = @"扫一扫，联系专属客服，帮你办理提现。";
    label6.textColor = GlobalFontColor;
    label6.font = [UIFont systemFontOfSize:BigFont];
    [todyScrollView addSubview:label6];
    [label6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.top.mas_equalTo(label5.mas_bottom).offset(50);
        make.centerX.mas_equalTo(todyScrollView);
    }];
    
    UIImageView *icon = [[UIImageView alloc]init];
    icon.image = [UIImage imageNamed:@"BossCode"];
    [todyScrollView addSubview:icon];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(128, 128));
        make.top.mas_equalTo(label6.mas_bottom).offset(20);
        make.centerX.mas_equalTo(todyScrollView);
    }];
    
    UILabel *label7 = [[UILabel alloc]init];
    label7.text = @"办理时间：周一至周五，9：00~18.30，";
    label7.textColor = GlobalFontColor;
    label7.font = [UIFont systemFontOfSize:BigFont];
    [todyScrollView addSubview:label7];
    [label7 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.top.mas_equalTo(icon.mas_bottom).offset(20);
        make.centerX.mas_equalTo(todyScrollView);
    }];
    
    UILabel *label8 = [[UILabel alloc]init];
    label8.text = @"节假日除外。";
    label8.textColor = GlobalFontColor;
    label8.font = [UIFont systemFontOfSize:BigFont];
    [todyScrollView addSubview:label8];
    [label8 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(260);
        make.top.mas_equalTo(label7.mas_bottom);
        make.centerX.mas_equalTo(todyScrollView);
    }];
    
    
}


@end
