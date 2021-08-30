extends Control

signal saveItem

onready var tabContainer : TabContainer = $AddCondPanel/TabContainer
onready var optionalCheckBox : CheckBox = $AddCondPanel/OptionalCheckBox

#-----------------
onready var PlayerCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/PlayerCheckBox"
onready var PVariableCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/CheckBox"
onready var PVConstantCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Constant/CheckBox"
onready var PVPlayerCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Player/CheckBox"
onready var PVOpponentCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Opponent/CheckBox"
onready var PVLMCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/LM/CheckBox"

onready var PVNumberOptionBtn : OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Number/OptionButton"
onready var PVOperatorOptionBtn: OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Number/OperatorValue"
onready var PVConstantSpinBox: SpinBox = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Constant/SpinBox"
onready var PVPlayerOptionBtn: OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Player/OptionButton"
onready var PVOpponentOptionBtn: OptionButton = $"AddCondPanel/TabContainer/1/Content/Variable/Value/Opponent/OptionButton"
onready var PVLMLineEdit: LineEdit = $"AddCondPanel/TabContainer/1/Content/Variable/Value/LM/LineEdit"

onready var PHaveCheckBox: CheckBox = $"AddCondPanel/TabContainer/1/Content/Have/CheckBox"
onready var PHaveLineEdit: LineEdit = $"AddCondPanel/TabContainer/1/Content/Have/LineEdit"
#-----------------
onready var CardCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/CardCheckBox"
onready var CIdCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Id/CheckBox"
onready var CIdLineEdit: LineEdit = $"AddCondPanel/TabContainer/2/Content/Id/LineEdit"

onready var CVariableCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/CheckBox"
onready var CVNumberOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Number/OptionButton"
onready var CVOperatorOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Number/OperatorValue"
onready var CVConstantCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Constant/CheckBox"
onready var CVConstantSpinBox: SpinBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/Constant/SpinBox"
onready var CVLMCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Variable/Value/LM/CheckBox"
onready var CVLMLineEdit: LineEdit = $"AddCondPanel/TabContainer/2/Content/Variable/Value/LM/LineEdit"

onready var CFamilyCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Family/CheckBox"
onready var CFamilyOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Family/OptionButton"
onready var CRaceCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Race/CheckBox"
onready var CRaceOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Race/OptionButton"
onready var CElementCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Element/CheckBox"
onready var CElementOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Element/OptionButton"
onready var CSpecialCheckBox: CheckBox = $"AddCondPanel/TabContainer/2/Content/Special/CheckBox"
onready var CSpecialOptionBtn: OptionButton = $"AddCondPanel/TabContainer/2/Content/Special/OptionButton"

#-----------------

var cardCondEditing: CardCondition
var index: int
var adding: bool

# Called when the node enters the scene tree for the first time.
func _ready():
	PVOperatorOptionBtn.get_popup().clear()
	CVOperatorOptionBtn.get_popup().clear()
	for i in EnumData.OperatorValue():
		PVOperatorOptionBtn.get_popup().add_radio_check_item(EnumData.OperatorValue()[i], i)
		CVOperatorOptionBtn.get_popup().add_radio_check_item(EnumData.OperatorValue()[i], i)
	PVOperatorOptionBtn.select(0)
	CVOperatorOptionBtn.select(0)
	#-------
	PVNumberOptionBtn.get_popup().clear()
	PVPlayerOptionBtn.get_popup().clear()
	PVOpponentOptionBtn.get_popup().clear()
	for i in EnumData.PlayerAttributeCond:
		PVNumberOptionBtn.get_popup().add_radio_check_item(i)
		PVPlayerOptionBtn.get_popup().add_radio_check_item(i)
		PVOpponentOptionBtn.get_popup().add_radio_check_item(i)
	PVNumberOptionBtn.select(0)
	PVPlayerOptionBtn.select(0)
	PVOpponentOptionBtn.select(0)
	#-------
	CVNumberOptionBtn.get_popup().clear()
	for i in EnumData.CardAttributeCond:
		CVNumberOptionBtn.get_popup().add_radio_check_item(i)
	#-------
	
	#-------
	CElementOptionBtn.get_popup().clear()
	for i in CardData.CARD_ELEMENT:
		CElementOptionBtn.get_popup().add_radio_check_item(i)
	CElementOptionBtn.select(0)
	#-------
	CSpecialOptionBtn.get_popup().clear()
	for i in EnumData.CardSpecialCond:
		CSpecialOptionBtn.get_popup().add_radio_check_item(i)
	CSpecialOptionBtn.select(0)
	#-------
	var nodeRadio = get_tree().get_nodes_in_group("RadioButton")
	for node in nodeRadio:
		node.connect("pressed", self, "_RefreshNodeEnable")
	hide()

func ShowPanel(data: CardCondition, index:int = 0, new: bool = false):
	adding = new
	cardCondEditing = data
	optionalCheckBox.pressed = cardCondEditing.optional
	match(cardCondEditing.conditionType):
		CardCondition.ConditionType.Player:
			tabContainer.current_tab = 0
			PlayerCheckBox.pressed = true
			match(cardCondEditing.conditionWhat):
				CardCondition.PlayerCondidionType.Variable:
					PVariableCheckBox.pressed = true
					PVNumberOptionBtn.selected = cardCondEditing.variableCond.number1
					PVOperatorOptionBtn.selected = cardCondEditing.variableCond.operator
					match(cardCondEditing.variableCond.checkType):
						EnumData.NumberValueType.Constant:
							PVConstantCheckBox.pressed = true
							PVConstantSpinBox.value = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.Player:
							PVPlayerCheckBox.pressed = true
							PVPlayerOptionBtn.selected = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.Opponent:
							PVOpponentCheckBox.pressed = true
							PVOpponentOptionBtn.selected = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.LM:
							PVLMCheckBox.pressed = true
							PVLMLineEdit.text = cardCondEditing.variableCond.variableName
				CardCondition.PlayerCondidionType.Have:
					PHaveCheckBox.pressed = true
					PHaveLineEdit.text = cardCondEditing.variableCond.cardId
		CardCondition.ConditionType.Card:
			tabContainer.current_tab = 1
			CardCheckBox.pressed = true
			match(cardCondEditing.conditionWhat):
				CardCondition.CardCondidionType.Id:
					CIdCheckBox.pressed = true
					CIdLineEdit.text = cardCondEditing.cardId
				CardCondition.CardCondidionType.Variable:
					CVariableCheckBox.pressed = true
					CVNumberOptionBtn.selected = cardCondEditing.variableCond.number1
					CVOperatorOptionBtn.selected = cardCondEditing.variableCond.operator
					match(cardCondEditing.variableCond.checkType):
						EnumData.NumberValueType.Constant:
							CVConstantCheckBox.pressed = true
							CVConstantSpinBox.value = cardCondEditing.variableCond.number2
						EnumData.NumberValueType.LM:
							CVLMCheckBox.pressed = true
							CVLMLineEdit.text = cardCondEditing.variableCond.variableName
				CardCondition.CardCondidionType.Family:
					CFamilyCheckBox.pressed = true
					CFamilyOptionBtn
				CardCondition.CardCondidionType.Race:
					CRaceCheckBox.pressed = true
					CRaceOptionBtn
				CardCondition.CardCondidionType.Element:
					CElementCheckBox.pressed = true
					CElementOptionBtn.selected = cardCondEditing.element
				CardCondition.CardCondidionType.Special:
					CSpecialCheckBox.pressed = true
					CSpecialOptionBtn.selected = cardCondEditing.special
	_RefreshNodeEnable()
	show()

func _RefreshNodeEnable():
	PVariableCheckBox.disabled = not PlayerCheckBox.pressed
	PVNumberOptionBtn.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVOperatorOptionBtn.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVConstantCheckBox.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVConstantSpinBox.editable = not (PVConstantCheckBox.disabled or not PVConstantCheckBox.pressed)
	PVPlayerCheckBox.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVPlayerOptionBtn.disabled = PVPlayerCheckBox.disabled or not PVPlayerCheckBox.pressed
	PVOpponentCheckBox.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVOpponentOptionBtn.disabled = PVOpponentCheckBox.disabled or not PVOpponentCheckBox.pressed
	PVLMCheckBox.disabled = PVariableCheckBox.disabled or not PVariableCheckBox.pressed
	PVLMLineEdit.editable = not (PVLMCheckBox.disabled or not PVLMCheckBox.pressed)
	
	PHaveCheckBox.disabled =  not PlayerCheckBox.pressed
	PHaveLineEdit.editable = not (PHaveCheckBox.disabled or not PHaveCheckBox.pressed)
	
	CIdCheckBox.disabled = not CardCheckBox.pressed
	CIdLineEdit.editable = not (CIdCheckBox.disabled or not CIdCheckBox.pressed)
	CVariableCheckBox.disabled = not CardCheckBox.pressed
	CVNumberOptionBtn.disabled = CVariableCheckBox.disabled or not CVariableCheckBox.pressed
	CVOperatorOptionBtn.disabled = CVariableCheckBox.disabled or not CVariableCheckBox.pressed
	CVConstantCheckBox.disabled = CVariableCheckBox.disabled or not CVariableCheckBox.pressed
	CVConstantSpinBox.editable = not (CVConstantCheckBox.disabled or not CVConstantCheckBox.pressed)
	CVLMCheckBox.disabled = CVariableCheckBox.disabled or not CVariableCheckBox.pressed
	CVLMLineEdit.editable = not (CVLMCheckBox.disabled or not CVLMCheckBox.pressed)
	
	CFamilyCheckBox.disabled = not CardCheckBox.pressed
	CFamilyOptionBtn.disabled = CFamilyCheckBox.disabled or not CFamilyCheckBox.pressed
	CRaceCheckBox.disabled = not CardCheckBox.pressed
	CRaceOptionBtn.disabled = CRaceCheckBox.disabled or not CRaceCheckBox.pressed
	CElementCheckBox.disabled = not CardCheckBox.pressed
	CElementOptionBtn.disabled = CElementCheckBox.disabled or not CElementCheckBox.pressed
	CSpecialCheckBox.disabled = not CardCheckBox.pressed
	CSpecialOptionBtn.disabled = CSpecialCheckBox.disabled or not CSpecialCheckBox.pressed


func _on_OptionalCheckBox_pressed():
	cardCondEditing.optional = optionalCheckBox.pressed

func _on_SaveBtn_pressed():
	if PlayerCheckBox.pressed:
		cardCondEditing.conditionType = CardCondition.ConditionType.Player
		if PVariableCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.PlayerCondidionType.Variable
			cardCondEditing.variableCond.number1 = PVNumberOptionBtn.selected
			cardCondEditing.variableCond.operator = PVOperatorOptionBtn.selected
			if PVConstantCheckBox.pressed:
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.Constant
				cardCondEditing.variableCond.number2 = PVConstantSpinBox.value
			elif PVPlayerCheckBox.pressed:
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.Player
				cardCondEditing.variableCond.number2 = PVPlayerOptionBtn.selected
			elif PVOpponentCheckBox.pressed:
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.Opponent
				cardCondEditing.variableCond.number2 = PVOpponentOptionBtn.selected
			else: #PVLMCheckBox.pressed
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.LM
				cardCondEditing.variableCond.variableName = PVLMLineEdit.text
		else:
			cardCondEditing.conditionWhat = CardCondition.PlayerCondidionType.Have
			cardCondEditing.cardId = PHaveLineEdit.text
	else:
		cardCondEditing.conditionType = CardCondition.ConditionType.Card
		if CIdCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Id
			cardCondEditing.cardId = CIdLineEdit.text
		elif CVariableCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Variable
			cardCondEditing.variableCond.number1 = CVNumberOptionBtn.selected
			cardCondEditing.variableCond.operator = CVOperatorOptionBtn.selected
			if CVConstantCheckBox.pressed:
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.Constant
				cardCondEditing.variableCond.number2 = CVConstantSpinBox.value
			else: #PVLMCheckBox.pressed
				cardCondEditing.variableCond.checkType = EnumData.NumberValueType.LM
				cardCondEditing.variableCond.variableName = CVLMLineEdit.text
		elif CFamilyCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Family
		
		elif CRaceCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Race
		
		elif CElementCheckBox.pressed:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Element
			cardCondEditing.element = CElementOptionBtn.selected
		else:
			cardCondEditing.conditionWhat = CardCondition.CardCondidionType.Special
			cardCondEditing.special = CSpecialOptionBtn.selected
	emit_signal("saveItem", cardCondEditing, index, adding)
	hide()

func _on_CancelBtn_pressed():
	hide()
