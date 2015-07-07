fs = require 'fs'
path = require 'path'
parseIDS = require './parseIDS'

# Tokens dictionary
dict = {}
targets = []
IDSdir = "#{__dirname}/chise-ids"

files = fs.readdirSync(IDSdir).filter (file) -> file.match /^IDS-.+\.txt$/

for file in files
	process.stdout.write "Reading #{file}... "
	data = fs.readFileSync(path.join IDSdir, file).toString()

	lines = data.replace(/\r\n/g, '\n').split '\n'
	tokenCount = 0
	errorCount = 0
	for line in lines
		# Skip comment
		continue if line[0] is ';'

		[id, token, body] = line.split '\t'
		if body isnt undefined and body isnt ''
			try
				dict[token] = parseIDS body
				tokenCount++
				if file is 'IDS-UCS-Basic.txt'
					targets.push token
			catch error
				# console.error "Errored in parsing \"#{line}\"\n#{error}"
				errorCount++

	process.stdout.write "#{tokenCount} tokens imported. #{errorCount} errors.\n"

resolved = {}

for target in targets
	resolveTokens = (AST) ->
		switch AST.type
			when 'character'
				if dict[AST.text]?.type is 'combine'
					[AST, AST.text] = [dict[AST.text], AST.text]
			when 'combine'
				for component, i in AST.components
					AST.components[i] = resolveTokens component
		return AST

	resolved[target] = resolveTokens dict[target]

fs.writeFileSync "#{__dirname}/resolved.json", JSON.stringify resolved

serialized = {}

for token, AST of resolved
	serialize = (AST) ->
		ret = []
		switch AST.type
			when 'character'
				ret.push AST.text
			when 'combine'
				for component in AST.components
					ret = ret.concat serialize component
		return ret

	serialized[token] = serialize AST

fs.writeFileSync "#{__dirname}/serialized.json", JSON.stringify serialized
