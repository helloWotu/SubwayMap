//
//  GraphicUtil.m
//  SubwayMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "GraphicUtil.h"

@implementation GraphicUtil
static inline float radians(float degrees) {return degrees * M_PI / 180; }

static inline float getRadiansOffset(float x1, float y1, float x2, float y2)
{
    if (x1 == x2) {
        return y2 > y1 ? M_PI_2 : -M_PI_2;
        
    }
    else if(y1 == y2){
        return x1 > x2 ? M_PI : 0;
    }
    float r = atanf((y2 - y1) / (x2 - x1));
    int signx = x2 - x1 > 0 ? 1 : -1;
    int signy = y2 - y1 > 0 ? 1 : -1;
    if ((signx == -1 && signy == 1) || (signx == -1 && signy == -1)) {
        r += M_PI;
    }
    return r;
}

/**
 *  计算文字长度
 */
+ (CGFloat )widthForLabel:(NSString *)text fontSize:(CGFloat)font
{
    CGSize size = [text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:font], NSFontAttributeName, nil]];
    return size.width;
}


+(CGFloat)spaceToPoint:(CGPoint)first fromPoint:(CGPoint)two
{
    float x = first.x - two.x;
    float y = first.y - two.y;
    return sqrtf(x * x + y * y);
}

//根据起始点坐标，直线斜率，距离获取结束点坐标
+(CGPoint)getEndPoint:(CGPoint)startPt forSlope:(float)slope forLen:(float)len
{
    float temp = sqrtf(slope * slope + 1);
    float x = len / temp + startPt.x;
    float y = len / temp * slope + startPt.y;
    return CGPointMake(x, y);
}

//16进制颜色(html颜色值)字符串转为UIColor
+ (UIColor *)hexStringToColor:(NSString *)stringToConvert {
    NSString * cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6) return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}

+ (void)drawLine:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy {
    CGContextMoveToPoint(ctx, startx, starty);
    CGContextAddLineToPoint(ctx, endx, endy);
    CGContextStrokePath(ctx);
}

+(void)drawCircle:(CGContextRef)ctx forCenterX:(float)centerx forCentery:(float)centery forRadius:(float)radius
{
    CGContextMoveToPoint(ctx, centerx, centery);
    CGContextAddArc(ctx, centerx, centery, radius, radians(0), radians(360), 0);
}

+(void)drawArc:(CGContextRef)ctx forCurrentPt:(CGPoint)curPt forP1:(CGPoint)p1 forP2:(CGPoint)p2 forRadius:(CGFloat)radius
{
    CGContextMoveToPoint(ctx, curPt.x, curPt.y);
    CGContextAddArcToPoint(ctx, p1.x, p1.y, p2.x, p2.y, radius);
    CGContextStrokePath(ctx);
}

+(void) drawRoundRect:(CGContextRef)ctx forCenterX:(float)centerx forCenterY:(float)centery forRadius:(float)radius forWidth:(float)width forHeight:(float)height
{
    CGContextMoveToPoint(ctx, centerx - width / 2 + radius, centery - height / 2);
    CGContextAddLineToPoint(ctx, centerx + width / 2 - radius, centery - height / 2);
    CGContextAddArcToPoint(ctx, centerx + width / 2, centery - height / 2, centerx + width / 2, centery - height / 2 + radius, radius);
    CGContextAddLineToPoint(ctx, centerx + width / 2, centery + height / 2 - radius);
    CGContextAddArcToPoint(ctx, centerx + width / 2, centery + height / 2, centerx + width / 2 - radius, centery + height / 2, radius);
    CGContextAddLineToPoint(ctx, centerx - width / 2 + radius, centery + height / 2);
    CGContextAddArcToPoint(ctx, centerx - width / 2, centery + height / 2, centerx - width / 2, centery + height / 2 - radius, radius);
    CGContextAddLineToPoint(ctx, centerx - width / 2, centery - height / 2 + radius);
    CGContextAddArcToPoint(ctx, centerx - width / 2, centery - height / 2, centerx - width / 2 + radius, centery - height / 2, radius);
    CGContextStrokePath(ctx);
}

//画90度圆弧＋直线
+(void) drawArcLine:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy
{
    float arcCenterX, arcCenterY, startAngle, endAngle;
    float disx = endx - startx;
    float disy = endy - starty;
    int signx = disx > 0 ? 1 : -1;
    int signy = disy > 0 ? 1 : -1;
    float r = fabsf(disx) < fabsf(disy) ? fabsf(disx) : fabsf(disy);
    if (fabsf(disx) < fabsf(disy)) {
        arcCenterX = startx;
        arcCenterY = starty + signy * r;
        // signx=1,signy=-1 --> startAngle = 0, (1,1->-M_PI_2)(-1,1->M_PI)(-1,-1->M_PI_2)
        startAngle = (signx + signy != 0) ? (-M_PI/(signx+signy)) : (signx > 0 ? 0 : M_PI);
        endAngle = startAngle + M_PI_2;
    } else {
        arcCenterX = startx + signx * r;
        arcCenterY = starty;
        // (1,-1->M_PI) (1,1->M_PI_2) (-1,1->0) (-1,-1->-M_PI_2)
        startAngle = (signx + signy != 0) ? (M_PI / (signx+signy)) : (signx >0 ? M_PI : 0);
        endAngle = startAngle + M_PI_2;
    }
    
    //90度圆弧统一clockwise参数为counterclockwise(0)
    CGContextAddArc(ctx, arcCenterX, arcCenterY, r, startAngle, endAngle, 0);
    
    CGContextMoveToPoint(ctx, startx + r * signx, starty + r * signy);
    CGContextAddLineToPoint(ctx, endx, endy);
    CGContextStrokePath(ctx);
}

+(void) drawLineArc:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy
{
    
    float arcCenterX, arcCenterY, startAngle, endAngle;
    float disx = endx - startx;
    float disy = endy - starty;
    int signx = disx > 0 ? 1 : -1;
    int signy = disy > 0 ? 1 : -1;
    float r = fabsf(disx) < fabsf(disy) ? fabsf(disx) : fabsf(disy);
    
    CGContextMoveToPoint(ctx, startx, starty);
    if (fabsf(disx) < fabsf(disy)) {
        arcCenterX = endx;
        arcCenterY = endy - signy * r;
        startAngle = (signx + signy != 0) ? (M_PI/(signx+signy)) : (signx > 0 ? M_PI : 0);
        endAngle = startAngle + M_PI_2;
        CGContextAddLineToPoint(ctx, startx, arcCenterY);
        if (signx == signy) {
            CGContextMoveToPoint(ctx, endx, endy);
        }
    }else{
        arcCenterX = endx - signx * r;
        arcCenterY = endy;
        startAngle = (signx + signy != 0) ? (-M_PI/(signx+signy)) : (signx > 0 ? 0 : M_PI);
        endAngle = startAngle + M_PI_2;
        CGContextAddLineToPoint(ctx, arcCenterX, starty);
        if (signx != signy) {
            CGContextMoveToPoint(ctx, endx, endy);
        }
    }
    CGContextAddArc(ctx, arcCenterX, arcCenterY, r, startAngle, endAngle, 0);
    CGContextStrokePath(ctx);
}

+(void) drawArc:(CGContextRef)ctx forStartX:(float)startx forStartY:(float)starty forEndX:(float)endx forEndY:(float)endy forCenterX:(float)centerx forCenterY:(float)centery
{
    float r = [self spaceToPoint:CGPointMake(startx, starty) fromPoint:CGPointMake(centerx, centery)];
    float startAngle = getRadiansOffset(centerx, centery, startx, starty);
    float endAngle = getRadiansOffset(centerx, centery, endx, endy);
    int clockwise = (endAngle - startAngle > 0) ? 0 : 1;
    CGContextAddArc(ctx, centerx, centery, r, startAngle, endAngle, clockwise);
    CGContextStrokePath(ctx);
}

+(void) drawLineArcLine:(CGContextRef)ctx
             forStartPt:(CGPoint)startPt
               forEndPt:(CGPoint)endPt
          forArcStartPt:(CGPoint)arcStartPt
            forArcEndPt:(CGPoint)arcEndPt
            forCenterPt:(CGPoint)centerPt;
{
    CGContextMoveToPoint(ctx, startPt.x, startPt.y);
    CGContextAddLineToPoint(ctx, arcStartPt.x, arcStartPt.y);
    float r = [self spaceToPoint:arcStartPt fromPoint:centerPt];
    float startAngle = getRadiansOffset(centerPt.x, centerPt.y, arcStartPt.x, arcStartPt.y);
    float endAngle = getRadiansOffset(centerPt.x, centerPt.y, arcEndPt.x, arcEndPt.y);
    float subAngle = endAngle - startAngle;
    int clockwise = ( subAngle > 0) ? 0 : 1;
    if (subAngle > M_PI) {
        clockwise = 1;
    }
    else if(subAngle < -M_PI){
        clockwise = 0;
    }
    CGContextAddArc(ctx, centerPt.x, centerPt.y, r, startAngle, endAngle, clockwise);
    CGContextAddLineToPoint(ctx, endPt.x, endPt.y);
    CGContextStrokePath(ctx);
}

+(void) drawMultiArcLine:(CGContextRef)ctx
              forStartPt:(CGPoint)startPt
                forEndPt:(CGPoint)endPt
        forArcStartPtAry:(NSArray *)arcStartPtAry
          forArcEndPtAry:(NSArray *)arcEndPtAry
          forCenterPtAry:(NSArray *)arcCenterPtAry
{
    CGPoint ptCur = CGPointMake(startPt.x, startPt.y);
    for (int i = 0; i < arcStartPtAry.count; i++) {
        CGPoint arcStartPt = [[arcStartPtAry objectAtIndex:i] CGPointValue];
        CGPoint arcEndPt = [[arcEndPtAry objectAtIndex:i] CGPointValue];
        CGPoint centerPt = [[arcCenterPtAry objectAtIndex:i] CGPointValue];
        
        CGContextMoveToPoint(ctx, ptCur.x, ptCur.y);
        CGContextAddLineToPoint(ctx, arcStartPt.x, arcStartPt.y);
        float r = [self spaceToPoint:arcStartPt fromPoint:centerPt];
        float startAngle = getRadiansOffset(centerPt.x, centerPt.y, arcStartPt.x, arcStartPt.y);
        float endAngle = getRadiansOffset(centerPt.x, centerPt.y, arcEndPt.x, arcEndPt.y);
        float subAngle = endAngle - startAngle;
        int clockwise = ( subAngle > 0) ? 0 : 1;
        if (subAngle > M_PI) {
            clockwise = 1;
        }
        else if(subAngle < -M_PI){
            clockwise = 0;
        }
        
        CGContextAddArc(ctx, centerPt.x, centerPt.y, r, startAngle, endAngle, clockwise);
        
        ptCur = CGPointMake(arcEndPt.x, arcEndPt.y);
    }
    CGContextAddLineToPoint(ctx, endPt.x, endPt.y);
    CGContextStrokePath(ctx);
}

+ (void)drawImage:(CGContextRef)ctx theImage:(UIImage*)image boundsHeight:(CGFloat)height forLeftTop:(CGPoint)leftTop forScale:(CGFloat)scale forRotate:(CGFloat)degree roateWidth:(CGFloat)width{
    CGFloat roate = (CANVAS_WIDTH * MIM_ZOOM_SCALE / scale_zoom) / width;
    CGContextSaveGState(ctx);
    //旋转坐标系
    CGContextTranslateCTM(ctx, 0, height);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    
    CGContextTranslateCTM(ctx, leftTop.x, height - leftTop.y);
    if (scale != 1) {
        CGContextScaleCTM(ctx, scale, scale);
    }
    if (degree != 0) {
        CGContextRotateCTM(ctx, degree);
    }
    
    CGRect newRect = CGRectMake(0, 0, image.size.width/8 * roate, image.size.height/8 * roate);
    CGContextDrawImage(ctx, newRect, [image CGImage]);
    CGContextRestoreGState(ctx);
}

/*
 + (UIImage*) linearGradientImage:(CGSize)size withColors:(NSArray*)colors {
 NSMutableArray *ar = [NSMutableArray array];
 for(UIColor *c in colors) [ar addObject:(id)c.CGColor];
 
 UIGraphicsBeginImageContextWithOptions(size, YES, 1);
 
 CGContextRef context = UIGraphicsGetCurrentContext();
 CGContextSaveGState(context);
 
 CGColorSpaceRef colorSpace = CGColorGetColorSpace([[colors lastObject] CGColor]);
 CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)ar, NULL);
 
 //     CGContextClipToRect(context, rect);
 
 CGPoint start = CGPointMake(0.0, 0.0);
 CGPoint end = CGPointMake(0.0, size.height);
 
 CGContextDrawLinearGradient(context, gradient, start, end, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
 
 UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
 
 CGGradientRelease(gradient);
 CGContextRestoreGState(context);
 
 // Clean up
 CGColorSpaceRelease(colorSpace); // Necessary?
 UIGraphicsEndImageContext(); // Clean up
 return image;
 }
 */

+ (UIImage *)radialGradientImage:(CGSize)size start:(float)start end:(float)end centre:(CGPoint)centre radius:(float)radius {
    // Initialise
    UIGraphicsBeginImageContextWithOptions(size, YES, 1);
    
    // Create the gradient's colours
    size_t num_locations = 2;
    CGFloat locations[2] = { 0.0, 1.0 };
    CGFloat components[8] = { start,start,start, 1.0,  // Start color
        end,end,end, 1.0 }; // End color
    
    CGColorSpaceRef myColorspace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef myGradient = CGGradientCreateWithColorComponents (myColorspace, components, locations, num_locations);
    
    // Normalise the 0-1 ranged inputs to the width of the image
    CGPoint myCentrePoint = CGPointMake(centre.x * size.width, centre.y * size.height);
    float myRadius = MIN(size.width, size.height) * radius;
    
    // Draw it!
    CGContextDrawRadialGradient (UIGraphicsGetCurrentContext(), myGradient, myCentrePoint,
                                 0, myCentrePoint, myRadius,
                                 kCGGradientDrawsAfterEndLocation);
    
    // Grab it as an autoreleased image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    // Clean up
    CGColorSpaceRelease(myColorspace); // Necessary?
    CGGradientRelease(myGradient); // Necessary?
    UIGraphicsEndImageContext(); // Clean up
    return image;
}

+ (UIImage *)addText:(UIImage *)img withText:(NSString *)text withPosition:(CGPoint)pt withFont:(UIFont *)font
{
    UIGraphicsBeginImageContext(img.size);
    
    CGContextSetFillColorWithColor(UIGraphicsGetCurrentContext(), [[UIColor whiteColor] CGColor]);
    [img drawAtPoint:CGPointZero];
    [text drawAtPoint:pt withFont:font];
    UIImage *myImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return myImage;
}
@end
