class_name ProcedureManager extends BaseStateMachine

enum PROCEDURE_TYPE{
	LAUNCH,
	INIT_RESOURCE,
	BEGAIN_GAME
}

class ProcedureLaunch extends BaseState:
	
	func enter(msg:={}):
		print("Launch")
		transition_to(PROCEDURE_TYPE.INIT_RESOURCE)

class ProcedureInitResource extends BaseState:
	
	func _init():
		DatatableManager.load_complated.connect(
			func():
				transition_to(PROCEDURE_TYPE.BEGAIN_GAME)
		)
	
	func enter(msg:={}):
		print("InitResource")
		DatatableManager.load_resource()
	

class ProcedureBegainGame extends BaseState:
	func enter(msg:={}):
		print("BegainGame")
		var world = AssetUtility.WORLD.instantiate()
		agent.add_child(world)
		_feed_data.call_deferred()
	
	func _feed_data():
		Globals.player_inventory._feed_data()
		Globals.temp_craft_panel._feed_data()
		Globals.temp_entity_manager._feed_data()	

func _ready():
	add_state(PROCEDURE_TYPE.LAUNCH, ProcedureLaunch.new())
	add_state(PROCEDURE_TYPE.INIT_RESOURCE, ProcedureInitResource.new())
	add_state(PROCEDURE_TYPE.BEGAIN_GAME, ProcedureBegainGame.new())
	launch.call_deferred(PROCEDURE_TYPE.LAUNCH)
