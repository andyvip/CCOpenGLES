//
//  ShaderManager.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "ShaderManager.h"

@interface ShaderManager()

@end

@implementation ShaderManager

+ (BOOL)loadShader:(NSString *)shaderName progam:(GLuint *)program{
    GLuint vsh, fsh;
    NSString *vshPath, *fshPath;
    
    vshPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"vsh"];
    if (![self compileShader:&vsh type:GL_VERTEX_SHADER file:vshPath]) {
        return NO;
    }
    
    fshPath = [[NSBundle mainBundle] pathForResource:shaderName ofType:@"fsh"];
    if (![self compileShader:&fsh type:GL_FRAGMENT_SHADER file:fshPath]) {
        return NO;
    }
    
    *program = glCreateProgram();
    glAttachShader(*program, vsh);
    glAttachShader(*program, fsh);
    
    if (vsh) {
        glDeleteShader(vsh);
        vsh = 0;
    }
    if (fsh) {
        glDeleteShader(fsh);
        fsh = 0;
    }
    return YES;
}

+ (BOOL)linkProgram:(GLuint )prog{
    GLint status;
    glLinkProgram(prog);
    
#if defined(DEBUG)
    GLint logLength;
    glGetProgramiv(prog, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetProgramInfoLog(prog, logLength, &logLength, log);
        NSLog(@"Program link：%s", log);
        free(log);
    }
#endif
    
    glGetProgramiv(prog, GL_LINK_STATUS, &status);
    if (status == 0) {
        if (prog) {
            glDeleteProgram(prog);
            prog = 0;
        }
        return NO;
    }
    return YES;
}

+ (BOOL)compileShader:(GLuint *)shader type:(GLenum )type file:(NSString* )file{
    GLint status;
    const GLchar *source;
    
    source = (GLchar *)[[NSString stringWithContentsOfFile:file encoding:NSUTF8StringEncoding error:nil] UTF8String];
    if (!source) {
        NSLog(@"Failed to load vertex shader");
        return NO;
    }
    
    *shader = glCreateShader(type);
    glShaderSource(*shader, 1, &source, NULL);
    glCompileShader(*shader);
    
#if defined(DEBUG)
    GLint logLength;
    glGetShaderiv(*shader, GL_INFO_LOG_LENGTH, &logLength);
    if (logLength > 0) {
        GLchar *log = (GLchar *)malloc(logLength);
        glGetShaderInfoLog(*shader, logLength, &logLength, log);
        NSLog(@"Shader compile：%s", log);
        free(log);
    }
#endif
    
    glGetShaderiv(*shader, GL_COMPILE_STATUS, &status);
    if (status == 0) {
        glDeleteShader(*shader);
        return NO;
    }
    return YES;
}

@end
