//
//  OpenGLViewController.m
//  OpenGL001
//
//  Created by 钟凡 on 2020/12/11.
//

#import "OpenGLViewController.h"
#import "ZFShader.h"

@interface OpenGLViewController ()

@property (nonatomic, assign) GLuint triangleVAO;
@property (nonatomic, assign) GLuint rectangleVAO;

@property (nonatomic, strong) ZFShader *triangleShader;
@property (nonatomic, strong) ZFShader *rectangleShader;

@end

@implementation OpenGLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    GLKView *glView = (GLKView *)self.view;
    glView.context = [[EAGLContext alloc] initWithAPI:kEAGLRenderingAPIOpenGLES3];
    [EAGLContext setCurrentContext:glView.context];
    
    [self setupShader];
    [self setupVAO];
}
- (void)setupShader {
    _triangleShader = [[ZFShader alloc] initWithVertexShader:@"triangle.vs" fragmentShader:@"triangle.fs"];
    _rectangleShader = [[ZFShader alloc] initWithVertexShader:@"rectangle.vs" fragmentShader:@"rectangle.fs"];
}
- (void)setupVAO {
    GLfloat triangleVertices[] = {
        //position      color
        -0.4, 0.0, 0.0, 1.0, 0.0, 0.0,
         0.0, 0.4, 0.0, 0.0, 1.0, 0.0,
         0.5, 0.0, 0.0, 0.0, 0.0, 1.0,
    };
    glGenBuffers(1, &_triangleVAO);
    glBindBuffer(GL_ARRAY_BUFFER, _triangleVAO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(triangleVertices), triangleVertices, GL_STATIC_DRAW);
    
    GLfloat rectangleVertices[] = {
        //position       color
        -0.4, -0.4, 0.0, 1.0, 0.0, 0.0,
        -0.4, -0.8, 0.0, 0.0, 1.0, 0.0,
         0.4, -0.8, 0.0, 0.0, 0.0, 1.0,
         0.4, -0.4, 0.0, 0.0, 1.0, 0.0,
    };
    glGenBuffers(1, &_rectangleVAO);
    glBindBuffer(GL_ARRAY_BUFFER, _rectangleVAO);
    glBufferData(GL_ARRAY_BUFFER, sizeof(rectangleVertices), rectangleVertices, GL_STATIC_DRAW);
}
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    GLKView *glView = (GLKView *)self.view;
    [EAGLContext setCurrentContext:glView.context];
    glClearColor(0, 0, 0, 1);
    glClear(GL_COLOR_BUFFER_BIT);
    
    [_triangleShader prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _triangleVAO);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glDrawArrays(GL_TRIANGLES, 0, 3);
    
    [_rectangleShader prepareToDraw];
    glBindBuffer(GL_ARRAY_BUFFER, _rectangleVAO);
    glEnableVertexAttribArray(0);
    glVertexAttribPointer(0, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)0);
    glEnableVertexAttribArray(1);
    glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)));
    glDrawArrays(GL_TRIANGLE_FAN, 0, 4);
}
@end
