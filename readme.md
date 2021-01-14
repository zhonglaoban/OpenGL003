# 在iOS中如何使用OpenGL给图形添加颜色

有了上一篇的基础，我们就可以画一些简单的图形了，接下来，我们要了解的就是如何给图形上色🎨。步骤很简单：
- 在顶点缓冲区中添加颜色的值
- 将颜色通过管道传给GPU
- 编写GLSL处理数据

## 在顶点缓冲区中添加颜色的值
我们只需要在之前的顶点数组里面，为每个顶点加入一个颜色的数值（rgb）。
```objc
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
```
## 将颜色通过管道传给GPU
`glEnableVertexAttribArray(1)` 表示绑定我们编写的GLSL中的第二个参数（a_Color）。
`glVertexAttribPointer(1, 3, GL_FLOAT, GL_FALSE, 6 * sizeof(float), (void*)(3 * sizeof(float)))` 后面两个参数表示的是步长和偏移，步长是间隔多少空间取一次数据，偏移是指从数据的第几位开始。
```
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
```
## 编写`GLSL`处理数据
这里的`a_Color`和`a_Position`是接收输入的参数，`FragColor`是输出给另外一个shader的参数，我们这里做简单的值传递就可以了。
```C
attribute vec3 a_Position;
attribute vec3 a_Color;

varying lowp vec3 FragColor;

void main(void) {
    gl_Position = vec4(a_Position, 1.0);
    FragColor = a_Color;
}
```
```C
varying lowp vec3 FragColor;

void main(void) {
    gl_FragColor = vec4(FragColor, 0);
}
```
运行项目，可以看到一个彩色的三角形和一个彩色的矩形，它们的顶点颜色就是我们设置的颜色，渲染的时候OpenGL会帮我们计算顶点之间的颜色差值，所以最后就是彩色的。
![截图](https://upload-images.jianshu.io/upload_images/3277096-67def084dce62b61.jpeg?imageMogr2/auto-orient/strip%7CimageView2/2/w/375)

[Github地址](https://github.com/zhonglaoban/OpenGL003)
