import Combine

extension Publisher {
    func printWhenDebug()-> Publishers.Print<Self> {
        #if DEBUG || Dev
        return self.print()
        #else
        return self
        #endif
    }
}