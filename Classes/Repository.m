#import <CoreData/CoreData.h>
#import "Repository.h"
#import "Category.h"
#import "Result.h"
#import "Recording.h"
#import "ProVideo.h"

static NSString* const IsFirstRun = @"IsFirstRun";

@implementation Repository

- (id)init {
    self = [super init];
    return self;
}

#pragma mark Categories

- (Category*)categoryWithId:(NSString*)code name:(NSString*)name product:(NSString*)product addTo:(NSMutableArray*)categories {
    [self assertMainThread];
    Category* result = [self.dependencyInjector createInstanceOfClass:[Category class]];
    result.code = code;
    result.title = name;
    [categories addObject:result];
    return result;
}

- (NSArray*)findCategories {
    [self assertMainThread];
    static NSMutableArray* categories = nil;
    if(categories != nil)
        return categories;
    categories = [NSMutableArray array];

    Category* nytt = [self categoryWithId:@"ny" name:NSLocalizedString(@"Nytt", nil) product:@"nytt1" addTo:categories];
    Category* drive = [self categoryWithId:@"dr" name:NSLocalizedString(@"Drive", nil) product:@"drive1" addTo:categories];
    Category* putt = [self categoryWithId:@"pu" name:NSLocalizedString(@"Putt", nil) product:nil addTo:categories];
    Category* chip = [self categoryWithId:@"c" name:NSLocalizedString(@"Chip", nil) product:@"chip1" addTo:categories];
    Category* bunker = [self categoryWithId:@"b" name:NSLocalizedString(@"Bunker", nil) product:@"bunker1" addTo:categories];
    Category* pitch = [self categoryWithId:@"pi" name:NSLocalizedString(@"Pitch", nil) product:@"pitch1" addTo:categories];

    [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Nytt nivå 1 teknik 1 sammanfattning", nil) level:1 to:nytt];
    [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Nytt nivå 1 teknik 2 sammanfattning", nil) level:1 to:nytt];
    [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Nytt nivå 1 teknik 3 sammanfattning", nil) level:1 to:nytt];
    [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Nytt nivå 2 teknik 1 sammanfattning", nil) level:2 to:nytt];
    // [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Nytt nivå 2 teknik 2 sammanfattning", nil) level:2 to:drive];
    // [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Nytt nivå 2 teknik 3 //sammanfattning", nil) level:2 to:drive];
    // [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Nytt nivå 3 teknik 1 sammanfattning", nil) level:3 to:drive];
    // [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Nytt nivå 3 teknik 2 sammanfattning", nil) level:3 to:drive];
    // [self addTechniqueWithName:NSLocalizedString(@"Nytt nivå 3 teknik 3", nil) summary:NSLocalizedString(@"Nytt nivå 3 teknik 3 sammanfattning", nil) level:3 to:drive];
    
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Drive nivå 1 teknik 1 sammanfattning", nil) level:1 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Drive nivå 1 teknik 2 sammanfattning", nil) level:1 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Drive nivå 1 teknik 3 sammanfattning", nil) level:1 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Drive nivå 2 teknik 1 sammanfattning", nil) level:2 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Drive nivå 2 teknik 2 sammanfattning", nil) level:2 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Drive nivå 2 teknik 3 sammanfattning", nil) level:2 to:drive];
    [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Drive nivå 3 teknik 1 sammanfattning", nil) level:3 to:drive];
    // [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Drive nivå 3 teknik 2 sammanfattning", nil) level:3 to:drive];
   // [self addTechniqueWithName:NSLocalizedString(@"Drive nivå 3 teknik 3", nil) summary:NSLocalizedString(@"Drive nivå 3 teknik 3 sammanfattning", nil) level:3 to:drive];
    
    [self addEvaluationWithName:NSLocalizedString(@"Putt utvärdering", nil) summary:NSLocalizedString(@"Putt utvärdering sammanfattning", nil) to:putt];
    [self addExerciseWithName:NSLocalizedString(@"Putt övning 1", nil) summary:NSLocalizedString(@"Putt övning 1 sammanfattning", nil) to:putt];
    [self addExerciseWithName:NSLocalizedString(@"Putt övning 2", nil) summary:NSLocalizedString(@"Putt övning 2 sammanfattning", nil) to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Putt nivå 1 teknik 1 sammanfattning", nil) level:1 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Putt nivå 1 teknik 2 sammanfattning", nil) level:1 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Putt nivå 1 teknik 3 sammanfattning", nil) level:1 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Putt nivå 2 teknik 1 sammanfattning", nil) level:2 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Putt nivå 2 teknik 2 sammanfattning", nil) level:2 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Putt nivå 2 teknik 3 sammanfattning", nil) level:2 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Putt nivå 3 teknik 1 sammanfattning", nil) level:3 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Putt nivå 3 teknik 2 sammanfattning", nil) level:3 to:putt];
    [self addTechniqueWithName:NSLocalizedString(@"Putt nivå 3 teknik 3", nil) summary:NSLocalizedString(@"Putt nivå 3 teknik 3 sammanfattning", nil) level:3 to:putt];

    [self addEvaluationWithName:NSLocalizedString(@"Chip utvärdering", nil) summary:NSLocalizedString(@"Chip utvärdering sammanfattning", nil) to:chip];
    [self addExerciseWithName:NSLocalizedString(@"Chip övning 1", nil) summary:NSLocalizedString(@"Chip övning 1 sammanfattning", nil) to:chip];
    [self addExerciseWithName:NSLocalizedString(@"Chip övning 2", nil) summary:NSLocalizedString(@"Chip övning 2 sammanfattning", nil) to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Chip nivå 1 teknik 1 sammanfattning", nil) level:1 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Chip nivå 1 teknik 2 sammanfattning", nil) level:1 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Chip nivå 1 teknik 3 sammanfattning", nil) level:1 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Chip nivå 2 teknik 1 sammanfattning", nil) level:2 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Chip nivå 2 teknik 2 sammanfattning", nil) level:2 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Chip nivå 2 teknik 3 sammanfattning", nil) level:2 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Chip nivå 3 teknik 1 sammanfattning", nil) level:3 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Chip nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Chip nivå 3 teknik 2 sammanfattning", nil) level:3 to:chip];
    [self addTechniqueWithName:NSLocalizedString(@"Extra rull", nil) summary:NSLocalizedString(@"Chip nivå 3 teknik 3 sammanfattning", nil) level:3 to:chip];

    [self addEvaluationWithName:NSLocalizedString(@"Bunker utvärdering", nil) summary:NSLocalizedString(@"Bunker utvärdering sammanfattning", nil) to:bunker];
    [self addExerciseWithName:NSLocalizedString(@"Bunker övning 1", nil) summary:NSLocalizedString(@"Bunker övning 1 sammanfattning", nil) to:bunker];
    [self addExerciseWithName:NSLocalizedString(@"Bunker övning 2", nil) summary:NSLocalizedString(@"Bunker övning 2 sammanfattning", nil) to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Bunker nivå 1 teknik 1 sammanfattning", nil) level:1 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Bunker nivå 1 teknik 2 sammanfattning", nil) level:1 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Bunker nivå 1 teknik 3 sammanfattning", nil) level:1 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Bunker nivå 2 teknik 1 sammanfattning", nil) level:2 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Bunker nivå 2 teknik 2 sammanfattning", nil) level:2 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Bunker nivå 2 teknik 3 sammanfattning", nil) level:2 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Bunker nivå 3 teknik 1 sammanfattning", nil) level:3 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Bunker nivå 3 teknik 2 sammanfattning", nil) level:3 to:bunker];
    [self addTechniqueWithName:NSLocalizedString(@"Bunker nivå 3 teknik 3", nil) summary:NSLocalizedString(@"Bunker nivå 3 teknik 3 sammanfattning", nil) level:3 to:bunker];

    [self addEvaluationWithName:NSLocalizedString(@"Pitch utvärdering", nil) summary:NSLocalizedString(@"Pitch utvärdering sammanfattning", nil) to:pitch];
    [self addExerciseWithName:NSLocalizedString(@"Pitch övning 1", nil) summary:NSLocalizedString(@"Pitch övning 1 sammanfattning", nil) to:pitch];
    [self addExerciseWithName:NSLocalizedString(@"Pitch övning 2", nil) summary:NSLocalizedString(@"Pitch övning 2 sammanfattning", nil) to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 1 teknik 1", nil) summary:NSLocalizedString(@"Pitch nivå 1 teknik 1 sammanfattning", nil) level:1 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 1 teknik 2", nil) summary:NSLocalizedString(@"Pitch nivå 1 teknik 2 sammanfattning", nil) level:1 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 1 teknik 3", nil) summary:NSLocalizedString(@"Pitch nivå 1 teknik 3 sammanfattning", nil) level:1 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 2 teknik 1", nil) summary:NSLocalizedString(@"Pitch nivå 2 teknik 1 sammanfattning", nil) level:2 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 2 teknik 2", nil) summary:NSLocalizedString(@"Pitch nivå 2 teknik 2 sammanfattning", nil) level:2 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 2 teknik 3", nil) summary:NSLocalizedString(@"Pitch nivå 2 teknik 3 sammanfattning", nil) level:2 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 3 teknik 1", nil) summary:NSLocalizedString(@"Pitch nivå 3 teknik 1 sammanfattning", nil) level:3 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 3 teknik 2", nil) summary:NSLocalizedString(@"Pitch nivå 3 teknik 2 sammanfattning", nil) level:3 to:pitch];
    [self addTechniqueWithName:NSLocalizedString(@"Pitch nivå 3 teknik 3", nil) summary:NSLocalizedString(@"Pitch nivå 3 teknik 3 sammanfattning", nil) level:3 to:pitch];

    return categories;
}

#pragma mark Exercises

- (Result*)resultWithScore:(NSUInteger)score forExercise:(Exercise*)exercise {
    [self assertMainThread];
    AssertNotNull(self.dependencyInjector);
    NSAssert(exercise.identity != nil, @"Bad exercise id %@", exercise.identity);
    Result* result = [self entityForName:@"Result"];
    [self save:result];
    [self asyncSave];
    result.exerciseId = exercise.identity;
    //result.timeValue = [NSDate timeIntervalSinceReferenceDate];

    result.score = score;
    //MLog(@"New result %@",result);
    return result;
}

- (void)addExerciseWithName:(NSString*)name summary:(NSString*)summary isEvaluation:(BOOL)isEvaluation to:(Category*)category {
    [self assertMainThread];
    AssertNotNull(self.dependencyInjector);
    Exercise* result = [self.dependencyInjector createInstanceOfClass:[Exercise class]];
    result.code = isEvaluation ? @"utv" : [NSString stringWithFormat:@"ovn%d", [category.exercises count] + 1];
    result.title = name;
    result.summary = summary;
    result.category = category;
    result.isEvaluation = isEvaluation;

    if(isEvaluation)
        category.evaluation = result;
    else
        [category addExercise:result];
}

- (void)addEvaluationWithName:(NSString*)name summary:(NSString*)summary to:(Category*)category {
    [self assertMainThread];
    [self addExerciseWithName:name summary:summary isEvaluation:YES to:category];
}

- (void)addExerciseWithName:(NSString*)name summary:(NSString*)summary to:(Category*)category {
    [self assertMainThread];
    [self addExerciseWithName:name summary:summary isEvaluation:NO to:category];
}

- (NSArray*)findResultsForExercise:(Exercise*)exercise {
    [self assertMainThread];
    NSFetchRequest* request = [[NSFetchRequest class] new];
    [request setEntity:[NSEntityDescription entityForName:@"Result" inManagedObjectContext:self.context]];
    [request setPredicate:[NSPredicate predicateWithFormat:@"exerciseId = %@", exercise.identity]];
    [request setSortDescriptors:@[[[NSSortDescriptor alloc] initWithKey:@"timeValue" ascending:YES]]];

    NSError* error = nil;
    NSArray* result = [self.context executeFetchRequest:request error:&error];
    NSAssert1(error == nil, @"Read data failed %@", error);
    return result;
}

#pragma mark Techniques

- (void)addTechniqueWithName:(NSString*)name summary:(NSString*)summary level:(NSUInteger)level to:(Category*)category {
    [self assertMainThread];
    Technique* result = [[Technique class] new];
    result.title = name;
    result.summary = summary;
    result.category = category;
    result.code = [NSString stringWithFormat:@"n%dt%d", level, [[category techniquesForLevel:level] count] + 1];
    [category addTechnique:result atLevel:level];
}

#pragma mark Recordings

- (Recording*)saveRecording:(NSString*)videoPath {
    [self assertMainThread];
    AssertNotNull(self.fileManager);
    NSError* error = nil;
    NSString* dstPath = [self nextVideoPath];
    NSString* fullPath = [self.videoDirectory stringByAppendingPathComponent:dstPath];
    BOOL copied = [self.fileManager copyItemAtPath:videoPath toPath:fullPath error:&error];
    NSAssert(copied && error == nil, @"File copy failed %@", error);
    Recording* result = [self entityForName:@"Swing"];
    result.summary = NSLocalizedString(@"Namn ny inspelning", nil);
    result.createdAt = [NSDate date];
    result.path = dstPath;
    [self save:result];
    MLog(@"Saved swing at path '%@'", fullPath);
    return result;
}

- (NSArray*)findRecordings {
    [self assertMainThread];
    if(![self isFirstRun]) {
        NSString* path = [[NSBundle mainBundle] pathForResource:@"minavideointro" ofType:@"mp4"];
        //[self saveRecording:path];
        Recording* rec = [self saveRecording:path];
        
        rec.summary = @"Exempelvideo";
        [self save];
        //rec.createdAt = [NSDate date];
    }
    NSFetchRequest* request = [NSFetchRequest new];
    [request setEntity:[NSEntityDescription entityForName:@"Swing" inManagedObjectContext:self.context]];
    [request setSortDescriptors:[NSArray arrayWithObject:[[NSSortDescriptor alloc] initWithKey:@"createdAt" ascending:NO selector:@selector(compare:)]]];
    NSError* error = nil;
    NSArray* result = [self.context executeFetchRequest:request error:&error];
    for(Recording* swing in result) {
      //  NSLog(@"swing videoPath =%@",swing.videoPath);
        [self.dependencyInjector autowire:swing];
        swing.repository = self;
        [swing setIsOwnRecording:true];
        
    }
    
    NSAssert1(error == nil, @"Read data failed %@", error);
    return result;
}

- (void)assertMainThread {
    NSAssert([NSThread isMainThread], @"Repository can only be accessed in main thread");
}

- (BOOL)isFirstRun {
    [self assertMainThread];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    BOOL result = [defaults boolForKey:IsFirstRun];
    [defaults setBool:YES forKey:IsFirstRun];
    [defaults synchronize];
    return result;
}

- (id)findProVideos {
    [self assertMainThread];
    static NSMutableArray* result = nil;
    if(result != nil)
        return result;
    NSString* dir = @"pro-video";
    NSArray* paths = [[NSBundle mainBundle] pathsForResourcesOfType:@"mp4" inDirectory:dir];
    result = [NSMutableArray array];
    NSNumberFormatter* fmt = [NSNumberFormatter new];
    [fmt setNumberStyle:NSNumberFormatterDecimalStyle];
    for(NSString* path in paths) {
        ProVideo* video = [self.dependencyInjector createInstanceOfClass:ProVideo.class];
        NSString* fileName = [path lastPathComponent];
        video.path = path;
        video.imageName = [dir stringByAppendingPathComponent:[fileName stringByDeletingPathExtension]];
        NSArray* names = [[fileName stringByDeletingPathExtension] componentsSeparatedByString:@" - "];
        if(names.count != 3) {
            MLog(@"Illegal format of pro video filename '%@', needs 'Namne  -.. - ...'. Video skipped", fileName);
            continue;
        }
        video.title = names[0];
        video.position = [fmt numberFromString:names[1]].integerValue;
        video.summary = names[2];
        [result addObject:video];
    }
    [result sortUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"position" ascending:YES]]];
    return result;
}

- (void)deleteRecording:(Recording*)swing {
    [self assertMainThread];
    NSError* error = nil;
    NSString* fullVideoPath = [self getFullVideoPath:swing];
    [self.fileManager removeItemAtPath:fullVideoPath error:&error];
    NSLog(@"Deleting '%@' %@", fullVideoPath, error);
    NSAssert(error == nil, @"Failed to delete %@, error %@", swing.path, error);
    [self deleteObject:swing];
}

- (NSString*)nextVideoPath {
    [self assertMainThread];
    NSString* dir = self.videoDirectory;
    NSError* error = nil;
    BOOL result = [self.fileManager createDirectoryAtPath:dir withIntermediateDirectories:YES attributes:nil error:&error];
    NSAssert(result && error == nil, @"Couldn't create recordings directory '%@', %@", dir, error);
    NSSet* contents = [NSSet setWithArray:[self.fileManager contentsOfDirectoryAtPath:dir error:&error]];
    NSAssert(error == nil, @"File listing error '%@' %@", dir, error);
    int i = 1;
    NSString* fileName = nil;
    while([contents containsObject:(fileName = [NSString stringWithFormat:@"%@ %i.mov", @"Inspelning", i])]) {
        i++;
    }
    return fileName;
}

- (NSString*)videoDirectory {
    [self assertMainThread];
    return [self.applicationDocumentsDirectory stringByAppendingPathComponent:@"Recordings"];
}

- (NSString*)getFullVideoPath:(Recording*)swing {
    [self assertMainThread];
    return [self.videoDirectory stringByAppendingPathComponent:swing.path];
}

#pragma mark Generic

- (void)deleteObject:(NSManagedObject*)object {
    [self assertMainThread];
    [self.context deleteObject:object];
    [self asyncSave];
}

- (void)save {
    [self assertMainThread];
    NSAssert(self.context != nil, @"Not initialized");
    NSError* error = nil;
    BOOL failed = [self.context hasChanges] && ![self.context save:&error];
    NSAssert1(!failed, @"Save failed %@", [error userInfo]);
    MLog(@"Saved");
}

- (void)asyncSave {
    [self assertMainThread];
    [self performSelector:@selector(save) withObject:nil afterDelay:0];
}

- (NSString*)applicationDocumentsDirectory {
    [self assertMainThread];
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
}

- (id)entityForName:(NSString*)name {
    [self assertMainThread];
    NSManagedObject* result = [[NSManagedObject alloc] initWithEntity:[self.model entitiesByName][name] insertIntoManagedObjectContext:nil];
    [self.dependencyInjector autowire:result];
    return result;
}

- (void)save:(NSManagedObject*)entity {
    [self assertMainThread];
    [self.context insertObject:entity];
    [self asyncSave];
}

#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext*)context {
    [self assertMainThread];
    if(_context != nil)
        return _context;

    self.context = ([[NSManagedObjectContext class] new]);
    [_context setPersistentStoreCoordinator:self.coordinator];
    return _context;
}


/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel*)model {
    [self assertMainThread];
    if(_model != nil) {
        return _model;
    }
    NSString* filename = @"Datamodel.mom";
    NSString* path = [[NSBundle mainBundle] pathForResource:[filename stringByDeletingPathExtension] ofType:[filename pathExtension]];
    self.model = [[NSManagedObjectModel alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
    return _model;
}


/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator*)coordinator {

    if(_coordinator != nil) {
        return _coordinator;
    }

    NSURL* storeURL = [NSURL fileURLWithPath:[[self applicationDocumentsDirectory] stringByAppendingPathComponent:@"Store.sqlite"]];

    NSError* error = nil;
    self.coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:self.model];
    if(![_coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }

    return _coordinator;
}

#pragma mark Toolbar memory
+ (void)setMenu1Color:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:color  forKey:@"menu1Color"];
}

- (NSArray *)findScorableCategories {
    NSMutableArray *result = [NSMutableArray array];
    for(Category *category in [self findCategories])
        if(category.scorables.count > 0)
            [result addObject:category];
    return result;
}

+ (void)setMenu2Color:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
      setInteger:color forKey:@"menu2Color"];
}
+ (void)setMenu3Color:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
      setInteger:color forKey:@"menu3Color"];
}
+ (void)setMenu4Color:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
      setInteger:color  forKey:@"menu4Color"];
}
+ (void)setMenu1Symbol:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:color  forKey:@"menu1Symbol"];
}

+ (void)setMenu2Symbol:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:color forKey:@"menu2Symbol"];
}
+ (void)setMenu3Symbol:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:color forKey:@"menu3Symbol"];
}
+ (void)setMenu4Symbol:(NSInteger) color
{
    [[NSUserDefaults standardUserDefaults]
     setInteger:color  forKey:@"menu4Symbol"];
}
+ (NSInteger)getMenu1Color {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu1Color"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu1Color"];
    } else {
        return 0;
    }
}
+ (NSInteger)getMenu2Color {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu2Color"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu2Color"];
    } else {
        return 1;
    }
}
+ (NSInteger)getMenu3Color {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu3Color"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu3Color"];
    } else {
        return 2;
    }
}
+ (NSInteger)getMenu4Color {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu4Color"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu4Color"];
    } else {
        return 3;
    }}

+ (NSInteger)getMenu1Symbol {
    
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu1Symbol"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu1Symbol"];
    } else {
        return 1;
    }
}
+ (NSInteger)getMenu2Symbol {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu2Symbol"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu2Symbol"];
    } else {
        return 2;
    }
}
+ (NSInteger)getMenu3Symbol {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu3Symbol"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu3Symbol"];
    } else {
        return 3;
    }
}
+ (NSInteger)getMenu4Symbol {
    if([[NSUserDefaults standardUserDefaults] objectForKey:@"menu4Symbol"] != nil) {
        return [[NSUserDefaults standardUserDefaults] integerForKey:@"menu4Symbol"];
    } else {
        return 4;
    }}
@end
