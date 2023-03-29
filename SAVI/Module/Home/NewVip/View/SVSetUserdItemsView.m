//
//  SVSetUserdItemsView.m
//  SAVI
//
//  Created by 杨忠平 on 2019/11/13.
//  Copyright © 2019 Sorgle. All rights reserved.
//

#import "SVSetUserdItemsView.h"
#import "SVSetUserdItemCell.h"

static NSString *SVSetUserdItemCellID = @"SVSetUserdItemCell";
@interface SVSetUserdItemsView()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *selectArray;
@end

@implementation SVSetUserdItemsView
- (NSMutableArray *)selectArray
{
    if (_selectArray == nil) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

- (instancetype)init
{
    if (self = [super init]) {

            self = [[NSBundle mainBundle]loadNibNamed:@"SVSetUserdItemsView" owner:nil options:nil].lastObject;
            // _addCustomView.textView.delegate = self;
            self.frame = CGRectMake(10, TopHeight, ScreenW - 20, ScreenH -TopHeight *2);
            self.layer.cornerRadius = 10;
            self.layer.masksToBounds = YES;
            // _setUserdItemView.center = CGPointMake(ScreenW / 2, ScreenH);
//            [self.cancleBtn addTarget:self action:@selector(cancleBtnClick) forControlEvents:UIControlEventTouchUpInside];
            [self.sureBtn addTarget:self action:@selector(setUserdItemSureBtnClick) forControlEvents:UIControlEventTouchUpInside];

            [self.tableView registerNib:[UINib nibWithNibName:@"SVSetUserdItemCell" bundle:nil] forCellReuseIdentifier:SVSetUserdItemCellID];
       
              self.tableView.separatorStyle = NO;

        
    }
    
    return self;
}
//- (void)awakeFromNib
//{
//    [super awakeFromNib];
//    [self.tableView registerNib:[UINib nibWithNibName:@"SVSetUserdItemCell" bundle:nil] forCellReuseIdentifier:SVSetUserdItemCellID];
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SVSetUserdItemCell *cell = [tableView dequeueReusableCellWithIdentifier:SVSetUserdItemCellID];
    if (!cell) {
        cell = [[SVSetUserdItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:SVSetUserdItemCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.dict = self.dataArray[indexPath.row];
    cell.indexPath = indexPath;
    
    __weak typeof(self) weakSelf = self;
    cell.countBlock = ^(NSIndexPath * _Nonnull indexPath) {
        [SVUserManager loadUserInfo];
        NSDictionary *dic = self.dataArray[indexPath.row];
        NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/UpdateMembeerCustomFieldItems?key=%@&field_id=%@",[SVUserManager shareInstance].access_token,dic[@"sv_field_id"]];
       // [self.dataArray removeObjectAtIndex:indexPath.row];
       // [self.tableView reloadData];
        [[SVSaviTool sharedSaviTool] POST:urlStr parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            //解析数据
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
            NSLog(@"dict = %@",dict);
            if ([[NSString stringWithFormat:@"%@",dict[@"succeed"]] isEqualToString:@"1"]) {
                
                [self.dataArray removeObjectAtIndex:indexPath.row];
                [self.tableView reloadData];
                
                if (weakSelf.removeDataArrayBlock) {
                    weakSelf.removeDataArrayBlock();
                }
                
            }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
             [SVTool TextButtonAction:self withSing:@"网络开小差了"];
        }];
     
       
    };
    
    cell.selectCountBlock = ^(NSString * _Nonnull selectStr, NSIndexPath * _Nonnull indexPath) {
        if (kArrayIsEmpty(self.selectArray)) {
            [self.selectArray addObject:selectStr];
        }else{
            for (NSString *str in self.selectArray) {
                if ([str isEqualToString:selectStr]) {
                    [self.selectArray removeObject:str];
                    break;
                }
            }
             [self.selectArray addObject:selectStr];
           // [self.selectArray addObject:selectStr];
        }
        
    };
    
    cell.removeCountBlock = ^(NSString * _Nonnull selectStr, NSIndexPath * _Nonnull indexPath) {
        for (NSString *str in self.selectArray) {
            if ([str isEqualToString:selectStr]) {
                 [self.selectArray removeObject:str];
                break;
            }
        }
        
    };
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - 确定按钮的点击
- (void)setUserdItemSureBtnClick{
    //sv_enabled 是否启用，sv_field_id :自定义主键id （新增时默认0） ，sv_field_name 自定义名称， sv_is_active是否删除，sv_is_remind_tim是否为时间自定义 ，sv_relation_id关联id （新增时默认0）  sv_sort  排序id
    [SVUserManager loadUserInfo];
    NSString *urlStr = [URLhead stringByAppendingFormat:@"/api/User/AddMemberCustomField?key=%@",[SVUserManager shareInstance].access_token];
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];// 创建一个时间格式化对象
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];//设定时间格式,这里可以设置成自己需要的格式
    NSString *dateString = [dateFormatter stringFromDate:currentDate];//将时间转化成字符串
    NSMutableArray *parame = [NSMutableArray array];
    for (NSString *nameStr in self.selectArray) {
        NSMutableDictionary *dictM = [NSMutableDictionary dictionary];
       // [md setObject:dateString forKey:@"order_datetime"];
        dictM[@"sv_creation_date"] = dateString;
        dictM[@"sv_enabled"] = @"false";
        dictM[@"sv_field_id"] = @"0";
        dictM[@"sv_field_name"] = nameStr;
        dictM[@"sv_is_active"] = @"false";
        dictM[@"sv_is_remind_tim"] = @"false";
        dictM[@"sv_relation_id"] = @"0";
        dictM[@"sv_sort"] = @"0";
        [parame addObject:dictM];
    }
    [[SVSaviTool sharedSaviTool] POST:urlStr parameters:parame progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //解析数据
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves error:nil];
        NSLog(@"dict = %@",dict);
        if ([[NSString stringWithFormat:@"%@",dict[@"succeed"]] isEqualToString:@"1"]) {
            
            if (self.sureBlock) {
                self.sureBlock();
            }
            
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [SVTool TextButtonAction:self withSing:@"网络开小差了"];
    }];
    
}




@end
