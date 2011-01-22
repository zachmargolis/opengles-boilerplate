OpenGL ES Boilerplate
===

There are a lot of conflicting OpenGL ES template files out there, and not all are easily extensible. This project aims to cut the crap, and provide a flexible set of OpenGL classes.


Important Pieces
-----
- `EAGLView`: is a `UIView` that takes an `ESRenderer`, allowing drop-in compatibility with any existing UIKit project.
- `ESRenderer`: a protocol that provides a common abstraction for the incompatible ES1 and ES2 implementations.
- `ES1Renderer`: an implementation of the `ESRenderer` protocol with methods appropriate for ES1 devices.
- `ES2Renderer`: same thing, but for ES2.


Renderers
-----
The `ES1Renderer` and `ES2Renderer` classes do not actually draw. They are built to be subclassed, and handle the bulk of "boilerplate" code.

The `ES1RendererExample` and `ES2RendererExample` are subclasses that wrap Apple's sample drawing routines. They demonstrate how to extend the renderers with new drawing code.