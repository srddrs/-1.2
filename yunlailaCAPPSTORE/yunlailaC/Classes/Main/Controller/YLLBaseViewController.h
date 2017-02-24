//
//  YLLBaseViewController.h
//  yunlailaC
//
//  Created by admin on 16/7/11.
//  Copyright © 2016年 com.yunlaila. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef enum
{
    test1,//测试1
    test   //测试2
} RequestTypes;

@protocol BaseHttpRequestDelegate <NSObject>
@optional
- (void)receiveSuccessData:(id)item RequestTypes:(RequestTypes)type;
- (void)receiveFailData:(id)item RequestTypes:(RequestTypes)type;
@end

@interface YLLBaseViewController : UIViewController

@property (nonatomic, assign) id<BaseHttpRequestDelegate> httpRequestDelegate;

@end
