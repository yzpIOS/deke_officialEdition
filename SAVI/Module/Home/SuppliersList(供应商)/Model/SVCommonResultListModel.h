//
//  SVCommonResultListModel.h
//  SAVI
//
//  Created by Sorgle on 2018/2/26.
//  Copyright © 2018年 Sorgle. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SVCommonResultListModel : NSObject

//飞哥的建议model
//@property (nonatomic,copy) NSString *errmsg;
@property (nonatomic,copy) NSString *errmsg;
@property (nonatomic,copy) NSString *errorCode;
@property (nonatomic,copy) NSString *succeed;
@property (nonatomic,copy) NSString *succeeMsg;
@property (nonatomic,copy) NSString *msgTime;

@property (nonatomic,copy) NSArray *values;

@property (nonatomic,copy) NSString *result;
@property (nonatomic,copy) NSString *software_versionid;

@end
