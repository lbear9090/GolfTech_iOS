/*
 
 Some simple support for dependency injection,
 see http://en.wikipedia.org/wiki/Dependency_injection
 
 Specification of behavior
 
 a new object is                         autowired in    made new        autowired in    made new
 parent          singleton in    child           singleton in
 and is then:                                            parent                          child
 injected to itself                      no              no              no              no
 injected to existing parent objects     no              yes             no              no
 injected from existing parent objects   yes             yes             yes             yes
 registered in parent injector           no              yes             no              no
 injected to existing child objects      no              yes             no              yes
 injected from existing child objects    no              no              yes             yes
 registered in child injector            no              no              no              no
 
 */

@interface DependencyInjector : NSObject {
}

/*
 Aquires an instance of the given class. If an instance of that class has already
 been aquired, the original instance is returned (i.e. the class is treated as a
 singleton.) The instance is registered as a singleton with the name of class, except
 that the initial letter is in lowercase. All writeable properties of the instance that
 matches any singletons registered earlier is initialized to those singletons. Also, any
 previous singletons that has a writable property matching the new singleton will have
 its property initialized to the new singleton.
 */
- (id)singletonOfClass:(Class)aClass;

/*
 Works as singletonOfClass: but the class is registered with the given name
 */
- (id)singletonOfClass:(Class)aClass withName:(NSString*)name;

/*
 Returns a new autowired instance of the class. The instance is not registered.
 */
- (id)createInstanceOfClass:(Class)aClass;

/*
 Returns a new autowired and alloced instance of the class. Receipient needs
 to call init* itself.
 */
- (id)instanceOfClass:(Class)aClass;

/*
 Works as singletonOfClass:withName: but use an existing object as the singleton.
 */
- (id)registerSingleton:(NSObject*)object withName:(NSString*)name;

/*
 Works as singletonOfClass: but no singleton is created, instead an existing instance is
 used only for autowiring all properites.
 Sends -awakeFromAutowire on completion.
 */
- (id)autowire:(NSObject*)object;

/*
 Create a child dependency injector. The child will act as as a subscope to the parent injector.
 All singletons registered in the parent will be visible in the child but not vice versa.
 When the child is released, it releases all properties registered with it. The child will
 register itself with the name given.
 */
- (DependencyInjector*)childDependencyInjectorWithName:(NSString*)name;

/*
 Returns the current list of registered singletons by key.
 */
- (NSDictionary*)registeredSingletons;

/*
 Loads the given nib by given name and owner using the bundle given (or the main bundle if none
 given), and autowires all objects.
 */
- (NSArray*)loadNibNamed:(NSString*)nibName inBundle:(NSBundle*)bundle owner:(id)owner;
- (NSArray*)loadNibNamed:(NSString*)nibName owner:(id)owner;

/*
 Instantiates the objects in a nib and autowires all objects.
 */
- (NSArray*)instantiateNib:(UINib*)nib owner:(id)owner;

/*
 Instantiates the objects in a nib and autowires all, and returns the first top-level
 cell found.
 */
- (UITableViewCell*)instantiateCellNib:(UINib*)nib owner:(id)owner;

@end


@interface NSObject (DependencyInjector)

/*
 Sent after the receiver has been autowired.
 */
- (void)awakeFromAutowire;

@end
