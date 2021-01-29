/*紀錄SQlite.swift 使用心得*/

import SQLite

class MySqlite {

var db: Connection!
let userTable = "myTable"

private let id = Expression<Int>(TableExpression.id.rawValue)
private let name = Expression<String>(TableExpression.name.rawValue)
private let birth = Expression<Int>(TableExpression.createAt.rawValue)

init(myPath: String) {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!
    do {
        db = try Coneection("\(path)/\(myPath)")
    } catch {
        print("db create is failed")
    }

    db.busyTimeout = 5

    db.busyHandler {
        tries in
        if tries >= 5 {
            return false
        }
        return true
    }

    createDB()
}


private func createDB() {
    // ifNotExists 如果不存在創建一個、withoutRowid 建立rowID 識別
    try! db.run(userTable.create(temporary: false, ifNotExists: true, withoutRowid: false) {
        table in
        // 設定id 為 主鍵，並且自動增加 (不需要指定)
        table.column(id, primaryKey: .autoincrement)
        // 名稱獨一無二
        table.column(name, unique: true)
        table.column(birth)
    }

}

/// insert 成功回傳該筆資料rowID
func insert(name: String, birth: Int)-> Int? {
    do {
        // 回傳Int64
        let id = db.run(userTable.insert(self.name <- name, self.birh <- birth)))
        return Int(id)
    } 
    // SQLITE Error Code : https://www.sqlite.org/rescode.html#constraint
    catch let Result.error(message, code, statement) where code == SQLITE_CONSTARAINT {
        // do something
    } catch let error {
        // do something
    }
    return nil
}

/// 查詢
func select<T>(name: String)-> [T] {
    // 查詢指定名稱
    let query1 = userTable.filter( self.name == name)

    // 查詢所有生日小於20歲的名稱, select([Expressible]) 要撈出的資料，沒指定到的不顯示)
    let query2 = userTable.select(self.name).filter(self.birth < 20)

    let result: [T] = []

    if let answers = try? db.prepare(query1) {
        for answer in answers {
            print("name: \(answer(self.name))")
            result.append(answer[self.name])
        }
    }

    return result
}

}


// 待補剩餘



