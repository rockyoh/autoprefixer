browserslist = require('browserslist')

utils = require('./utils')

class Browsers

  # Return all prefixes for default browser data
  @prefixes: ->
    return @prefixesCache if @prefixesCache

    data = require('caniuse-db/data').agents
    @prefixesCache = utils.uniq("-#{i.prefix}-" for name, i of data).
                           sort (a, b) -> b.length - a.length

  # Check is value contain any possibe prefix
  @withPrefix: (value) ->
    unless @prefixesRegexp
      @prefixesRegexp = /// #{ @prefixes().join('|') } ///

    @prefixesRegexp.test(value)

  constructor: (@data, requirements, @options) ->
    @selected = @parse(requirements)

  # Return browsers selected by requirements
  parse: (requirements) ->
    browserslist(requirements, { path: @options?.from })

  # Select major browsers versions by criteria
  browsers: (criteria) ->
    selected = []
    for browser, data of @data
      versions = criteria(data).map (version) -> "#{browser} #{version}"
      selected = selected.concat(versions)
    selected

  # Return prefix for selected browser
  prefix: (browser) ->
    [name, version] = browser.split(' ')
    if name == 'opera' and parseFloat(version) < 15
      '-o-'
    else
      '-' + @data[name].prefix + '-'

  # Is browser is selected by requirements
  isSelected: (browser) ->
    @selected.indexOf(browser) != -1

module.exports = Browsers
