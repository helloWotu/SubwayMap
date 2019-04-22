//
//  MetroDrawer.h
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MetroStation.h"
#import "MetroLine.h"
#import "MetroMarkIcon.h"
#import "MetroPath.h"
#import "MetropathSegmentStation.h"
#import "MetroIcon.h"
#import "MetroPathNode.h"

NS_ASSUME_NONNULL_BEGIN

@interface MetroDrawer : NSObject
@property (nonatomic ,assign) NSInteger isDouble;//是否绘制双线图 默认单线  传1 双线

//绘制曲线：使用贝塞尔绘制法
- (void)paintArcLinkFromStartNode:(MetroPathNode *)startNode toEndNode:(MetroPathNode *)endNode andControlNode:(MetroPathNode *)controlNode inLine:(MetroPrimaryLine *)line;

//绘制站点间连线
- (void)paintLink:(CGContextRef)ctx fromStartNode:(CGPoint) startNode toEndNode:(CGPoint)endNode inLine:(id)line;
- (void)paintLink:(CGContextRef)ctx pathNodes:(NSArray *)pathNodes inLine:(id)line;

//绘制地铁站点
- (void)paintStation:(CGContextRef) ctx andStation:(MetroStation *)station isPath:(BOOL)isPath;
- (void)paintTransferArrow:(CGContextRef)ctx andStation:(MetroStation *)station;

//绘制地铁站点名称
- (void)paintStationLabel:(CGContextRef)ctx andStation:(MetroStation *)station inView:(UIView *)view isPath:(BOOL)isPath;

//绘制换乘站圆角矩形
- (void)paintIcons:(CGContextRef)ctx andIcon:(MetroIcon *)icon inView:(UIView *)view;

//绘制乘车路径
- (void)paintPath:(CGContextRef)ctx andPaths:(NSArray *)paths inLine:(id)line withMask:(CGRect)rect;

//绘制拥挤度路径
- (void)paintLink:(CGContextRef)ctx sections:(NSArray *)sections inLine:(id)line;

//绘制单条拥挤度路径
- (void)paintLink:(CGContextRef)ctx upSections:(NSArray *)upSections downSections:(NSArray *)downSections inLine:(id)line withMask:(CGRect)rect;

@end

NS_ASSUME_NONNULL_END
