// Similar to C# using statements - brings modules/namespaces into scope
import SwiftUI       // SwiftUI framework (like WPF/UWP with XAML)
import SwiftData      // Apple's data persistence (similar to EF Core, but simpler)

// MARK: - ContentView (Main UI)
struct ContentView: View {
    
    // @Environment(\.modelContext) = inject dependency (like DI container)
    // .modelContext = SwiftData's database context (similar to DbContext in EF Core)
    // private var = private field/property
    @Environment(\.modelContext) private var modelContext
    
    // @Query = fetch data from SwiftData (like DbSet<T>.ToListAsync())
    // private var items: [Item] = items is array of Item (like List<Item>)
    // Note: This still uses SwiftData's Item model - you'll want to update to use Game
    @Query private var items: [Item]

    // var body: some View = required computed property (like XAML Content property)
    // 'some View' = opaque return type (Swift infers actual type)
    var body: some View {
        // NavigationSplitView = three-column layout (like VS solution explorer)
        // Similar to: NavigationPage with MasterDetailPage in Xamarin
        NavigationSplitView {
            // List = ItemsControl/ListView (displays collection)
            List {
                // ForEach = foreach loop in XAML (renders collection)
                // In C# XAML: <ItemsControl ItemsSource="{Binding Items}">
                ForEach(items) { item in
                    // NavigationLink = hyperlink/navigation (like NavigationPage.PushAsync)
                    NavigationLink {
                        // Detail view when item is tapped
                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
                    } label: {
                        // What shows in the list
                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
                    }
                }
                // .onDelete = attach swipe-to-delete behavior
                .onDelete(perform: deleteItems)
            }
            // .navigationSplitViewColumnWidth = column width (like GridView.ColumnWidth)
            .navigationSplitViewColumnWidth(min: 180, ideal: 200)
            // .toolbar = action bar (like ToolbarItem in XAML/WPF)
            .toolbar {
                ToolbarItem {
                    // Button with action closure (like Button Command)
                    Button(action: addItem) {
                        // Label = text + icon (like TextBlock with Image)
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
        } detail: {
            // Detail pane when nothing selected
            Text("Select an item")
        }
    }

    // private func = private method
    // func addItem() = public void AddItem() in C#
    private func addItem() {
        // withAnimation = animate changes (like Storyboard in WPF)
        withAnimation {
            // let = immutable variable (like 'var x =' but can't change)
            // Item(timestamp: Date()) = object initializer (like new Item { Timestamp = DateTime.Now })
            let newItem = Item(timestamp: Date())
            // modelContext.insert = DbContext.Entry(item).State = Added
            modelContext.insert(newItem)
        }
    }

    // IndexSet = collection of indices (like List<int> of selected indices)
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            // for index in offsets = foreach (same as C#)
            for index in offsets {
                // Delete item at index from array
                modelContext.delete(items[index])
            }
        }
    }
}

// MARK: - Preview Provider
// #Preview = SwiftUI preview (like Live Visual Tree in VS or Hot Reload)
// Renders view in Xcode canvas during development
#Preview {
    // .modelContainer = creates in-memory database for preview
    // Similar to: UseInMemoryDatabase in EF Core
    ContentView()
        .modelContainer(for: Item.self, inMemory: true)
}
