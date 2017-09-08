import FluentProvider
import PostgreSQLProvider
import AuthProvider

extension Config {
  
    public func setup() throws {
      
        Node.fuzzy = [Row.self, JSON.self, Node.self]

        try setupProviders()
        try setupPreparations()
    }
    
    /// Configure providers
    private func setupProviders() throws {
      
      try addProvider(FluentProvider.Provider.self)
      try addProvider(PostgreSQLProvider.Provider.self)
      try addProvider(AuthProvider.Provider.self)
    }
    
    /// Add all models that should have their
    /// schemas prepared before the app boots
    private func setupPreparations() throws {
      
      preparations.append(Meetup.self)
      preparations.append(User.self)
    }
}
