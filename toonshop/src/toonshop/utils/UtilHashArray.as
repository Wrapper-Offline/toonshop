package toonshop.utils
{
	import toonshop.utils.UtilHashMap;

	public class UtilHashArray
	{
		private var keyToIndexMap:UtilHashMap;
		private var indexToKeyMap:Array;
		private var data:Array;

		public function UtilHashArray()
		{
			super();
			this.keyToIndexMap = new UtilHashMap();
			this.indexToKeyMap = new Array();
			this.data = new Array();
		}

		/**
		 * pushes a value to the array 
		 * @param key
		 * @param value
		 * @param hasConflict
		 * @return index
		 */		
		public function push(key:String, value:*, hasConflict:Boolean = true) : int
		{
			var index:int = 0;
			if (this.keyToIndexMap.containsKey(key)) {
				if (hasConflict) {
					index = this.keyToIndexMap.getValue(key) as int;
					this.data[index] = value;
				} else {
					throw new Error("The key "+key+" already exists in the HashArray.");
				}
			} else {
				index = int(this.data.length);
				this.data.push(value);
				this.indexToKeyMap.push(key);
				this.keyToIndexMap.put(key, index);
			}
			return index;
		}

		public function remove(startIndex:int, removeCount:int) : void
		{
			var index:int = 0;
			if(startIndex >= this.length || startIndex + removeCount - 1 >= this.length)
			{
				throw new Error("UtilHashArray index out of bound error. Index --> " + startIndex);
			}
			index = 0;
			while(index < removeCount)
			{
				this.keyToIndexMap.remove(this.indexToKeyMap[startIndex + index]);
				index++;
			}
			this.data.splice(startIndex, removeCount);
			this.indexToKeyMap.splice(startIndex, removeCount);
			// correct all the indexes in the keytoindexmap
			index = startIndex;
			while(index < this.length)
			{
				this.keyToIndexMap.remove(this.indexToKeyMap[index]);
				this.keyToIndexMap.put(this.indexToKeyMap[index], index);
				index++;
			}
		}

		public function removeByKey(key:String) : void
		{
			var index:int = this.getIndex(key);
			if(index != -1)
			{
				this.remove(index, 1);
			}
		}

		/**
		 * merges 2 UtilHashArrays at an insert index 
		 * @param insertIndex where do i put it
		 * @param array the new array to be inserting into the old array
		 * @param hasConflict does the new array contain keys already found in the old array? if it does this function replaces the old array's
		 */		
		public function insert(insertIndex:int, array:UtilHashArray, hasConflict:Boolean = true) : void
		{
			var array2:UtilHashArray = array.clone();
			var index:int = array2.length - 1;
			while (index >= 0) {
				var key:String = array2.getKey(index);
				if (this.containsKey(key)) {
					if (hasConflict) {
						// just go in and replace every conflict with the new array
						this.replaceValueByKey(key, array2.getValueByIndex(index));
						array2.remove(index, 1);
					} else {
						// check for any conflicts
						throw new Error("The key "+key+" already exists in the HashArray.");
					}
				}
				index--;
			}
			// this.indexToKeyMap.splice(insertIndex, 0, ...array2.indexToKeyMap.concat());
			var spliceFunc:Function = this.indexToKeyMap.splice;
			var array2clone:Array = array2.indexToKeyMap.concat();
			array2clone.unshift(0);
			array2clone.unshift(insertIndex);
			spliceFunc.apply(this.indexToKeyMap, array2clone);
			// this.data.splice(insertIndex, 0, ...array2.data.concat());
			spliceFunc = this.data.splice;
			array2clone = array2.data.concat();
			array2clone.unshift(0);
			array2clone.unshift(insertIndex);
			spliceFunc.apply(this.data, array2clone);
			// wham bam thank you ma'am
			array2.removeAll();
			array2 = null;
			// pretty much just redo everything in the index map from the insertindex up
			index = insertIndex;
			while(index < this.length)
			{
				this.keyToIndexMap.put(this.indexToKeyMap[index], index);
				index++;
			}
		}

		public function containsKey(key:String) : Boolean
		{
			return this.keyToIndexMap.containsKey(key);
		}

		public function containsValue(value:*) : Boolean
		{
			var index:int = 0;
			while (index < this.data.length)
			{
				if (this.data[index] == value) {
					return true;
				}
				index++;
			}
			return false;
		}

		/**
		 * get a key at an index 
		 * @param index
		 * @return the key you asked for
		 */		
		public function getKey(index:int) : String
		{
			return this.indexToKeyMap[index];
		}

		public function getKeys() : Array
		{
			return this.indexToKeyMap;
		}

		/**
		 * get an index at a key
		 * @param key
		 * @return the index you asked for
		 */		
		public function getIndex(key:String) : int
		{
			var index:* = this.keyToIndexMap.getValue(key);
			if (index != null) {
				return int(index);
			}
			return -1;
		}

		public function getValueByKey(key:String) : *
		{
			var index:int = this.getIndex(key);
			if (index > -1) {
				return this.data[index];
			}
			return null;
		}

		public function getValueByIndex(index:int) : *
		{
			return this.data[index];
		}

		public function replaceValueByIndex(index:int, newValue:*) : void
		{
			if (index >= this.length || index < 0) {
				throw new Error("index out of bound");
			}
			this.data[index] = newValue;
		}

		public function replaceValueByKey(key:String, newValue:*) : void
		{
			var index:int = this.getIndex(key);
			if (index == -1) {
				throw new Error("The specified key does not exist.");
			}
			this.data[index] = newValue;
		}

		public function get length() : int
		{
			return this.data.length;
		}

		public function removeAll() : void
		{
			this.keyToIndexMap.clear();
			this.keyToIndexMap = new UtilHashMap();
			this.indexToKeyMap.splice(0,this.indexToKeyMap.length);
			this.indexToKeyMap = new Array();
			this.data.splice(0,this.data.length);
			this.data = new Array();
		}

		public function getArray() : Array
		{
			return this.data;
		}

		public function unshift(key:String, value:Object) : uint
		{
			if (this.keyToIndexMap.containsKey(key)) {
				this.remove(this.getIndex(key), 1);
			}
			this.data.unshift(value);
			this.indexToKeyMap.unshift(key);
			// ugh we gotta redo this index map again
			var index:int = 0;
			while (index < this.indexToKeyMap.length) {
				this.keyToIndexMap.put(this.indexToKeyMap[index], index);
				index++;
			}
			return this.length;
		}

		public function clone() : UtilHashArray
		{
			var newArray:UtilHashArray = new UtilHashArray();
			newArray.data = this.data.concat();
			newArray.indexToKeyMap = this.indexToKeyMap.concat();
			var index:int = 0;
			while(index < newArray.indexToKeyMap.length) {
				newArray.keyToIndexMap.put(newArray.indexToKeyMap[index], index);
				index++;
			}
			return newArray;
		}

		public function isIdentical(compare:UtilHashArray) : Boolean
		{
			if (this.data.toString() == compare.data.toString() && this.indexToKeyMap.toString() == compare.indexToKeyMap.toString())
			{
				return true;
			}
			return false;
		}
	}
}
