//
//  LOGOViewController.m
//  CCOpenGLES
//
//  Created by wsk on 16/10/9.
//  Copyright © 2016年 cyd. All rights reserved.
//

#import "LOGOViewController.h"

#define BUFFER_OFFSET(i) ((char *)NULL + (i))

@interface LOGOViewController ()
{
    GLuint _VBO;
}

@property(nonatomic, strong)GLKBaseEffect *effect;

@end

@implementation LOGOViewController

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
         0.5f, -0.5f, -0.5f,    0,1,0,1,   
         0.5f,  0.5f, -0.5f,    0,0,1,1, 
         0.5f, -0.5f,  0.5f,    1,0,0,1,
         0.5f, -0.5f,  0.5f,    1,0,0,1,
         0.5f,  0.5f,  0.5f,    0,0,0,1,
         0.5f,  0.5f, -0.5f,    0,0,1,1,
        
         0.5f,  0.5f, -0.5f,    0,0,1,1,  
        -0.5f,  0.5f, -0.5f,    249/255.f,193/255.f,25/255.f,1, 
         0.5f,  0.5f,  0.5f,    0,0,0,1,
         0.5f,  0.5f,  0.5f,    0,0,0,1,
        -0.5f,  0.5f, -0.5f,    249/255.f,193/255.f,25/255.f,1,
        -0.5f,  0.5f,  0.5f,    203/255.f,26/255.f,143/255.f,1,
        
        -0.5f,  0.5f, -0.5f,    203/255.f,26/255.f,143/255.f,1,
        -0.5f, -0.5f, -0.5f,    0,0,0,1,
        -0.5f,  0.5f,  0.5f,    203/255.f,26/255.f,143/255.f,1,
        -0.5f,  0.5f,  0.5f,    203/255.f,26/255.f,143/255.f,1,
        -0.5f, -0.5f, -0.5f,    0,0,0,1,
        -0.5f, -0.5f,  0.5f,    1,0,0,1,
         
        -0.5f, -0.5f, -0.5f,    1,0,0,1,
         0.5f, -0.5f, -0.5f,    0,1,0,1,  
        -0.5f, -0.5f,  0.5f,    1,0,0,1,
        -0.5f, -0.5f,  0.5f,    1,0,0,1,
         0.5f, -0.5f, -0.5f,    0,1,0,1,
         0.5f, -0.5f,  0.5f,    1,0,0,1,
        
         0.5f,  0.5f,  0.5f,    0,0,0,1,
        -0.5f,  0.5f,  0.5f,    203/255.f,26/255.f,143/255.f,1,
         0.5f, -0.5f,  0.5f,    1,0,0,1,
         0.5f, -0.5f,  0.5f,    1,0,0,1,
        -0.5f,  0.5f,  0.5f,    203/255.f,26/255.f,143/255.f,1,
        -0.5f, -0.5f,  0.5f,    1,0,0,1,
        
         0.5f, -0.5f, -0.5f,    0,1,0,1,
        -0.5f, -0.5f, -0.5f,    0,0,0,1,
         0.5f,  0.5f, -0.5f,    0,0,1,1,
         0.5f,  0.5f, -0.5f,    0,0,1,1,
        -0.5f, -0.5f, -0.5f,    0,0,0,1,
        -0.5f,  0.5f, -0.5f,    249/255.f,193/255.f,25/255.f,1, 
    };
    
    self.effect = [[GLKBaseEffect alloc] init];
    
    float aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(65.0f), aspect, 0.1f, 100.0f);
    self.effect.transform.projectionMatrix = projectionMatrix;
    
    GLKMatrix4 modelViewMatrix = GLKMatrix4MakeTranslation(0.0f, 0.0f, -5.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(30.0f), 1.0f, 0.0f, 0.0f);
    modelViewMatrix = GLKMatrix4Rotate(modelViewMatrix, GLKMathDegreesToRadians(-45.0f), 0.0f, 1.0f, 0.0f);
    self.effect.transform.modelviewMatrix = modelViewMatrix;
    
    glEnable(GL_DEPTH_TEST);
    
    glGenBuffers(1, &_VBO);
    glBindBuffer(GL_ARRAY_BUFFER, _VBO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexs), vertexs, GL_STATIC_DRAW);
    
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, 7*sizeof(GLfloat), BUFFER_OFFSET(0));
    
    glEnableVertexAttribArray(GLKVertexAttribColor);
    glVertexAttribPointer(GLKVertexAttribColor, 4, GL_FLOAT, GL_FALSE, 7*sizeof(GLfloat), BUFFER_OFFSET(3*sizeof(GLfloat)));
}

-(void)glkView:(GLKView *)view drawInRect:(CGRect)rect{
    
    glClearColor(0xeb/255.f, 0xf5/255.f, 0xff/255.f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    
    [self.effect prepareToDraw];
    glDrawArrays(GL_TRIANGLES, 0, 36);
}

- (void)dealloc
{
    [EAGLContext setCurrentContext:((GLKView *)self.view).context];
    if (_VBO != 0){
        glDeleteBuffers (1,&_VBO);
        _VBO = 0;
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
