package toonshop.utils
{
	import flash.utils.Dictionary;
	
	public dynamic class UtilHashMap extends Dictionary
	{
		
		public function UtilHashMap(weakKeys:Boolean = false)
		{
			super(weakKeys);
		}
		
		public function put(key:String, value:*) : void
		{
			this[key] = value;
		}
		
		public function remove(key:String) : void
		{
			this[key] = null;
			delete this[key];
		}
		
		public function containsKey(key:String) : Boolean
		{
			return this[key] != null;
		}
		
		public function containsValue(value:*) : Boolean
		{
			var iteratedKey:String = null;
			for (iteratedKey in this)
			{
				if (this[iteratedKey] == value)
				{
					return true;
				}
			}
			return false;
		}
		
		public function getKey(key:*) : String
		{
			var iteratedKey:String = null;
			for (iteratedKey in this)
			{
				if (this[iteratedKey] == key)
				{
					return iteratedKey;
				}
			}
			return null;
		}
		
		public function getValue(key:String) : *
		{
			return this[key];
		}
		
		public function size() : int
		{
			var iteratedKey:String = null;
			var length:int = 0;
			for (iteratedKey in this)
			{
				length++;
			}
			return length;
		}
		
		public function isEmpty() : Boolean
		{
			return this.size() <= 0;
		}
		
		public function clear() : void
		{
			var iteratedKey:String = null;
			for (iteratedKey in this)
			{
				this[iteratedKey] = null;
				delete this[iteratedKey];
			}
		}
	}
}
