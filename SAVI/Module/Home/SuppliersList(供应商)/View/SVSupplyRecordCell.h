//
//  SVSupplyRecordCell.h
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVSupplyRecordCell : UITableViewCell

//NSMutableDictionary *dataDict = [NSMutableDictionary dictionary];
//[dataDict setObject:diction[@"sv_pc_cdate"] forKey:@"sv_pc_cdate"];
//[dataDict setObject:diction[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
//[dataDict setObject:diction[@"sv_pc_total"] forKey:@"sv_pc_total"];
//[dataDict setObject:diction[@"sv_pr_totalnum"] forKey:@"sv_pr_totalnum"];
//[dataDict setObject:diction[@"prlist"] forKey:@"prlist"];


@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UILabel *time;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;
@property (weak, nonatomic) IBOutlet UILabel *sv_pr_totalnum;


@end
