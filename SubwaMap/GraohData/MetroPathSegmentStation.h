//
//  MetroPathSegmentStation.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MetroPathSegmentStation : NSObject

//xml文件解析node属性
@property (nonatomic, copy) NSArray  * stationColorArr;
@property (nonatomic, copy) NSString * stationName;
@property (nonatomic, copy) NSString * stationDisabled;
@property (nonatomic, copy) NSString * stationPinYin;
@property (nonatomic, copy) NSString * stationType;
@property (strong,nonatomic) NSDictionary * dicStatus;
@property (nonatomic, copy) NSString * stationLineCode;

@property float x;
@property float y;
//station中上下左右偏移属性
@property (nonatomic, copy) NSString * labelLeft;
@property (nonatomic, copy) NSString * labelRight;
@property (nonatomic, copy) NSString * labelTop;
@property (nonatomic, copy) NSString * labelBottom;


//路径查询返回数据sdata属性
@property (nonatomic, copy) NSString * sCode;
@property (nonatomic, copy) NSString * sName;
@property (nonatomic, copy) NSString * upOrder;
@property (nonatomic, copy) NSString * xfer;
@property (nonatomic, copy) NSString * lpfv;
@property (nonatomic, copy) NSString * spfv;
@property (nonatomic, copy) NSString * arrt;
@property (nonatomic, copy) NSString * dept;
@property (nonatomic, copy) NSString * intvl;
@property (nonatomic, copy) NSString * dis;
@property (nonatomic, copy) NSString * lpfvColour;
@property (nonatomic, copy) NSString * waitt;
@property (nonatomic, copy) NSString * walkt;
@property (nonatomic, copy) NSString * walkd;
@property (nonatomic, copy) NSString * isPass;
@property (nonatomic, copy) NSString * costt;


//获取该站点运行状态是否正常(0-正常,1-异常)
- (int)getDisabledStatus:(NSString *)stationName;
@end

NS_ASSUME_NONNULL_END
