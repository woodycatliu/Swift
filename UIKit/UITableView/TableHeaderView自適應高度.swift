/*
善用 tableViewHeaderView  可以讓UI更加美觀，
但是 它是想要讓它自適應高度，就沒這麼好處理
可以參考以下做法
*/





        let stack = UIStackView()
        stack.axis = .vertical
        stack.alignment = .fill
        stack.distribution = .equalCentering

        stack.addArrangedSubview(oneView)
        stack.addArrangedSubview(TwoView)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.tableHeaderView = stack
        stack.topAnchor.constraint(equalTo: popularTableView.topAnchor).isActive = true
        stack.widthAnchor.constraint(equalTo: popularTableView.widthAnchor).isActive = true
        stack.centerXAnchor.constraint(equalTo: popularTableView.centerXAnchor).isActive = true
        
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = popularTableView.tableHeaderView
    
    
    // 調整tableView Layout
    private func adjustTableHeaderViewLayout() {
        tableView.tableHeaderView?.layoutIfNeeded()
        tableView.tableHeaderView = popularTableView.tableHeaderView
    }