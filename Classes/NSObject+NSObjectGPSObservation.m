#import <objc/runtime.h>
#import "NSObject+NSObjectGPSObservation.h"

@interface NSObject ()
@property(nonatomic, retain) NSMutableDictionary* observations;
@end

static void* NSObjectGPSObservationContext = nil;

@implementation NSObject (NSObjectGPSObservation)

- (NSMutableDictionary*)observations {
    static void* key;
    id value = objc_getAssociatedObject(self, key);
    if(value != nil)
        return value;
    value = [NSMutableDictionary new];
    objc_setAssociatedObject(self, key, value, OBJC_ASSOCIATION_RETAIN);
    return value;
}

- (id)subjectForKey:(NSValue*)key {
    return [key nonretainedObjectValue];
}

- (id)keyForSubject:(id)subject {
    return [NSValue valueWithNonretainedObject:subject];
}

- (void)unregisterFromAllObservations {
    for(id subjectKey in self.observations.allKeys) {
        [self unregisterAsObserverOf:[self subjectForKey:subjectKey]];
    }
}

- (void)unregisterAsObserverOf:(id)subject {
    if(subject == nil)
        return;
    NSString* subjectKey = [self keyForSubject:subject];
    for(NSString* keyPath in self.observations[subjectKey]) {
        //MLog(@"[%p removeObserver:%p forKeyPath:%@ context:%p]", subject, self, keyPath, &NSObjectGPSObservationContext);
        [subject removeObserver:self forKeyPath:keyPath context:&NSObjectGPSObservationContext];
    }
    [self.observations removeObjectForKey:[self keyForSubject:subjectKey]];
}

- (void)registerAsObserverOf:(id)subject forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options {
    NSString* subjectKey = [self keyForSubject:subject];
    if(self.observations == nil)
        self.observations = [NSMutableDictionary new];
    if(self.observations[subjectKey] == nil)
        self.observations[subjectKey] = [NSMutableSet new];
    [self.observations[subjectKey] addObject:keyPath];
    //MLog(@"[%p addObserver:%p forKeyPath:%@ options:%p context:%p]", subject, self, keyPath, options, &NSObjectGPSObservationContext);
    [subject addObserver:self forKeyPath:keyPath options:options context:&NSObjectGPSObservationContext];
}

- (void)observeValueForKeyPath:(NSString*)keyPath ofObject:(id)subject change:(NSDictionary*)change context:(void*)context {
    if(context != &NSObjectGPSObservationContext)
        [self observeValueForKeyPath:keyPath ofObject:subject change:change context:context];
    NSString* subjectKey = [self keyForSubject:subject];
    NSAssert(self.observations[subjectKey] != nil, @"Unexpected subject");
    NSAssert([self.observations[subjectKey] containsObject:keyPath], @"Unexpected keyPath");

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"

    NSString* selectorName = [NSString stringWithFormat:@"notify%@:", [keyPath stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:[[keyPath substringToIndex:1] capitalizedString]]];
    [self performSelector:NSSelectorFromString(selectorName) withObject:change];
#pragma clang diagnostic pop
}

@end