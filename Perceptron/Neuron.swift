
//  Neuron
//  Perceptron
//
//  Created by Erk EKİN on 22/11/15.
//  Copyright © 2016 Erk Ekin. All rights reserved.
//


import Foundation

import Accelerate

public class Neuron {

	var activation: Function
	var weight: la_object_t

	init(activation: Function, weight: la_object_t) {
		self.activation = activation
		self.weight = weight
	}

	func propagate(input: [Double]) -> Double {
   
		assert(la_count_t(input.count) == la_matrix_rows(self.weight), "the number of input must equal to the number of weight")
        
		let input = la_matrix_from_double_buffer(input, la_count_t(input.count), 1, 1, la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        
		let product = la_matrix_product(input, self.weight)
        
		let identity = la_matrix_from_double_buffer([Double](count: Int(la_matrix_rows(product)), repeatedValue: 1.0), 1, la_matrix_rows(product), la_matrix_rows(product), la_hint_t(LA_NO_HINT), la_attribute_t(LA_DEFAULT_ATTRIBUTES))
        
		let sumMatrix = la_matrix_product(product, identity)
        
		var elements = [Double](count: Int(la_matrix_rows(sumMatrix) * la_matrix_cols(sumMatrix)), repeatedValue: Double(0.0))
        
		let status = la_matrix_to_double_buffer(&elements, la_matrix_rows(sumMatrix), sumMatrix)
        
		assert(status == la_status_t(LA_SUCCESS), "status must be success")
        
		return self.activation(elements[0])
	}
	
}
