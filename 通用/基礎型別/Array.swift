/*
some array 用法
*/


// create array for Consecutive numbers
let array = Array(0...5)
let array2 = Array(5..100)

// Array 自動分拆為 字典分組
// 字典分組

let books = ["Apple Man", "America Dream", "Big Mom", "bee", "A Book", "Panic", "Padma", "Mom 995"]

let bookList = Dictionary(grouping: books, by: {
    $0.prefix(1)
})

