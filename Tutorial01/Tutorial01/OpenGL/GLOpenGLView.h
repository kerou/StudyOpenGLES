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

@interface GLOpenGLView : UIView
{


}

@property (strong, nonatomic) CAEAGLLayer *eaglLayer;
@property (strong, nonatomic) EAGLContext *context;
@property (assign, nonatomic) GLuint colorRenderBuffer;
@property (assign, nonatomic) GLuint frameBuffer;


@end
