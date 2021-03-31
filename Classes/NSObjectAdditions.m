#import <objc/runtime.h>
#import "NSObjectAdditions.h"

static NSMutableDictionary* SKNSObjectAdditionsGlobalPropertiesCache;

@implementation NSObject (SKNSObjectAdditions)

+ (NSMutableDictionary*)propertiesCache {
    if(SKNSObjectAdditionsGlobalPropertiesCache == nil) {
        SKNSObjectAdditionsGlobalPropertiesCache = [NSMutableDictionary dictionary];
    }
    return SKNSObjectAdditionsGlobalPropertiesCache;
}



#pragma mark -

+ (NSSet*)declaredProperties {
    NSSet* cachedProperties = nil;
    NSString* className = NSStringFromClass(self);
    @synchronized(self) {
        cachedProperties = [[self propertiesCache] objectForKey:className];
        if(!cachedProperties) {
            NSMutableSet* result = [NSMutableSet set];
            unsigned int count = 0;
            objc_property_t* props = class_copyPropertyList(self, &count);
            NSUInteger i;
            for(i = 0; i < count; i++) {
                objc_property_t prop = props[i];
                NSString* propName = [NSString stringWithCString:property_getName(prop) encoding:NSASCIIStringEncoding];
                [result addObject:propName];
            }
            if([self superclass] != nil) {
                [result unionSet:[[self superclass] declaredProperties]];
            }
            free(props);
            cachedProperties = result;
            [[self propertiesCache] setObject:cachedProperties forKey:className];
        }
    }
    return cachedProperties;
}


- (NSSet*)declaredProperties {
    return [[self class] declaredProperties];
}


- (BOOL)isPropertyRetained:(NSString*)name {
    objc_property_t prop = class_getProperty([self class], [name UTF8String]);
    NSString* attrs = [NSString stringWithUTF8String:property_getAttributes(prop)];
    return [attrs rangeOfString:@",&,"].location != NSNotFound;
}


+ (NSBundle*)bundleForClassMethod:(SEL)selector {
    Class class;

    class = self;

    do {
        if([self isSelector:selector implementedByClass:object_getClass(class)])
            return [NSBundle bundleForClass:class];
    } while((class = [class superclass]));

    return nil;
}


+ (NSBundle*)bundleForInstanceMethod:(SEL)selector {
    Class class;

    class = self;

    do {
        if([self isSelector:selector implementedByClass:class])
            return [NSBundle bundleForClass:class];
    } while((class = [class superclass]));

    return nil;
}


- (BOOL)isSelector:(SEL)selector implementedByClass:(Class)class {
    Method* methods;
    unsigned int i, count;
    BOOL implemented;

    implemented = NO;
    methods = class_copyMethodList(class, &count);

    if(methods) {
        for(i = 0; i < count; i++) {
            if(method_getName(methods[i]) == selector) {
                implemented = YES;

                break;
            }
        }

        free(methods);
    }

    return implemented;
}


+ (NSArray*)namesOfSettersForPropertiesOfClass:(Class)class {
    NSMutableArray* setterNames;
    NSString* setterName, * propertyName;
    objc_property_t* properties;
    objc_property_attribute_t* attributes;
    unsigned int i, j, propertyCount, attributeCount;

    setterNames = [[NSMutableArray alloc] init];
    properties = class_copyPropertyList(class, &propertyCount);

    for(i = 0; i < propertyCount; i++) {
        setterName = nil;
        attributes = property_copyAttributeList(properties[i], &attributeCount);

        for(j = 0; j < attributeCount; j++) {
            if(strcmp(attributes[j].name, "S") == 0) {
                setterName = [NSString stringWithUTF8String:attributes[j].value];

                break;
            }
        }

        if(!setterName) {
            propertyName = [NSString stringWithUTF8String:property_getName(properties[i])];

            if([propertyName length] > 0) {
                setterName = [NSString stringWithFormat:@"set%@%@:", [[propertyName substringToIndex:1] uppercaseString], [propertyName substringFromIndex:1]];
            } else {
                setterName = [NSString stringWithFormat:@"set%@:", [[propertyName substringToIndex:1] uppercaseString]];
            }
        }

        [setterNames addObject:setterName];
    }

    free(properties);

    return setterNames;
}



#pragma mark -

@end
