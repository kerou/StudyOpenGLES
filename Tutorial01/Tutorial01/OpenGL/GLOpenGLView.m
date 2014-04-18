//
//  GLOpenGLView.m
//  Tutorial01
//
//  Created by gw_ysy on 14-4-11.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import "GLOpenGLView.h"
#import "GLESUtils.h"


@interface  GLOpenGLView()

// 设置layer属性
- (void)setupLayer;
// 自动旋转
@property (nonatomic, strong) CADisplayLink *displayLink;

@end


@implementation GLOpenGLView

@synthesize eaglLayer;
@synthesize context;
@synthesize frameBuffer,colorRenderBuffer;
@synthesize programHandle,positionSlot,modelViewSlot,projectionSlot;
@synthesize posX,posY,posZ,rotateX,scaleZ;
@synthesize displayLink;

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
    [self setupProgram];
    [self setupProjection];
    [self updateTransfrom];
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
                                    kEAGLDrawablePropertyColorFormat    :kEAGLColorFormatRGBA8};


}

// 设置Open GL渲染上下文EAGLContext
- (void)setupContext
{
    // 指定 Open GL渲染API的版本 这里使用2.0版
    EAGLRenderingAPI api = kEAGLRenderingAPIOpenGLES2;
    // 初始化上下文
    context = [[EAGLContext alloc] initWithAPI:api];
    if (! context)
    {
        NSLog(@"初始化上下文失败！");
        exit(1);
    }
    // 设置为当前上下文
    if (! [EAGLContext setCurrentContext:context])
    {
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
    frameBuffer       = 0;
    glDeleteRenderbuffers(1, &colorRenderBuffer);
    colorRenderBuffer = 0;
}

// 创建程序
- (void)setupProgram
{
    // 加载着色器
    NSString *vertexShaderPath   = [[NSBundle mainBundle] pathForResource:@"VertexShader" ofType:@"glsl"];
    NSString *fragmentShaderPath = [[NSBundle mainBundle] pathForResource:@"FragmentShader" ofType:@"glsl"];
    // 创建program
    programHandle = [GLESUtils loadProgram:vertexShaderPath withFragmentShaderFilepath:fragmentShaderPath];
    if (programHandle == 0) {
        NSLog(@" >> Error: Failed to setup program.");
        return;
    }
    // 运行
    glUseProgram(programHandle);
    // 获取位置属性 slot attribute 位置
    positionSlot = glGetAttribLocation(programHandle, "vPosition");
    // 获取模型 矩阵 位置
    modelViewSlot = glGetUniformLocation(programHandle, "modelView");
    // 获取投影 矩阵 位置
    projectionSlot = glGetUniformLocation(programHandle, "projection");
}

// 绘制3D图形 四棱锥
- (void)drawTriCone
{
    // 存储5个顶点 三个数字一个顶点
    GLfloat vertices[] = {
         0.5f , 0.5f , 0.0f,
         0.5f ,-0.5f , 0.0f,
        -0.5f ,-0.5f , 0.0f,
        -0.5f , 0.5f , 0.0f,
         0.0f , 0.0f , -0.707f
    };
    // 运用下标 组成索引 对应于vertices数组 共八条线
    GLubyte indices[] = {
        0,1,1,2,2,3,3,0,
        4,0,4,1,4,2,4,3
    };
    /*
     * 这种方法也可以绘制三角形
     *
    // 存储3个顶点 三个数字一个顶点
    GLfloat vertices[] = {
        0.0f,  0.5f, 0.0f,
        -0.5f, -0.5f, 0.0f,
        0.5f, -0.5f, 0.0f};
    // 运用下标 组成索引 对应于vertices数组 共八条线
    GLubyte indices[] = {
        0,1,1,2,2,0
    };
    */
    
    /*
     * 这种方法也可以绘制三角形
     *
     // 存储3个顶点 三个数字一个顶点
     GLfloat vertices[] = {
     0.0f,  0.5f, 0.0f,
     -0.5f, -0.5f, 0.0f,
     0.5f, -0.5f, 0.0f};
     // 加载定点数据
     glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
     glEnableVertexAttribArray(positionSlot);
     // 绘制三角形
     glDrawArrays(GL_TRIANGLES, 0, 3);
     */
    
    // 加载定点数据
    glVertexAttribPointer(positionSlot, 3, GL_FLOAT, GL_FALSE, 0, vertices);
    glEnableVertexAttribArray(positionSlot);
    
    // 设置线宽
    glLineWidth(1);
    
    // 绘制
    glDrawElements(GL_LINES, sizeof(indices)/sizeof(GLubyte), GL_UNSIGNED_BYTE, indices);
    
    
    // 获取线宽
    GLfloat lineWidthRange[2];
    glGetFloatv(GL_ALIASED_LINE_WIDTH_RANGE, lineWidthRange);
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
    // 设置 viewport
    glViewport(0, 0, self.frame.size.width, self.frame.size.height);
    
    // 绘制图形
    [self drawTriCone];
    
    // 将指定 renderbuffer 呈现在屏幕上
    [context presentRenderbuffer:GL_RENDERBUFFER];
    
}

// 设置 投影变换
- (void)setupProjection
{
    // 生成一个60角度的投影矩阵
    CGFloat aspect = self.frame.size.width / self.frame.size.height;
    // 单位矩阵
    ksMatrixLoadIdentity(&projectionMatrix);
    // 透视属性设置
    ksPerspective(&projectionMatrix, 60, aspect, 1.0f, 20.f);
    // 加载
    glUniformMatrix4fv(projectionSlot, 1, GL_FALSE, (GLfloat*)&projectionMatrix.m[0][0]);

}

// 更新变换
- (void)updateTransfrom
{
    // 生成模型矩阵属性
    ksMatrixLoadIdentity(&modelViewMatrix);
    //
    ksMatrixTranslate(&modelViewMatrix, posX, posY, posZ);
    //
    ksMatrixRotate(&modelViewMatrix, rotateX, 1.0, 0.0, 0.0);
    //
    ksMatrixScale(&modelViewMatrix, 1.0, 1.0, scaleZ);
    // 加载模型 变换
    glUniformMatrix4fv(modelViewSlot, 1, GL_FALSE, (GLfloat*)&modelViewMatrix.m[0][0]);
    
}
// clear
- (void)clear
{
    [self destoryRenderAndFrameBuffer];
    
    if (programHandle != 0) {
        glDeleteProgram(programHandle);
        programHandle = 0;
    }
    
    if (context && [EAGLContext currentContext] == context)
        [EAGLContext setCurrentContext:nil];
    
    context = nil;

}

@end
