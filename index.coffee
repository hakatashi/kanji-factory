availableParts = require './src/parts.json'

totalWeight = 0
for character, weight of availableParts
	totalWeight += weight

# Load database
$.get 'data.json', (data) ->
	for own character, tokens of data
		tokens.sort()
	window.data = data
	$(document).ready ->
		resetParts()
		$('.kanji-part').click ->
			$(@).toggleClass 'active'
			checkCreativity()
		$('.go').click ->
			submit()

randint = (lower, upper) ->
	[lower, upper] = [0, lower] unless upper?
	[lower, upper] = [upper, lower] if lower > upper
	return Math.floor(Math.random() * (upper - lower) + lower)

getRandomParts = ->
	level = randint totalWeight
	for character, weight of availableParts
		level -= weight
		return character if level < 0

resetParts = (ids = [0...15]) ->
	for id in ids
		part = getRandomParts()
		$('.kanji-part').eq(id).text(part).removeClass 'active'

submit = ->
	hit = checkCreativity()

	if hit isnt null
		$('.generated-kanjies').append hit
		resetParts [0...15].filter (index) -> $('.kanji-part').eq(index).hasClass 'active'
		$('.go').removeClass 'active'

checkCreativity = ->
	$('.go').removeClass 'active'

	parts = $('.kanji-part.active').map(-> $(@).text()).toArray()
	if parts.length <= 1
		return null

	partsSize = parts.length
	parts.sort()
	for own character, tokens of window.data
		if tokens.length isnt partsSize then continue

		if (parts.every (part, index) -> tokens[index] is part)
			$('.go').addClass 'active'
			return character

	return null
