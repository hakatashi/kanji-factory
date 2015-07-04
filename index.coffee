availableParts =
	"一": 11006
	"口": 8040
	"十": 4399
	"ノ": 3334
	"木": 2270
	"丶": 1792
	"八": 1420
	"艹": 1386
	"⺡": 1200
	"大": 985
	"𠆢": 887
	"⺅": 845
	"月": 823
	"又": 801
	"⺘": 764
	"女": 754
	"儿": 725
	"金": 721
	"火": 712
	"宀": 709
	"ク": 657
	"亠": 646
	"糸": 598
	"虫": 585
	"山": 568
	"灬": 521
	"言": 509
	"勹": 505
	"厶": 498
	"冖": 487
	"冂": 484
	"心": 475
	"⻖": 441
	"人": 431
	"⺖": 416
	"⺮": 409
	"夂": 390
	"尸": 383
	"石": 373
	"寸": 361
	"隹": 360
	"攵": 359
	"辶": 350
	"鳥": 329
	"力": 318
	"⺉": 315
	"厂": 313
	"皿": 291
	"艮": 290
	"立": 286
	"广": 282
	"夕": 278
	"匕": 265
	"車": 264
	"耳": 262
	"刀": 261
	"子": 255
	"几": 255
	"巾": 254
	"工": 245
	"足": 241
	"疒": 234
	"止": 234
	"丁": 232
	"衤": 228
	"馬": 224
	"方": 221
	"⺨": 216
	"小": 210
	"羽": 208
	"雨": 205
	"門": 205
	"⺫": 200
	"彳": 198
	"䒑": 197
	"廾": 197
	"戈": 195
	"彡": 192
	"酉": 188
	"匚": 187
	"斤": 186
	"虍": 182
	"欠": 182
	"弓": 164
	"幺": 156
	"爫": 150
	"龷": 140
	"示": 138
	"⺊": 137
	"㐅": 134
	"冫": 132
	"西": 132
	"豕": 126
	"㔾": 125
	"⺌": 124
	"衣": 122
	"ネ": 121
	"⺧": 119
	"革": 118
	"丂": 116

totalWeight = 0
for character, weight of availableParts
	totalWeight += Math.pow weight, 0.7

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

getRandomParts = ->
	level = randint totalWeight
	for character, weight of availableParts
		level -= Math.pow weight, 0.7
		return character if level < 0

resetParts = (ids = [0..14]) ->
	for id in ids
		part = getRandomParts()
		$('.kanji-part').eq(id).text(part).removeClass 'active'

submit = ->
	parts = $('.kanji-part.active').map(-> $(@).text()).toArray()

	return if parts.length is 1

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
		resetParts [0..15].filter (index) -> $('.kanji-part').eq(index).hasClass 'active'
