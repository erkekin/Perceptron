
//  Functions
//  Perceptron
//
//  Created by Erk EKİN on 22/11/15.
//  Copyright © 2016 Erk Ekin. All rights reserved.
//

import Foundation

internal typealias Function = (Double) -> Double

internal enum Functions {

	case Step(t: Double)
	case Sigmoid
	case Rectifier
	case SoftMax

	var function: Function {
		switch self {
		case let .Step(t):
			return { $0 >= t ? 1.0 : -1.0 }
		case .Sigmoid:
			return { 1 / (1 + exp($0)) }
		case .Rectifier:
			return { max(0, $0) }
		case .SoftMax:
			return { log(1 + exp($0)) }
		}
	}
	
}
