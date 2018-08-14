//
//  StyleDateRang+CoreDataProperties.h
//  
//
//  Created by Apple on 16/5/17.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StyleDateRange.h"

NS_ASSUME_NONNULL_BEGIN

@interface StyleDateRange (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *daterang_id;
@property (nullable, nonatomic, retain) NSString *name;
@property (nullable, nonatomic, retain) NSNumber *start;
@property (nullable, nonatomic, retain) NSNumber *end;
@property (nullable, nonatomic, retain) NSNumber *series_id;
@property (nullable, nonatomic, retain) NSNumber *status;

@end

NS_ASSUME_NONNULL_END
