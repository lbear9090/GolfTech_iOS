#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
#pragma clang diagnostic ignored "-Wgcc-compat"
#pragma clang diagnostic ignored "-Wlogical-op-parentheses"
#pragma clang diagnostic ignored "-Wmissing-braces"
#pragma clang diagnostic ignored "-Wfloat-equal"
#pragma clang diagnostic ignored "-Wcovered-switch-default"
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
#pragma clang diagnostic ignored "-Wunreachable-code"
#pragma clang diagnostic ignored "-Wunused-function"
#pragma clang diagnostic ignored "-Wundef"
#pragma clang diagnostic ignored "-Wcast-align"
#import "isgl3d.h"
#pragma clang diagnostic pop

#import "ScrollWheelImpl.h"

static NSString* const ScrollBarHexColor = @"063504";

@implementation ScrollWheelImpl {
    Isgl3dMeshNode* _wheel;
}

+ (id<Isgl3dCamera>)createDefaultSceneCameraForViewport:(CGRect)viewport {
    Isgl3dFocusZoomPerspectiveLens *lens = [[Isgl3dFocusZoomPerspectiveLens alloc] initFromViewSize:viewport.size fovyDegrees:45 nearZ:1.0f farZ:100.0f];
    lens.zoom = 6.6;
    
    Isgl3dVector3 cameraPosition = Isgl3dVector3Make(0.0f, 0.0f, 40.f);
    Isgl3dVector3 cameraLookAt = Isgl3dVector3Make(0.0f, 0.0f, -1.0f); // only direction
    Isgl3dVector3 cameraLookUp = Isgl3dVector3Make(0.0f, 1.0f, 0.0f);
    return [[Isgl3dNodeCamera alloc] initWithLens:lens position:cameraPosition lookAtTarget:cameraLookAt up:cameraLookUp];
}

- (id)init {
    self = [super init];
    CGFloat scale = 1;
    
    Isgl3dTextureMaterial* material = [Isgl3dTextureMaterial materialWithTextureFile:@"skrollhjul.png" shininess:1 precision:Isgl3dTexturePrecisionHigh repeatX:YES repeatY:YES];
    Isgl3dCylinder* wheel = [Isgl3dCylinder meshWithGeometry:1 * 5 * 3.141 * scale radius:2.9 * scale ns:64 nt:32 openEnded:YES];
    _wheel = [self.scene createNodeWithMesh:wheel andMaterial:material];

    Isgl3dLight* light = [Isgl3dLight lightWithHexColor:@"444444" diffuseColor:ScrollBarHexColor specularColor:@"444444" attenuation:0];
    light.lightType = DirectionalLight;
    [light setDirection:0 y:0 z:-1];
    [self.scene addChild:light];

    return self;
}

- (void)rotate:(CGFloat)angle {
    self.currentAngle = -_wheel.rotationY + angle;
    //MLog(@"Requesting to rotate %f",angle);
}

- (void)setCurrentAngle:(CGFloat)newAngle {
    //MLog(@"New angle is %f",newAngle);
    newAngle = fmaxf(_maxAngle, newAngle);
    newAngle = fminf(_minAngle, newAngle);
    _wheel.rotationY = -newAngle;
}

- (CGFloat)currentAngle {
    CGFloat result = -_wheel.rotationY;
    //MLog(@"current angle is %f",result);
    return result;
}

@end

