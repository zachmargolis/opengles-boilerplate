/*
 
 File: Shaders.h

 Created by Zach Margolis on 1/22/10
 Copied from Apple, Inc's sample code

*/

#ifndef SHADERS_H
#define SHADERS_H

#include <OpenGLES/ES2/gl.h>
#include <OpenGLES/ES2/glext.h>

/* Shader Utilities */
GLint compileShader(GLuint *shader, GLenum type, GLsizei count, NSString *file);
GLint linkProgram(GLuint prog);
GLint validateProgram(GLuint prog);
void destroyShaders(GLuint vertShader, GLuint fragShader, GLuint prog);

#endif /* SHADERS_H */
