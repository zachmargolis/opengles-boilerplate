/*
 
 File: ES2RendererExample.m

 Created by Zach Margolis on 1/22/10
 Based on Apple, Inc's sample code

*/

#import "ES2RendererExample.h"
#import "Shaders.h"
#include "matrix.h"

// uniform index
enum {
    UNIFORM_MODELVIEW_PROJECTION_MATRIX,
    NUM_UNIFORMS
};
GLint uniforms[NUM_UNIFORMS];

// attribute index
enum {
    ATTRIB_VERTEX,
    ATTRIB_COLOR,
    NUM_ATTRIBUTES
};



@implementation ES2RendererExample

#pragma mark Rendering

- (void)render;
{
    
    // Replace the implementation of this method to do your own custom drawing
    
    const GLfloat squareVertices[] = {
        -0.5f, -0.5f,
        0.5f,  -0.5f,
        -0.5f,  0.5f,
        0.5f,   0.5f,
    };
    const GLubyte squareColors[] = {
        255, 255,   0, 255,
        0,   255, 255, 255,
        0,     0,   0,   0,
        255,   0, 255, 255,
    };

    [self setFramebuffer];
    
    glClearColor(0.5f, 0.4f, 0.5f, 1.0f);
    glClear(GL_COLOR_BUFFER_BIT);
    
    // use shader program
    glUseProgram(program);
    
    // handle viewing matrices
    GLfloat proj[16], modelview[16], modelviewProj[16];
    // setup projection matrix (orthographic)
    mat4f_LoadOrtho(-1.0f, 1.0f, -1.5f, 1.5f, -1.0f, 1.0f, proj);
    // setup modelview matrix (rotate around z)
    mat4f_LoadZRotation(rotz, modelview);
    // projection matrix * modelview matrix
    mat4f_MultiplyMat4f(proj, modelview, modelviewProj);
    rotz += 3.0f * M_PI / 180.0f;
    
    // update uniform values
    glUniformMatrix4fv(uniforms[UNIFORM_MODELVIEW_PROJECTION_MATRIX], 1, GL_FALSE, modelviewProj);
    
    // update attribute values
    glVertexAttribPointer(ATTRIB_VERTEX, 2, GL_FLOAT, 0, 0, squareVertices);
    glEnableVertexAttribArray(ATTRIB_VERTEX);
    glVertexAttribPointer(ATTRIB_COLOR, 4, GL_UNSIGNED_BYTE, 1, 0, squareColors); //enable the normalized flag
    glEnableVertexAttribArray(ATTRIB_COLOR);
    
    // Validate program before drawing. This is a good check, but only really necessary in a debug build.
    // DEBUG macro must be defined in your debug configurations if that's not already the case.
#if defined(DEBUG)
    if (![self validateProgram:program]) {
        NSLog(@"Failed to validate program: %d", program);
        return;
    }
#endif
    
    // draw
    glDrawArrays(GL_TRIANGLE_STRIP, 0, 4);

    [self presentFramebuffer];
}

#pragma mark Shader Methods

- (BOOL)loadShaders;
{
    NSError *error = nil;
    program = [self buildShaderProgramWithVertexShaders:[NSArray arrayWithObject:@"template"] andFragmentShaders:[NSArray arrayWithObject:@"template"] error:&error attributeBlock:^(GLuint prog) {
        // bind attribute locations
        glBindAttribLocation(prog, ATTRIB_VERTEX, "position");
        glBindAttribLocation(prog, ATTRIB_COLOR, "color");
    } uniformBlock:^(GLuint prog) {
         // get uniform locations
        uniforms[UNIFORM_MODELVIEW_PROJECTION_MATRIX] = glGetUniformLocation(prog, "modelViewProjectionMatrix");
    }];

    return YES;
}

- (void)deleteShaders;
{
    // realease the shader program object
    if (program) {
        glDeleteProgram(program);
        program = 0;
    }
}

@end
