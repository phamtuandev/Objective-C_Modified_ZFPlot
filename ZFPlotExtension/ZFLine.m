//
//  ZFLine.m
//  ZFPlotExtension
//
//  Created by Aileen Nielsen on 11/9/15.
//  Copyright © 2015 SunnysideProductions. All rights reserved.
//

#import "ZFLine.h"

@implementation ZFLine

- (void) drawPoints {
    /*** Draw points ***/
    [self.dictDispPoint enumerateObjectsUsingBlock:^(id obj, NSUInteger ind, BOOL *stop){
        if(ind > 0)
        {
            self.prevPoint = [[[self.dictDispPoint objectAtIndex:ind-1] valueForKey:fzPoint] CGPointValue];
            self.curPoint = [[[self.dictDispPoint objectAtIndex:ind] valueForKey:fzPoint] CGPointValue];
        }
        else
        {
            // first point
            self.prevPoint = [[[self.dictDispPoint objectAtIndex:ind] valueForKey:fzPoint] CGPointValue];
            self.curPoint = self.prevPoint;
        }
        
        // line style
        [self setContextWidth:1.5f andColor:self.baseColorProperty];
        
        // draw the curve
        if(ind < self.countDown) [self drawCurveFrom:self.prevPoint to:self.curPoint];
        
        [self endContext];
        
        
        long linesRatio;
        
        if([self.dictDispPoint count] < intervalLinesVertical + 1){
            linesRatio = [self.dictDispPoint count]/MAX(([self.dictDispPoint count]-1), 1);
        }
        else    linesRatio  = [self.dictDispPoint count]/intervalLinesVertical ;
        
        
        
        if(ind%linesRatio == 0) {
            [self setContextWidth:0.5f andColor:linesColor];
            // Vertical Lines
            if(ind!=0) {
                CGPoint lower = CGPointMake(self.curPoint.x, topMarginInterior+self.chartHeight);
                CGPoint higher = CGPointMake(self.curPoint.x, topMarginInterior);
                if(self.gridLinesOn) [self drawLineFrom:lower to: higher];
            }
            
            [self endContext];
            
            // draw x-axis values
            CGPoint datePoint = CGPointMake(self.curPoint.x-15, topMarginInterior + self.chartHeight + 2);
            if(self.useDates == 0.0){
                [self drawString:[NSString stringWithFormat:@"%d", (int)ind] at:datePoint withFont:systemFont andColor:linesColor];
            }
            else if(self.useDates == 1.0){
                NSString* date = [self dateFromString: [[self.dictDispPoint objectAtIndex:ind] valueForKey:fzXValue]];
                [self drawString:date at:datePoint withFont:systemFont andColor:linesColor];
            }
            else{
                NSString *xUse;
                if(self.xUnits) xUse = [NSString stringWithFormat:@"%@ %@", [[self.dictDispPoint objectAtIndex:ind] valueForKey:fzXValue], self.xUnits];
                else xUse = [[self.dictDispPoint objectAtIndex:ind] valueForKey:fzXValue];
                [self drawString: xUse at:datePoint withFont:systemFont andColor:linesColor];
            }
            
            [self endContext];
            
        }
        
    }];
    
}


- (void) drawSpecial{
    // gradient's path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGPoint origin = CGPointMake((signed)self.leftMargin, (signed)(topMarginInterior+self.chartHeight));
    if (self.dictDispPoint && self.dictDispPoint.count > 0) {
        
        //origin
        CGPathMoveToPoint(path, nil, origin.x, origin.y);
        CGPoint p;
        for (int i = 0; i < self.dictDispPoint.count; i++) {
            p = [[[self.dictDispPoint objectAtIndex:i] valueForKey:fzPoint] CGPointValue];
            CGPathAddLineToPoint(path, nil, p.x, p.y);
        }
    }
    CGPathAddLineToPoint(path, nil, self.curPoint.x, topMarginInterior+self.chartHeight);
    CGPathAddLineToPoint(path, nil, origin.x,origin.y);
    
    // gradient
    if(self.countDown >= self.dictDispPoint.count)[self gradientizefromPoint:CGPointMake(0, self.yMax) toPoint:CGPointMake(0, topMarginInterior+self.chartWidth) forPath:path];
    
    CGPathRelease(path);

}

@end