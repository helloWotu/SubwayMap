//
//  MetroDataContainer.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroDataContainer.h"
#import "MetroPath.h"
#import "MetroPathSegment.h"
#import "MetroPathSegmentStation.h"
//#import "HUDView.h"
//#import "SVProgressHUD.h"

@interface MetroDataContainer ()

@end

@implementation MetroDataContainer

static MetroDataContainer *instance = nil;

+ (MetroDataContainer *)shareInstance {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL]init];
    });
    
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self shareInstance];
}

+ (void)releaseInstance {
    if (instance) {
        instance = nil;
    }
}

#pragma mark - 初始化数据信息
- (void)downloadSubwayData {
   
    NSString * firstObj = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstLoadJson"];
    if(firstObj == nil){
        
        NSString *path = [[NSBundle mainBundle] pathForResource:@"subway" ofType:@"json"];
        NSData *jsonData = [NSData dataWithContentsOfFile:path];
        NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
        NSString * path1 = [NSString stringWithFormat:@"%@/subway.json",cachePath];
        [jsonData writeToFile:path1 atomically:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"firstLoadJson"];
            
    }
        [self readSubwayJson];
}

- (void)readSubwayJson {
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@/subway.json",cachePath];
    NSData *jsonData = [NSData dataWithContentsOfFile:path];
    if(jsonData){
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        self.jsonDic = jsonDic;
        [self InitData:jsonDic];
    }
}

- (void)InitData:(NSDictionary *)jsonDic{

    self.lines = [NSMutableArray array];
    //遍历line 路网图的线路数组
    NSArray * lineArr = [jsonDic objectForKey:@"lines"];
    for (int i = 0; i < lineArr.count; i++) {
        NSString     * lineName    = [lineArr[i] objectForKey:@"name"];
        NSString     * lineCode    = [lineArr[i] objectForKey:@"code"];
    
        NSDictionary * primaryDic   = [lineArr[i] objectForKey:@"primary"];
        NSString     * primaryColor = [primaryDic objectForKey:@"color"];
        NSString     * primaryAlpha = [primaryDic objectForKey:@"alpha"];
        long primaryWeight = [[primaryDic objectForKey:@"weight"] longLongValue] * scale_zoom;
        [self.lineCodeColorDic setObject:primaryColor forKey:lineCode];
        
        self.primaryLine = [[MetroPrimaryLine alloc] initColor:primaryColor andAlpha:primaryAlpha andWeight:primaryWeight];
        
        NSArray * primarySections = [primaryDic objectForKey:@"sections"];
        for (int i = 0; i < primarySections.count; i++) {
            NSString * beginCode  = [primarySections[i] objectForKey:@"beginCode"];
            NSString * endCode    = [primarySections[i] objectForKey:@"endCode"];
            NSString * name       = [primarySections[i] objectForKey:@"name"];
            NSString * sectionColor       = [primarySections[i] objectForKey:@"color"];
            NSArray  * pathNodes  = [primarySections[i] objectForKey:@"pathNodes"];
            
            MetroSection * section = [[MetroSection alloc] initName:name andBeginCode:beginCode andEndCode:endCode sectionColor:sectionColor];
            for (int i = 0; i < pathNodes.count; i++) {
                NSString * nodeType  = [pathNodes[i] objectForKey:@"type"];
                CGFloat nodeX = [[pathNodes[i] objectForKey:@"x"] floatValue] * scale_zoom;
                CGFloat nodeY = [[pathNodes[i] objectForKey:@"y"] floatValue] * scale_zoom;
                MetroPathNode * pathNode = [[MetroPathNode alloc] initType:nodeType andX:nodeX andY:nodeY];
                [section.pathNodes addObject:pathNode];
            }
            [self.primaryLine.sections addObject:section];
        }
        
        
        NSDictionary * upDic = [lineArr[i] objectForKey:@"up"];
        NSString * upColor = [upDic objectForKey:@"color"];
        NSString * upAlpha = [upDic objectForKey:@"alpha"];
        long upWeight = [[upDic objectForKey:@"weight"] longLongValue] * scale_zoom;
        
        self.upLine = [[MetroUpLine alloc] initColor:upColor andAlpha:upAlpha andWeight:upWeight];
        
        NSArray * upSections = [upDic objectForKey:@"sections"];
        for (int i = 0; i < upSections.count; i++) {
            NSString * beginCode = [upSections[i] objectForKey:@"beginCode"];
            NSString * endCode   = [upSections[i] objectForKey:@"endCode"];
            NSString * name      = [upSections[i] objectForKey:@"name"];
            NSString * sectionColor      = [upSections[i] objectForKey:@"color"];
            NSArray  * pathNodes = [upSections[i] objectForKey:@"pathNodes"];
            
            MetroSection * section = [[MetroSection alloc] initName:name andBeginCode:beginCode andEndCode:endCode sectionColor:sectionColor];
            
            for (int i = 0; i < pathNodes.count; i++) {
                NSString * nodeType  = [pathNodes[i] objectForKey:@"type"];
                CGFloat nodeX = [[pathNodes[i] objectForKey:@"x"] floatValue] * scale_zoom;
                CGFloat nodeY = [[pathNodes[i] objectForKey:@"y"] floatValue] * scale_zoom;
                MetroPathNode * pathNode = [[MetroPathNode alloc] initType:nodeType andX:nodeX andY:nodeY];
                [section.pathNodes addObject:pathNode];
            }
            [self.upLine.sections addObject:section];
        }
        
        
        NSDictionary * downDic   = [lineArr[i] objectForKey:@"down"];
        NSString     * downColor = [downDic objectForKey:@"color"];
        NSString     * downAlpha = [downDic objectForKey:@"alpha"];
        long downWeight = [[downDic objectForKey:@"weight"] longLongValue] * scale_zoom;
        
        _downLine = [[MetroDownLine alloc] initColor:downColor andAlpha:downAlpha andWeight:downWeight];
        
        NSArray * downSections = [downDic objectForKey:@"sections"];
        for (int i = 0; i < downSections.count; i++) {
            NSString * beginCode = [downSections[i] objectForKey:@"beginCode"];
            NSString * endCode = [downSections[i] objectForKey:@"endCode"];
            NSString * name = [downSections[i] objectForKey:@"name"];
            NSString * sectionColor = [downSections[i] objectForKey:@"color"];
            
            NSArray * pathNodes = [downSections[i] objectForKey:@"pathNodes"];
            
            MetroSection * section = [[MetroSection alloc] initName:name andBeginCode:beginCode andEndCode:endCode sectionColor:sectionColor];
            
            for (int i = 0; i < pathNodes.count; i++) {
                NSString * nodeType  = [pathNodes[i] objectForKey:@"type"];
                CGFloat nodeX = [[pathNodes[i] objectForKey:@"x"] floatValue] * scale_zoom;
                CGFloat nodeY = [[pathNodes[i] objectForKey:@"y"] floatValue] * scale_zoom;
                MetroPathNode * pathNode = [[MetroPathNode alloc] initType:nodeType andX:nodeX andY:nodeY];
                [section.pathNodes addObject:pathNode];
            }
            [_downLine.sections addObject:section];
        }
        
        MetroLine * line = [[MetroLine alloc] initName:lineName andCode:lineCode andPrimaryLine:_primaryLine andUpLine:_upLine andDownLine:_downLine];
        [_lines addObject:line];
    }
    
    
    NSMutableArray * stations_line01 = [NSMutableArray array];
    NSMutableArray * stations_line02 = [NSMutableArray array];
    NSMutableArray * stations_line03 = [NSMutableArray array];
    NSMutableArray * stations_line04 = [NSMutableArray array];
    NSMutableArray * stations_line07 = [NSMutableArray array];
    NSMutableArray * stations_line10 = [NSMutableArray array];

    _stations = [NSMutableArray array];
    NSArray * stations = [jsonDic objectForKey:@"stations"];
    for (int i = 0; i < stations.count; i++) {
        NSString * stationCode = [stations[i] objectForKey:@"code"];
        NSString * stationName = [stations[i] objectForKey:@"name"];
        NSString * stationAppName = [stations[i] objectForKey:@"appName"];
        NSString * stationPinyin = [stations[i] objectForKey:@"pinyin"];
        NSString * stationColor = [stations[i] objectForKey:@"color"];
        NSString * stationFillColor = [stations[i] objectForKey:@"fillColor"];
        CGFloat stationRadius = [[stations[i] objectForKey:@"radius"] floatValue] * scale_zoom;
        CGFloat stationX = [[stations[i] objectForKey:@"x"] floatValue] * scale_zoom;
        CGFloat stationY = [[stations[i] objectForKey:@"y"] floatValue] * scale_zoom;
        BOOL stationVisible = [[stations[i] objectForKey:@"visible"] boolValue];
        BOOL stationDisabled = [[stations[i] objectForKey:@"disabled"] boolValue];

        BOOL istransfer = [[stations[i] objectForKey:@"istransfer"] boolValue];
        NSString * transferLine = [stations[i] objectForKey:@"transferLine"];

        NSDictionary * stationLabelDic = [stations[i] objectForKey:@"label"];
        NSString * labelText = [stationLabelDic objectForKey:@"text"];
        NSString * labelColor = [stationLabelDic objectForKey:@"color"];
        NSString * labelFontSize = [stationLabelDic objectForKey:@"fontSize"];
        CGFloat labelRotate = [[stationLabelDic objectForKey:@"rotate"] floatValue];

//        [self.stationIdPinyin setObject:stationPinyin forKey:stationCode];

        CGFloat labelTop = 0.0;
        CGFloat labelBottom = 0.0;
        CGFloat labelLeft = 0.0;
        CGFloat labelRight = 0.0;
        if (![[stationLabelDic objectForKey:@"top"] isKindOfClass:[NSNull class]]) {
            labelTop = [[stationLabelDic objectForKey:@"top"] floatValue] * scale_zoom;
        }
        if (![[stationLabelDic objectForKey:@"bottom"] isKindOfClass:[NSNull class]]) {
            labelBottom = [[stationLabelDic objectForKey:@"bottom"] floatValue] * scale_zoom;
        }
        if (![[stationLabelDic objectForKey:@"left"] isKindOfClass:[NSNull class]]) {
            labelLeft = [[stationLabelDic objectForKey:@"left"] floatValue] * scale_zoom;
        }
        if (![[stationLabelDic objectForKey:@"right"] isKindOfClass:[NSNull class]]) {
            labelRight = [[stationLabelDic objectForKey:@"right"] floatValue] * scale_zoom;
        }

        MetroLabel * label = [[MetroLabel alloc] initWithText:labelText andColor:labelColor andFontSize:labelFontSize andRotate:labelRotate andTop:labelTop andBottom:labelBottom andLeft:labelLeft andRight:labelRight];

        MetroStation * station = [[MetroStation alloc] initName:stationName appName:stationAppName andCode:stationCode andPinyin:stationPinyin andColor:stationColor andFillColor:stationFillColor andRadius:stationRadius andStaionX:stationX andStaionY:stationY andVisible:stationVisible andDisabled:stationDisabled andLabel:label istransfer:istransfer transferLine:transferLine];
        [_stations addObject:station];

        if ([stationCode hasPrefix:@"01"]) {
            [stations_line01 addObject:station];
        }
        if ([stationCode hasPrefix:@"02"]) {
            [stations_line02 addObject:station];
        }
        if ([stationCode hasPrefix:@"03"]) {
            [stations_line03 addObject:station];
        }
        if ([stationCode hasPrefix:@"04"]) {
            [stations_line04 addObject:station];
        }
        if ([stationCode hasPrefix:@"07"]) {
            [stations_line07 addObject:station];
        }
        if ([stationCode hasPrefix:@"10"]) {
            [stations_line10 addObject:station];
        }
    }
    [_lineCodeStationsDic setObject:stations_line01 forKey:@"1"];
    [_lineCodeStationsDic setObject:stations_line02 forKey:@"2"];
    [_lineCodeStationsDic setObject:stations_line03 forKey:@"3"];
    [_lineCodeStationsDic setObject:stations_line04 forKey:@"4"];
    [_lineCodeStationsDic setObject:stations_line07 forKey:@"7"];
    [_lineCodeStationsDic setObject:stations_line10 forKey:@"10"];
    
    
    _icons = [NSMutableArray array];
    NSArray * iconsArr = [jsonDic objectForKey:@"icons"];
    for (int i = 0; i < iconsArr.count; i++) {
        NSString * type = [iconsArr[i] objectForKey:@"type"];
        NSString * label = [iconsArr[i] objectForKey:@"label"];
        NSString * color = [iconsArr[i] objectForKey:@"color"];
        NSString * alpha = [iconsArr[i] objectForKey:@"alpha"];
        NSString * fontSize = [iconsArr[i] objectForKey:@"fontSize"];
        NSString * weight = [iconsArr[i] objectForKey:@"weight"];
        NSString * imageUrl = [iconsArr[i] objectForKey:@"imageurl"];
        CGFloat rotate = [[iconsArr[i] objectForKey:@"rotate"] floatValue] * scale_zoom;
        CGFloat iconX = [[iconsArr[i] objectForKey:@"x"] floatValue] * scale_zoom;
        CGFloat iconY = [[iconsArr[i] objectForKey:@"y"] floatValue] * scale_zoom;
        NSArray * pathNodes = [iconsArr[i] objectForKey:@"pathNodes"];
        
        MetroIcon * icon = [[MetroIcon alloc] initWithType:type andLabel:label andColor:color andAlpha:alpha andFontSize:fontSize andWeight:weight andImageUrl:imageUrl andRotate:rotate andIconX:iconX andIconY:iconY];
        
        for (int i = 0; i < pathNodes.count; i++) {
            NSString * nodeType  = [pathNodes[i] objectForKey:@"type"];
            CGFloat nodeX = [[pathNodes[i] objectForKey:@"x"] floatValue] * scale_zoom;
            CGFloat nodeY = [[pathNodes[i] objectForKey:@"y"] floatValue] * scale_zoom;
            MetroPathNode * pathNode = [[MetroPathNode alloc] initType:nodeType andX:nodeX andY:nodeY];
            [icon.pathNodes addObject:pathNode];
        }
        [_icons addObject:icon];
    }
    
    
}

@end
