class_name EnergyStateComponent extends EntityBaseComponent

signal energy_state_changed

enum EnergyState {NoPower, Normal, LowPower}
var energy_state := EnergyState.NoPower:
	set(value):
		energy_state = value
		energy_state_changed.emit()
		
