
protocol TextProtocol: AnyObject {
    var text: String { get set }
}


extension Reactive where Base: TextProtocol {
    var text: Binder<String> {
        return Binder(self.base) { vm, text in
            vm.text = text
        }
    }
}
