//
//  TCSingletonDB.m
//  TripCost
//
//  Created by andy on 15/8/21.
//  Copyright (c) 2015年 AventLabs. All rights reserved.
//

#import "TCSingletonDB.h"
#import "FMDB.h"
#import "Trip.h"
#import "TCMember.h"

@interface TCSingletonDB()

@property (strong,nonatomic) FMDatabase *db;
@property (strong,nonatomic) NSString *dbPath;
@property (strong,nonatomic) NSMutableArray *tripArray;

@end

@implementation TCSingletonDB

+ (TCSingletonDB*)sharedDB{
    static TCSingletonDB *singletondb = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        singletondb = [[self alloc] initDatabase];
    });
    
    return singletondb;
}

- (id)initDatabase{
    if(self = [super init])
    {
        self.dbPath  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/database.db"];
        self.db = [FMDatabase databaseWithPath:self.dbPath];
        if ([self.db open]) {
//            NSString *sql = @"create table trip (id integer primary key autoincrement, name text, createdate text, creatername text, createrid text);"
//            "create table tripmember (id integer primary key autoincrement, tripid integer, memberid text);"
//            "create table tripbill (id integer primary key autoincrement, tripid integer, date text,locationname text, latitude double,longitude double,category integer,comment text,bill double,billavg double);"
//            "create table billmember (id integer primary key autoincrement, billid integer, memberid integer);"
//            "create table member (id integer primary key autoincrement, name text, email text, avatar text);";
            
            NSString *sql = @"create table trip (id integer primary key autoincrement, name text, createdate text, creatername text, createrid text);";
            
            BOOL success = [self.db executeStatements:sql];
        }
        [self.db close];
    }
    
    return self;
}

- (void)addTrip:(Trip*)trip{
    [self.db open];
    [self.db executeUpdate:@"INSERT INTO trip(name,createdate,creatername,createrid) VALUES (?,?,?,?)",
                            trip.name,trip.createdate,trip.creatername,trip.createrid];
    NSLog(@"%@",self.db.lastErrorMessage);
    NSInteger lastId = [self.db lastInsertRowId];
    
    for (TCMember* member in trip.membersArray) {
        NSString *sql = @"INSERT INTO tripmember(tripid,memberemail) VALUES(?,?)";
        NSLog(@"%@",sql);
        
        [self.db executeUpdate:sql,[NSNumber numberWithInteger:lastId],member.strEmail];
    }
    
    [self.db close];
}

- (NSMutableArray*)loadTrip{
    [self.db open];
    if (!self.tripArray) {
        self.tripArray = [NSMutableArray array];
    }
    FMResultSet *s = [self.db executeQuery:@"SELECT * FROM trip order by createdate desc"];
    while ([s next]) {
        Trip *trip = Trip.new;
        trip.tripid = [NSString stringWithFormat:@"%d",[s intForColumn:@"id"]];
        trip.name = [s stringForColumn:@"name"];
        trip.createdate = [s stringForColumn:@"createdate"];
        trip.creatername = [s stringForColumn:@"createname"];
        trip.createrid = [s stringForColumn:@"createid"];
        
        trip.membersArray = [self loadTripMember:trip.tripid];
        
        [self.tripArray addObject:trip];
    }
    
    return self.tripArray;
    
}

- (NSMutableArray*)loadTripMember:(NSString*)tripid
{
    NSMutableArray *member = [NSMutableArray array];
    
    FMResultSet *s = [self.db executeQuery:@"SELECT * FROM tripmember where tripid = ?",tripid];
    while ([s next]) {
        
    }
    
    return member;
}
//
//- (void)addTrip{
//    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:self.dbPath];
//    [queue inDatabase:^(FMDatabase *db) {
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:1]];
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:2]];
//        [db executeUpdate:@"INSERT INTO myTable VALUES (?)", [NSNumber numberWithInt:3]];
//        
//        FMResultSet *rs = [db executeQuery:@"select * from foo"];
//        while ([rs next]) {
//        
//        }
//    }];
//}
@end
