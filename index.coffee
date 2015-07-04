availableParts = [
	"一", "口", "十", "木", "ノ", "丶", "丿", "艹",
	"シ", "大", "八", "𠆢", "イ", "月", "又", "⺘",
	"女", "金", "火", "宀", "ク", "亠", "糸", "儿",
	"虫", "山", "灬", "言", "勹", "厶", "貝", "冖",
	"心", "⻖", "冂", "⺖", "⺮", "土", "夂", "人",
	"石", "寸", "隹", "攵", "辶", "鳥", "力", "⺉",
	"厂", "皿", "艮", "广", "夕", "匕", "尸", "車",
	"耳", "刀", "几", "子", "巾", "钅", "工", "足",
	"疒", "止", "丁", "衤", "馬", "方", "⺨", "小",
	"羽", "立", "雨", "門", "⺫", "彳", "䒑", "廾",
	"戈", "彡", "酉", "匚", "斤", "欠", "虍", "贝",
	"弓", "纟", "讠", "幺", "爫", "龷", "示", "⺊",
	"㐅", "冫", "西", "兀", "豕", "㔾", "⺌", "衣",
	"ネ", "⺧", "革", "户", "丂", "巳", "臼", "比",
	"戊", "舟", "巛", "マ", "龰", "辛", "毛", "二"
]

# Load database
$.get 'data.json', (data) ->
	for own character, tokens of data
		tokens.sort()
	window.data = data
	$(document).ready ->
		resetParts()
		$('.kanji-part').click ->
			$(@).toggleClass 'active'
		$('.go').click ->
			submit()

randint = (lower, upper) ->
	[lower, upper] = [0, lower] unless upper?
	[lower, upper] = [upper, lower] if lower > upper
	return Math.floor(Math.random() * (upper - lower) + lower)

resetParts = (ids = [0..9]) ->
	for id in ids
		part = availableParts[randint availableParts.length]
		$('.kanji-part').eq(id).text(part).removeClass 'active'

submit = ->
	parts = []
	$('.kanji-part').each ->
		parts.push $(@).text() if $(@).hasClass 'active'

	partsSize = parts.length
	hit = null
	parts.sort()
	for own character, tokens of window.data
		if tokens.length isnt partsSize then continue

		if (parts.every (part, index) -> tokens[index] is part)
			hit = character
			break

	if hit isnt null
		$('.generated-kanjies').append hit
		resetParts [0..9].filter (index) -> $('.kanji-part').eq(index).hasClass 'active'
