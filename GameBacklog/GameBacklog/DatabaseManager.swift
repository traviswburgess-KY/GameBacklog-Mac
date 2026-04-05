// Similar to C# using statements - brings modules/namespaces into scope
import Foundation   // Base framework (like System namespace in .NET)
import GRDB         // SQLite toolkit (similar to Entity Framework or Dapper in C#)

// MARK: - DatabaseManager (Singleton)
// final class = sealed class in C# - cannot be subclassed
// In Swift, 'class' is reference type (passed by reference, like C# class)
// This is similar to a static class with instance methods in C#
final class DatabaseManager {
    
    // static let shared = public static readonly DatabaseManager Shared { get; }
    // This is the Singleton pattern - use DatabaseManager.shared to access
    static let shared = DatabaseManager()
    
    // private(set) = read-only property from outside, writable from inside
    // Similar to: private DatabaseQueue _dbQueue; public DatabaseQueue DbQueue { get; private set; }
    private(set) var dbQueue: DatabaseQueue!
    
    // private init() = private constructor - prevents 'new DatabaseManager()' from outside
    // In C#: private DatabaseManager() { }
    private init() {}
    
    // func setup() throws = public void Setup() that can throw
    // throws in Swift is like methods that can throw Exception in C#
    func setup() throws {
        // let = immutable variable (like 'var' in C# with readonly modifier)
        // FileManager.default = FileManager.Singleton in Swift
        let fileManager = FileManager.default
        
        // try fileManager.url(...) = try/catch equivalent
        // throws exceptions that can bubble up
        let appSupportURL = try fileManager.url(
            for: .applicationSupportDirectory,  // Environment.SpecialFolder.ApplicationData
            in: .userDomainMask,               // no app sandboxing
            appropriateFor: nil,                // no specific use case
            create: true                        // create if doesn't exist
        )
        
        // URL.appendPathComponent = Path.Combine(appSupportURL, "GameBacklogDB.sqlite")
        let dbURL = appSupportURL.appendingPathComponent("GameBacklogDB.sqlite")
        
        // var = mutable variable (like regular C# variable)
        var config = Configuration()
        
        // Closure/trailing closure syntax - like lambda or anonymous method
        // config.prepareDatabase { db in ... } is like: config.PrepareDatabase(db => { ... })
        config.prepareDatabase { db in
            // db.trace { print("SQL: \($0)") } = log SQL statements
            // $0 = first parameter, like 'x' in 'x => x' lambda
            // \($0) = string interpolation, like $"{x}" or $"SQL: {x}" in C#
            db.trace { print("SQL: \($0)") }
        }
        
        // DatabaseQueue = connection to SQLite database
        // Similar to: using var connection = new SqlConnection(connectionString)
        dbQueue = try DatabaseQueue(path: dbURL.path, configuration: config)
        
        // Run database migrations
        try migrator.migrate(dbQueue)
    }
    
    // private var migrator: DatabaseMigrator { ... }
    // Computed property (like C# property with get{}), runs each access
    private var migrator: DatabaseMigrator {
        var migrator = DatabaseMigrator()
        
        // migrator.registerMigration("name") { db in ... }
        // Similar to EF Core migrations or FluentMigrator
        migrator.registerMigration("v1_createTables") { db in
            try Platform.createTable(in: db)
            try Status.createTable(in: db)
            try Game.createTable(in: db)
        }
        
        return migrator
    }
    
    // MARK: - Platform CRUD
    
    // func insertPlatform(_ platform: Platform) throws
    // _ = external parameter label omitted (like unnamed first param in C#)
    // In C#: public void InsertPlatform(Platform platform)
    func insertPlatform(_ platform: Platform) throws {
        try dbQueue.write { db in  // write = transaction (like TransactionScope)
            // var = mutable variable (required because insert modifies it)
            var newPlatform = platform
            try newPlatform.insert(db)
        }
    }
    
    // func fetchAllPlatforms() throws -> [Platform]
    // -> [Platform] = return type is array of Platform
    // Similar to: public async Task<List<Platform>> FetchAllPlatformsAsync()
    func fetchAllPlatforms() throws -> [Platform] {
        try dbQueue.read { db in  // read = read-only transaction
            try Platform.fetchAll(db)
        }
    }
    
    // MARK: - Game CRUD
    
    func insertGame(_ game: Game) throws {
        try dbQueue.write { db in
            var newGame = game
            try newGame.insert(db)
        }
    }
    
    func fetchAllGames() throws -> [Game] {
        try dbQueue.read { db in
            try Game.fetchAll(db)
        }
    }
    
    // MARK: - Status CRUD
    
    func insertStatus(_ status: Status) throws {
        try dbQueue.write { db in
            var newStatus = status
            try newStatus.insert(db)
        }
    }
    
    func fetchAllStatuses() throws -> [Status] {
        try dbQueue.read { db in
            try Status.fetchAll(db)
        }
    }
    
    // MARK: - Delete Operations
    
    func deleteStatus(_ status: Status) throws {
        // _ = discard result (like _ = ignore)
        // In C#: _ = status.Delete(db);  // discard the return value
        _ = try dbQueue.write { db in
            try status.delete(db)
        }
    }
    
    func deleteGame(_ game: Game) throws {
        _ = try dbQueue.write { db in
            try game.delete(db)
        }
    }
}
