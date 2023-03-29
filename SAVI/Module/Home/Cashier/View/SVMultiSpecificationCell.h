//
//  SVMultiSpecificationCell.h
//  SAVI
//
//  Created by houming Wang on 2018/12/3.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVSelectedGoodsModel.h"
@interface SVMultiSpecificationCell : UITableViewCell
//用模型赋值
@property (nonatomic, strong) SVSelectedGoodsModel *goodsModel;
//给cell标记
@property (nonatomic, strong) NSIndexPath *indexPatch;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;
//@property (nonatomic,strong) NSString *labelStr;

//动图block
@property (nonatomic,copy)  void(^SingleShopCartBlock)(UIImageView *imageView);
@property (weak, nonatomic) IBOutlet UIButton *addButton;

//计算件数的block
@property (nonatomic, copy) void(^countChangeBlock)(SVSelectedGoodsModel * model,NSIndexPath *indexPatch);
@end
