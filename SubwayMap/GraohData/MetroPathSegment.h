//
//  MetroPathSegment.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroPathSegment : NSObject
//xml文件解析line属性
@property (nonatomic, copy) NSString * lineCode;
@property (nonatomic, copy) UIColor  * lineColor;
@property (nonatomic, copy) NSString * lineName;
@property (nonatomic, copy) NSString * lineLoop;
@property (nonatomic, copy) NSString * lineShow;
@property (nonatomic, copy) NSString * lineWeight;
@property (copy,nonatomic)  NSString * lCode;
@property (copy,nonatomic)  NSString * lName;
@property (copy,nonatomic)  NSString * dir;
@property (copy,nonatomic)  NSString * flag;
@property (copy,nonatomic)  NSString * tripNo;
@property (copy,nonatomic)  NSString * tableNo;
@property (copy,nonatomic)  NSString * isCircle;
@property (copy,nonatomic)  NSString * stations;
@property (copy,nonatomic)  NSString * loadCoef;
@property (copy,nonatomic)  NSString * length;
@property (copy,nonatomic)  NSString * eType;
@property (copy,nonatomic)  NSString * eDesc;
@property (strong,nonatomic) NSMutableArray * sDataArr;
@property (strong,nonatomic) NSMutableArray * sNodeArr;

@end

NS_ASSUME_NONNULL_END
