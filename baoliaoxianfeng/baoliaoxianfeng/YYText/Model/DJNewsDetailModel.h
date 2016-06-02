//
//  DJNewsDetailModel.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    DJNewsModelTypeImg = 0,
    DJNewsModelTypeText = 1,
    DJNewsModelTypeLink = 2,
} DJNewsModelType;

@interface DJNewsDetailModel : NSObject

@property(nonatomic, assign) DJNewsModelType type;
@property(nonatomic, copy)   NSString* url;
@property(nonatomic, assign) CGFloat size;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, strong) UIColor* color;
@property(nonatomic, copy)   NSString* content;

-(instancetype)initWithDict:(NSDictionary*)dic;

@end
