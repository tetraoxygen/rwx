//
//  BitArray.swift
//  BitArray
//
//  Created by Charlie Welsh on 9/5/21.
//	Credit to https://gist.github.com/harlanhaskins/a8a1837831af17cc81b90f26445c7aca
//

import Foundation

import Foundation

extension BinaryInteger {
	/// Gets the bit at the specified bit index in the receiver, reading from
	/// least to most-significant bit.
	///
	/// For example,
	/// ```
	/// 0b0010.bit(at: 0) == false
	/// 0b0010.bit(at: 1) == true
	/// ```
	func bit(at index: Int) -> Bool {
		return (self >> index) & 1 == 1
	}

	/// Sets the bit at the specified bit index in the receiver, reading from
	/// least to most-significant bit.
	///
	/// For example,
	/// ```
	/// 0b0010.setBit(at: 0, to: true) --> 0b0011
	/// 0b0010.setBit(at: 1, to: false) --> 0b0000
	/// ```
	mutating func setBit(at index: Int, to bool: Bool) {
		if bool {
			self |= (1 << index)
		} else {
			self &= ~(1 << index)
		}
	}
}

/// BitArray is a specialized container of bits that attempts to minimize the
/// amount of memory used.
public struct BitArray: MutableCollection, RandomAccessCollection {
	static let wordSize = MemoryLayout<UInt32>.size
	/// The in-progress collection of 32-bit words holding the bits in this bit
	/// array.
	private var words = [UInt32]()

	/// The bit corresponding to the current index in the last word in the words
	/// array. This last word is considered 'in-flight', and only the bits up to
	/// the currentBitIndex are valid inside the last word.
	private var currentBitIndex = 0

	/// Creates an empty BitArray.
	public init() {
	}

	/// Creates a BitArray from the Bools in the provided sequence.
	public init<Seq: Sequence>(_ sequence: Seq) where Seq.Element == Bool {
		for b in sequence {
			append(b)
		}
	}

	/// Creates a BitArray by reading `bits` bits from the provided Data.
	///
	/// - Parameters:
	///   - data: The data containing the bits to be read in bit order.
	///   - bits: The number of bits to read from the data provided.
	public init(data: Data, bits: Int) {
		precondition(bits <= data.count * 8, "cannot read more bits than Data contains")
		// Get the number of full 32-bit words represented in the data
		let numberOfFullWords = data.count / BitArray.wordSize
		var numberOfWordsRequired = numberOfFullWords
		if data.count % 4 != 0 {
			numberOfWordsRequired += 1
		}
		words = [UInt32](repeating: 0, count: numberOfWordsRequired)

		// Copy the bytes out of the provided data, reading it as a sequence of
		// UInt32s.
		words.withUnsafeMutableBufferPointer {
			_ = data.copyBytes(to: $0)
		}
		self.currentBitIndex = bits - (numberOfFullWords * 32)
	}

	/// The starting bit index (always 0).
	public var startIndex: Int {
		return 0
	}

	/// An index corresponding to 1 past the last bit in the sequence.
	public var endIndex: Int {
		if words.isEmpty { return 0 }
		let numberOfFullWordBits = (words.count - 1) * 32
		return numberOfFullWordBits + Int(currentBitIndex)
	}

	/// The number of bits in the bit array.
	public var count: Int {
		return endIndex
	}

	/// Gets the word and bit index within the word corresponding to the provided
	/// index in the bit array.
	private func convertBitIndexToWordAndBit(_ index: Int) -> (word: Int, bit: Int) {
		precondition(index < endIndex,
					 "cannot read bit \(index) from BitArray with \(count) bits")
		let word = index / 32
		let bit = index % 32
		return (word, bit)
	}

	/// Stores or retrieves the bit at the provided index in the array.
	public subscript(_ bitIndex: Int) -> Bool {
		get {
			let (wordIndex, bit) = convertBitIndexToWordAndBit(bitIndex)
			return words[wordIndex].bit(at: bit)
		}
		set {
			let (wordIndex, bit) = convertBitIndexToWordAndBit(bitIndex)
			words[wordIndex].setBit(at: bit, to: newValue)
		}
	}

	/// Appends the provided Bool to the end of the bit array, adding words
	/// as necessary.
	public mutating func append(_ bool: Bool) {
		if words.isEmpty {
			words.append(0)
		}
		words[words.count - 1].setBit(at: currentBitIndex, to: bool)
		if currentBitIndex == 31 {
			currentBitIndex = 0
			words.append(0)
		} else {
			currentBitIndex += 1
		}
	}

	/// Removes the last bit in the bit array.
	public mutating func removeLast() {
		if currentBitIndex == 0 {
			words.removeLast()
			currentBitIndex = 31
		} else {
			currentBitIndex -= 1
		}
	}

	/// Extracts the minimum number of bytes required to transmit the contents
	/// of this BitArray.
	public var data: Data {
		var d = words.withUnsafeBufferPointer { Data(buffer: $0) }

		// If we have no extra bits to write, or we're going to need the last
		// byte of the last word, then go ahead and finish with our aligned bytes.
		let numUselessBytesFromLastWord = (31 - currentBitIndex) / 8
		d.removeLast(numUselessBytesFromLastWord)

		return d
	}

	/// Gives the value of the data in this array as a hex string.
	public var hexEncodedString: String {
		data.hexEncodedString()
	}

	/// Gives the value of the data in this array as an octal string.
	public var octalEncodedString: String {
		data.octalEncodedString()
	}
}
