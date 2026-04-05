// Similar to C# using statements - brings modules/namespaces into scope
import Foundation   // Base framework (like System namespace in .NET)
import GRDB         // SQLite toolkit (similar to Entity Framework or Dapper in C#)

// MARK: - Platform Entity
// struct = class with value type semantics (like C# record or struct)
// Unlike C# classes, structs in Swift are passed by VALUE (copied), not by reference
// Protocols after : are like interfaces in C# (multiple inheritance allowed)
struct Platform: Codable, FetchableRecord, PersistableRecord, Identifiable {
    
    // static let = static readonly field (compile-time constant)
    // Similar to: public static readonly string DatabaseTableName = "Platform";
    static let databaseTableName = "Platform"
    
    // var = mutable field/property (like regular C# properties)
    // Int64? = nullable Int64 (Swift uses ? for nullability, like C# int?)
    // Unlike C#, Swift uses lowercase types (Int64, String, Date) from the Swift standard library
    var platformID: Int64?
    var platformName: String
    var lastUpdateDate: Date  // DateTime in C# becomes Date in Swift
    
    // static let with relationship helper (GRDB specific)
    // hasMany = one-to-many relationship (like ICollection<T> in EF Core)
    // Similar to: public virtual ICollection<Game> Games { get; }
    static let games = hasMany(Game.self)
    
    // Computed property returning lazy query (like IQueryable<Game>)
    var games: QueryInterfaceRequest<Game> {
        request(for: Platform.games)
    }
    
    // var id: Int64? { platformID } = computed property returning platformID
    // The { get } is implicit for single-expression computed properties
    // Identifiable protocol requires an 'id' property
    var id: Int64? { platformID }
}

// MARK: - Platform.Columns Enum
// extension = partial class in C# - adds functionality to existing type
// Can add methods, computed properties, or conformances to existing types
extension Platform {
    // enum with String raw value - similar to C# enum with underlying type
    enum Columns: String, ColumnExpression {
        case platformID = "PlatformID"
        case platformName = "PlatformName"
        case lastUpdateDate = "LastUpdateDate"
    }
    
    // static func = static method
    // 'throws' = method that can throw exception (like C# throwing)
    static func createTable(in db: Database) throws {
        // try = call a throwing function
        // Trailing closure syntax - like LINQ query syntax
        try db.create(table: databaseTableName, ifNotExists: true) { t in
            t.autoIncrementedPrimaryKey(Columns.platformID.rawValue)  // IDENTITY(1,1)
            t.column(Columns.platformName.rawValue, .text)            // NVARCHAR
            t.column(Columns.lastUpdateDate.rawValue, .datetime)      // DATETIME
        }
    }
}
