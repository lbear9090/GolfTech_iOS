#import "Category.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface Category () {
    NSMutableArray* techniques;
}
@property(nonatomic, strong) ASINetworkQueue* downloads;
@end

@implementation Category

- (id)init {
    self = [super init];
    self.exercises = [NSMutableArray array];
    self.downloads = ([[ASINetworkQueue class] new]);
    self.downloads.showAccurateProgress = YES;
    [self.downloads setMaxConcurrentOperationCount:2];
    techniques = [NSMutableArray arrayWithCapacity:3];
    for(int i = 0; i < 3; i++) {
        techniques[i] = [NSMutableArray array];
    }
    return self;
}

- (NSString*)imageName {
    return [[NSString stringWithFormat:@"kategorivaljare %@", self.code] lowercaseString];
}

- (void)addExercise:(Exercise*)exercise {
    AssertNotNull(self.exercises);
    [self.exercises addObject:exercise];
}

- (void)addTechnique:(Technique*)technique atLevel:(NSUInteger)level {
    AssertNotNull(self->techniques);

    [self->techniques[level - 1] addObject:technique];
}

- (NSMutableArray*)techniquesForLevel:(NSUInteger)level {
    return self->techniques[level - 1];
}

- (NSArray*)techniques {
    NSMutableArray* result = [NSMutableArray array];
    for(int i = 0; i < techniques.count; i++) {
        [result addObjectsFromArray:techniques[i]];
    }
    return result;
}

- (NSArray*)scorables {
    NSMutableArray *result = [NSMutableArray array];
    if(self.evaluation != nil)
        [result addObject:self.evaluation];
    [result addObjectsFromArray:self.exercises];
    return result;
}

@end




