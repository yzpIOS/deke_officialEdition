//
//  SVNewVipTwoCell.m
//  SAVI
//
//  Created by Sorgle on 17/4/13.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import "SVNewVipTwoCell.h"

@implementation SVNewVipTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [SVUserManager loadUserInfo];
    NSDictionary *sv_versionpowersDict = [SVUserManager shareInstance].sv_versionpowersDict;
    NSDictionary *MemberDic = sv_versionpowersDict[@"Member"];

    //零售价
    if (kDictIsEmpty(MemberDic)) {
        self.phoneNumber.userInteractionEnabled = YES;
      
    }else{
        NSString *MobilePhoneShow = [NSString stringWithFormat:@"%@",MemberDic[@"MobilePhoneShow"]];
        if (kStringIsEmpty(MobilePhoneShow)) {
            self.phoneNumber.userInteractionEnabled = YES;
          
        }else{
            if ([MobilePhoneShow isEqualToString:@"1"]) {
          
                self.phoneNumber.userInteractionEnabled = YES;
              
        }else{
          //  self.RetailAndWholesalePrices.text = @"***";
//            self.licensePlateNumberCell.phoneNumber.userInteractionEnabled = NO;
            self.phoneNumber.userInteractionEnabled = NO;
        }
        }
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//+ (instancetype)tempTableViewCellWith:(UITableView *)tableView indexPath:(NSIndexPath *)indexPath {
//
//
//}

//+ (instancetype)tempTableViewCellWith:(UITableView *)tableView index:(NSInteger)index{
//    NSString *identifier = @"";//对应xib中设置的identifier
////    NSInteger index = 0; //xib中第几个Cell
//    switch (index) {
//        case 0:
//            identifier = @"SVNewVipTwoCellFirst";
//           // index = 0;
//            break;
//        case 1:
//            identifier = @"SVNewVipTwoCellSecond";
//           // index = 1;
//            break;
//        default:
//            break;
//    }
//    SVNewVipTwoCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[[NSBundle mainBundle] loadNibNamed:@"SVNewVipTwoCell" owner:self options:nil] objectAtIndex:index];
//    }
//    return cell;
//}

@end
