extends RefCounted

func test_storage():
	var storage1 = Storage.create(1, 10)
	var storage2 = Storage.create(2, 20)
	var storage3 = Storage.create(3, 44)
	var storage4 = Storage.create(2, 35)
	
	var sc = StorageCollection.new()
	sc.append_storage(storage1)
	sc.append_storage(storage2)
	sc.append_storage(storage3)
	sc.append_storage(storage4)
	
	var data = sc.get_type_total_data()
	print(data)
	
	var f_sc = StorageCollection.new()
	f_sc.append_storage(Storage.create(1, 2))
	f_sc.append_storage(Storage.create(2, 1))
	

