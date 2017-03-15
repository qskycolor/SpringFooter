//
//  JESpringVerticalFooterView.h
//  JiaeD2C
//
//  Created by gaojuyan on 16/5/12.
//  Copyright © 2016年 www.jiae.com. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^JESpringFooterViewLoadBlock)();

@interface JESpringFooterView : UIView

@property (nonatomic, assign) CGFloat offset;/**drag一定距离触发回调*/
@property (nonatomic, assign, readonly, getter=isReady) BOOL ready;/**标记是否准备好执行block*/
@property (nonatomic, copy) JESpringFooterViewLoadBlock loadBlock;

@end
