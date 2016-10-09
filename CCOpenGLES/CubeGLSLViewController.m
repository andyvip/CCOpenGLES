//
//  CubeGLSLViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "CubeGLSLViewController.h"
#import "ShaderManager.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface CubeGLSLViewController (){
    GLuint _VBO;

    GLKMatrix4 _modelViewProjectionMatrix;
    GLKMatrix3 _normalMatrix;

    int _uModelViewProjectionMatrixIndex;
    int _uNormalMatrixIndex;
}
@property(nonatomic, assign)GLuint program;
@end

@implementation CubeGLSLViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setupGL];
}

-(void)setupGL{
    GLKView *view = (GLKView *)self.view;
    view.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES2];
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    [EAGLContext setCurrentContext:view.context];
    
    GLfloat vertexs[] = {
         0.5f, -0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,    
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  
         0.5f, -0.5f,  0.5f,    1.0f,  0.0f,  0.0f,  
         0.5f,  0.5f,  0.5f,    1.0f,  0.0f,  0.0f,   
         0.5f,  0.5f, -0.5f,    1.0f,  0.0f,  0.0f,  
        
         0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,    
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,   
         0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f,  1.0f,  0.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f,  1.0f,  0.0f,   
        
        -0.5f,  0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,  
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,   
        -0.5f,  0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,    
        -0.5f, -0.5f, -0.5f,   -1.0f,  0.0f,  0.0f,    
        -0.5f, -0.5f,  0.5f,   -1.0f,  0.0f,  0.0f,   
        
        -0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,   
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,    
        -0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,   
         0.5f, -0.5f, -0.5f,    0.0f, -1.0f,  0.0f,    
         0.5f, -0.5f,  0.5f,    0.0f, -1.0f,  0.0f,   
        
         0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,   
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,   
         0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
        -0.5f,  0.5f,  0.5f,    0.0f,  0.0f,  1.0f,    
        -0.5f, -0.5f,  0.5f,    0.0f,  0.0f,  1.0f,   
        
         0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
         0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,    
        -0.5f, -0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
        -0.5f,  0.5f, -0.5f,    0.0f,  0.0f, -1.0f,   
    };
    
    [ShaderManager loadShader:@"CubeShader" progam:&_program];
    glBindAttribLocation(_program, GLKVertexAttribPosition, "aPosition");
    glBindAttribLocation(_program, GLKVertexAttribNormal, "aNormal");
    
    [ShaderManager linkProgram:_program];
    _uModelViewProjectionMatrixIndex = glGetUniformLocation(_program, "uModelViewProjectionMatrix");
    _uNormalMatrixIndex = glGetUniformLocation(_program, "uNormalMatrix");
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
  
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4RotateX(modelViewMatrix, GLKMathDegreesToRadians(30.0f));
    modelViewMatrix = GLKMatrix4RotateY(modelViewMatrix, GLKMathDegreesToRadians(-30.0f));
    
    _normalMatrix = GLKMatrix4GetMatrix3(GLKMatrix4InvertAndTranspose(modelViewMatrix, NULL));
    _modelViewProjectionMatrix = GLKMatrix4Multiply(projectionMatrix, modelViewMatrix);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribNormal);
    glVertexAttribPointer(GLKVertexAttribNormal, 3, GL_FLOAT, GL_FALSE, 6*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glEnable(GL_DEPTH_TEST);
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    glUseProgram(_program);
    
    glUniformMatrix4fv(_uModelViewProjectionMatrixIndex, 1, 0, _modelViewProjectionMatrix.m);
    glUniformMatrix3fv(_uNormalMatrixIndex, 1, 0, _normalMatrix.m);
    
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

-(void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_VBO != 0){
        glDeleteBuffers(1,&_VBO);
        _VBO = 0;
    }
    
    if (_program != 0) {
        glDeleteProgram(_program);
        _program = 0;
    }
    
    [EAGLContext setCurrentContext:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
