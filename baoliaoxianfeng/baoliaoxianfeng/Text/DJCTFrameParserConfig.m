//
//  DJCTFrameParserConfig.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJCTFrameParserConfig.h"

@implementation DJCTFrameParserConfig

- (id)init {
    self = [super init];
    if (self) {
        _width = 200.0f;
        _fontSize = 16.0f;
        _lineSpace = 8.0f;
        _textColor = RGB(108, 108, 108);
    }
    return self;
}

@end
