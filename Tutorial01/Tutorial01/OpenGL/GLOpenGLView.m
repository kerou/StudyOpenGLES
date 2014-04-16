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

@synthesize eaglLayer;
@synthesize context;
@synthesize frameBuffer,colorRenderBuffer;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [self setupLayer];
    [self setupContext];
    [self destoryRenderAndFrameBuffer];
    [self setupRenderBuffer];
    [self setupFrameBuffer];
    [self render];
}


// 为了让 UIView 显示 opengl 内容，我们必须将默认的 layer 类型修改为 CAEAGLLayer 类型
+ (Class)layerClass
{
    return [CAEAGLLayer class];
}

// 设置layer属性
- (void)setupLayer
{
    eaglLayer = (CAEAGLLayer *)self.layer;
    // 默认透明 要设置成不透明
    eaglLayer.opaque = YES;
    // 设置描绘属性 不维持渲染内容以及颜色格式为rgba8
    eaglLayer.drawableProperties =@{kEAGLDrawablePropertyRetainedBacking:[NSNumber numberWithBool:NO],
                                     kEAGLDrawablePropertyColorFormat   :kEAGLColorFormatRGBA8};


}

// 设置Open GL渲染上下文EAGLContext
- (void)setupContext
{
    // 指定 Open GL渲染API的版本 这里使用2.0版
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    // 初始化上下文
    context = [[EAGLContext alloc] initWithAPI:api];
    if (! context) {
        NSLog(@"初始化上下文失败！");
        exit(1);
    }
    // 设置为当前上下文
    if (! [EAGLContext setCurrentContext:context]) {
        NSLog(@"设置当前上下文失败！");
        exit(1);
    }
}

// 设置绘制缓冲区
- (void)setupRenderBuffer
{
    // 为RenderBuffer申请一个id "1"代表id个数
    // 注意：返回的 id 不会为0，id 0 是OpenGL ES 保留的，我们也不能使用 id 为0的 renderbuffer
    glGenRenderbuffers(1, &colorRenderBuffer);
    // 将指定的id的renderBuffer设置为当前renderBuffer 参数 target 必须为 GL_RENDERBUFFER
    glBindRenderbuffer(GL_RENDERBUFFER, colorRenderBuffer);
    // 为 color renderbuffer 分配存储空间
    [context renderbufferStorage:GL_RENDERBUFFER fromDrawable:eaglLayer];

}

// 设置管理者 管理color depth stencil
- (void)setupFrameBuffer
{
    // 为frameBuffer申请一个id "1"代表id个数
    // 注意：返回的 id 不会为0，id 0 是OpenGL ES 保留的，我们也不能使用 id 为0的 frameBuffer
    glGenFramebuffers(1, &frameBuffer);
    // 将指定的id的frameBuffer设置为当前frameBuffer 参数 target 必须为 GL_FRAMEBUFFER
    glBindFramebuffer(GL_FRAMEBUFFER, frameBuffer);
    // 将 _colorRenderBuffer 装配到 GL_COLOR_ATTACHMENT0 这个装配点上
    glFramebufferRenderbuffer(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_RENDERBUFFER, colorRenderBuffer);

}

// uiview布局变化时 销毁原来的buffer
- (void)destoryRenderAndFrameBuffer
{
    glDeleteFramebuffers(1, &frameBuffer);
    frameBuffer = 0;
    glDeleteRenderbuffers(1, &colorRenderBuffer);
    colorRenderBuffer = 0;
}

// 绘制
- (void)render
{
    // 用来设置清屏颜色 默认为黑色
    glClearColor(0, 1.0, 0, 1.0);
    // 用来指定要用清屏颜色来清除由mask指定的buffer
    // mask 可以是 GL_COLOR_BUFFER_BIT，GL_DEPTH_BUFFER_BIT和GL_STENCIL_BUFFER_BIT的自由组合
    glClear(GL_COLOR_BUFFER_BIT);
    
    //  在 renderbuffer 可以被呈现之前，必须调用renderbufferStorage:fromDrawable: 为之分配存储空间。在前面设置 drawable 属性时，我们设置 kEAGLDrawablePropertyRetainedBacking 为FALSE，表示不想保持呈现的内容，因此在下一次呈现时，应用程序必须完全重绘一次。将该设置为 TRUE 对性能和资源影像较大，因此只有当renderbuffer需要保持其内容不变时，我们才设置 kEAGLDrawablePropertyRetainedBacking  为 TRUE。
    
    // 将指定 renderbuffer 呈现在屏幕上
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
    
}



@end
