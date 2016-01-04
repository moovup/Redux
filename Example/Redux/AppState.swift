//
//  AppState.swift
//  SwiftRedux
//
//  Created by Steven Chan on 31/12/15.
//  Copyright © 2015 CocoaPods. All rights reserved.
//

import Redux

let kAppStateKeyTodoList = "todoList"

struct AppState: ReduxAppState, AnyEquatable, Equatable {
    var todoList: TodoListState
    
    func get(key: String) -> AnyEquatable? {
        switch key {
        case kAppStateKeyTodoList: return self.todoList
        default: return nil
        }
    }
    
    mutating func set(key: String, value: AnyEquatable) {
        switch key {
        case kAppStateKeyTodoList:
            self.todoList = value as! TodoListState
            break
        default:
            break
        }
    }
}

func ==(lhs: AppState, rhs: AppState) -> Bool {
    return lhs.todoList == rhs.todoList
}


extension ReduxStore {
    
    func getTodoListState() -> TodoListState {
        return getAppState().get(kAppStateKeyTodoList) as! TodoListState
    }
    
}
