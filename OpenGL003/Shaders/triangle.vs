attribute vec3 a_Position;
attribute vec3 a_Color;

varying lowp vec3 FragColor;

void main(void) {
    gl_Position = vec4(a_Position, 1.0);
    FragColor = a_Color;
}
