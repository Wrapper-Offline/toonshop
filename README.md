# Toonshop
Toonshop is an open-source reconstruction of the Flash components of the GoAnimate software. The project stems from a completion of the original GoAPI and the resulting desire to implement new features in the studio without having to resort to limited, hacky mods done through JPEXS FFDec.

# Building
Each folder in the root directory can be imported as a project in Flash Builder 4.6 or above. From there, the project can be built. Alternatively, you can install the Apache Flex SDK, and build it in VSCode using the AS3 & MXML extension.

# Usage
Toonshop cannot be used as a drop-in replacement for the GoAnimate videomaker. You'll need to be using the latest build of Wrapper: Offline for it to work properly. This is because Toonshop accesses the API through different routes and relies on slight modifications to the theme XMLs to avoid the mess GoAnimate fell into by hardcoding things.
