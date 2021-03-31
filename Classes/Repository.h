#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "DependencyInjector.h"

@class Exercise, Result;
@class Technique;
@class Recording;

@interface Repository : NSObject
@property(nonatomic, weak) DependencyInjector* dependencyInjector;
@property(nonatomic, strong) NSFileManager* fileManager;
@property(nonatomic, strong) NSManagedObjectContext* context;
@property(nonatomic, strong) NSManagedObjectModel* model;
@property(nonatomic, strong) NSPersistentStoreCoordinator* coordinator;

- (NSArray*)findCategories;
- (NSArray*)findResultsForExercise:(Exercise*)exercise;
- (Result*)resultWithScore:(NSUInteger)score forExercise:(Exercise*)exercise;

- (Recording*)saveRecording:(NSString*)videoPath;
- (id)findRecordings;
- (void)deleteRecording:(Recording*)swing;
- (NSString*)getFullVideoPath:(Recording*)swing;

- (void)save;
- (void)asyncSave;
- (NSString*)applicationDocumentsDirectory;
- (void)save:(NSManagedObject*)entity;

- (id)findProVideos;

+ (void) setMenu1Color:(NSInteger)color;
- (NSArray *)findScorableCategories;
+ (void) setMenu2Color:(NSInteger)color;
+ (void) setMenu3Color:(NSInteger)color;
+ (void) setMenu4Color:(NSInteger)color;

+ (void) setMenu1Symbol:(NSInteger)color;
+ (void) setMenu2Symbol:(NSInteger)color;
+ (void) setMenu3Symbol:(NSInteger)color;
+ (void) setMenu4Symbol:(NSInteger)color;

+ (NSInteger) getMenu1Color;
+ (NSInteger) getMenu2Color;
+ (NSInteger) getMenu3Color;
+ (NSInteger) getMenu4Color;

+ (NSInteger) getMenu1Symbol;
+ (NSInteger) getMenu2Symbol;
+ (NSInteger) getMenu3Symbol;
+ (NSInteger) getMenu4Symbol;
@end
