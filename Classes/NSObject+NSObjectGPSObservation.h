@interface NSObject (NSObjectGPSObservation)
- (void)unregisterFromAllObservations;
- (void)unregisterAsObserverOf:(id)subject;
- (void)registerAsObserverOf:(id)subject forKeyPath:(NSString*)keyPath options:(NSKeyValueObservingOptions)options;
@end