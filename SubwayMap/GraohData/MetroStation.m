//
//  MetroStation.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroStation.h"

@implementation MetroStation
- (id)initName:(NSString *)name appName:(NSString *)appName andCode:(NSString *)code
     andPinyin:(NSString *)pinyin andColor:(NSString *)color andFillColor:(NSString *)fillColor andRadius:(CGFloat )radius andStaionX:(CGFloat)staionX andStaionY:(CGFloat)staionY andVisible:(BOOL)visible andDisabled:(BOOL)disabled andLabel:(MetroLabel *)stationLabel  istransfer:(BOOL)istransfer transferLine:(NSString *)transferLine {
    if (self = [super init]) {
        self.name = name;
        self.appName = appName;
        self.code = code;
        self.pinyin = pinyin;
        self.color = color;
        self.fillColor = fillColor;
        self.radius = radius;
        self.stationX = staionX;
        self.stationY = staionY;
        self.visible = visible;
        self.disabled = disabled;
        self.stationLabel = stationLabel;
        self.istransfer = istransfer;
        self.transferLine = transferLine;
    }
    return self;
}

- (CGRect)getStationRect {//23
    
    return CGRectMake(_stationX - self.radius * 2, _stationY - self.radius * 2, self.radius * 4, self.radius * 4);
}


@end
