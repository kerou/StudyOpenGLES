//
//  GLOpenGLView.m
//  Tutorial01
//
//  Created by gw_ysy on 14-4-11.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import "GLOpenGLView.h"

@interface  GLOpenGLView()

// 设置layer属性
- (void)setupLayer;

@end


@implementation GLOpenGLView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

// 为了让 UIView 显示 opengl 内容，我们必须将默认的 layer 类型修改为 CAEAGLLayer 类型
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// 设置layer属性
- (void)setupLayer
{


}




@end
