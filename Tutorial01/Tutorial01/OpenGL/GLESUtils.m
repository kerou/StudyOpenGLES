//
//  GLESUtils.m
//  Tutorial01
//
//  Created by gw_ysy on 14-4-16.
//  Copyright (c) 2014年 GL. All rights reserved.
//

#import "GLESUtils.h"

@implementation GLESUtils

// 创建着色器
// string
+ (GLuint)loadShader:(GLenum)type withString:(NSString *)shaderString
{
    // 创建着色器
    GLuint shader = glCreateShader(type);
    if (shader == 0) {
        NSLog(@"Error: failed to create shader.");
        return 0;
    }
    // 加载资源
    const char *shaderStringUTF8 = [shaderString UTF8String];
    glShaderSource(shader, 1, &shaderStringUTF8, NULL);
    // 完成shader
    glCompileShader(shader);
    // 检查shader状态
    GLint compiled = 0;
    glGetShaderiv(shader, GL_COMPILE_STATUS, &compiled);
    // 状态显示异常 打印log
    if (!compiled) {
        
        GLint infoLen = 0;
        glGetShaderiv(shader, GL_INFO_LOG_LENGTH, &infoLen);
        
        if (infoLen > 1) {
            
            char *infoLog = malloc(sizeof(char)*infoLen);
            glGetShaderInfoLog(shader, infoLen, NULL, infoLog);
            NSLog(@"Error compiling shader:\n%s\n", infoLog );
            free(infoLog);
            
        }
        glDeleteShader(shader);
        return 0;
    }
    
    return shader;
    
}


// file path
+ (GLuint)loadShader:(GLenum)type withFilePath:(NSString *)shaderFilePath
{
    NSError  *error;
    NSString *shaderString = [NSString stringWithContentsOfFile:shaderFilePath
                                                        encoding:NSUTF8StringEncoding
                                                           error:&error];
    if (!shaderString) {
        NSLog(@"Error: loading shader file: %@ %@", shaderFilePath, error.localizedDescription);
        return 0;
    }
    return [self loadShader:type withString:shaderString];
}

@end
