require 'string.fromcodepoint'
require 'string.prototype.codepointat'

ord = (char) -> char.codePointAt 0
chr = (codePoint) -> String.fromCodePoint codePoint

# IDS parser
module.exports = (IDS) ->
	originalIDS = IDS

	# Tokenize
	tokens = []
	while IDS.length > 0
		codePoint = ord IDS

		if codePoint is ord '&'
			indexOfSemicolon = IDS.indexOf ';'
			token =
				type: 'character'
				body: IDS[0 .. indexOfSemicolon]
		else if 0x2FF0 <= codePoint < 0x3000
			token =
				type: 'combine'
				body: chr codePoint
		else
			token =
				type: 'character'
				body: chr codePoint

		IDS = IDS[token.body.length..]
		tokens.push token

	numberOfComponents =
		'⿰': 2
		'⿱': 2
		'⿲': 3
		'⿳': 3
		'⿴': 2
		'⿵': 2
		'⿶': 2
		'⿷': 2
		'⿸': 2
		'⿹': 2
		'⿺': 2
		'⿻': 2

	# Build AST
	# Slice tokens directly
	buildAST = ->
		switch tokens[0].type
			when 'character'
				AST =
					type: 'character'
					text: tokens[0].body
				tokens = tokens[1..]
			when 'combine'
				AST =
					type: 'combine'
					composition: tokens[0].body
					components: []

				times = numberOfComponents[tokens[0].body]
				tokens = tokens[1..]
				for i in [1..times]
					if tokens.length is 0
						throw new Error "Expected argument ##{i}
							of #{AST.composition} in #{originalIDS}
							is missing"
					AST.components.push buildAST()

		return AST

	AST = buildAST()
