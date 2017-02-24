//
//  WJSegmentMenu.m
//  WJSegmentMenu
//
//  Created by 吴计强 on 16/3/22.
//  Copyright © 2016年 com.firsttruck. All rights reserved.
//

#import "WJSegmentMenu.h"


@interface WJSegmentMenu (){
    
    CGFloat _btnW;
    UIView *_line;
    NSInteger _lastTag;
}

@end

@implementation WJSegmentMenu

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)segmentWithTitles:(NSArray *)titles{
    
    // 创建按钮
    _btnW = 320/titles.count;
    for (int i = 0; i < titles.count; i ++) {
        
        UIButton *button = [[UIButton alloc]init];
        button.tag = 730+i;
        button.frame = CGRectMake(i * _btnW, 0, _btnW, 30-2);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:fontColor forState:UIControlStateNormal];
        [button setTitleColor:titleViewColor forState:UIControlStateSelected];
        button.titleLabel.font = viewFont1;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (button.tag == 730) {
            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
        }

    }
    UIView *fgx = [[UIView alloc] initWithFrame:CGRectMake(320/titles.count, 4, 1, 22)];
    fgx.backgroundColor = bgViewColor;
    [self addSubview:fgx];
    // 创建滑块
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(4, 30-2, _btnW-8, 2);
    line.backgroundColor = titleViewColor;
    [self addSubview:line];
    _line = line;


}
- (void)segmentWithTitles:(NSArray *)titles andIndex:(NSInteger)index
{
    _btnW = 320/titles.count;
    // 创建滑块
    UIView *line = [[UIView alloc]init];
    line.frame = CGRectMake(4, 30-2, _btnW-8, 2);
    line.backgroundColor = titleViewColor;
    [self addSubview:line];
    _line = line;
    for (int i = 0; i < titles.count; i ++) {
        
        UIButton *button = [[UIButton alloc]init];
        button.tag = 730+i;
        button.frame = CGRectMake(i * _btnW, 0, _btnW, 30-2);
        [button setTitle:titles[i] forState:UIControlStateNormal];
        [button setTitleColor:fontColor forState:UIControlStateNormal];
        [button setTitleColor:titleViewColor forState:UIControlStateSelected];
        button.titleLabel.font = viewFont1;
        [button addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
        if (button.tag == 730+index) {
//            [button sendActionsForControlEvents:UIControlEventTouchUpInside];
            [self click:button];
        }
        
    }
    
   

}
// 点击事件
- (void)click:(UIButton *)btn{
    
    if (_lastTag >= 700) {
        UIButton *lastBtn = (id)[self viewWithTag:_lastTag];
        lastBtn.selected = NO;
    }
    btn.selected = YES;
    CGFloat lineX = (btn.tag - 730) * _btnW +4;
    [UIView animateWithDuration:0.25 animations:^{
        CGRect frame = _line.frame;
        frame.origin.x = lineX*APP_DELEGATE().autoSizeScaleX;
        _line.frame = frame;
    }];
    
    _lastTag = btn.tag;
    
    if ([_delegate respondsToSelector:@selector(segmentWithIndex:title:)]) {
        [_delegate segmentWithIndex:(btn.tag-730) title:btn.titleLabel.text];
    }
    
    
}



- (void)layoutSubviews{
    
    
}


@end
