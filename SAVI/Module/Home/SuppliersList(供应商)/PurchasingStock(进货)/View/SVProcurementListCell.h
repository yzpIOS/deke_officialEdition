//
//  SVProcurementListCell.h
//  SAVI
//
//  Created by Sorgle on 2017/12/30.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVProcurementListCell : UITableViewCell

//[dataDict setObject:diction[@"sv_pc_cdate"] forKey:@"sv_pc_cdate"];
//[dataDict setObject:diction[@"sv_pc_noid"] forKey:@"sv_pc_noid"];
//[dataDict setObject:diction[@"sv_pc_total"] forKey:@"sv_pc_total"];
//[dataDict setObject:diction[@"sv_pc_statestr"] forKey:@"sv_pc_statestr"];
//[dataDict setObject:diction[@"sv_productname"] forKey:@"sv_productname"];
//[dataDict setObject:diction[@"prlist"] forKey:@"prlist"];
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_statestr;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;
@property (weak, nonatomic) IBOutlet UILabel *sv_suname;
@property (weak, nonatomic) IBOutlet UILabel *caogaoLabel;

@end
