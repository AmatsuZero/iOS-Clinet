//
//  SHNewsContentMgr.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DJNewsDetailModel;
@class DJTextImg;

@class DJNewsContentMgr;

@protocol DJNewsContentMgrDelegate <NSObject>

-(void)contentMgr:(DJNewsContentMgr*)mgr refreshWithNewContent:(NSAttributedString*)attrStr;

@end

@interface DJNewsContentMgr : NSObject

@property(nonatomic, copy) NSAttributedString* textContent;

@property(nonatomic,weak) id <DJNewsContentMgrDelegate> delegate;

@end
