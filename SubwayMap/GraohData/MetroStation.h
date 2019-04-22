//
//  MetroStation.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetroLabel.h"


NS_ASSUME_NONNULL_BEGIN

@interface MetroStation : NSObject

@property (nonatomic, copy) NSString * appName;
@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * name;
@property (nonatomic, copy) NSString * pinyin;
@property (nonatomic, copy) NSString * color;
@property (nonatomic, copy) NSString * fillColor;
@property (nonatomic, assign) CGFloat  radius;
@property (nonatomic, assign) CGFloat  stationX;
@property (nonatomic, assign) CGFloat  stationY;
@property (nonatomic, strong) MetroLabel * stationLabel;
@property (nonatomic, assign) BOOL visible;
@property (nonatomic, assign) BOOL disabled;
@property (nonatomic, assign) BOOL istransfer;
@property (nonatomic, copy) NSString * transferLine;
@property (nonatomic, assign) BOOL isLimit;
@property (nonatomic, copy) NSString *limitCode;

- (id)initName:(NSString *)name appName:(NSString *)appName andCode:(NSString *)code
     andPinyin:(NSString *)pinyin andColor:(NSString *)color andFillColor:(NSString *)fillColor andRadius:(CGFloat )radius andStaionX:(CGFloat)staionX andStaionY:(CGFloat)staionY andVisible:(BOOL)visible andDisabled:(BOOL)disabled andLabel:(MetroLabel *)stationLabel istransfer:(BOOL)istransfer transferLine:(NSString *)transferLine;

//获取地铁站点的矩形区域
- (CGRect)getStationRect;

@end

NS_ASSUME_NONNULL_END
