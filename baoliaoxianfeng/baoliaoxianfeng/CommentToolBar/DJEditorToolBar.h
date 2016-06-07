//
//  DJEditorToolBar.h
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/6/3.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DJEditorToolBar;

@protocol DJEditorToolBarDelegate <NSObject>

@optional

-(void)toolBar:(DJEditorToolBar*)toolBar img:(UIImage*)img;

@end

@interface DJEditorToolBar : UIToolbar

@property (nonatomic,weak) id<DJEditorToolBarDelegate> toolBardelegate;

@end
