//
//  SVInformationVC.m
//  SAVI
//
//  Created by Sorgle on 17/5/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVInformationVC.h"
#import "SVInformationOneCell.h"
#import "SVInformationTwoCell.h"
#import "SVInformationThreeCell.h"
#import "SVAccountCancellationVC.h"
#import "SVModifyInformationVC.h"
#import "JJPhotoManeger.h"
static NSString *InformationOneCellID = @"InformationOneCell";
static NSString *InformationTwoCellID = @"InformationTwoCell";
static NSString *InformationThreeCellID = @"InformationThreeCell";
@interface SVInformationVC ()<JJPhotoDelegate>
@property (nonatomic,strong) NSMutableArray *imageArr_big;

//@property (nonatomic,strong) SVInformationOneCell *oneCell;

@end

@implementation SVInformationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置title
//    UILabel *title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 44)];
//    title.text = @"店铺信息";
//    title.textAlignment = NSTextAlignmentCenter;
//    title.textColor = [UIColor whiteColor];
//    self.navigationItem.titleView = title;
    self.navigationItem.title = @"店铺信息";
    //适配ios11偏移问题
    UIBarButtonItem *backltem = [[UIBarButtonItem alloc]initWithImage:nil style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.backBarButtonItem = backltem;
    
    //样式
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, ScreenW, ScreenH-64) style:UITableViewStyleGrouped];
    // 隐藏UITableViewStyleGrouped上边多余的间隔
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN - 20)];
    [self.tableView setSeparatorColor:cellSeparatorColor];
    //取消tableView的选中
    self.tableView.allowsSelection = NO;
    self.tableView.backgroundColor = BackgroundColor;
    /** 去除tableview 右侧滚动条 */
    self.tableView.showsVerticalScrollIndicator = NO;
    //适配ios11
    self.tableView.estimatedRowHeight = 0;
    self.tableView.estimatedSectionHeaderHeight = 0;
    self.tableView.estimatedSectionFooterHeight = 0;
    //去分割线
    //self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //self.tableView.tableFooterView = [[UIView alloc]init];
    //注册cell
    [self.tableView registerNib:[UINib nibWithNibName:@"SVInformationOneCell" bundle:nil] forCellReuseIdentifier:InformationOneCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVInformationTwoCell" bundle:nil] forCellReuseIdentifier:InformationTwoCellID];
    [self.tableView registerNib:[UINib nibWithNibName:@"SVInformationThreeCell" bundle:nil] forCellReuseIdentifier:InformationThreeCellID];
    
    //添加修改按钮
    UIBarButtonItem *releaseButon = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"ic_ModifyOne"] style:UIBarButtonItemStylePlain target:self action:@selector(onClickedOKbtn)];
    self.navigationItem.rightBarButtonItem = releaseButon;
    
    
}

//添加修改按钮响应方法
- (void)onClickedOKbtn{
    [self.tableView reloadData];
    self.hidesBottomBarWhenPushed = YES;
    SVModifyInformationVC *VC = [[SVModifyInformationVC alloc]init];
    
    __weak typeof(self) weakSelf = self;
    VC.ModifyInformationBlock = ^(){
        [weakSelf.tableView reloadData];
        if (weakSelf.informationBlock) {
            weakSelf.informationBlock();
        }
    };
    
    [self.navigationController pushViewController:VC animated:YES];
}

//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//    //刷新界面
//    [self.tableView reloadData];
//}

#pragma mark - Table view data source
//返回组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 3;
}
//返回几个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
//创建cell
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [SVUserManager loadUserInfo];
    
    if (indexPath.section == 0) {
        //创建cell
        SVInformationOneCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationOneCellID forIndexPath:indexPath];
        //如果没有就重新建一个
        if (!cell) {
            cell = [[SVInformationOneCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InformationOneCellID];
        }
        //头像赋值
//        cell.iconImg.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:self.valuesDic[@"sv_us_logo"]]]]];
        cell.iconImg.layer.cornerRadius = 27.5;
        //UIImageView切圆的时候就要用到这一句了
        cell.iconImg.layer.masksToBounds = YES;
        
       
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_logo]) {
            
            [cell.iconImg sd_setImageWithURL:[NSURL URLWithString:[URLHeadPortrait stringByAppendingString:[SVUserManager shareInstance].sv_us_logo]] placeholderImage:[UIImage imageNamed:@"iconView"]];
        }
        
        _imageArr_big = [NSMutableArray array];
        //        _picUrlArr = [NSMutableArray array];
        [_imageArr_big addObject:cell.iconImg];
        cell.iconImg.userInteractionEnabled = YES;
        //添加点击操作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
        [tap addTarget:self action:@selector(tap:)];
        [cell.iconImg addGestureRecognizer:tap];
        
     
        return cell;
    }else if (indexPath.section == 1){
        //创建cell
        SVInformationTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationTwoCellID forIndexPath:indexPath];
        
        if (!cell) {
            cell = [[SVInformationTwoCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InformationTwoCellID];
        }
        

        
        
        //店铺名称
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_name]) {
            cell.shopName.text = [SVUserManager shareInstance].sv_us_name;
        } else {
            cell.shopName.text = @"未设置";
        }
        //店铺简称
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_shortname]) {
            cell.shopReferred.text = [SVUserManager shareInstance].sv_us_shortname;
        } else {
            cell.shopReferred.text = @"未设置";
        }
        //截取字符串
        NSString  *a = [SVUserManager shareInstance].sv_ul_regdate;
        NSString *b = [a substringToIndex:10];
        //时间
        cell.date.text = b;
        //座机
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_phone]) {
            cell.shopNumber.text = [SVUserManager shareInstance].sv_us_phone;
        } else {
            cell.shopNumber.text = @"未设置";
        }
        return cell;
    }else if (indexPath.section == 2){
        SVInformationThreeCell *cell = [tableView dequeueReusableCellWithIdentifier:InformationThreeCellID forIndexPath:indexPath];
        if (!cell) {
            cell = [[SVInformationThreeCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:InformationThreeCellID];
        }
        
        UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagClick)];
        
        [cell.accountCancellationView addGestureRecognizer:tag];
        
        //店主名
        if ([SVTool isBlankString:[SVUserManager shareInstance].sv_ul_name]  || [[SVUserManager shareInstance].sv_ul_name isEqualToString:@"<null>"]) {
            cell.Name.text = @"未设置";
        } else {
            cell.Name.text = [SVUserManager shareInstance].sv_ul_name;
        }
        
        //手机
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_ul_mobile]) {
            cell.phoneNumber.text = [SVUserManager shareInstance].sv_ul_mobile;
        } else {
            cell.phoneNumber.text = @"未设置";
        }
            
        //邮件
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_ul_email]) {
            cell.Email.text = [SVUserManager shareInstance].sv_ul_email;
        } else {
            cell.Email.text = @"未设置";
        }
        
        //种类
        cell.IndustryTypes.text = [SVUserManager shareInstance].sv_uit_name;
        
        //地址
        if (![SVTool isBlankString:[SVUserManager shareInstance].sv_us_address]) {
            cell.address.text = [SVUserManager shareInstance].sv_us_address;
        } else {
            cell.address.text = @"未设置";
        }
        
        return cell;
    }
    return nil;
}

- (void)tagClick{
    SVAccountCancellationVC *VC = [[SVAccountCancellationVC alloc] init];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:VC animated:YES];
    VC.hidesBottomBarWhenPushed = YES;
}

//聊天图片放大浏览
-(void)tap:(UITapGestureRecognizer *)tap
{
    
    UIImageView *view = (UIImageView *)tap.view;
    JJPhotoManeger *mg = [JJPhotoManeger maneger];
    mg.delegate = self;
    // [mg showNetworkPhotoViewer:_imageArr urlStrArr:_picUrlArr selecView:view];
    [mg showLocalPhotoViewer:_imageArr_big selecView:view];
    //    [mg showLocalPhotoViewer:_imageArr selecView:view];
    
}

-(void)photoViwerWilldealloc:(NSInteger)selecedImageViewIndex
{
    
//    NSLog(@"最后一张观看的图片的index是:%zd",selecedImageViewIndex);
}

//设置cell的高
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return 85;
    }else if (indexPath.section ==  1){
        return 224;
    }else if (indexPath.section == 2){
        return 335;
    }
    return 0;
}

//设置cell的间隔
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 10;
//}

//设置组与的距离
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

#pragma mark - 懒加载 并作数据请求


//-(SVInformationOneCell *)oneCell{
//    if (!_oneCell) {
//        _oneCell = [[SVInformationOneCell alloc]init];
//    }
//    return _oneCell;
//}
@end
