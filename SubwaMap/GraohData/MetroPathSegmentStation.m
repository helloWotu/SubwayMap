//
//  MetroPathSegmentStation.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroPathSegmentStation.h"

@implementation MetroPathSegmentStation
//获取该站点运行状态是否正常(0-正常,1-异常)
- (int)getDisabledStatus:(NSString *)stationName {
    NSString * disabled = [_dicStatus objectForKey:stationName];
    if ([disabled isEqualToString:@"false"]) {
        return 0;
    }
    else
        return 1;
}
@end
