//
//  MetroGraph.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class MetroStation;

NS_ASSUME_NONNULL_BEGIN

@interface MetroGraph : NSObject

@property (strong, nonatomic) NSArray * icons;
@property (strong, nonatomic) NSArray * lines;
@property (strong, nonatomic) NSArray * stations;
@property (strong, nonatomic) NSArray * currentPathLines;


//通过屏幕点击位置pt获取地铁站点node
- (MetroStation *) getNodeAt:(CGPoint)pt;

@end

NS_ASSUME_NONNULL_END
