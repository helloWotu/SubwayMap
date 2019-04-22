//
//  MetroLine.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetroPrimaryLine.h"
#import "MetroUpLine.h"
#import "MetroDownLine.h"
NS_ASSUME_NONNULL_BEGIN

@interface MetroLine : NSObject
@property (nonatomic, copy) NSString * lineCode;
@property (nonatomic, copy) NSString * lineName;
@property (nonatomic, assign) BOOL lineLoop;
@property (nonatomic, assign) BOOL lineVisible;

@property (nonatomic, strong) MetroPrimaryLine * primaryLine;
@property (nonatomic, strong) MetroUpLine * upLine;
@property (nonatomic, strong) MetroDownLine * downLine;

- (id)initName:(NSString *)lineName andCode:(NSString *)lineCode andPrimaryLine:(MetroPrimaryLine *)primaryLine andUpLine:(MetroUpLine *)upLine andDownLine:(MetroDownLine *)downLine;
@end

NS_ASSUME_NONNULL_END
