//
//  MetroDrawer.m
//  SubwaMap
//
//  Created by Tuzy on 2019/4/19.
//  Copyright © 2019 tuzhaoyang. All rights reserved.
//

#import "MetroDrawer.h"
#import "GraphicUtil.h"
#import "MetroPathNode.h"
#import "MetroSection.h"
#import "MetroDataContainer.h"

@implementation MetroDrawer


- (void)paintLink:(CGContextRef)ctx pathNodes:(NSArray *)pathNodes inLine:(id)line {
    
    if ([line isKindOfClass:[MetroPrimaryLine class]]) {
        MetroPrimaryLine * primaryLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:primaryLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, primaryLine.weight);
        CGContextSetAlpha(ctx, [primaryLine.alpha floatValue]);
    }
    if ([line isKindOfClass:[MetroUpLine class]]) {
        MetroUpLine * upLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:upLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, upLine.weight);
        CGContextSetAlpha(ctx, [upLine.alpha floatValue]);
    }
    if ([line isKindOfClass:[MetroDownLine class]]) {
        MetroDownLine * downLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:downLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, downLine.weight);
        CGContextSetAlpha(ctx, [downLine.alpha floatValue]);
    }
    
    if (pathNodes.count > 0) {
        MetroPathNode * startPathNode = pathNodes[0];
        CGContextMoveToPoint(ctx, startPathNode.x, startPathNode.y);
    }
    
    
    for (int i = 1; i < pathNodes.count; i++) {
        MetroPathNode * nextPathNode = pathNodes[i];
        CGContextAddLineToPoint(ctx, nextPathNode.x, nextPathNode.y);
    }
    CGContextStrokePath(ctx);
}



#pragma mark - 绘制主线、上行线、下行线
- (void)paintLink:(CGContextRef)ctx fromStartNode:(CGPoint) startNode toEndNode:(CGPoint)endNode inLine:(id)line {
    
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    if ([line isKindOfClass:[MetroPrimaryLine class]]) {
        MetroPrimaryLine * primaryLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:primaryLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, primaryLine.weight);
        CGContextSetAlpha(ctx, [primaryLine.alpha floatValue]);
    }
    if ([line isKindOfClass:[MetroUpLine class]]) {
        MetroUpLine * upLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:upLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, upLine.weight);
        CGContextSetAlpha(ctx, [upLine.alpha floatValue]);
    }
    if ([line isKindOfClass:[MetroDownLine class]]) {
        MetroDownLine * downLine = line;
        UIColor * lineColor = [GraphicUtil hexStringToColor:downLine.color];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        CGContextSetLineWidth(ctx, downLine.weight);
        CGContextSetAlpha(ctx, [downLine.alpha floatValue]);
    }
    [GraphicUtil drawLine:ctx forStartX:startNode.x forStartY:startNode.y forEndX:endNode.x forEndY:endNode.y];
    
}

#pragma mark - 绘制站点
- (void)paintStation:(CGContextRef)ctx andStation:(MetroStation *)station isPath:(BOOL)isPath {
    //设置圆圈中填充颜色
    if (![station.fillColor isKindOfClass:[NSNull class]]) {
        UIColor * fillColor = [GraphicUtil hexStringToColor:station.fillColor];
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextSetAlpha(ctx, 1);
    }else{
        CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] CGColor]);
        CGContextSetAlpha(ctx, 1);
    }
    CGContextMoveToPoint(ctx, station.stationX, station.stationY);
    CGContextAddArc(ctx, station.stationX, station.stationY, station.radius, 0, 2 * M_PI, 0);
    CGContextFillPath(ctx);
    
    //设置圆圈边缘颜色
    NSArray * colors = [station.color componentsSeparatedByString:@","];
    UIColor * stationColor = [GraphicUtil hexStringToColor:colors.firstObject];
    if(self.isDouble == 1){
        if([station.code isKindOfClass:[NSNull class]] || [station.code isEqualToString:@""] || station.disabled){
            stationColor = [GraphicUtil hexStringToColor:@"#F0F0F0"];
        }
    }
    CGContextSetStrokeColorWithColor(ctx, [stationColor CGColor]);
    CGContextSetLineWidth(ctx, 5.0 * scale_zoom);
    CGContextAddArc(ctx, station.stationX, station.stationY, station.radius, 0, 2 * M_PI, 0);
    CGContextStrokePath(ctx);
}


//绘制换乘站箭头
- (void)paintTransferArrow:(CGContextRef)ctx andStation:(MetroStation *)station {
    //限流
    if(station.isLimit&&self.isDouble == 1){
        NSString *limitCode = station.limitCode;
        NSString *imgName = nil;
        if([limitCode isEqualToString:@"4"]){
            imgName = @"中断";
        }else if ([limitCode isEqualToString:@"0"]){
            imgName = @"跳站";
        }else if ([limitCode isEqualToString:@"20"]){
            imgName = @"临时限流";
        }
        CGFloat r = station.radius + 5.0 * scale_zoom;
        CGSize size = CGSizeMake(2* r, 2* r);
        CGRect rect = CGRectMake(station.stationX - r, station.stationY - r, size.width, size.height);
        UIImage* myImageObj = [UIImage imageNamed:imgName];
        [myImageObj drawInRect:rect];
        station.isLimit = NO;
        return;
    }
    if (station.istransfer) {
        CGFloat r = station.radius;
        
        
        NSArray *colorArray = [station.color componentsSeparatedByString:@","];
        if (colorArray.count == 2) {
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [[GraphicUtil hexStringToColor:colorArray[0]] CGColor]);
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGAffineTransform transform = CGAffineTransformMakeTranslation(station.stationX + r * 0.08 - r, station.stationY + r * 0.08 - r);
            CGPathMoveToPoint(pathRef, &transform, r * 2 * 0.12, r * 2 * 0.58);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.10, r * 2 * 0.25, r * 2 * 0.39, r * 2 * 0.14);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.47, r * 2 * 0.11, r * 2 * 0.56, r * 2 * 0.12);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.66, r * 2 * 0.14, r * 2 * 0.74, r * 2 * 0.21);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.79, r * 2 * 0.25, r * 2 * 0.84, r * 2 * 0.33);
            CGPathAddLineToPoint(pathRef, &transform, r * 2 * 0.49, r * 2 * 0.44);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.64, r * 2 * 0.24, r * 2 * 0.44, r * 2 * 0.26);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.16, r * 2 * 0.31, r * 2 * 0.12, r * 2 * 0.58);
            CGPathCloseSubpath(pathRef);
            CGContextAddPath(ctx, pathRef);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(pathRef);
            CGContextRestoreGState(ctx);
            
            
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [[GraphicUtil hexStringToColor:colorArray[1]] CGColor]);
            CGMutablePathRef pathRef2 = CGPathCreateMutable();
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(station.stationX + r * 0.95 * 2 - r, station.stationY + r * 0.96 * 2 - r);
            CGAffineTransform transform2 = CGAffineTransformRotate(transform1, M_PI);
            CGPathMoveToPoint(pathRef2, &transform2, r * 2 * 0.12, r * 2 * 0.58);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.10, r * 2 * 0.25, r * 2 * 0.39, r * 2 * 0.14);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.47, r * 2 * 0.11, r * 2 * 0.56, r * 2 * 0.12);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.66, r * 2 * 0.14, r * 2 * 0.74, r * 2 * 0.21);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.79, r * 2 * 0.25, r * 2 * 0.84, r * 2 * 0.33);
            CGPathAddLineToPoint(pathRef2, &transform2, r * 2 * 0.49, r * 2 * 0.44);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.64, r * 2 * 0.24, r * 2 * 0.44, r * 2 * 0.26);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.16, r * 2 * 0.31, r * 2 * 0.12, r * 2 * 0.58);
            CGPathCloseSubpath(pathRef2);
            CGContextAddPath(ctx, pathRef2);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(pathRef2);
            CGContextRestoreGState(ctx);
        }else if (colorArray.count == 3) {
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [[GraphicUtil hexStringToColor:colorArray[0]] CGColor]);
            CGMutablePathRef pathRef = CGPathCreateMutable();
            CGAffineTransform transform = CGAffineTransformMakeTranslation(station.stationX - r, station.stationY - r);
            CGPathMoveToPoint(pathRef, &transform, r * 2 * 0.29, r * 2 * 0.50);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.14, r * 2 * 0.29, r * 2 * 0.36, r * 2 * 0.19);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.58, r * 2 * 0.09, r * 2 * 0.76, r * 2 * 0.27);
            CGPathAddLineToPoint(pathRef, &transform, r * 2 * 0.43, r * 2 * 0.37);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.48, r * 2 * 0.33, r * 2 * 0.49, r * 2 * 0.30);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.50, r * 2 * 0.25, r * 2 * 0.42, r * 2 * 0.25);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.37, r * 2 * 0.25, r * 2 * 0.35, r * 2 * 0.27);
            CGPathAddQuadCurveToPoint(pathRef, &transform,r * 2 * 0.26, r * 2 * 0.34, r * 2 * 0.29, r * 2 * 0.50);
            CGPathCloseSubpath(pathRef);
            CGContextAddPath(ctx, pathRef);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(pathRef);
            CGContextRestoreGState(ctx);
            
            
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [[GraphicUtil hexStringToColor:colorArray[1]] CGColor]);
            CGMutablePathRef pathRef2 = CGPathCreateMutable();
            CGAffineTransform transform1 = CGAffineTransformMakeTranslation(station.stationX + r * 1.18 * 2 - r, station.stationY + r * 0.65 - r);
            CGAffineTransform transform2 = CGAffineTransformRotate(transform1, M_PI/180*120);
            CGPathMoveToPoint(pathRef2, &transform2, r * 2 * 0.29, r * 2 * 0.50);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.14, r * 2 * 0.29, r * 2 * 0.36, r * 2 * 0.19);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.58, r * 2 * 0.09, r * 2 * 0.76, r * 2 * 0.27);
            CGPathAddLineToPoint(pathRef2, &transform2, r * 2 * 0.43, r * 2 * 0.37);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.48, r * 2 * 0.33, r * 2 * 0.49, r * 2 * 0.30);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.50, r * 2 * 0.25, r * 2 * 0.42, r * 2 * 0.25);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.37, r * 2 * 0.25, r * 2 * 0.35, r * 2 * 0.27);
            CGPathAddQuadCurveToPoint(pathRef2, &transform2,r * 2 * 0.26, r * 2 * 0.34, r * 2 * 0.29, r * 2 * 0.50);
            CGPathCloseSubpath(pathRef2);
            CGContextAddPath(ctx, pathRef2);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(pathRef2);
            CGContextRestoreGState(ctx);
            
            CGContextSaveGState(ctx);
            CGContextSetFillColorWithColor(ctx, [[GraphicUtil hexStringToColor:colorArray[2]] CGColor]);
            CGMutablePathRef pathRef3 = CGPathCreateMutable();
            CGAffineTransform transform3 = CGAffineTransformMakeTranslation(station.stationX + r * 0.65 - r, station.stationY + r * 1.18 * 2 - r);
            CGAffineTransform transform4 = CGAffineTransformRotate(transform3, M_PI/180*240);
            CGPathMoveToPoint(pathRef3, &transform4, r * 2 * 0.29, r * 2 * 0.50);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.14, r * 2 * 0.29, r * 2 * 0.36, r * 2 * 0.19);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.58, r * 2 * 0.09, r * 2 * 0.76, r * 2 * 0.27);
            CGPathAddLineToPoint(pathRef3, &transform4, r * 2 * 0.43, r * 2 * 0.37);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.48, r * 2 * 0.33, r * 2 * 0.49, r * 2 * 0.30);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.50, r * 2 * 0.25, r * 2 * 0.42, r * 2 * 0.25);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.37, r * 2 * 0.25, r * 2 * 0.35, r * 2 * 0.27);
            CGPathAddQuadCurveToPoint(pathRef3, &transform4,r * 2 * 0.26, r * 2 * 0.34, r * 2 * 0.29, r * 2 * 0.50);
            CGPathCloseSubpath(pathRef3);
            CGContextAddPath(ctx, pathRef3);
            CGContextDrawPath(ctx, kCGPathFill);
            CGPathRelease(pathRef3);
            CGContextRestoreGState(ctx);
        }
    }
}


//绘制地铁站点名称
- (void)paintStationLabel:(CGContextRef)ctx andStation:(MetroStation *)station inView:(UIView *)view  isPath:(BOOL)isPath {
    if (!isPath) {
        if (!station.visible) {
            return;
        }
    }
    
    //    if (!station.visible) {
    //        return;
    //    }
    
    NSString * stationLabelText = station.stationLabel.text;
    CGFloat fontSize = [station.stationLabel.fontSize floatValue] * scale_zoom;
    UIColor * labelColor = [GraphicUtil hexStringToColor:station.stationLabel.color];
    
    CGFloat top = station.stationLabel.top;
    CGFloat bottom = station.stationLabel.bottom;
    CGFloat left = station.stationLabel.left;
    CGFloat right = station.stationLabel.right;
    CGFloat rotate = station.stationLabel.rotate;
    
    UIFont * font = [UIFont systemFontOfSize:fontSize];
    CGSize size = CGSizeMake(fontSize * stationLabelText.length + 1, fontSize + 2);
    
    //新路网图
    CGFloat stationLabelX = station.stationX;
    CGFloat stationLabelY = station.stationY;
    if (top != 0 && right != 0) {//右上
        stationLabelX = stationLabelX + right;
        stationLabelY = stationLabelY - top - size.height;
    }else if (right != 0 && bottom != 0){//右下
        stationLabelX = stationLabelX + right;
        stationLabelY = stationLabelY + bottom;
    }else if (left != 0 && bottom != 0){//左下
        stationLabelX = stationLabelX - left - size.width;
        stationLabelY = stationLabelY + bottom;
    }else if (left != 0 && top != 0){//左上
        stationLabelX = stationLabelX - left - size.width;
        stationLabelY = stationLabelY - top - size.height;
    }else{
        if (top != 0) {//上
            stationLabelX = stationLabelX - size.width/2;
            stationLabelY = stationLabelY - top - size.height/2;
        }
        if (bottom != 0) {//下
            stationLabelX = stationLabelX - size.width/2;
            stationLabelY = stationLabelY + bottom  - size.height/2;
        }
        if (left != 0) {//左
            stationLabelX = stationLabelX - left - size.width;
            stationLabelY = stationLabelY - size.height/2;
        }
        if (right != 0) {//右
            stationLabelX = stationLabelX + right;
            stationLabelY = stationLabelY - size.height/2;
        }
    }
    
    NSDictionary * dict = @{NSFontAttributeName:font,
                            NSForegroundColorAttributeName:labelColor};
    
    UIGraphicsPushContext(ctx);
    [stationLabelText drawAtPoint:CGPointMake(stationLabelX, stationLabelY) withAttributes:dict];
    
    //    CGContextSaveGState(ctx);
    //    if (rotate) {
    //        CGContextTranslateCTM(ctx, stationLabelX, stationLabelY);
    //        CGContextRotateCTM(ctx, rotate);
    //        [stationLabelText drawAtPoint:CGPointMake(0, 0) withAttributes:dict];
    //    }else{
    //        [stationLabelText drawAtPoint:CGPointMake(stationLabelX, stationLabelY) withAttributes:dict];
    //    }
    //    CGContextRestoreGState(ctx);
    
    UIGraphicsPopContext();
}

- (void)paintIcons:(CGContextRef)ctx andIcon:(MetroIcon *)icon inView:(UIView *)view{
    NSString * type = icon.type;
    //    NSString * label = icon.label;
    //    NSString * color = icon.color;
    //    NSString * alpha = icon.alpha;
    //    NSString * fontSize = icon.fontSize;
    NSString * imageUrl = icon.imageUrl;
    //    CGFloat rotate = icon.rotate;
    CGFloat iconX = icon.iconX;
    CGFloat iconY = icon.iconY;
    NSArray * pathNodes = icon.pathNodes;
    
    UIColor * iconColor = [UIColor blackColor];
    CGContextSetStrokeColorWithColor(ctx, iconColor.CGColor);
    CGContextSetLineWidth(ctx, 3.0 * scale_zoom);
    if ([type isEqualToString:@"sprite"]) {
        
        if (pathNodes[0]) {
            MetroPathNode * pathNode = pathNodes[0];
            CGContextAddArc(ctx, iconX + pathNode.y, iconY + pathNode.y, pathNode.y, M_PI, M_PI * 2, 0);
            CGContextMoveToPoint(ctx, iconX, iconY + pathNode.y);
            CGContextAddLineToPoint(ctx, iconX, iconY + pathNode.y + (75 * scale_zoom));
            CGContextAddArc(ctx, iconX + pathNode.y, iconY + pathNode.y + (75 * scale_zoom), pathNode.y, M_PI , 0, 1);
            CGContextMoveToPoint(ctx, iconX + pathNode.y + pathNode.y, iconY + pathNode.y + (75 * scale_zoom));
            CGContextAddLineToPoint(ctx, iconX + pathNode.y + pathNode.y, iconY + pathNode.y);
            CGContextStrokePath(ctx);
        }
        
    }else if([type isEqualToString:@"label"]){
        
    }else if([type isEqualToString:@"image"]){
        UIImage * image;
        if ([imageUrl isEqualToString:@"/img/line1_lable.png"]) {
            image = [UIImage imageNamed:@"1号线-小"];
        }else if ([imageUrl isEqualToString:@"/img/line2_lable.png"]){
            image = [UIImage imageNamed:@"2号线-小"];
        }else if ([imageUrl isEqualToString:@"/img/line3_lable.png"]){
            image = [UIImage imageNamed:@"3号线-小"];
        }else if ([imageUrl isEqualToString:@"/img/line4_lable.png"]){
            image = [UIImage imageNamed:@"4号线-小"];
        }else if ([imageUrl isEqualToString:@"/img/line7_lable.png"]){
            image = [UIImage imageNamed:@"7号线-小"];
        }else if ([imageUrl isEqualToString:@"/img/line10_lable.png"]){
            image = [UIImage imageNamed:@"10号线-小"];
        }
        [self paintIconImage:image context:ctx stationPosition:CGPointMake(iconX, iconY)];
    }
    
}

- (void)paintIconImage:(UIImage *)image context:(CGContextRef)ctx stationPosition:(CGPoint)position {
    
    CGContextSaveGState(ctx);
    CGContextTranslateCTM(ctx, position.x - 9, position.y + 9);
    CGContextScaleCTM(ctx, 1.0, -1.0);
    CGRect newRect = CGRectMake(0, 0, 18 ,18);
    CGContextDrawImage(ctx, newRect, [image CGImage]);
    CGContextRestoreGState(ctx);
}


#pragma mark - Assist
//绘制曲线：使用贝塞尔绘制法
- (void)paintArcLinkFromStartNode:(MetroPathNode *)startNode toEndNode:(MetroPathNode *)endNode andControlNode:(MetroPathNode *)controlNode inLine:(MetroPrimaryLine *)line {
    UIBezierPath * bezierPath = [[UIBezierPath alloc] init];
    bezierPath.lineWidth = line.weight;
    UIColor * color = [GraphicUtil hexStringToColor:line.color];
    [color set];
    //画起点
    [bezierPath moveToPoint:CGPointMake(startNode.x, startNode.y)];
    //画弧
    [bezierPath addQuadCurveToPoint:CGPointMake(endNode.x, endNode.y) controlPoint:CGPointMake(controlNode.x, controlNode.y)];
    
    [bezierPath stroke];
    
}

- (void)paintPath:(CGContextRef)ctx andPaths:(NSArray *)paths inLine:(id)line withMask:(CGRect)rect {
    if (paths.count == 0) {
        return;
    }
    
    MetroLine * metroLine = (MetroLine *)line;
    UIColor * lineColor = [GraphicUtil hexStringToColor:metroLine.primaryLine.color];
    CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
    CGContextSetLineWidth(ctx, metroLine.primaryLine.weight);
    CGContextSetAlpha(ctx, [metroLine.primaryLine.alpha floatValue]);
    
    MetroPathNode * startPathNode = paths[0];
    CGContextMoveToPoint(ctx, startPathNode.x, startPathNode.y);
    for (int i = 1; i < paths.count; i++) {
        MetroPathNode * nextPathNode = paths[i];
        CGContextAddLineToPoint(ctx, nextPathNode.x, nextPathNode.y);
    }
    CGContextStrokePath(ctx);
}



- (void)paintLink:(CGContextRef)ctx sections:(NSArray *)sections inLine:(id)line {
    CGFloat lineWidth = 0;
    NSString * metroLineColor;
    if ([line isKindOfClass:[MetroPrimaryLine class]]) {
        MetroPrimaryLine * primaryLine = line;
        CGContextSetLineWidth(ctx, primaryLine.weight);
        lineWidth = primaryLine.weight;
        metroLineColor = primaryLine.color;
    }
    if ([line isKindOfClass:[MetroUpLine class]]) {
        MetroUpLine * upLine = line;
        CGContextSetLineWidth(ctx, upLine.weight);
        lineWidth = upLine.weight;
        metroLineColor = upLine.color;
    }
    if ([line isKindOfClass:[MetroDownLine class]]) {
        MetroDownLine * downLine = line;
        CGContextSetLineWidth(ctx, downLine.weight);
        lineWidth = downLine.weight;
        metroLineColor = downLine.color;
    }
    
    NSMutableSet * set  = [NSMutableSet set];
    for (MetroSection * section in sections) {
        if(section.sectionColor != nil) [set addObject:section.sectionColor];
        UIColor * lineColor = [GraphicUtil hexStringToColor:section.sectionColor];
        CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
        NSArray * pathNodes = section.pathNodes;
        
        for (int a = 0; a < pathNodes.count - 1; a++) {
            MetroPathNode * anchorNode = pathNodes[a];
            MetroPathNode * endNode = pathNodes[a+1];
            if ([anchorNode.type isEqualToString:@"anchor"] && [endNode.type isEqualToString:@"anchor"]) {
                [GraphicUtil drawLine:ctx forStartX:anchorNode.x forStartY:anchorNode.y forEndX:endNode.x forEndY:endNode.y];
            }else if([anchorNode.type isEqualToString:@"control"]){
                MetroPathNode * startNode = pathNodes[a-1];
                UIGraphicsPushContext(ctx);
                UIBezierPath * bezierPath = [[UIBezierPath alloc] init];
                bezierPath.lineWidth = lineWidth;
                UIColor * color = lineColor;
                [color set];
                [bezierPath moveToPoint:CGPointMake(startNode.x, startNode.y)];
                [bezierPath addQuadCurveToPoint:CGPointMake(endNode.x, endNode.y) controlPoint:CGPointMake(anchorNode.x, anchorNode.y)];
                [bezierPath stroke];
                UIGraphicsPopContext();
            }
        }
    }
}


- (void)paintLink:(CGContextRef)ctx upSections:(NSArray *)upSections downSections:(NSArray *)downSections inLine:(id)line withMask:(CGRect)rect {
    //绘制白色遮罩层
    CGContextSetFillColorWithColor(ctx, [[UIColor whiteColor] colorWithAlphaComponent:0.75].CGColor);
    CGContextFillRect(ctx, rect);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);
    CGContextSetLineCap(ctx, kCGLineCapRound);
    
    CGFloat lineWidth = 0;
    
    if ([line isKindOfClass:[MetroUpLine class]]) {
        MetroUpLine * upLine = line;
        CGContextSetLineWidth(ctx, upLine.weight);
        lineWidth = upLine.weight;
    }
    if ([line isKindOfClass:[MetroDownLine class]]) {
        MetroDownLine * downLine = line;
        CGContextSetLineWidth(ctx, downLine.weight);
        lineWidth = downLine.weight;
    }
    
    
    for (MetroSection * section in upSections) {
        [self paintSection:ctx section:section lineWidth:lineWidth];
    }
    
    for (MetroSection * section in downSections) {
        [self paintSection:ctx section:section lineWidth:lineWidth];
    }
}

- (void)paintSection:(CGContextRef)ctx section:(MetroSection *)section lineWidth:(CGFloat)lineWidth {
    UIColor * lineColor;
    if (section.sectionColor != nil) {
        lineColor = [GraphicUtil hexStringToColor:section.sectionColor];
    }else {
        lineColor = [GraphicUtil hexStringToColor:@"#838b8b"];
    }
    
    NSArray * pathNodes = section.pathNodes;
    CGContextSetStrokeColorWithColor(ctx, [lineColor CGColor]);
    for (int i = 0; i < pathNodes.count - 1; i++) {
        MetroPathNode * anchorNode = pathNodes[i];
        MetroPathNode * endNode = pathNodes[i+1];
        if ([anchorNode.type isEqualToString:@"anchor"] && [endNode.type isEqualToString:@"anchor"]) {
            [GraphicUtil drawLine:ctx forStartX:anchorNode.x forStartY:anchorNode.y forEndX:endNode.x forEndY:endNode.y];
        }else if([anchorNode.type isEqualToString:@"control"]){
            MetroPathNode * startNode = pathNodes[i-1];
            UIGraphicsPushContext(ctx);
            UIBezierPath * bezierPath = [[UIBezierPath alloc] init];
            bezierPath.lineWidth = lineWidth;
            UIColor * color = lineColor;
            [color set];
            [bezierPath moveToPoint:CGPointMake(startNode.x, startNode.y)];
            [bezierPath addQuadCurveToPoint:CGPointMake(endNode.x, endNode.y) controlPoint:CGPointMake(anchorNode.x, anchorNode.y)];
            [bezierPath stroke];
            UIGraphicsPopContext();
        }
    }
    CGContextStrokePath(ctx);
}

@end
