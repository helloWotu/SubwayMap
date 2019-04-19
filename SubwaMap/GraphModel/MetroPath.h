//
//  MetroPath.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroPath : NSObject
@property (copy,nonatomic) NSString * startName;//起始站点名称
@property (copy,nonatomic) NSString * endName;//结束站点名称
@property (copy,nonatomic) NSString * loadCoef;
@property (copy,nonatomic) NSString * pathCode;
@property (copy,nonatomic) NSString * startTime;
@property (copy,nonatomic) NSString * minutes;
@property (copy,nonatomic) NSString * stations;
@property (copy,nonatomic) NSString * lengthFee;
@property (copy,nonatomic) NSString * fee;
@property (copy,nonatomic) NSString * length;
@property (copy,nonatomic) NSString * method;
@property (copy,nonatomic) NSString * lines;
@property (strong,nonatomic) NSMutableArray * segmentsArr;

@end

NS_ASSUME_NONNULL_END
