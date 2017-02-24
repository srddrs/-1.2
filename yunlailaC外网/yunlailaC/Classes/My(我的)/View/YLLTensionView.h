//
//  YLLTensionView.h
//  yunlailaC
//
//  Created by admin on 16/7/12.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    localImage,
    netImage
    
}ISLocalImage;
@interface YLLTensionView : UIView

/**
 *  初始化
 *
 *  @param frame     frame
 *  @param imageName 图片名字
 *
 *  @return self
 */
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSString *)imageName;

/**
 *  加载的网络图片拉伸
 *
 *  @param frame       frame
 *  @param imageUrl
 *  @param placeholder placeholder description
 *
 *  @return return value description
 */
- (instancetype) initWithFrame:(CGRect)frame WithImages:(NSURL *)imageUrl PlaceholderImage:(UIImage *)placeholder;

/**
 *  放大方法
 *
 *  @param offset 滚动的offset
 */
- (void)imageViewStretchingWithOffSet:(CGFloat)offset;

@end
