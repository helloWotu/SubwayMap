//
//  GraphicUtil.h
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GraphicUtil : NSObject
/**
 计算文字长度
 
 @param text 文字
 @param font 字体
 @return 长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font;
//16进制颜色(html颜色值)字符串转为UIColor
+(UIColor *)hexStringToColor: (NSString *) stringToConvert;

+(CGFloat)spaceToPoint:(CGPoint)first fromPoint:(CGPoint)two;

//根据起始点坐标，直线斜率，距离获取结束点坐标
+(CGPoint)getEndPoint:(CGPoint)startPt forSlope:(float)slope forLen:(float)len;

+(void) drawLine:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy;

+(void) drawCircle:(CGContextRef)ctx forCenterX:(float)centerx forCentery:(float)centery forRadius:(float)radius;

+(void) drawRoundRect:(CGContextRef)ctx forCenterX:(float)centerx forCenterY:(float)centery forRadius:(float)radius forWidth:(float)width forHeight:(float)height;

+(void) drawArcLine:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy;

+(void) drawLineArc:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy;

+(void) drawArc:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy forCenterX:(float)centerx forCenterY:(float)centery;

+(void) drawLineArcLine:(CGContextRef)ctx forStartPt:(CGPoint)startPt forEndPt:(CGPoint)endPt forArcStartPt:(CGPoint)arcStartPt forArcEndPt:(CGPoint)arcEndPt forCenterPt:(CGPoint)centerPt;

+(void) drawMultiArcLine:(CGContextRef)ctx forStartPt:(CGPoint)startPt forEndPt:(CGPoint)endPt
        forArcStartPtAry:(NSArray *)arcStartPtAry forArcEndPtAry:(NSArray *)arcEndPtAry
          forCenterPtAry:(NSArray *)arcCenterPtAry;

+ (void)drawImage:(CGContextRef)ctx theImage:(UIImage*)image boundsHeight:(CGFloat)height forLeftTop:(CGPoint)leftTop forScale:(CGFloat)scale forRotate:(CGFloat)degree roateWidth:(CGFloat)width;

//+ (UIImage*) linearGradientImage:(CGSize)size withColors:(NSArray*)colors;

+ (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius;

+ (UIImage *)addText:(UIImage *)img withText:(NSString *)text withPosition:(CGPoint)pt withFont:(UIFont *)font;
@end

NS_ASSUME_NONNULL_END
