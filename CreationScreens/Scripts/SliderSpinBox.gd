extends HSplitContainer

var curVal

func _ready():
	curVal = $SpinBox.value
	curVal = $Slider.value

func _on_slider_drag_ended(value_changed):
	$SpinBox.value = $Slider.value
	curVal = $SpinBox.value
	curVal = $Slider.value

func _on_spin_box_value_changed(value):
	$Slider.value = value
	curVal = $SpinBox.value
	curVal = $Slider.value

func assignValue(value):
	$Slider.value = value
	$SpinBox.value = value
	$Slider.value = value
	curVal = $SpinBox.value
	curVal = $Slider.value
