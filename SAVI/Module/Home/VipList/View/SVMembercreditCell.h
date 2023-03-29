//
//  SVMembercreditCell.h
//  SAVI
//
//  Created by houming Wang on 2020/11/25.
//  Copyright © 2020 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SVMemberCreditModel;
NS_ASSUME_NONNULL_BEGIN

@interface SVMembercreditCell : UITableViewCell
//@property (nonatomic,strong) NSDictionary * dict;
@property (nonatomic,strong) SVMemberCreditModel * model;
@property (nonatomic,strong) NSMutableArray * valuesArray;
@property (weak, nonatomic) IBOutlet UITextField *order_money2;
@property (nonatomic,assign) NSInteger indexRow;
@property (nonatomic,copy) void (^order_moneyAndBlock)(NSInteger indexRow,NSString *order_money);

@property (nonatomic,strong) SVMemberCreditModel * model2;
@end

NS_ASSUME_NONNULL_END
