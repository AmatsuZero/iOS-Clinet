//
//  DJTextDisplay.m
//  baoliaoxianfeng
//
//  Created by ios-yf on 16/5/30.
//  Copyright © 2016年 OneManArmy. All rights reserved.
//

#import "DJTextDisplay.h"
#import "DJCoreTextImageData.h"
#import "Masonry.h"
#import <CoreText/CoreText.h>
#import "DJMagnifiedViewr.h"
#import "DJAPPUtility.h"

NSString *const DJCTDisplayViewImagePressedNotification = @"DJCTDisplayViewImagePressedNotification";
NSString *const DJCTDisplayViewLinkPressedNotification = @"DJCTDisplayViewLinkPressedNotification";

typedef enum DJCTDisplayViewState : NSInteger {
    DJCTDisplayViewStateNormal,       // 普通状态
    DJCTDisplayViewStateTouching,     // 正在按下，需要弹出放大镜
    DJCTDisplayViewStateSelecting     // 选中了一些文本，需要弹出复制菜单
}DJCTDisplayViewState;

#define ANCHOR_TARGET_TAG 1
#define FONT_HEIGHT  40

@interface DJTextDisplay ()<UIGestureRecognizerDelegate,DJCoreTextImageDataDelegate>
@property (nonatomic) NSInteger selectionStartPosition;
@property (nonatomic) NSInteger selectionEndPosition;
@property (nonatomic) DJCTDisplayViewState state;
@property (strong, nonatomic) UIImageView *leftSelectionAnchor;
@property (strong, nonatomic) UIImageView *rightSelectionAnchor;
@property (strong, nonatomic) DJMagnifiedViewr *magnifierView;
/**
 *  添加点击事件支持
 */
- (void)setupEvents;
/**
 *  点击事件回调
 */
- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer;

@end

@implementation DJTextDisplay

- (id)init {
    if (self = [super init]) {
        [self setupEvents];
    }
    return self;
}

-(DJMagnifiedViewr *)magnifierView
{
    if (!_magnifierView) {
        _magnifierView = [[DJMagnifiedViewr alloc]init];
        _magnifierView.viewToMagnify = self;
        [self addSubview:_magnifierView];
    }
    return _magnifierView;
}

-(void)setData:(DJCoreTextData *)data
{
    _data = data;
    self.state = DJCTDisplayViewStateNormal;
    [self updateConstraints:^(MASConstraintMaker *make) {
      make.height.mas_equalTo(data.height);
    }];
    [self setNeedsDisplay];
}

- (void)setState:(DJCTDisplayViewState)state {
    if (_state == state) {
        return;
    }
    _state = state;
    if (_state == DJCTDisplayViewStateNormal) {
        _selectionStartPosition = -1;
        _selectionEndPosition = -1;
        [self removeSelectionAnchor];
        [self removeMaginfierView];
        [self hideMenuController];
    } else if (_state == DJCTDisplayViewStateTouching) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
    } else if (_state == DJCTDisplayViewStateSelecting) {
        if (_leftSelectionAnchor == nil && _rightSelectionAnchor == nil) {
            [self setupAnchors];
        }
        if (_leftSelectionAnchor.tag != ANCHOR_TARGET_TAG && _rightSelectionAnchor.tag != ANCHOR_TARGET_TAG) {
            [self removeMaginfierView];
            [self hideMenuController];
        }
    }
    [self setNeedsDisplay];
}

#pragma mark -- 绘制相关
- (void)fillSelectionAreaInRect:(CGRect)rect {
    UIColor *bgColor = RGB(204, 221, 236);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor.CGColor);
    CGContextFillRect(context, rect);
}

- (void)drawSelectionArea {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
            break;
        }
        // 2. start和end不在一个line
        // 2.1 如果start在line中，则填充Start后面部分区域
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.2 如果 start在line前，end在line后，则填充整个区域
        else if (_selectionStartPosition < range.location && _selectionEndPosition >= range.location + range.length) {
            CGFloat ascent, descent, leading, width;
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, width, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        } // 2.3 如果start在line前，end在line中，则填充end前面的区域,break
        else if (_selectionStartPosition < range.location && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x, linePoint.y - descent, offset, ascent + descent);
            [self fillSelectionAreaInRect:lineRect];
        }
    }
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    if (self.data == nil) {
        return;
    }
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    if (self.state == DJCTDisplayViewStateTouching || self.state == DJCTDisplayViewStateSelecting) {
        [self drawSelectionArea];
        [self drawAnchors];
    }
    
    CTFrameDraw(self.data.ctFrame, context);
    
    for (DJCoreTextImageData * imageData in self.data.imageArray) {
        imageData.delegate = self;
        UIImage *image = [UIImage imageWithContentsOfFile:imageData.picURL];
        if (image) {
            CGContextDrawImage(context, imageData.imagePosition, image.CGImage);
        }
    }
}

- (void)drawAnchors {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return;
    }
    
    // 翻转坐标系
    CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
    transform = CGAffineTransformScale(transform, 1.f, -1.f);
    
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            CGRect originFra = _leftSelectionAnchor.frame;
            originFra.origin = origin;
            _leftSelectionAnchor.frame = originFra;
        }
        if ([self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGPoint origin = CGPointMake(linePoint.x + offset - 5, linePoint.y + ascent + 11);
            origin = CGPointApplyAffineTransform(origin, transform);
            CGRect originFra = _rightSelectionAnchor.frame;
            originFra.origin = origin;
            _rightSelectionAnchor.frame = originFra;
            break;
        }
    }
}

- (BOOL)isPosition:(NSInteger)position inRange:(CFRange)range {
    if (position >= range.location && position < range.location + range.length) {
        return YES;
    } else {
        return NO;
    }
}
#pragma mark -- 菜单相关
- (void)setupAnchors {
    _leftSelectionAnchor = [self createSelectionAnchorWithTop:YES];
    _rightSelectionAnchor = [self createSelectionAnchorWithTop:NO];
    [self addSubview:_leftSelectionAnchor];
    [self addSubview:_rightSelectionAnchor];
}

- (UIImage *)cursorWithFontHeight:(CGFloat)height isTop:(BOOL)top {
    // 22
    CGRect rect = CGRectMake(0, 0, 22, height * 2);
    UIColor *color = RGB(28, 107, 222);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    // draw point
    if (top) {
        CGContextAddEllipseInRect(context, CGRectMake(0, 0, 22, 22));
    } else {
        CGContextAddEllipseInRect(context, CGRectMake(0, height * 2 - 22, 22, 22));
    }
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillPath(context);
    // draw line
    [color set];
    CGContextSetLineWidth(context, 4);
    CGContextMoveToPoint(context, 11, 22);
    CGContextAddLineToPoint(context, 11, height * 2 - 22);
    CGContextStrokePath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}



- (void)showMenuController {
    if ([self becomeFirstResponder]) {
        CGRect selectionRect = [self rectForMenuController];
        // 翻转坐标系
        CGAffineTransform transform =  CGAffineTransformMakeTranslation(0, self.bounds.size.height);
        transform = CGAffineTransformScale(transform, 1.f, -1.f);
        selectionRect = CGRectApplyAffineTransform(selectionRect, transform);
        //菜单类
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        UIMenuItem* copyItem = [[UIMenuItem alloc]initWithTitle:@"复制" action:@selector(copyItemClicked:)];
        UIMenuItem* resendItem = [[UIMenuItem alloc]initWithTitle:@"分享" action:@selector(shareItemClicked:)];
        [theMenu setMenuItems:@[copyItem,resendItem]];
        [theMenu setTargetRect:selectionRect inView:self];
        [theMenu setMenuVisible:YES animated:YES];
    }
}

- (void)hideMenuController {
    if ([self resignFirstResponder]) {
        UIMenuController *theMenu = [UIMenuController sharedMenuController];
        [theMenu setMenuVisible:NO animated:YES];
    }
}

- (CGRect)rectForMenuController {
    if (_selectionStartPosition < 0 || _selectionEndPosition > self.data.content.length) {
        return CGRectZero;
    }
    CTFrameRef textFrame = self.data.ctFrame;
    CFArrayRef lines = CTFrameGetLines(self.data.ctFrame);
    if (!lines) {
        return CGRectZero;
    }
    CFIndex count = CFArrayGetCount(lines);
    // 获得每一行的origin坐标
    CGPoint origins[count];
    CTFrameGetLineOrigins(textFrame, CFRangeMake(0,0), origins);
    
    CGRect resultRect = CGRectZero;
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 1. start和end在一个line,则直接弄完break
        if ([self isPosition:_selectionStartPosition inRange:range] && [self isPosition:_selectionEndPosition inRange:range]) {
            CGFloat ascent, descent, leading, offset, offset2;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            offset2 = CTLineGetOffsetForStringIndex(line, _selectionEndPosition, NULL);
            CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, offset2 - offset, ascent + descent);
            resultRect = lineRect;
            break;
        }
    }
    if (!CGRectIsEmpty(resultRect)) {
        return resultRect;
    }
    
    // 2. start和end不在一个line
    for (int i = 0; i < count; i++) {
        CGPoint linePoint = origins[i];
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFRange range = CTLineGetStringRange(line);
        // 如果start在line中，则记录当前为起始行
        if ([self isPosition:_selectionStartPosition inRange:range]) {
            CGFloat ascent, descent, leading, width, offset;
            offset = CTLineGetOffsetForStringIndex(line, _selectionStartPosition, NULL);
            width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
            CGRect lineRect = CGRectMake(linePoint.x + offset, linePoint.y - descent, width - offset, ascent + descent);
            resultRect = lineRect;
        }
    }
    return resultRect;
}

- (void)removeSelectionAnchor {
    if (_leftSelectionAnchor) {
        [_leftSelectionAnchor removeFromSuperview];
        _leftSelectionAnchor = nil;
    }
    if (_rightSelectionAnchor) {
        [_rightSelectionAnchor removeFromSuperview];
        _rightSelectionAnchor = nil;
    }
}

- (void)removeMaginfierView {
    if (_magnifierView) {
        [_magnifierView removeFromSuperview];
        _magnifierView = nil;
    }
}
#pragma mark -- 手势相关
- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    debugMethod();
    if (action == @selector(copyItemClicked:) || action == @selector(shareItemClicked:)) {
        return YES;
    }
    return NO;
}

- (void)setupEvents {
    UIGestureRecognizer * tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                  action:@selector(userTapGestureDetected:)];
    [self addGestureRecognizer:tapRecognizer];
    
    UIGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                                                             action:@selector(userLongPressedGuestureDetected:)];
    [self addGestureRecognizer:longPressRecognizer];
    
    UIGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(userPanGuestureDetected:)];
    [self addGestureRecognizer:panRecognizer];
    
    self.userInteractionEnabled = YES;
}

- (void)userTapGestureDetected:(UIGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    if (_state == DJCTDisplayViewStateNormal) {
        for (DJCoreTextImageData * imageData in self.data.imageArray) {
            // 翻转坐标系，因为imageData中的坐标是CoreText的坐标系
            CGRect imageRect = imageData.imagePosition;
            CGPoint imagePosition = imageRect.origin;
            imagePosition.y = self.bounds.size.height - imageRect.origin.y - imageRect.size.height;
            CGRect rect = CGRectMake(imagePosition.x, imagePosition.y, imageRect.size.width, imageRect.size.height);
            // 检测点击位置 Point 是否在rect之内
            if (CGRectContainsPoint(rect, point)) {
                NSLog(@"hint image");
                // 在这里处理点击后的逻辑
                NSDictionary *userInfo = @{ @"imageData": imageData };
                [[NSNotificationCenter defaultCenter] postNotificationName:DJCTDisplayViewImagePressedNotification
                                                                    object:self userInfo:userInfo];
                return;
            }
        }
        
        DJCoreTextLinkData *linkData = [DJAPPUtility touchLinkInView:self atPoint:point data:self.data];
        if (linkData) {
            NSLog(@"hint link!");
            NSDictionary *userInfo = @{ @"linkData": linkData };
            [[NSNotificationCenter defaultCenter] postNotificationName:DJCTDisplayViewLinkPressedNotification
                                                                object:self userInfo:userInfo];
            return;
        }
    } else {
        self.state = DJCTDisplayViewStateNormal;
    }
}

- (void)userLongPressedGuestureDetected:(UILongPressGestureRecognizer *)recognizer {
    CGPoint point = [recognizer locationInView:self];
    debugMethod();
    debugLog(@"state = %li", (long)recognizer.state);
    debugLog(@"point = %@", NSStringFromCGPoint(point));
    if (recognizer.state == UIGestureRecognizerStateBegan ||
        recognizer.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [DJAPPUtility touchContentOffsetInView:self atPoint:point data:self.data];
        if (index != -1 && index < self.data.content.length) {
            _selectionStartPosition = index;
            _selectionEndPosition = index + 2;
        }
        self.magnifierView.touchPoint = point;
        self.state = DJCTDisplayViewStateTouching;
    } else {
        if (_selectionStartPosition >= 0 && _selectionEndPosition <= self.data.content.length) {
            self.state = DJCTDisplayViewStateSelecting;
            [self showMenuController];
        } else {
            self.state = DJCTDisplayViewStateNormal;
        }
    }
}

- (void)userPanGuestureDetected:(UIGestureRecognizer *)recognizer {
    if (self.state == DJCTDisplayViewStateNormal) {
        return;
    }
    CGPoint point = [recognizer locationInView:self];
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        if (_leftSelectionAnchor && CGRectContainsPoint(CGRectInset(_leftSelectionAnchor.frame, -25, -6), point)) {
            debugLog(@"try to move left anchor");
            _leftSelectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        } else if (_rightSelectionAnchor && CGRectContainsPoint(CGRectInset(_rightSelectionAnchor.frame, -25, -6), point)) {
            debugLog(@"try to move right anchor");
            _rightSelectionAnchor.tag = ANCHOR_TARGET_TAG;
            [self hideMenuController];
        }
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {
        CFIndex index = [DJAPPUtility touchContentOffsetInView:self atPoint:point data:self.data];
        if (index == -1) {
            return;
        }
        if (_leftSelectionAnchor.tag == ANCHOR_TARGET_TAG && index < _selectionEndPosition) {
            debugLog(@"change start position to %ld", index);
            _selectionStartPosition = index;
            self.magnifierView.touchPoint = point;
            [self hideMenuController];
        } else if (_rightSelectionAnchor.tag == ANCHOR_TARGET_TAG && index > _selectionStartPosition) {
            debugLog(@"change end position to %ld", index);
            _selectionEndPosition = index;
            self.magnifierView.touchPoint = point;
            [self hideMenuController];
        }
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded ||
               recognizer.state == UIGestureRecognizerStateCancelled) {
        debugLog(@"end move");
        _leftSelectionAnchor.tag = 0;
        _rightSelectionAnchor.tag = 0;
        [self removeMaginfierView];
        [self showMenuController];
    }
    
    [self setNeedsDisplay];
}
//创建长按选中
- (UIImageView *)createSelectionAnchorWithTop:(BOOL)isTop {
    UIImage *image = [self cursorWithFontHeight:FONT_HEIGHT isTop:isTop];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame = CGRectMake(0, 0, 11, FONT_HEIGHT);
    return imageView;
}

#pragma mark -- 呼出菜单操作事件
//复制操作
-(void)copyItemClicked:(id)sender
{
    debugLog(@"点击了复制！");
    NSLog(@"%@",[self.data.content attributedSubstringFromRange:NSMakeRange(_selectionStartPosition, _selectionEndPosition-_selectionStartPosition)]);
    [UIPasteboard generalPasteboard].string = [NSString stringWithFormat:@"%@",[self.data.content attributedSubstringFromRange:NSMakeRange(_selectionStartPosition, _selectionEndPosition-_selectionStartPosition)]];
    
}
//共享操作
-(void)shareItemClicked:(id)sender
{
    debugLog(@"点击了分享！");
    //待实现shareExtension
}

#pragma mark -- 图片数据代理方法
-(void)coretextImgData:(DJCoreTextImageData *)imgdata replceWithNewImg:(NSString*)newURL
{
    imgdata.picURL = newURL;
    
    [self setNeedsDisplay];
}

@end
