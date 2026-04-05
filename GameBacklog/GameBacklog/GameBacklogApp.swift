// Similar to C# using statements - brings modules/namespaces into scope
import SwiftUI   // SwiftUI framework (like WPF/UWP with XAML)

// MARK: - Application Entry Point
// @main = entry point attribute (like static void Main() in C#)
// Swift automatically calls this struct's main() method
@main
struct GameBacklogApp: App {
    
    // init() = constructor (like C# constructors)
    // Runs once when the app starts, before any views appear
    init() {
        // do-catch = try-catch in C#
        do {
            try DatabaseManager.shared.setup()
        } catch {
            // fatalError = throws exception and crashes (like throw new Exception())
            // In production, you'd show an alert instead
            fatalError("Failed to setup database: \(error)")
        }
    }

    // var body: some Scene
    // Computed property returning some Scene (opaque return type)
    // Similar to: public Scene Body { get { return new WindowGroup { ... }; } }
    var body: some Scene {
        // WindowGroup = collection of windows with same content
        // Similar to: MainWindow in WPF or MainPage in UWP
        WindowGroup {
            // ContentView() = your main UI view
            ContentView()
        }
    }
}
