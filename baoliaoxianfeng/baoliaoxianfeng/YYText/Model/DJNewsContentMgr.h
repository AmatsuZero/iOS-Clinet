//
//  SHNewsContentMgr.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/2.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YYText.h"
#import "DJEditorToolBar.h"

@class DJNewsDetailModel;
@class DJTextImg;

@class DJNewsContentMgr;

@protocol DJNewsContentMgrDelegate <NSObject>

-(void)contentMgr:(DJNewsContentMgr*)mgr openLink:(NSURL*)link;
-(void)contentMgr:(DJNewsContentMgr *)mgr ViewImg:(UIImage*)img;

@end

@protocol DJNewsContentSaveDelegate <NSObject>

@optional

@end

@interface DJNewsContentMgr : NSObject<YYTextViewDelegate,DJEditorToolBarDelegate>

@property(nonatomic, strong) NSMutableAttributedString* textContent;

@property(nonatomic,weak) id <DJNewsContentMgrDelegate> delegate;

@property(nonatomic,weak) id <DJNewsContentSaveDelegate>contentKeeper;

//将图像插入当前文本当中
-(void)insertImgintoCurrentTextView:(YYTextView*)text generalFont:(UIFont*)font image:(UIImage*)img;
-(void)saveContent:(NSAttributedString*)content;

@end
