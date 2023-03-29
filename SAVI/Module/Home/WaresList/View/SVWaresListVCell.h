//
//  SVWaresListVCell.h
//  SAVI
//
//  Created by Sorgle on 17/4/15.
//  Copyright © 2017年 Sorgle. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SVduoguigeModel.h"

@interface SVWaresListVCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *cellButton;

//给cell标记
@property (nonatomic, strong) NSIndexPath *indexPatch;
//用模型赋值
//@property (nonatomic, strong) SVSelectedGoodsModel *goodsModel;

/**
 模型
 */
@property (nonatomic, strong) SVduoguigeModel *model;

//@property (nonatomic, strong) NSIndexPath *index;

@property (nonatomic, copy) void(^waresListVCelllock)(SVduoguigeModel *model,NSIndexPath * index);



@end
