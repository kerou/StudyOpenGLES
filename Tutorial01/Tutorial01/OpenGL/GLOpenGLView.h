//
//  GLOpenGLView.h
//  Tutorial01
//
//  Created by gw_ysy on 14-4-11.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <OpenGLES/ES2/glext.h>
#import <OpenGLES/ES2/gl.h>
#import "ksMatrix.h"

@interface GLOpenGLView : UIView
{
    // 模型视图矩阵
    ksMatrix4 modelViewMatrix;
    // 投影矩阵
    ksMatrix4 projectionMatrix;
    
    ////****05****///
    ksMatrix4 _shoulderModelViewMatrix05;
    ksMatrix4 _elbowModelViewMatrix05;
    float _rotateColorCube05;
    CADisplayLink *displayLink05;
}

@property (strong, nonatomic) CAEAGLLayer *eaglLayer;
@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLuint colorRenderBuffer;
@property (assign, nonatomic) GLuint frameBuffer;
// 绘图属性
@property (assign, nonatomic) GLuint programHandle;
@property (assign, nonatomic) GLuint positionSlot;
@property (assign, nonatomic) GLuint modelViewSlot;
@property (assign, nonatomic) GLuint projectionSlot;
@property (assign, nonatomic) GLuint colorSlot;
// 图像移动 变形
@property (assign, nonatomic) CGFloat posX;     // x 轴上移动
@property (assign, nonatomic) CGFloat posY;     // y 轴上移动
@property (assign, nonatomic) CGFloat posZ;     // z 轴上移动
@property (assign, nonatomic) CGFloat rotateX;  // x 轴上旋转
@property (assign, nonatomic) CGFloat scaleZ;   // z 轴上缩放

// 更新变换
- (void)updateTransfrom;
// 绘制
- (void)render;
// clear
- (void)clear;
// 自动旋转
- (void)displayLinkCallback:(CADisplayLink *)displayLink;
- (void)toggleDisplayLink;

////****05****///
@property (nonatomic,assign) float rotateShoulder05;
@property (nonatomic,assign) float rotateElbow05;
- (void)render05;
- (void)clearup05;
- (void)toggleDisplayLink05;
- (void)updateShoulderTransform05;
- (void)updateElbowTransform05;
- (void)resetTransform05;

- (void)updateRectangleTransform05;
- (void)updateColorCubeTransform05;
- (void)drawColorCube05;

- (void)drawCube05:(ksVec4)color;

@end
