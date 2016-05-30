//
//  DJTextDisplay.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJTextDisplay.h"
#import <CoreText/CoreText.h>

@implementation DJTextDisplay

-(void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    if (self.data) {
        CTFrameDraw(self.data.ctFrame, context);
    }
}

@end
