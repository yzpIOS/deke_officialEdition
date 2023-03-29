//
//  SVSystemSettingsVC.m
//  SAVI
//
//  Created by Sorgle on 2017/12/5.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVSystemSettingsVC.h"
//关于我们
#import "SVAboutWeVC.h"
//修改密码
#import "SVModifyCipherVC.h"
//德客
#import "SVAgreementVC.h"
//cell
#import "SVSystemOneCell.h"

#import "SVVersionVC.h"

#import "SVForgetRefundPasswordVC.h"


static NSString *SystemCellID = @"SystemCell";

@interface SVSystemSettingsVC ()<UITableViewDelegate,UITableViewDataSource>


@end

@implementation SVSystemSettingsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //标题
    self.navigationItem.title = @"系统设置";
    
    self.hidesBottomBarWhenPushed = YES;
    
    UITableView *tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH - 64) style:UITableViewStylePlain];
    //RGBA(241, 241, 241, 1)
    tableView.backgroundColor = RGBA(241, 241, 241, 1);
    //设置cell的样式---完全没有线
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //去掉多余的分割线,显示cell还有线
    //tableView.tableFooterView = [[UIView alloc]init];
    //适配ios11
    tableView.estimatedRowHeight = 0;
    tableView.estimatedSectionHeaderHeight = 0;
    tableView.estimatedSectionFooterHeight = 0;
    //添加到View上
    [self.view addSubview:tableView];
    //指定代理
    tableView.dataSource = self;
    tableView.delegate = self;
    
    [tableView registerNib:[UINib nibWithNibName:@"YCMineCell" bundle:nil] forCellReuseIdentifier:SystemCellID];
    
//<<<<<<< HEAD
    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(20, 390, ScreenW - 40, 30)];
    Label.text = @"使用德客网页版、电脑客户版、手机客户端、强大的多端同步，店铺管理随身在手！请访问：www.decerp.cn";
    
//    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(20, 300, ScreenW - 40, 30)];
//    Label.text = @"使用收银会员管理网页版、电脑客户版、手机客户端、强大的多端同步，店铺管理随身在手！";
//=======
//    UILabel *Label = [[UILabel alloc]initWithFrame:CGRectMake(20, 355, ScreenW - 40, 30)];
//    Label.text = @"使用收银会员管理网页版、电脑客户版、手机客户端、强大的多端同步，店铺管理随身在手！";
//>>>>>>> f4db0be... oem收款流水报表，登录页面等一些增加或者修改
    
    Label.numberOfLines = 0;
    Label.font = [UIFont systemFontOfSize:10];
    Label.textAlignment = NSTextAlignmentCenter;
    Label.textColor = [UIColor grayColor];
    [tableView addSubview:Label];
    
    UIButton *button = [[UIButton alloc]init];
    button.titleLabel.font = [UIFont systemFontOfSize:12];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    [button setTitleColor:RGBA(22, 121, 255, 1) forState:UIControlStateNormal];
    [button setTitle:@"《德客会员管理收银软件协议》" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(jumpSmallClass) forControlEvents:UIControlEventTouchUpInside];
    [tableView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(tableView.mas_centerX);
        make.bottom.mas_equalTo(tableView.mas_bottom).offset(ScreenH - 94);
    }];
    
    
}

-(void)jumpSmallClass {
    SVAgreementVC *viewControler = [[SVAgreementVC alloc]init];
    [self.navigationController pushViewController:viewControler animated:YES];
}

#pragma mark - Table view data source
//返回组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 6;
}

//返回几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//cell的高度
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 120;
    }
    return 50;
}

//组与组间距
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0 || section == 1) {
        return 0;
    }
    if (section == 3 ) {
        return 10;
    }
    return 0.5;
}

//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        SVSystemOneCell *cell = [[NSBundle mainBundle]loadNibNamed:@"SVSystemOneCell" owner:nil options:nil].lastObject;
        cell.backgroundColor = RGBA(241, 241, 241, 1);
        //点击cell没点击阴影效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置cell不能点击
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    [SVUserManager loadUserInfo];
    if (indexPath.section == 1) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"mine_oldVersion"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"当前版本";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"v%@",[SVUserManager shareInstance].sv_oldVersion];
        //点击cell没点击阴影效果
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        //设置cell不能点击
        cell.userInteractionEnabled = NO;
        return cell;
    }
    
    if (indexPath.section == 2) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"mine_newVersion"];
        //点击cell没点击阴影效果
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"新版更新";
        
        if ([[SVUserManager shareInstance].sv_oldVersion isEqualToString:[SVUserManager shareInstance].sv_newVersion]) {
            cell.detailTextLabel.text = @"无新版本";
            cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
            //设置cell不能点击
            cell.userInteractionEnabled = NO;
        } else {
            UILabel *Vlabel = [[UILabel alloc]init];
            Vlabel.backgroundColor = RGBA(200, 30, 30, 1);
            Vlabel.text = [NSString stringWithFormat:@"  v%@  ",[SVUserManager shareInstance].sv_newVersion];
            Vlabel.textColor = [UIColor whiteColor];
            Vlabel.layer.cornerRadius = 10;
            Vlabel.layer.masksToBounds = YES;
            [cell addSubview:Vlabel];
            [Vlabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.mas_equalTo(cell.mas_centerY);
                make.right.mas_equalTo(cell).offset(-30);
            }];
            //加箭头
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        }
        
        return cell;
    }
    
    if (indexPath.section == 3) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"mine_cipher"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"修改密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //点击cell没点击阴影效果
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 4) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"liushui_mine"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"设置退款密码";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //点击cell没点击阴影效果
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    if (indexPath.section == 5) {
        UITableViewCell *cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"twoCell"];
        cell.imageView.image = [UIImage imageNamed:@"mine_version"];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textColor = GlobalFontColor;
        cell.textLabel.text = @"关于我们";
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        //点击cell没点击阴影效果 ModifyCipher
        //cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
    return nil;
}

#pragma mark - 点击事件
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //一句实现点击效果
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    //跳转到更新状态
    if (indexPath.section == 2 && indexPath.row == 0) {
        NSString *urlStr = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/de-ke/id%@?mt=8",APPID];
        //跳转到AppStore，该App下载界面
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }
    
    //跳转到修改密码
    if (indexPath.section == 3 && indexPath.row == 0) {
        SVModifyCipherVC *VC = [[SVModifyCipherVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    //设置退款密码
    if (indexPath.section == 4 && indexPath.row == 0) {

        SVForgetRefundPasswordVC *vc = [[SVForgetRefundPasswordVC alloc] init];
        vc.selectNum = 1;
        [self.navigationController pushViewController:vc animated:YES];
    }
    //跳转到关于我们
    if (indexPath.section == 5 && indexPath.row == 0) {
        SVAboutWeVC *VC = [[SVAboutWeVC alloc]init];
        [self.navigationController pushViewController:VC animated:YES];
    }
    
    
}



@end
