/*
透過 value(key) 方式抓到 UISearchBar 的TextField 
方便將其他UI 貼齊 UISearch Bar 內的 TextField，做出一個漂亮的AutoComplete

Point: 務必將 tableView 與 SearchBar 裝在同一個BackgroundView，
不可將tableView 塞進 searchBar 內，會造成 tableView 觸控衝突，導致tableView 觸控cell 點擊失效
*/


let backgroundView = UIView()
let tableView = UITableView()
let searchBar = UISearchBar()

guard let textField = searchBar.value(forKey: "searchField") as? UITextField else { return }

backgroundView.addSubview(searchBar)
backgroundView.addSubview(tableView)

// searchBar autoLayout..
searchBar.topAnchor.constraint(...)

// tableView autoLayout
tableView.topAnchor.constraint(equalTo: textField.bottomAnchor, constant: 0).isActive = true

