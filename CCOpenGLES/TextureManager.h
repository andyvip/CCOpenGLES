//
//  TextureManager.h
//  CCOpenGLES
//
//  Created by wsk on 16/10/8.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import <GLKit/GLKit.h>

@interface TextureManager : NSObject

+ (void)loadTexture:(GLuint *)textureName image:(UIImage *)image;

@end
