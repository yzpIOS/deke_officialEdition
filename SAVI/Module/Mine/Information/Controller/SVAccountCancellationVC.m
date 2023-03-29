//
//  SVAccountCancellationVC.m
//  SAVI
//
//  Created by 杨忠平 on 2022/6/26.
//  Copyright © 2022 Sorgle. All rights reserved.
//

#import "SVAccountCancellationVC.h"
#import "SVAgreementVC.h"
#import "SVAccountCancellationOperation.h"
#import "SVUnregistAgreement.h"
@interface SVAccountCancellationVC ()
@property (strong, nonatomic) UIButton *agreeButon;
@property (strong, nonatomic)UIImageView*img1;
@property (strong, nonatomic) UILabel *ruleLbl;
@property (strong, nonatomic) UIButton *logoutReminderBtn;
@property (strong, nonatomic) UIButton *accountCancellationBtn;

@end

@implementation SVAccountCancellationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    self.title = @"注销账号";
    self.view.backgroundColor = [UIColor whiteColor];
   
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.font = [UIFont systemFontOfSize:14];
//    NSMutableParagraphStyle *titleParagraphStyle = [[NSMutableParagraphStyle alloc] init];
//
//    titleParagraphStyle.lineSpacing = 16;// 字体的行间距
//
//       NSDictionary *titleAttributes = @{
//
//                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
//
//                                    NSParagraphStyleAttributeName:titleParagraphStyle,
//
//                                    NSKernAttributeName : @(1.4f)
//                                    };
    titleLabel.text = @"提示：注销代表您同意放弃所有资产和权益！";
    [self.view addSubview:titleLabel];
    [titleLabel sizeToFit];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(10);
        make.top.mas_equalTo(self.view.mas_top);
       // make.bottom.mas_offset(self.view.mas_bottom).offset(50);
    }];
    
    
    
    UILabel *detailLabel = [[UILabel alloc] init];
    detailLabel.textAlignment = NSTextAlignmentLeft;
    detailLabel.numberOfLines = 0;
   // 提示：注销代表您同意放弃所有资产和权益！
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
       
       paragraphStyle.lineSpacing = 16;// 字体的行间距
       
       NSDictionary *attributes = @{
                                    
                                    NSFontAttributeName:[UIFont systemFontOfSize:14],
                                    
                                    NSParagraphStyleAttributeName:paragraphStyle,
                                    
                                    NSKernAttributeName : @(1.4f)
                                    };
  //  NSString *noticeDescDetai = [self filterHTML:model.noticeDesc];
    
    detailLabel.attributedText = [[NSAttributedString alloc] initWithString:@"★身份、账号信息、会员信息等全部清空且无法恢复 \n★账号注销后代表你同意自动放弃所有权益 \n★交易记录、供应商记录、奖励记录将清空 \n★账号一旦被注销将不可恢复，请在操作前自行备份账号相关的所有信息 \n★注销德客账号并不代表账号注销前的行为和相关责任得到任何形式的豁免或减轻" attributes:attributes];
//    detailLabel.text = [NSString stringWithFormat:@"提示：注销代表您同意放弃所有资产和权益！ \n★身份、账号信息、会员信息等全部清空且无法恢复 \n★账号注销后代表你同意自动放弃所有权益 \n★交易记录、供应商记录、奖励记录将清空 \n★账号一旦被注销将不可恢复，请在操作前自行备份账号相关的所有信息 \n★注销德客账号并不代表账号注销前的行为和相关责任得到任何形式的豁免或减轻"];
    
    [self.view addSubview:detailLabel];
    [detailLabel sizeToFit];
    [detailLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left).offset(10);
        make.right.mas_equalTo(self.view.mas_right).offset(10);
        make.top.mas_equalTo(titleLabel.mas_bottom).offset(16);
       // make.bottom.mas_offset(self.view.mas_bottom).offset(50);
    }];
    
    UIButton *accountCancellationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.accountCancellationBtn = accountCancellationBtn;
    [accountCancellationBtn setTitle:@"注销账号" forState:UIControlStateNormal];
    [accountCancellationBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [accountCancellationBtn setBackgroundColor:BackgroundColor];
    accountCancellationBtn.userInteractionEnabled = NO;
    [self.view addSubview:accountCancellationBtn];
    [accountCancellationBtn addTarget:self action:@selector(accountCancellationClick) forControlEvents:UIControlEventTouchUpInside];
    [accountCancellationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view.mas_left);
        make.right.mas_equalTo(self.view.mas_right);
        make.bottom.mas_equalTo(self.view.mas_bottom);
        make.height.mas_equalTo(50+BottomHeight);
    }];
    
    
    _agreeButon = [[UIButton alloc]init];
    [self.view addSubview:_agreeButon];
    _agreeButon.selected = NO;
    [_agreeButon addTarget:self action:@selector(onAgreeClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _img1 = [[UIImageView alloc]init];
    [_agreeButon addSubview:_img1];
    _img1.image = [UIImage imageNamed:@"box_noSelect"];

    _ruleLbl = [[UILabel alloc]init];
    _ruleLbl.font = [UIFont systemFontOfSize: 14];
    _ruleLbl.text = @"勾选即表示已阅读并同意";
    _ruleLbl.textAlignment = NSTextAlignmentCenter;
  //  _ruleLbl.text = @"注册即代表同意用户协议和隐私政策";
    _ruleLbl.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.00];
    _ruleLbl.userInteractionEnabled = YES;
    [_ruleLbl sizeToFit];
//    UITapGestureRecognizer* tap_rule = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onBtnClick)];
//    [_ruleLbl addGestureRecognizer:tap_rule];
    [self.view addSubview:_ruleLbl];
    
    _logoutReminderBtn = [[UIButton alloc]init];
    [self.view addSubview:_logoutReminderBtn];
    [_logoutReminderBtn setTitle:@"《注销提醒》" forState:UIControlStateNormal];
    [_logoutReminderBtn sizeToFit];
    _logoutReminderBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    _logoutReminderBtn.titleLabel.font = [UIFont systemFontOfSize:14];
   // _logoutReminderBtn.titleLabel.textColor = navigationBackgroundColor;
    [_logoutReminderBtn setTitleColor:navigationBackgroundColor forState:UIControlStateNormal];
   // _agreeButon.selected = NO;
    [_logoutReminderBtn addTarget:self action:@selector(logoutReminderClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _img1.sd_layout
    .centerYEqualToView(_agreeButon)
    .leftSpaceToView(_agreeButon, 20)
    .widthIs(12)
    .heightIs(12);
    
    _ruleLbl.sd_layout
    .bottomSpaceToView(accountCancellationBtn, 10)
    .centerXIs(ScreenW * 0.5 - 22)
   // .widthIs(173)
    .heightIs(40);
    
    _agreeButon.sd_layout
    .centerYEqualToView(_ruleLbl)
    .rightSpaceToView(_ruleLbl, 0)
    .widthIs(40)
    .heightIs(40);
    
    _logoutReminderBtn.sd_layout
    .centerYEqualToView(_ruleLbl)
    .leftSpaceToView(_ruleLbl, 0);
//    .widthIs(40)
//    .heightIs(40);
    
    
    
}
#pragma mark - 注销账号
- (void)accountCancellationClick{
    if (!self.agreeButon.selected) {
        [SVTool TextButtonAction:self.view withSing:@"请先同意注销提醒"];
        return;
    }
    SVAccountCancellationOperation *vc = [[SVAccountCancellationOperation alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
    vc.hidesBottomBarWhenPushed = YES;

}

- (void)onAgreeClick:(UIButton *)btn{
    [self.agreeButon setSelected:!self.agreeButon.selected];
    if (self.agreeButon.selected)
    {
        _img1.image = [UIImage imageNamed:@"box_select"];
        self.accountCancellationBtn.userInteractionEnabled = YES;
        [self.accountCancellationBtn setBackgroundColor:navigationBackgroundColor];
        
    }
    else
    {
        _img1.image = [UIImage imageNamed:@"box_noSelect"];
        self.accountCancellationBtn.userInteractionEnabled = NO;
        [self.accountCancellationBtn setBackgroundColor:BackgroundColor];
    }
}

- (void)logoutReminderClick:(UIButton *)btn{
    self.hidesBottomBarWhenPushed =YES;
    SVUnregistAgreement *viewControler = [[SVUnregistAgreement alloc]init];
    viewControler.pathName = @"unregist";
    [self.navigationController pushViewController:viewControler animated:YES];
    self.hidesBottomBarWhenPushed = YES;
}


@end
