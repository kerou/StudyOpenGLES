//
//  GLESUtils.h
//  Tutorial01
//
//  Created by gw_ysy on 14-4-16.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <OpenGLES/ES2/gl.h>

@interface GLESUtils : NSObject

// 创建着色器
// string
+ (GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString;
// file path
+ (GLuint)loadShader:(GLenum)type withFilePath:(NSString *)shaderFilePath;


@end
