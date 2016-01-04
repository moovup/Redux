import UIKit
import XCTest
import Redux

/**

Mock Counter

**/
struct CounterActionCreators {
    let increment: ActionCreator = { args in
        ReduxAction(payload: CounterAction.Increment)
    }
    
    let decrement: ActionCreator = { args in
        ReduxAction(payload: CounterAction.Decrement)
    }
}

enum CounterAction : ReduxActionType {
    case Decrement
    case Increment
}


struct CounterState: AnyEquatable, Equatable {
    var count: Int
}

func ==(lhs: CounterState, rhs: CounterState) -> Bool {
    return lhs.count == rhs.count
}


func counterReducer(previousState: Any, action: ReduxAction) -> Any {
    var counterState = previousState as! CounterState;
    switch action.payload {
    case CounterAction.Increment:
        counterState.count = counterState.count + 1
        break
    case CounterAction.Decrement:
        counterState.count = counterState.count - 1
        break
    default:
        break
    }
    return counterState
}



/**

Mock List

**/
struct ListActionCreators {
    let append: ActionCreator = { (args: Any...) in
        ReduxAction(payload: ListAction.Append(args[0] as! String))
    }
    
    let remove: ActionCreator = { args in
        ReduxAction(payload: ListAction.Remove)
    }
}

enum ListAction : ReduxActionType {
    case Append(String)
    case Remove
}


struct ListState: AnyEquatable, Equatable {
    var list: [String]
}

func ==(lhs: ListState, rhs: ListState) -> Bool {
    return lhs.list == rhs.list
}


func listReducer(previousState: Any, action: ReduxAction) -> Any {
    var listState = previousState as! ListState;
    switch action.payload {
    case ListAction.Append(let str):
        listState.list.append(str)
        break
    case ListAction.Remove:
        listState.list.removeLast()
        break
    default:
        break
    }
    return listState
}



/**

Mock App

**/
struct CombineState: ReduxAppState, AnyEquatable, Equatable {
    var count: CounterState
    var list: ListState
    
    func get(key: String) -> AnyEquatable? {
        switch key {
        case "count": return self.count
        case "list": return self.list
        default: return nil
        }
    }
    
    mutating func set(key: String, value: AnyEquatable) {
        switch key {
        case "count":
            self.count = value as! CounterState
            break
        case "list":
            self.list = value as! ListState
            break
        default:
            break
        }
    }
}

func ==(lhs: CombineState, rhs: CombineState) -> Bool {
    return lhs.count == rhs.count && lhs.list == rhs.list
}


class Store: StoreType {
    
    static func configureStore() -> ReduxStore {
        
        let initialState = CombineState(
            count: CounterState(count: 0),
            list: ListState(list: [String]())
        )
        
        let reducers: [String: Reducer] = [
            "count": counterReducer,
            "list": listReducer
        ]
        
        return createStore(combineReducers(reducers), initialState: initialState)
    }
    
}

extension ReduxStore {
    
    func getCountState() -> CounterState {
        return getAppState().get("count") as! CounterState
    }
    
    func getListState() -> ListState {
        return getAppState().get("list") as! ListState
    }
}

