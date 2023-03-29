//
//  SVInformationVC.h
//  SAVI
//
//  Created by Sorgle on 17/5/2.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SVInformationVC : UITableViewController

@property (nonatomic,copy) void (^informationBlock)();

@end
