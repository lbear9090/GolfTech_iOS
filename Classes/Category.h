#import <Foundation/Foundation.h>
#import "Exercise.h"
#import "Technique.h"
#import "Locale.h"

@protocol CategoryEvents
@optional
- (void)error;
- (BOOL)available;
- (BOOL)downloading;
@end


@interface Category : NSObject <CategoryEvents> {
}
@property(nonatomic, copy) NSString* code;
@property(nonatomic, copy) NSString* title;
@property(weak, nonatomic, readonly) NSString* imageName;
@property(nonatomic, strong) Exercise* evaluation;
@property(nonatomic, strong) NSMutableArray* exercises;
@property(weak, nonatomic, readonly) NSArray* scorables;
@property(nonatomic, readonly) NSArray* techniques;
- (NSMutableArray*)techniquesForLevel:(NSUInteger)level;
- (void)addExercise:(Exercise*)exercise;
- (void)addTechnique:(Technique*)technique atLevel:(NSUInteger)level;
@end

