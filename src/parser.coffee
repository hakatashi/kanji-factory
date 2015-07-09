fs = require 'fs'
util = require 'util'
path = require 'path'
extend = require 'xtend'
parseIDS = require './parseIDS'

# Tokens dictionary
dict = {}
targets = []
IDSdir = "#{__dirname}/chise-ids"

# Parse opotions
options = {}
options.all = '--all' in process.argv

files = fs.readdirSync(IDSdir).filter (file) -> file.match /^IDS-.+\.txt$/
files.push '../overload.txt'

for file in files
	process.stdout.write "Loading #{file}... "
	data = fs.readFileSync(path.join IDSdir, file).toString()

	lines = data.replace(/\r\n/g, '\n').split '\n'
	tokenCount = 0
	errorCount = 0
	for line in lines
		# Skip comment
		continue if line[0] is ';'

		if file is '../overload.txt'
			[token, body] = line.split '\t'
		else
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

process.stdout.write 'Resolving depenedencies... '

resolved = {}

for target in targets
	resolveTokens = (AST) ->
		AST = extend true, {}, AST
		switch AST.type
			when 'character'
				if not dict[AST.text]?
					# Nope
				else if dict[AST.text]?.type is 'character'
					if dict[AST.text]?.text is AST.text
						# Nope
					else
						AST = dict[AST.text]
				else
					[AST, AST.text] = [resolveTokens(dict[AST.text]), AST.text]
			when 'combine'
				for component, i in AST.components
					AST.components[i] = resolveTokens component
		return AST

	resolved[target] = resolveTokens dict[target]

process.stdout.write 'done.\n'

if options.all
	process.stdout.write 'Writing resolved.json... '

	fs.writeFileSync "#{__dirname}/resolved.json", JSON.stringify resolved

	process.stdout.write 'done.\n'

process.stdout.write 'Flattening data... '

flattened = {}

for token, AST of resolved
	flatten = (AST) ->
		switch AST.type
			when 'character'
				return AST.text
			when 'combine'
				ret = [AST.text]
				for component in AST.components
					result = flatten component
					if typeof result is 'object' and result[0] is undefined
						ret = ret.concat result[1..]
					else
						ret.push result
				return ret

	flattened[token] = flatten AST
	if typeof flattened[token] is 'object'
		flattened[token][0] = token

process.stdout.write 'done.\n'

if options.all
	process.stdout.write 'Writing flattened.json... '

	fs.writeFileSync "#{__dirname}/flattened.json", JSON.stringify flattened
	fs.writeFileSync "#{__dirname}/flattened.max.js", util.inspect flattened, depth: null

	process.stdout.write 'done.\n'

process.stdout.write 'Writing data.json... '

fs.writeFileSync "#{__dirname}/data.json", JSON.stringify flattened

process.stdout.write 'done.\n'

process.stdout.write 'Serializing dependencies... '

serialized = {}

for token, AST of resolved
	serialize = (AST) ->
		ret = []
		switch AST.type
			when 'character'
				ret.push AST.text
			when 'combine'
				if AST.text
					ret.push AST.text
				for component in AST.components
					ret = ret.concat serialize component
		return ret

	serialized[token] = serialize AST

process.stdout.write 'done.\n'

if options.all
	process.stdout.write 'Writing serialized.json... '

	fs.writeFileSync "#{__dirname}/serialized.json", JSON.stringify serialized
	fs.writeFileSync "#{__dirname}/serialized.max.js", util.inspect serialized

	process.stdout.write 'done.\n'

process.stdout.write 'Taking stats... '

stats = {}

for token, parts of serialized
	for part in parts
		stats[part] ?= 0
		stats[part]++

statsArray = ([part, count] for part, count of stats)
statsArray.sort (a, b) -> b[1] - a[1]

newStats = {}

for [part, count] in statsArray
	newStats[part] = count

process.stdout.write 'done.\n'

if options.all
	process.stdout.write 'Writing stats... '

	fs.writeFileSync "#{__dirname}/stats.max.js", util.inspect newStats

	process.stdout.write 'done.\n'

process.stdout.write 'Writing parts.json... '

excludes = [
	# Parts onlly used in simplified chinese
	'钅', '贝', '纟', '讠', '鱼', '车', '鸟', '门', '马', '页'
	# Too subdevided parts
	'丨', '𠃊',
]
availableParts = {}

for [part, count] in statsArray
	if part not in excludes and part[0] isnt '&'
		availableParts[part] = count
		break if Object.keys(availableParts).length is 200

fs.writeFileSync "#{__dirname}/parts.json", JSON.stringify availableParts

process.stdout.write 'done.\n'

process.stdout.write "Build succeeded. Memory usage: #{process.memoryUsage().rss / 1024 / 1024} MiB\n"
