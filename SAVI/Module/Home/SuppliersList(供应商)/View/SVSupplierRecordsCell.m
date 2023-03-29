//
//  SVSupplierRecordsCell.m
//  SAVI
//
//  Created by houming Wang on 2021/5/7.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import "SVSupplierRecordsCell.h"
#import "SVReconciliationModel.h"

@interface SVSupplierRecordsCell()
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_noid;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_cdate;
@property (weak, nonatomic) IBOutlet UILabel *sv_pr_totalnum;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_note;

@property (weak, nonatomic) IBOutlet UILabel *sv_pc_total;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_costs;
@property (weak, nonatomic) IBOutlet UILabel *sv_pc_realpay;

@end
@implementation SVSupplierRecordsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.cornerRadius = 10;
    self.layer.masksToBounds = YES;
}

- (void)setModel:(SVReconciliationModel *)model
{
    _model = model;
    self.sv_pc_noid.text = model.sv_pc_noid;
    NSString *timeString = model.sv_pc_cdate;
    NSString *time1 = [timeString substringToIndex:10];
    NSString *time2 = [timeString substringWithRange:NSMakeRange(11, 8)];
    self.sv_pc_cdate.text = [NSString stringWithFormat:@"%@ %@",time1,time2];
    self.sv_pr_totalnum.text = [NSString stringWithFormat:@"%.2f",model.sv_pr_totalnum];
    self.sv_pc_note.text = model.sv_pc_note;
    self.sv_pc_total.text = [NSString stringWithFormat:@"%.2f",model.sv_pc_total];
    self.sv_pc_costs.text = [NSString stringWithFormat:@"%.2f",model.sv_pc_costs];
    self.sv_pc_realpay.text = [NSString stringWithFormat:@"%.2f",model.sv_pc_realpay];
 
}

- (void)setFrame:(CGRect)frame{
    
//    // frame.origin.x += 10;
//     frame.origin.y += 10;
//     frame.size.height -= 10;
//    // frame.size.width -= 20;
//     [super setFrame:frame];
    
    frame.origin.y += 5;
    frame.size.height -= 5;
    frame.origin.x += 10;
    frame.size.width -= 20;
    [super setFrame:frame];
}

@end
