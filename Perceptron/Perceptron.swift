
//  Perceptron
//  Perceptron
//
//  Created by Erk EKİN on 22/11/15.
//  Copyright © 2016 Erk Ekin. All rights reserved.
//

import Foundation

import Accelerate

public class Perceptron {

	public var neuron: Neuron! = nil

	public init() {

	}

	public func train(inputs inputs: [[Double]], outputs: [Double], learningRate: Double, epsilon: Double) {
		assert(inputs.count == outputs.count, "the number of input must equal to the number of output")

		let inputs = inputs.map({ [1.0] + $0 })

		self.neuron = {
			let weight = inputs[0].map({ (_) -> Double in
				return Double(arc4random_uniform(UInt32.max)) / Double(UInt32.max)
			})
			return Neuron(activation: Functions.Step(t: 0.0).function, weight: la_matrix_from_double_buffer(weight, la_count_t(weight.count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES)))
			}()

		var oldWeight: la_object_t
		repeat {
			oldWeight = self.neuron.weight
			for i in 0 ..< inputs.count {
				let input = la_matrix_from_double_buffer(inputs[i], la_count_t(inputs[i].count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
				let expected = outputs[i]
				let output = self.neuron.propagate(inputs[i])
				if abs(expected - output) >= abs(epsilon) {
					let error = la_scale_with_double(input, learningRate * (expected - output))
					let newWeight = la_sum(self.neuron.weight, error)
					self.neuron.weight = newWeight
				}
			}
		} while la_norm_as_double(la_difference(oldWeight, self.neuron.weight), la_norm_t(LA_L1_NORM)) > 0
	}

	public func test(input: [Double]) -> Double {
		assert(self.neuron != nil, "test must not be called before the network is trained")
		return self.neuron.propagate([1.0] + input)
	}
	
}
