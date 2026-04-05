// Similar to C# using statements - brings modules/namespaces into scope
import Foundation   // Base framework (like System namespace in .NET)
import GRDB         // SQLite toolkit (similar to Entity Framework or Dapper in C#)

// MARK: - Game Entity
// struct = class with value type semantics (like C# record or struct)
// Unlike C# classes, structs in Swift are passed by VALUE (copied), not by reference
// Protocols after : are like interfaces in C# (multiple inheritance allowed)
struct Game: Codable, FetchableRecord, PersistableRecord, Identifiable {
    
    // static let = static readonly field (compile-time constant)
    // Similar to: public static readonly string DatabaseTableName = "Game";
    static let databaseTableName = "Game"
    
    // var = mutable field/property (like regular C# properties)
    // Int64? = nullable Int64 (Swift uses ? for nullability, like C# int?)
    // Unlike C#, Swift uses lowercase types (Int64, String, Date) from the Swift standard library
    var gameID: Int64?
    var gameName: String
    var platformID: Int64?
    var statusID: Int64?
    var mainStoryCompletionHours: Int?
    var mainExtraStoryCompletionHours: Int?
    var completionistHours: Int?
    var lastUpdateDate: Date  // DateTime in C# becomes Date in Swift
    
    // static let with relationship helper (GRDB specific)
    // hasMany/hasOne/belongsTo define foreign key relationships
    // Similar to navigation properties in EF Core
    static let platform = belongsTo(Platform.self)  // virtual Platform Platform { get; }
    static let status = belongsTo(Status.self)      // virtual Status Status { get; }
    
    // Computed properties in Swift (like C# properties with only get, no backing field)
    // These return QueryInterfaceRequest<T> which is like IQueryable<T> - lazy queries
    var platform: QueryInterfaceRequest<Platform> {
        request(for: Game.platform)
    }
    
    var status: QueryInterfaceRequest<Status> {
        request(for: Game.status)
    }
    
    // var id: Int64? { gameID } = computed property returning gameID
    // The { get } is implicit for single-expression computed properties
    // Identifiable protocol requires an 'id' property - similar to needing an Id property on base entity classes
    var id: Int64? { gameID }
}

// MARK: - Game.Columns Enum
// extension = partial class in C# - adds functionality to existing type
// Can add methods, computed properties, or conformances to existing types
extension Game {
    // enum with String raw value - similar to C# enum with underlying type
    // enum Columns: String { case platformID = "PlatformID" }
    enum Columns: String, ColumnExpression {
        case gameID = "GameID"
        case gameName = "GameName"
        case platformID = "PlatformID"
        case statusID = "StatusID"
        case mainStoryCompletionHours = "MainStoryCompletionHours"
        case mainExtraStoryCompletionHours = "MainExtraStoryCompletionHours"
        case completionistHours = "CompletionistHours"
        case lastUpdateDate = "LastUpdateDate"
    }
    
    // static func = static method
    // 'throws' = method that can throw exception (like C# throwing)
    // Similar to: public static void CreateTable(Database db)
    static func createTable(in db: Database) throws {
        // try = call a throwing function (like await for async, but for exceptions)
        // try? would return nil on failure, try! would crash on failure
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            // Trailing closure syntax - last param can be outside ()
            // This is like: db.CreateTable(databaseTableName, (t) => { ... })
            t.autoIncrementedPrimaryKey(Columns.gameID.rawValue)  // IDENTITY(1,1) in SQL
            t.column(Columns.gameName.rawValue, .text)           // NVARCHAR in SQL
            t.column(Columns.platformID.rawValue, .integer)       // INT in SQL
                .references(Platform.databaseTableName, onDelete: .setNull)  // FK with cascade
            t.column(Columns.statusID.rawValue, .integer)
                .references(Status.databaseTableName, onDelete: .setNull)
            t.column(Columns.mainStoryCompletionHours.rawValue, .integer)
            t.column(Columns.mainExtraStoryCompletionHours.rawValue, .integer)
            t.column(Columns.completionistHours.rawValue, .integer)
            t.column(Columns.lastUpdateDate.rawValue, .datetime)  // DATETIME in SQL
        }
    }
}
