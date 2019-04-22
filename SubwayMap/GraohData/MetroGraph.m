//
//  MetroGraph.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroGraph.h"
#import "MetroStation.h"

@implementation MetroGraph
//通过屏幕点击位置pt获取地铁站点node
- (MetroStation *)getNodeAt:(CGPoint)pt {
    for (MetroStation * station in _stations) {
        CGRect rect = [station getStationRect];
        
        if (CGRectContainsPoint(rect, pt)) {
            return station;
        }
    }
    return nil;
}
@end
