#import "DependencyInjector.h"
#import "NSObjectAdditions.h"

@interface DependencyInjector ()
@property(nonatomic, strong) NSMutableDictionary* singletons;
@property(nonatomic, strong) DependencyInjector* parent;
@property(nonatomic, strong) NSMutableDictionary* children;
@property(nonatomic, copy) NSString* name;
- (NSString*)classNameAsProperty:(Class)clazz;
- (void)unregisterChild:(NSString*)child;
@end

@implementation DependencyInjector

#pragma mark -
#pragma mark Life cycle

- (id)initWithName:(NSString*)aName {
    self = [super init];

    //SKConditionalLog(@"TraceDependencyInjector", @"DependencyInjector new injector %p",self);

    self.singletons = [NSMutableDictionary dictionary];
    self.children = [NSMutableDictionary dictionary];
    self.name = aName;
    return self;
}

- (id)init {
    return [self initWithName:@"dependencyInjector"];
}

- (void)dealloc {
    if(self.parent) {
        [self.parent unregisterChild:self.name];
    }
}

- (void)unregisterChild:(NSString*)aName {
    NSAssert([self.children objectForKey:aName] != nil, @"Failed to unregister child");
    [self.children removeObjectForKey:aName];
}

#pragma mark -

- (void)setValue:(id)value forKey:(NSString*)key onObject:(id)object {
    //SKConditionalLog(@"TraceDependencyInjector", @"DependencyInjector %@(%p).%@ = %@(%p)", NSStringFromClass([object class]), object, key, NSStringFromClass([value class]), value);

    [object setValue:value forKey:key];
}

- (BOOL)hasSingletonWithName:(NSString*)aName {
    return [self.singletons objectForKey:aName] != nil || [self.parent hasSingletonWithName:aName];
}

- (void)injectObjectToExistingSingletons:(NSObject*)object name:(NSString*)aName {
    for(id singletonName in [self.singletons allKeys]) {
        id singleton = [self.singletons objectForKey:singletonName];
        if([[singleton declaredProperties] containsObject:aName]) {
            [self setValue:object forKey:aName onObject:singleton];
        }
    }
    for(NSValue* childValue in self.children.allValues) {
        [[childValue nonretainedObjectValue] injectObjectToExistingSingletons:object name:aName];
    }
}

- (id)registerSingleton:(NSObject*)object withName:(NSString*)resultName {
    NSAssert3(![self hasSingletonWithName:resultName], @"There is already a registered singleton %@ %p for '%@'", NSStringFromClass([object class]), object, resultName);

    //SKConditionalLog(@"TraceDependencyInjector", @"DependencyInjector registered singleton '%@' %@(%p)", resultName, NSStringFromClass([object class]), object);

    [self autowire:object];
    [self injectObjectToExistingSingletons:object name:resultName];
    [self.singletons setObject:object forKey:resultName];
    return object;
}

- (id)singletonOfClass:(Class)class withName:(NSString*)resultName {
    NSAssert(self.singletons != nil, @"Not initialized");

    if([self.singletons objectForKey:resultName] != nil) {
        return [self.singletons objectForKey:resultName];
    }
    id result = [self createInstanceOfClass:class];
    [self registerSingleton:result withName:resultName];
    return result;
}

- (id)singletonOfClass:(Class)class {
    NSAssert(self.singletons != nil, @"Not initialized");
    NSString* resultName = [self classNameAsProperty:class];
    return [self singletonOfClass:class withName:resultName];
}

- (id)instanceOfClass:(Class)class {
    id result = [class alloc];
    [self autowire:result];
    return result;
}

- (id)createInstanceOfClass:(Class)class {
    id result = [self instanceOfClass:class];
    id initedResult = [result init];
    NSAssert(result == initedResult, @"DependencyInjector doesn't support init returning a different instance than alloc");
    return initedResult;
}

- (id)doAutowire:(NSObject*)object {
    [self.parent doAutowire:object];
    for(NSString* property in [object declaredProperties]) {
        NSObject* value = [_singletons objectForKey:property];
        if(value != nil) {
            [self setValue:value forKey:property onObject:object];
        } else if([property isEqual:self.name]) {
            NSAssert(![object isPropertyRetained:self.name], @"The dependency injector cannot inject itself to a retained property %@.%@, it will cause a leak", NSStringFromClass(object.class), self.name);
            [self setValue:self forKey:self.name onObject:object];
        }
    }
    return object;
}

- (id)autowire:(NSObject*)object {
    //SKConditionalLog(@"TraceDependencyInjector", @"%@ is autowiring %@(%p)", self.name, NSStringFromClass([object class]), object);
    id result = [self doAutowire:object];
    if([result respondsToSelector:@selector(awakeFromAutowire)])
        [result awakeFromAutowire];
    return result;
}

- (id)autowireSubviewsOfView:(UIView*)view {
    UIView* subview;

    for(subview in view.subviews)
        [self autowire:[self autowireSubviewsOfView:subview]];

    return view;
}

- (NSArray*)autowireNibObjects:(NSArray*)objects {
    id object;

    for(object in objects) {
        if([object isKindOfClass:[UIView class]])
            [self autowireSubviewsOfView:object];

        [self autowire:object];
    }

    return objects;
}

- (DependencyInjector*)childDependencyInjectorWithName:(NSString*)aName {
    NSAssert1([self.children objectForKey:aName] == nil, @"There is already a registered singleton with name '%@'", aName);
    DependencyInjector* child = [[self.class alloc] initWithName:aName];
    child.parent = self;
    [self.children setObject:[NSValue valueWithNonretainedObject:child] forKey:aName];

    //SKConditionalLog(@"TraceDependencyInjector", @"DependencyInjector %p is child of %p", child, child.parent);

    return child;
}

- (NSDictionary*)registeredSingletons {
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:self.singletons];
    [result setObject:self forKey:self.name];
    return result;
}

- (NSArray*)loadNibNamed:(NSString*)nibName inBundle:(NSBundle*)bundle owner:(id)owner {
    return [self autowireNibObjects:[bundle loadNibNamed:nibName owner:owner options:nil]];
}

- (NSArray*)loadNibNamed:(NSString*)nibName owner:(id)owner {
    return [self loadNibNamed:nibName inBundle:[NSBundle mainBundle] owner:owner];
}

- (NSArray*)instantiateNib:(UINib*)nib owner:(id)owner {
    return [self autowireNibObjects:[nib instantiateWithOwner:owner options:nil]];
}

- (UITableViewCell*)instantiateCellNib:(UINib*)nib owner:(id)owner {
    NSArray* objects;
    id object;

    objects = [self instantiateNib:nib owner:owner];

    for(object in objects) {
        if([object isKindOfClass:[UITableViewCell class]])
            return object;
    }

    return nil;
}

#pragma mark private methods

- (NSString*)classNameAsProperty:(Class)clazz {
    NSString* className = NSStringFromClass(clazz);
    NSString* key = [className // TODO refactor to NSString
        stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[className substringToIndex:1] lowercaseString]];
    return key;
}

@end
