//
//  MetroDataContainer.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetroLine.h"
#import "MetroPrimaryLine.h"
#import "MetroUpLine.h"
#import "MetroDownLine.h"
#import "MetroSection.h"
#import "MetroPathNode.h"
#import "MetroIcon.h"
#import "MetroLabel.h"
#import "MetroStation.h"

NS_ASSUME_NONNULL_BEGIN

@interface MetroDataContainer : NSObject
+ (MetroDataContainer *)shareInstance;
+ (void)releaseInstance;

@property (nonatomic ,copy) NSDictionary *jsonDic;
@property (strong,nonatomic) MetroPrimaryLine * primaryLine;
@property (strong,nonatomic) MetroUpLine      * upLine;
@property (strong,nonatomic) MetroDownLine    * downLine;

#pragma mark - 配置文件中数据,绘制线路必须
@property (nonatomic, strong) NSMutableArray      * lines;                 //线路信息数组(MetroLine数组) 线网图line信息 1
@property (nonatomic, strong) NSMutableArray      * stations;              //站点信息(MetroStation数组) 圆点 1
@property (nonatomic, strong) NSMutableArray      * icons;



#pragma mark - 线路接口数据
//线路icon数组(MetroIcon数组)  1
@property (nonatomic, strong) NSMutableDictionary * lineCodeColorDic;      //lineCode-Color每条线的color  1
@property (nonatomic, strong) NSMutableDictionary * lineCodeStationsDic;   //lineCode-stations 线网图站点样式 1
@property (nonatomic, strong) NSMutableDictionary * stationIdPinyin;       //stationId-pinyin 线网图站点拼音 1

@property (nonatomic, strong) NSArray             * returnSations;         //接口所有站点信息
@property (nonatomic, strong) NSArray             * lineCodeArray;         //接口所有线路标号

@property (nonatomic, strong) NSMutableDictionary * returnLineSationsDic;  //存储接口返回每条线路的所有站点信息 1
@property (nonatomic, strong) NSDictionary        * lineSectionDistanceDic;//存储接口返回所有站点距离信息 1

- (void)downloadSubwayData;



@end

NS_ASSUME_NONNULL_END
