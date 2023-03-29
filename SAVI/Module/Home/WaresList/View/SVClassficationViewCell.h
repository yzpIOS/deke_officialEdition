//
//  SVClassficationViewCell.h
//  SAVI
//
//  Created by houming Wang on 2021/1/22.
//  Copyright © 2021 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class SVClassficationModel;
@interface SVClassficationViewCell : UITableViewCell
//@property (nonatomic,strong) NSDictionary * oneDict;
//@property (nonatomic,strong) NSDictionary * twoDict;

@property (nonatomic,strong) SVClassficationModel * oneModel;
@property (nonatomic,strong) SVClassficationModel * twoModel;
@end

NS_ASSUME_NONNULL_END
