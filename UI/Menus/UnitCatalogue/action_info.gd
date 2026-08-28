extends Control

func init(action: Action):
	$ActionName.text = action.name
	$RangeLabel.text = "Range: " + str(action.range)
	if action.strength > 0:
		$StrengthLabel.text = "Strength: " + str(action.strength)
	else:
		$StrengthLabel.hide()
